variable "prefix" {
  description = "Prefix used for naming Azure resources"
  type        = string
  default     = "quoteapi"
}

variable "unique_suffix" {
  description = "A short random suffix to ensure global uniqueness (ACR name suffix)"
  type        = string
  default     = "123"
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "westeurope"
}

variable "kubernetes_version" {
  description = "Number of max pods in the default (system) node pool per node"
  type        = string
  default     = "1.33.2"
}

variable "sku_tier" {
  description = "Number of max pods in the default (system) node pool per node"
  type        = string
  default     = "Standard"
}

variable "node_count" {
  description = "Number of nodes in the default (system) node pool"
  type        = number
  default     = 2
}

variable "node_count_min" {
  description = "Minimum number of nodes in the default (system) node pool"
  type        = number
  default     = 2
}

variable "node_count_max" {
  description = "Maximum number of nodes in the default (system) node pool"
  type        = number
  default     = 4
}

variable "max_pods" {
  description = "Number of max pods in the default (system) node pool per node"
  type        = number
  default     = 49
}

variable "node_vm_size" {
  description = "VM size for the AKS node pool"
  type        = string
  default     = "Standard_D4ds_v6"
}

variable "node_auto_scaling_enabled" {
  description = "VM size for the AKS node pool"
  type        = bool
  default     = true
}