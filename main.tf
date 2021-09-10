provider "aws" {
  region  = var.region
  profile = var.profile
}

module "instance_profile" {
  source      = "./modules/instance_profile"                             # where we created our configuration
  ip_name     = "demo_ec2_profile"                                       # instance profile name
  role_name   = "demo_ssm_role"                                          # role name
  policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"] # list of policy arn to attach
  tag_name    = "demo-ec2-ssm-policy"                                    # the tag key name value
  tags        = var.tags                                                 # pass the root module tag variable values
}

module "proxy_server" {
  source            = "./modules/instances"
  count             = 1
  ec2_name          = "${"core-proxy"}${format("%02d",count.index+1)}"
  key_name          = var.key_name                                     # we will need to define this in our root variables.tf
  ec2_subnet        = module.vpc.public_subnets[0]                     # retrieve the public sn from the vpc module
  vpc_sg_ids        = [module.security-group-prometheus.this_security_group_id, module.security-group-proxy.this_security_group_id]  # retrieve the security group id from the module
  ami               = data.aws_ami.aws-linux2.id                       # we will need a data source to get the latest ami
  iam_inst_prof     = module.instance_profile.iam_instance_profile_name# profile name from our module
  ec2_instance_size = var.instance_size["proxy"]                       # instance size map variable. Need to define 
  ec2_tags          = var.tags
  userdata          = templatefile("./templates/proxy.tpl",{proxy_server = ("core-proxy${format("%02d",count.index+1)}"), prom_server = module.prometheus_server[count.index].private_ip})
}

module "prometheus_server" {
  source            = "./modules/instances"
  count             = 1
  ec2_name          = "${"core-prom"}${format("%02d",count.index+1)}"
  key_name          = var.key_name
  ec2_subnet        = module.vpc.private_subnets[0]
  vpc_sg_ids        = [module.security-group-prometheus.this_security_group_id, module.security-group-proxy.this_security_group_id]
  ami               = data.aws_ami.aws-linux2.id
  iam_inst_prof     = module.instance_profile.iam_instance_profile_name
  ec2_instance_size = var.instance_size["prometheus"]
  ec2_tags          = var.tags
  userdata          = templatefile("./templates/prometheus.tpl", {prometheus_server = ("core-prom${format("%02d",count.index+1)}")})
}