# name from TfPilot is the full resource name (project-env-userName-shortId); use as-is, only sanitize
locals {
  instance_name = substr(replace(lower(var.name), "/[^a-z0-9-]/", "-"), 0, 255)

  required_tags = {
    ManagedBy        = "tfpilot"
    TfPilotRequestId = var.request_id
    Project          = var.project
    Environment      = var.environment
  }

  merged_tags = merge(local.required_tags, var.tags)

  presets = {
    "shared-public" = {
      vpc_id                   = "vpc-00a3272d06e0ae01c"
      public_subnet_ids        = ["subnet-09169af2390c33dd9", "subnet-08ba0c093135facc0", "subnet-09df87c077abc295e"]
      default_security_group_id = "sg-00c2997a8b5f86149"
    }
  }
  preset = local.presets[var.network_preset]

  resolved_subnet_id = var.subnet_id != null && var.subnet_id != "" ? var.subnet_id : local.preset.public_subnet_ids[0]
  resolved_security_group_ids = length(var.security_group_ids) > 0 ? var.security_group_ids : [local.preset.default_security_group_id]
}

data "aws_ssm_parameter" "ami" {
  count = (var.ami_id != "" ? 0 : (var.ami_ssm_param != "" ? 1 : 0))

  name = var.ami_ssm_param
}

locals {
  resolved_ami = var.ami_id != "" ? var.ami_id : (var.ami_ssm_param != "" ? data.aws_ssm_parameter.ami[0].value : null)
}

resource "aws_instance" "this" {
  ami                    = local.resolved_ami
  instance_type          = var.instance_type
  subnet_id              = local.resolved_subnet_id
  vpc_security_group_ids = local.resolved_security_group_ids
  key_name               = var.key_name

  associate_public_ip_address = var.associate_public_ip_address
  monitoring                  = var.monitoring

  root_block_device {
    volume_size = var.root_volume_size_gb
  }

  tags = merge(local.merged_tags, {
    Name = local.instance_name
  })
}
