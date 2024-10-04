
resource "aws_apigatewayv2_api" "api_gw" {
  name          = "api-gw"
  protocol_type = "HTTP"
}

resource "aws_lambda_function" "lambda" {
  for_each      = var.private_subnets
  function_name = "lambda_function_${each.key}"
  timeout       = 30
  image_uri     = var.image_uri
  role          = aws_iam_role.lambda_exec_role.arn
  package_type  = "Image"

  vpc_config {
    subnet_ids         = [each.value]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

resource "aws_lambda_permission" "allow_api_gateway" {
  for_each      = var.private_subnets
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda[each.key].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gw.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "integration" {
  for_each               = var.private_subnets
  api_id                 = aws_apigatewayv2_api.api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_uri        = aws_lambda_function.lambda[each.key].invoke_arn
  payload_format_version = "2.0"
  timeout_milliseconds   = 30000
}

resource "aws_apigatewayv2_route" "api_gw_route" {
  for_each  = var.private_subnets
  api_id    = aws_apigatewayv2_api.api_gw.id
  route_key = "GET /todoitems"

  target = "integrations/${aws_apigatewayv2_integration.integration[each.key].id}"
}

resource "aws_apigatewayv2_stage" "v1" {
  api_id = aws_apigatewayv2_api.api_gw.id
  name   = "v1"

  auto_deploy = true
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_exec_policy" {
  name = "lambda_execution_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:DescribeImages"
        ],
        Resource = "arn:aws:ecr:us-east-1:730335231740:repository/dotnet-todo-repo"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_exec_policy.arn
}

resource "aws_security_group" "lambda_sg" {
  name        = "lambda_security_group"
  description = "Allow Lambda to access necessary services"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}