module "security-group-prometheus" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"
  name = "SGAllowPrometheus"                         # Name of the Security group
  vpc_id = module.vpc.vpc_id                         # VPC Id using the value from the vpc module
  tags = merge(                                      # Tagging - add the tag variables and merge with name
    var.tags, {
      Name = "SgAllowPrometheus"
  })
  ingress_with_cidr_blocks = [                       # SG custom ingress rules for Prometheus server which is in 
    {                                                # a Private subnet
      from_port   = 9090
      to_port     = 9100
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9182
      to_port     = 9182
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },]
    egress_with_cidr_blocks = [                      # SG Egress rules for Prometheus server
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "security-group-proxy" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"
  name = "SgAllowProxy"                             # Name of the Security group
  vpc_id = module.vpc.vpc_id                        # VPC Id using the value from the vpc module
  tags = merge(                                     # Tagging - add the tag variables and merge with name
    var.tags, {
      Name = "SgAllowProxy"
  })
  ingress_cidr_blocks = ["0.0.0.0/0"]               # SG predefined ingress rules for Proxy server which is in 
  ingress_rules = ["http-80-tcp"]                   # a public subnet
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}