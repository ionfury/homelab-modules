variable "name" {
  description = "Name to use for the VMs and Namespace."
  type        = string
}

variable "vm_count" {
  description = "Number of VMs to create in the namespace."
  type        = number
  default     = 1
}

variable "data_root_size" {
  description = "Size of the root diskof each VM."
  type        = string
  default     = "32G"
}

variable "data_root_storage_class" {
  description = "Storage class to use for root diskof each VM."
  type        = string
}

variable "data_disk_size" {
  description = "Size of the data diskof each VM."
  type        = string
  default     = "64G"
}

variable "data_disk_storage_class" {
  description = "Storage class to use for the data disk of each VM."
  type        = string
}

variable "talos_version" {
  description = "Version of talos to run."
  type        = string
}

variable "cores" {
  description = "Number of cores to allocate to each VM."
  type        = number
  default     = 2
}

variable "memory" {
  description = "Amount of memory to allocate to each VM."
  type        = string
  default     = "4G"
}
/*
variable "kubernetes_config" {
  description = "The full kubernetes config."
  type        = string
  sensitive   = true
}
*/
