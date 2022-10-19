output "elb_consul_dns_address" {
  description = "ELB DNS name"
  value       = aws_lb.consul-asg-dc1.dns_name
}