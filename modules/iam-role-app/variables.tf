variable "name" {
  type        = string
  description = "Logical name for the role"
}

variable "project" {
  type        = string
  description = "Project identifier"
}

variable "environment" {
  type        = string
  description = "Environment identifier"
}

variable "request_id" {
  type        = string
  description = "Optional request identifier"
  default     = ""
}

variable "assume_role_policy_json" {
  type        = string
  description = "Assume role policy JSON"
}

variable "inline_policies" {
  type        = map(string)
  description = "Inline policies as map of name -> JSON"
  default     = {}
}

variable "managed_policy_arns" {
  type        = list(string)
  description = "Managed policy ARNs"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to merge with required defaults"
  default     = {}
}
