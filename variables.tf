variable "location" {
  type        = string
  default     = "eastus2"
  description = "Location where the resoruces are going to be created."
}

variable "suffix" {
  type        = string
  default     = "Demo"
  description = "To be added at the beginning of each resource."
}

variable "rgName" {
  type        = string
  default     = "PrivateEndPointRG"
  description = "Resource Group Name."
}

variable "tags" {
  type = map
  default = {
    "Environment" = "Dev"
    "Project"     = "PrivateEndPoint"
    "BillingCode" = "Internal"
    "Customer"    = "Demo"
  }
}

## Networking variables
variable "vnetName" {
  type        = string
  default     = "Main"
  description = "VNet name."
}

locals {
  base_cidr_block = "10.70.0.0/16"
}

## Security variables
variable "sgName" {
  type        = string
  default     = "default_RDPSSH_SG"
  description = "Default Security Group Name to be applied by default to VMs and subnets."
}

variable "sourceIPs" {
  type        = list
  default     = [""]
  description = "Public IPs to allow inboud communications."
}

## Storage
variable "storageAccountName" {
  type        = string
  default     = "prvtndpntstrg"
  description = "Storage Account Name."
}

variable "saKind" {
  type        = string
  default     = "StorageV2"
  description = "Defines the Kind of account. Valid options are Storage, StorageV2 and BlobStorage."
}

variable "saTier" {
  type        = string
  default     = "Standard"
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium."
}

variable "saReplicationType" {
  type        = string
  default     = "GRS"
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
}

variable "fsName" {
  type        = string
  default     = "sharefolder"
  description = "The name of the share. Must be unique within the storage account where the share is located."

}

variable "fsQuota" {
  type        = string
  default     = 50
  description = "The maximum size of the share, in gigabytes. Must be greater than 0, and less than or equal to 5 TB (5120 GB)."
}

## VM
variable "vmUserName" {
  type        = string
  default     = "storageAdmin"
  description = "Username to be added to the VM."
}

variable "sshKeyPath" {
  type        = string
  default     = "~/.ssh/vm_ssh.pub"
  description = "SSH Key to use when creating the VM."
}

variable "vmSize" {
  type        = string
  default     = "Standard_DS3_v2"
  description = "Specifies the size of the Virtual Machine."
}
