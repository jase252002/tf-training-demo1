# tf-training-demo1

## Details
As part of an external certification program this demo has been created to help colleagues obtain Hashicorp Terraform associate certification

## Deployment details
The demonstration will deploy the following using Terraform

1. Setup a VCS (git - this is not using terraform but it can be and maybe included at a later date when I work it out)
2. AWS Components (aws provider)
    1. VPC
    2. Private and Public Subnets
    3. Internet Gateway
    4. Nat Gateway
    5. Route tables
    6. Security Groups
    7. Instance profile
    8. IAM Policy
    9. Deploy and configure a Prometheus server in the private subnet
    10. Deploy and configure a NGINX server with reverse proxy rule to access the Prometheus server in the public subnet
3. Utilise the S3 bucket for Terraform remote state

### Known issues
None

### Planned enhancements
None presently

## Author
**Dave Hart**
[link to blog!](https://davehart.co.uk)
## Editied by Jason Sykes