resource "digitalocean_droplet" "do_droplet" {
    name       = "devops-lab"
    region     = "lon1"
    size       = "s-2vcpu-4gb-120gb-intel"
    image      = "ubuntu-24-10-x64"
    tags       = ["astro-docs", "devops-lab", "k3s", "monitoring", "production"]
    monitoring = true
    vpc_uuid   = "31593245-8cab-4488-b476-289f716217b2"
}