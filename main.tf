provider "google" {
    project = "mygcpproject-367617"
    region = "us-central1"
    credentials = "accounts.json"
}

resource "google_compute_network" "testvpc"{
    name = "testtfvpc"
}

resource "google_compute_subnetwork" "testsub"{
    name = "testtfsub"
    ip_cidr_range = "10.1.20.0/24"
    region = "us-central1"
    network = google_compute_network.testvpc.id

}

resource "google_compute_instance" "testvm" {
    name = "testtfvm"
    machine_type = "f1-micro"
    zone = "us-central1-a"

    tags = [ "test" ]

   boot_disk {
      initialize_params {
           image =  "debian-cloud/debian-11"
  }
 }

 network_interface {
   network = google_compute_network.testvpc.id
   access_config {
    nat_ip = google_compute_address.teststatic.address
   }
 }
}

resource "google_compute_address" "teststatic" {
  name = "testmystatic"
}

resource "google_compute_firewall" "testfirewall" {
       name = "testtffirewall"
       network = google_compute_network.testvpc.name
       allow {
         protocol = "icmp"
       }
       allow {
         protocol = "tcp"
         ports = ["80", "8080", "1000-2000","22"]
       }
       target_tags = [ "roo" ]
       source_ranges = [ "0.0.0.0/0" ]
}


resource "random_id" "testbucketname" {
    byte_length = 8
  
}

resource "google_storage_bucket" "static_site" {
    name = "ganeshgcp-${random_id.testbucketname.dec}"
    location = "EU"
  
}


data "google_compute_image" "testimage" {
    family = "debian-11"
  project = "debian-cloud"
}



terraform {
  backend "gcs"{
    bucket = "petclinicbuk"
    credentials ="accounts.json"
  }
}