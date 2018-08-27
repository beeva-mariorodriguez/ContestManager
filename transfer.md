# transfer!

https://github.com/beeva-mariorodriguez

## intro to packer
* tool for creating machine images for multiple platforms (EC2 AMIs!)
* example: [beevalabs-docker-nvidia-ami](https://github.com/beeva-mariorodriguez/beevalabs-docker-nvidia-ami)
* json file + shell script provisioner
	* find base AMI:
		```bash
		aws ec2 describe-images --region us-east-2 --filters Name=name,Values='debian-stretch-hvm-x86_64*' --owners xxxxxxxxx
        ```
	* build instructions:
        ```bash
        packer build filename.json
        ```

## intro to terraform
* Terraform is a tool for building, changing, and versioning infrastructure
* examples: 
    * [basic-aws-infra](https://github.com/beeva-mariorodriguez/basic-aws-infra)
    * [ethereum-private-infra](https://github.com/beeva-mariorodriguez/ethereum-private-infra)
* *.tf files: configurations
    * desired state
    * variables: configuration
    * outputs: values that will be highlighted to the user when Terraform applies, can be recovered using ``terraform output``:
        ```bash
        ssh core@$(terraform output bastion_ip_address)
        ```
    * [my shit] use main.tf for the common code (VPC, provider, initial security groups, variables, outputs ...) and 1 tf file for each group of machines
* provisioning
    * the provisioner shell script runs unattended on the machine after it's created, so:
        * you must be able to login in the machine using the ssh key
        * the script will not run as root, so remember to sudo
    * [my shit] use 1 script called setup-vm.sh that receives the machine's role as an argument, and any configuration in environment variables
        ```terraform
        resource "aws_instance" "bastion" {
            ...
            provisioner "remote-exec" {
                inline = [
                    "export ETHEREUM_IMAGE=${var.ethereum_image}",
                    "export ETHERBASE=${var.etherbase}",
                    "export BOOTNODE_IP=${aws_instance.ethereum_bootnode.private_ip}",
                    "chmod +x /tmp/setup-vm.sh",
                    "/tmp/setup-vm.sh bastion",
                 ]
            }
        }
        ```
* commands:
    * ``terraform init``
    * ``terraform fmt``
    * ``terraform validate``
    * ``terraform plan``
    * ``terraform apply [-auto-approve]``
    * ``terraform destroy [-f]``

## blockchain

### ContestManager
* https://github.com/beeva-mariorodriguez/ContestManager
* mocha tests: branch "mocha" (branch mocha contains changes from WIP-mocha, but with squashed and cleaned up commits)
    * four tests on one file: test/contestmanager.js
    * hardest part: manage child contracts, check the comments in test/contestmanager.js
* TODO: more tests
* TODO: find some tool to check test coverage

## ethereum-private-infra
* https://github.com/beeva-mariorodriguez/ethereum-private-infra
* evolution of the infrastructure created for the one day lab event
* currently  the miners communicate over the private network
    * TODO: find a way to allow external miners 
    * TODO: make inter miner communication over public/private network configurable via terraform
