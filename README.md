# Cloud deployment with Terraform and Ansible

This is a quick and easy example of how to use [terraform](https://www.terraform.io/) and [ansible](https://www.ansible.com/) to deploying an app to AWS or GCP. We are using my repo [simple image classifier](https://github.com/pauloesampaio/simple_image_clf) as example of app. It already have a Dockerfile to create a container running the app, so here we'll  be:

- creating the infra-structure with Terraform
- Configuring it with Ansible
- Cloning the app repo from git
- Running it

## Before you begin

You will have to setup your credentials and ssh keys for your favorite provider and add them to the `variable.tf` file. I recommend creating an IAM user and giving him the needed permissions to creat instances, network configs and SSH. I put an example under [GCP](https://github.com/pauloesampaio/cloud_deploy_with_terraform/blob/master/gcp_deploy/variable.tf_example) and [AWS](https://github.com/pauloesampaio/cloud_deploy_with_terraform/blob/master/aws_deploy/variables.tf_example) on how to, once you have this setup, define your credentials and keys on the variables file.

## Terraform

Basically, terraform will create an instance according to the instructions in the `main.tf` file. Here I'm creating the smallest instance available in each provider, adding a Ubunto distribution and call Ansible to configure it.

## Ansible

Once terraform creates the instance, it will call Ansible to configure it. On the playbook, ansible is basically installing docker, cloning the repo, building the container and running the app.

## Running

Obviously you need to have both terraform and ansible properly installed on you machine. Once you have it, you can:

- Run `terraform init <DESIRED FOLDER>`, where the desired folder is the one with the `tf.main` you want to run. Here it could be `./aws_deploy` or `./gcp_deploy`
- Then `terraform plan <DESIRED FOLDER>`
- Finally `terraform apply <DESIRED FOLDER>`

If you want to destroy the instance, you can run `terraform destroy <DESIRED FOLDER>`.

## Contact

If you have any comments/questions, you can find me [here](https://pauloesampaio.github.io)





