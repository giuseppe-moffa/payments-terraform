# ec2-instance module

Creates a single EC2 instance with sane defaults. No autoscaling.

## Inputs

- `name`, `project`, `environment`, `request_id`
- `instance_type` — e.g. t3.micro, t3.small
- `network_preset` — preset id (e.g. shared-public); supplies default VPC, subnet, security group
- `subnet_id` — optional override; leave empty to use preset default (advanced)
- `security_group_ids` — optional override; leave empty to use preset default (advanced)
- `subnet_type` — optional: public or private (advanced)
- `ami_id` — AMI ID (use this or `ami_ssm_param`, not both)
- `ami_ssm_param` — SSM parameter name for AMI (e.g. `/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64`). Used when `ami_id` is empty.
- `key_name` — optional key pair name for SSH
- `associate_public_ip_address` — whether to assign a public IP (default `false`)
- `root_volume_size_gb` — root volume size in GB (default `20`)
- `monitoring` — enable detailed (basic) CloudWatch monitoring (default `true`)
- `tags` — additional tags merged with required defaults

## Outputs

- `instance_id`
- `private_ip`
- `public_ip` — set when a public IP is associated, otherwise null
