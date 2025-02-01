################# ALB Outputs #################
# output "alb_arn" {
#   description = "ARN of the ALB"
#   value       = module.alb.arn
# }

# output "id" {
#   description = "ID of the load balancer"
#   value       = module.alb.id
# }

# output "security_group_ids" {
#   description = "Security group IDs created"
#   value       = module.alb.security_group_ids
# }

# output "target_group_arn" {
#   description = "ARN of the target group"
#   value       = module.alb.target_group_arn
# }

# output "target_group_health_check" {
#   description = "Health check configuration of the target group"
#   value       = module.alb.target_group_health_check
# }

################# NLB Outputs #################
output "nlb_arn" {
  description = "ARN of the NLB"
  value       = module.nlb.arn
}

output "id" {
  description = "ID of the load balancer"
  value       = module.nlb.id
}

output "security_group_ids" {
  description = "Security group IDs created"
  value       = module.nlb.security_group_ids
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = module.nlb.target_group_arn
}
