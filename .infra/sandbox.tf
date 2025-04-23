

module "docs" {
  source       = "git::https://github.com/coinify-v2/infra.git//modules/ecs/service"
  service_name = "docs"
  env          = "stg"

  is_publicly_accessible = true

  container_secret_manager_secrets = []

  lb_health_check = {
    path = "/status"
  }

  # Env variables and secrets
  container_environment_variables = [
    {
      name  = "PORT"
      value = "80"
    },
    {
      name  = "USERNAME"
      value = "Marktcom"
    },
    {
      name  = "PASSWORD"
      value = "Software"
    },
  ]


  ####################
  # Same for every service in a cluster.
  # This is retrieved from main workload workspace
  ####################
  vpc_id             = data.terraform_remote_state.sandbox.outputs.vpc.vpc_id
  service_subnet_ids = data.terraform_remote_state.sandbox.outputs.vpc.private_subnets

  ecs_cluster_name                 = data.terraform_remote_state.sandbox.outputs.ecs_cluster.ecs_cluster_name
  alb_listener_arn_public          = data.terraform_remote_state.sandbox.outputs.ecs_cluster.alb_listener_arn_public
  service_security_group_id_public = data.terraform_remote_state.sandbox.outputs.ecs_cluster.security_group_lb_id
  security_group_id                = data.terraform_remote_state.sandbox.outputs.ecs_cluster.security_group_container_id

  routing_host_public = "docs.sandbox.devgo.app"

  # Service Connect
  service_discovery_namespace_name = data.terraform_remote_state.sandbox.outputs.service_mesh.name
  enable_service_connect_http      = true
  enable_service_connect_grpc      = false

  autoscaling = {
    min_capacity = 1
    max_capacity = 2
  }

  tags = {
    env = "sandbox"
  }
}
