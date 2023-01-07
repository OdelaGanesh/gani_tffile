output "testopimages"{
    value = data.google_compute_image.testimage.self_link
}


output "ip" {
    value = google_compute_instance.testvm.network_interface.0.access_config.0.nat_ip
  
}