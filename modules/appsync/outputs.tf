output "posting_service_datasource_arn" {
  value = aws_appsync_datasource.posting_service.arn
}

output "create_post_resolver_arn" {
  value = aws_appsync_resolver.create_post_resolver.arn
}
