output "instance_id" { value = module.gcp_instance.instance_id }
output "public_ip"   { value = module.gcp_instance.public_ip }
output "private_ip"  { value = module.gcp_instance.private_ip }

output "admin_user" {
  value = "deployer"
}
