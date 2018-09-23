variable "client_id" {  
  type = "string"
}

variable "client_secret" {  
  type = "string"
}

variable "location" {  
  type    = "string"
  default = "West Europe"
}

variable "subscription_id" {  
  type = "string"
}

variable "tenant_id" {  
  type = "string"
}

variable "agent_count" {
    default = 3
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "k8s"
}

variable cluster_name {
    default = "k8s-cluster"
}

variable resource_group_name {
    default = "k8s-resource"
}