
name                     = "arc-load-balancer"
bucket_name              = "arc-terraform-alb-logs-1"
load_balancer_type       = "network" 
internal                 = false         
idle_timeout             = 60           
enable_deletion_protection = false      
ip_address_type          = "ipv4"  
region                   = "us-east-1"
environment             = "dev"
namespace               = "arc"
security_group_name      = "arc-alb-sg"

network_forward_action = true

vpc_name    = "Default VPC"
subnet_name = ["vnk-1", "vnk-2"]

# Security group rules
security_group_data = {
  create      = true
  description = "Security Group for alb"
  ingress_rules = [
    {
      description = "Allow VPC traffic"
      cidr_block  = "0.0.0.0/0" # Changed to string
      from_port   = 0
      ip_protocol = "tcp"
      to_port     = 443
    },
    {
      description = "Allow traffic from self"
      self        = true
      from_port   = 80
      ip_protocol = "tcp"
      to_port     = 80
    },
  ]
  egress_rules = [
    {
      description = "Allow all outbound traffic"
      cidr_block  = "0.0.0.0/0" # Changed to string
      from_port   = -1
      ip_protocol = "-1"
      to_port     = -1
    }
  ]
}


target_group_config = {
  name        = "arc-poc-alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = "vpc-68f96212"
  target_type = "instance"
  health_check = {
    enabled             = true
    interval            = 30 # Time in seconds between health checks
    path                = "/"
    port                = 80 # The port on which to perform the health check
    protocol            = "HTTP"
    timeout             = 5     # Time in seconds to wait for a response
    unhealthy_threshold = 3     # Number of consecutive failed health checks
    healthy_threshold   = 2     # Number of consecutive successful health checks
    matcher             = "200" # Expected response code from the health check
  }
  # stickiness = {
  #   enabled         = true
  #   type            = "lb_cookie"
  #   cookie_duration = 3600  # Cookie duration in seconds
  # }
}

target_group_attachment_config = [
  {
    target_id   = "i-024cca3753df50299" # Instance ID
    target_type = "instance"
    port        = 80
    # availability_zone = "us-east-1a"
  }
]


cidr_blocks = null


# default_action = [
#   {
#     type             = "forward"
#     forward = {
#       # arn = null
#       target_groups = [
#         {
#           weight           = 20
#         }
#       ]
#       # stickiness = {
#       #   duration = 300
#       #   enabled  = true
#       # }
#     }
#   },

# {
#   type             = "redirect"
#   redirect = {
#     host        = "divyasf.sourcef.us"
#     path        = "/new-path"
#     query       = "?id=123"
#     protocol    = "HTTPS"
#     port        = "443"
#     status_code = "HTTP_301"
#   }
# },
# {
#   type             = "authenticate-oidc"
#   authenticate_oidc = {
#     authorization_endpoint = "https://example.com/authorize"
#     client_id              = "your-client-id"
#     client_secret          = "your-client-secret"
#     issuer                 = "https://example.com"
#     token_endpoint         = "https://example.com/token"
#     user_info_endpoint     = "https://example.com/userinfo"
#   }
# },
# {
#   type             = "authenticate-cognito"
#   authenticate_cognito = {
#     user_pool_arn                     = "arn:aws:cognito-idp:us-east-1:804295906245:userpool/us-east-1_9XOuJux4d"
#     user_pool_client_id               = "1dks0el3q70530ove0dp8mj6gp"
#     user_pool_domain                  = "us-east-19xoujux4d"
#     authentication_request_extra_params = { "param1" = "value1" }
#     on_unauthenticated_request        = "deny"
#     scope                             = "openid"
#     session_cookie_name               = "AWSELBAuthSessionCookie"
#     session_timeout                   = 3600
#   }
#   },
#     {
#   type             = "fixed-response"
#   fixed_response = {
#     status_code  = "200"
#     content_type = "text/plain"
#     message_body = "Hello, World!"
#   }
# },
# ]

default_action = [{
  type = "forward"
  forward = {
    target_groups = [{
      # arn = aws_lb_target_group.this.arn
      weight = 20
    }]
    stickiness = {
      duration = 300
      enabled  = true
    }
  }
}]


alb_listener = {
  port     = 88
  protocol = "TCP"
  #  alpn_policy              = "HTTP2Only"
  # certificate_arn          = "arn:aws:acm:us-east-1:804295906245:certificate/08759044-ad33-4bdb-b18c-7de7f85e272a"
  # ssl_policy               = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  # tcp_idle_timeout_seconds = 360
}

listener_rules = {
  rule1 = {
    priority = 9
    actions = [
      {
        type  = "redirect"
        order = 1
        redirect = {
          host        = "divyasf.sourcef.us"
          path        = "/redirect"
          query       = "action=redirect"
          protocol    = "HTTPS"
          port        = 443
          status_code = "HTTP_301"
        }
      }
    ]
    conditions = [
      {
        host_header = {
          values = ["example.com"]
        }
      }
    ]
  },

  rule2 = {
    priority = 999
    actions = [
      {
        type  = "fixed-response"
        order = 1
        fixed_response = {
          status_code  = "200"
          content_type = "text/plain"
          message_body = "OK"
        }
      }
    ]
    conditions = [
      {
        path_pattern = {
          values = ["/status"]
        }
      }
    ]
  }
}

# listener_certificates = [
#   {
#     certificate_arn = "arn:aws:acm:region:account-id:certificate/certificate-id"
#   }
# ]



# SSL and Listener settings
# certificate_arn = "arn:aws:acm:region:account-id:certificate/certificate-id"
# ssl_policy      = null
# port            = 443
# protocol        = "HTTPS"
#  alpn_policy     = null

# Optional settings
# tcp_idle_timeout_seconds = 60
