
# Lambda function

resource "aws_lambda_function" "voice_lambda" {
  filename         = "${path.module}/lambda.zip"
  function_name    = "voice-note-presigner"
  role             = var.lambda_role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  timeout          = 10

  environment {
    variables = {
      BUCKET_NAME = var.voice_notes_bucket_name
    }
  }
}


# API Gateway HTTP API

resource "aws_apigatewayv2_api" "voice_api" {
  name          = "voice-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_headers = ["*"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_origins = ["*"]
    expose_headers = ["*"]
    max_age       = 3600
  }
}


# Lambda permission for API Gateway

resource "aws_lambda_permission" "allow_apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.voice_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.voice_api.execution_arn}/*/*"
}


# Lambda integration

resource "aws_apigatewayv2_integration" "voice_lambda_integration" {
  api_id             = aws_apigatewayv2_api.voice_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.voice_lambda.invoke_arn

  integration_method = "ANY"
  payload_format_version = "2.0"
}


# Routes

resource "aws_apigatewayv2_route" "presigned_route" {
  api_id    = aws_apigatewayv2_api.voice_api.id
  route_key = "GET /presigned-url"
  target    = "integrations/${aws_apigatewayv2_integration.voice_lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "list_route" {
  api_id    = aws_apigatewayv2_api.voice_api.id
  route_key = "GET /list"
  target    = "integrations/${aws_apigatewayv2_integration.voice_lambda_integration.id}"
}


# Stage

resource "aws_apigatewayv2_stage" "dev_stage" {
  api_id      = aws_apigatewayv2_api.voice_api.id
  name        = "dev"
  auto_deploy = true

  depends_on = [
    aws_apigatewayv2_integration.voice_lambda_integration,
    aws_apigatewayv2_route.presigned_route,
    aws_apigatewayv2_route.list_route
  ]
}