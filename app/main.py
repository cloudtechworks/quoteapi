import asyncio
import httpx
import os
from fastapi import FastAPI, Request
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.instrumentation.httpx import HTTPXClientInstrumentor
from slowapi import Limiter
from slowapi.util import get_remote_address

# Configure tracing
trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)

otlp_exporter = OTLPSpanExporter(
    endpoint=os.getenv("OTEL_EXPORTER_OTLP_ENDPOINT", "http://otel-collector:4318/v1/traces"),
)
trace.get_tracer_provider().add_span_processor(BatchSpanProcessor(otlp_exporter))

app = FastAPI()

limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter

# Instrumentations
FastAPIInstrumentor.instrument_app(app)
HTTPXClientInstrumentor().instrument()


QUOTES_APIS = [
    "https://dummyjson.com/quotes/random",
    "https://zenquotes.io/api/random"
]

async def fetch_quote(url: str):
    async with httpx.AsyncClient(timeout=5.0) as client:
        try:
            resp = await client.get(url)
            data = resp.json()
            if isinstance(data, list):
                data = data[0]
            return {"quote": data.get("quote") or data.get("q"), "author": data.get("author")}
        except:
            return None

@app.get("/quote")
@limiter.limit("5/minute")
async def get_quote(request: Request):
    # Start tasks for all APIs
    tasks = [asyncio.create_task(fetch_quote(url)) for url in QUOTES_APIS]
    # Wait for the first one to finish
    done, pending = await asyncio.wait(tasks, return_when=asyncio.FIRST_COMPLETED)
    
    # Cancel the rest
    for task in pending:
        task.cancel()
    
    # Return the result from the first completed task
    for task in done:
        if task.result():
            return task.result()
    
    # Fallback if all fail
    return {"quote": "No quote available", "author": "Unknown"}
