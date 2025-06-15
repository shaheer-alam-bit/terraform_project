provider "aws" {
  region = "us-east-1"
}

module "alb" {
  source = "./modules/alb"
  
  asg_name = module.ec2.asg_name
}

module "ec2" {
  source = "./modules/ec2" 
  depends_on = [ module.rds ]

  DB_NAME = module.rds.pg_db_name
  DB_USERNAME = module.rds.pg_db_username
  DB_PASSWORD = module.rds.pg_db_password
  DB_ENDPOINT = module.rds.pg_db_endpoint
  DB_PORT = module.rds.pg_db_port
  sg-id = module.rds.ec2_sg_id
}

module "rds" {
  source = "./modules/rds"
}

module "route53" {
  source = "./modules/route53"

  alb_dns_name = module.alb.load_balancer_dns_name
  alb_zone_id  = module.alb.load_balancer_zone_id
  ec2_instance_public_ip = module.ec2.metabase_public_ip
}