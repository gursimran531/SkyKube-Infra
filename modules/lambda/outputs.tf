output "api_gateway_endpoint" { 
  description = "The endpoint URL of the API Gateway for the voice note service."
  value       = aws_apigatewayv2_api.voice_api.api_endpoint
}