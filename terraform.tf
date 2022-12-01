terraform {
    backend "remote" {
        hostname = "app.terraform.io"
        organization = "terraform-org-cloud"
    }

    workspaces {
        name = "terraform-aws-openpbs"
    }
}