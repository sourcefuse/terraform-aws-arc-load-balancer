# terraform-aws-module-template example

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.84.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_elb"></a> [elb](#module\_elb) | ../ | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | sourcefuse/arc-s3/aws | 0.0.4 |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.6 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy_document.alb_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_listener"></a> [alb\_listener](#input\_alb\_listener) | n/a | <pre>object({<br>    port                     = optional(number, 80)<br>    protocol                 = optional(string, "HTTP")<br>    alpn_policy              = optional(string, null)<br>    certificate_arn          = optional(string, "")<br>    ssl_policy               = optional(string, "")<br>    tcp_idle_timeout_seconds = optional(number, 350)<br>  })</pre> | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the bucket | `string` | n/a | yes |
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | Default actions for the ALB listener. | <pre>list(object({<br>    type = string<br><br>    authenticate_oidc = optional(object({<br>      authorization_endpoint              = string<br>      authentication_request_extra_params = optional(map(string), {})<br>      client_id                           = string<br>      client_secret                       = string<br>      issuer                              = string<br>      token_endpoint                      = string<br>      user_info_endpoint                  = string<br>      on_unauthenticated_request          = optional(string, "deny")<br>      scope                               = optional(string)<br>      session_cookie_name                 = optional(string)<br>      session_timeout                     = optional(number)<br>    }))<br><br>    authenticate_cognito = optional(object({<br>      user_pool_arn                       = string<br>      user_pool_client_id                 = string<br>      user_pool_domain                    = string<br>      authentication_request_extra_params = optional(map(string), {})<br>      on_unauthenticated_request          = optional(string, "deny")<br>      scope                               = optional(string)<br>      session_cookie_name                 = optional(string)<br>      session_timeout                     = optional(number)<br>    }))<br><br>    fixed_response = optional(object({<br>      status_code  = string<br>      content_type = optional(string, "text/plain")<br>      message_body = optional(string, "")<br>    }))<br><br>    forward = optional(object({<br>      target_groups = list(object({<br>        weight = optional(number, null)<br>      }))<br>      stickiness = optional(object({<br>        duration = number<br>        enabled  = optional(bool, false)<br>      }))<br>    }))<br>    redirect = optional(object({<br>      host        = optional(string)<br>      path        = optional(string)<br>      query       = optional(string)<br>      protocol    = optional(string)<br>      port        = optional(number)<br>      status_code = string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_listener_rules"></a> [listener\_rules](#input\_listener\_rules) | A map of listener rules | <pre>map(object({<br>    priority = number<br>    authenticate_oidc = optional(object({<br>      authorization_endpoint              = string<br>      client_id                           = string<br>      client_secret                       = string<br>      issuer                              = string<br>      token_endpoint                      = string<br>      user_info_endpoint                  = string<br>      authentication_request_extra_params = map(string)<br>      on_unauthenticated_request          = string<br>      scope                               = string<br>      session_cookie_name                 = string<br>      session_timeout                     = number<br>    }))<br>    actions = list(object({<br>      type  = string<br>      order = number<br>      redirect = optional(object({<br>        host        = string<br>        path        = string<br>        query       = string<br>        protocol    = string<br>        port        = number<br>        status_code = string<br>      }))<br>      fixed_response = optional(object({<br>        status_code  = string<br>        content_type = string<br>        message_body = string<br>      }))<br>      authenticate_cognito = optional(object({<br>        user_pool_arn              = string<br>        user_pool_client_id        = string<br>        user_pool_domain           = string<br>        on_unauthenticated_request = string<br>      }))<br>    }))<br>    conditions = list(object({<br>      host_header = optional(object({<br>        values = list(string)<br>      }))<br>      path_pattern = optional(object({<br>        values = list(string)<br>      }))<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_network_forward_action"></a> [network\_forward\_action](#input\_network\_forward\_action) | Default forward action for the ALB listener. | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_security_group_data"></a> [security\_group\_data](#input\_security\_group\_data) | n/a | <pre>object({<br>    security_group_ids_to_attach = optional(list(string), []),<br>    create                       = optional(bool, true),<br>    description                  = optional(string, null),<br>    ingress_rules = optional(list(object({<br>      description              = optional(string, null)<br>      cidr_block               = optional(string, null)<br>      source_security_group_id = optional(string, null)<br>      from_port                = number<br>      ip_protocol              = string<br>      to_port                  = string<br>      self                     = optional(bool, false)<br>    })), []),<br>    egress_rules = optional(list(object({<br>      description                   = optional(string, null)<br>      cidr_block                    = optional(string, null)<br>      destination_security_group_id = optional(string, null)<br>      from_port                     = number<br>      ip_protocol                   = string<br>      to_port                       = string<br>      prefix_list_id                = optional(string, null)<br>    })), [])<br>  })</pre> | <pre>{<br>  "create": false<br>}</pre> | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | The name of the security group | `string` | n/a | yes |
| <a name="input_subnet_names"></a> [subnet\_names](#input\_subnet\_names) | List of subnet names to lookup | `list(string)` | <pre>[<br>  "arc-poc-private-subnet-private-us-east-1a",<br>  "arc-poc-private-subnet-private-us-east-1b"<br>]</pre> | no |
| <a name="input_target_group_attachment_config"></a> [target\_group\_attachment\_config](#input\_target\_group\_attachment\_config) | List of target group attachment configurations | <pre>list(object({<br>    target_id         = string<br>    target_type       = string # Values: "instance", "ip", or "lambda"<br>    port              = optional(number)<br>    availability_zone = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_target_group_config"></a> [target\_group\_config](#input\_target\_group\_config) | n/a | <pre>object({<br>    name                              = optional(string)<br>    name_prefix                       = optional(string)<br>    port                              = optional(number)<br>    protocol                          = optional(string)<br>    vpc_id                            = optional(string)<br>    ip_address_type                   = optional(string)<br>    load_balancing_anomaly_mitigation = optional(bool)<br>    load_balancing_cross_zone_enabled = optional(bool)<br>    preserve_client_ip                = optional(bool)<br>    protocol_version                  = optional(string)<br>    load_balancing_algorithm_type     = optional(string)<br>    target_type                       = optional(string)<br>    proxy_protocol_v2                 = optional(bool)<br>    slow_start                        = optional(number)<br><br>    health_check = optional(object({<br>      enabled             = bool<br>      interval            = number<br>      path                = string<br>      port                = number<br>      protocol            = string<br>      timeout             = number<br>      unhealthy_threshold = number<br>      healthy_threshold   = number<br>      matcher             = string<br>    }))<br><br>    stickiness = optional(object({<br>      type            = string<br>      cookie_duration = number<br>      cookie_name     = optional(string)<br>      enabled         = bool<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID for the resources | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC to add the resources | `string` | `"arc-poc-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | ARN of the ALB |
| <a name="output_load_balancer_id"></a> [load\_balancer\_id](#output\_load\_balancer\_id) | ID of the load balancer |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | Security group IDs created |
| <a name="output_target_group_arn"></a> [target\_group\_arn](#output\_target\_group\_arn) | ARN of the target group |
| <a name="output_target_group_health_check"></a> [target\_group\_health\_check](#output\_target\_group\_health\_check) | Health check configuration of the target group |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
