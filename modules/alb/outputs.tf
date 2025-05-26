output "alb_dns" {
  value = aws_lb.wiki.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.wiki.arn
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}