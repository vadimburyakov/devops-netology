output "zone" {
  value = yandex_compute_instance.node01.zone
}

output "internal_ip_address_node01" {
  value = yandex_compute_instance.node01.network_interface.0.ip_address
}

output "external_ip_address_node01" {
  value = yandex_compute_instance.node01.network_interface.0.nat_ip_address
}