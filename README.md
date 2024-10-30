# Google Cloud Projects


![](https://i.imgur.com/waxVImv.png)
### [View all Roadmaps](https://github.com/nholuongut/all-roadmaps) &nbsp;&middot;&nbsp; [Best Practices](https://github.com/nholuongut/all-roadmaps/blob/main/public/best-practices/) &nbsp;&middot;&nbsp; [Questions](https://www.linkedin.com/in/nholuong/)
<br/>

![Google Projects and Resources](GCP%20Project%20Example.png)

## Summary
This terraform state creates a list of folders and associated projects in a 
Google Cloud Platform organization.  Currently only one level of folders is
supported.

Folders host shared VPCs.  While folder and project names are completely 
configurable, the defaults for this project will make the "ops" project in 
each folder the host account for the shared VPC, and all other accounts
attach as a service account.

Additionally, each project will contain a service account with a configurable
set of IAM roles attached, giving the Terraform service account "just enough"
permissions to create infrastructure for an account.  These service accounts
don't have static keys.  Instead, specify a list of users or groups who can
impersonate the service account in order to manage resources within a project.

It is possible to configure IAM policies for each folder.  Currently,
the only implemented role is the "viewer" role but the modules/folder/main.tf
file can be extended to support more roles.  Folder-level IAM policie are
inherited through all downstream projects.

Finally, each folder will contain a Google Storage bucket, with versioning
enabled, that is intended to be used as the storage bucket for the GCP storage
backend, for Terraform.

## Impersonating terraform service accounts

The `example` folder contains an example terraform state that simply creates a
Google Cloud Storage bucket.  Note, however, that it initializes two instances
of the [GCP provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs): 
one for the application default credentials, and another to use a token
generated for the terraform service account within a project.

## Creating groups
Setting up a service account to be able to manage Google Cloud Identity Groups
is a difficult process.

So far I've had to add some organization-wide permissions to the terrraform
service account to get this to work (some of these roles are not covered in the 
preceeding document):

- Billing Account Administrator
- Compute Shared VPC Admin
- Service Account Admin
- Logging Admin
- Folder Admin
- Project Lien Modifier
- Organization Administrator
- Project Creator
- Project IAM Admin
- Service Usage Admin
- Storage Admin

## Usage

Requirements:

- Terraform 0.13 or newer, due to use of for_each in module declarations
- A Google organization, either tied to Google Cloud Identity services
or GSuite.

First, you will need to know your billing account ID and be logged in as an
organization administrator.  Given a new organization, run: 

```bash
gcloud config configurations create my-account
gcloud config set core/account my-email@my-cloud-identity-domain.com
gcloud config set compute/region us-central1 # or any other region
gcloud auth login
gcloud auth application-default login
```

Apply your terraform state by running `TF_VAR_billing_account_id=XXXX terraform
apply -var-file tfvars/my.tfvars`.  You can also copy the tfvars file to the
root folder of this project and it will be applied automatically (no -var-file 
flag).

### Variables

Note that the billing_account_id variable, above, isn't set in a tfvars file.
It is recommended that you do not commit your billing account ID to a Git 
repository.

| Variable Name                            | Purpose                                                               | Type            | Default Value                   | Required? |
|------------------------------------------|-----------------------------------------------------------------------|-----------------|---------------------------------|-----------|
| gcp_region                               | The GCP region in which to create resources                           | string          | us-central1                     | no        |
| org_domain                               | The domain of the organization being managed                          | string          | gregongcp.net                   | yes       |
| billing_account_id                       | The ID of the billing account being used                              | string          | none                            | yes       |
| folders                                  | The list of root level folders to create                              | list of objects | example                         | yes       |
| folders/name                             | The name of each folder                                               | string          | examples                        | yes       |
| folders/viewers                          | Users and groups to assign to the folder 'viewers' role               | list of strings | examples                        | no        |
| projects                                 | A list of projects to create                                          | list of objects | examples                        | yes       |
| projects/folder_name                     | The folder in which to place the project being created                | string          | examples                        | yes       |
| projects/project_name                    | The name of the project to create                                     | string          | examples                        | yes       |
| projects/identifier                      | An internal identifier for terraform.  Must be unique.                | string          | examples                        | yes       |
| projects/enabled_apis                    | A list of APIs to enable for the project                              | list of strings | []                              | no        |
| projects/auto_create_network             | Automatically create a network for the project                        | bool            | false                           | no        |
| projects/role_bindings                   | A list of IAM role bindings attached to the terraform service account | list of strings | []                              | no        |
| projects/terraform_impersonators         | A list of users and groups allowed to impersonate the service account | list of strings | []                              | no        |
| networks                                 | A list of VPC networks to create                                      | list of objects | examples                        | yes       |
| networks/name                            | The name of the network to create                                     | string          | example                         | yes       |
| networks/host_project_identifier         | The project that will servce as the host VPC account                  | string          | example                         | yes       |
| networks/parent_folder_name              | The folder in which to create the network resource                    | string          | example                         | yes       |
| networks/auto_create_subnets             | Automatically create subnets in the VPC                               | bool            | false                           | no        |
| networks/routing_mode                    | Advertise routes GLOBALly or REGIONALly                               | string          | REGIONAL                        | no        |
| networks/delete_default_routes_on_create | Delete the default route after creating the VPC network               | bool            | true                            | no        |
| networks/cidr_block                      | The CIDR block of the VPC                                             | string          | example                         | no        |
| networks/gcp_regions                     | The GCP regions in which to create subnets for the VPC                | list of strings | us-central1, us-east1, us-west1 | no        |
| networks/subnet_cidr_prefix              | The size of each subnet to create, specified as a CIDR mask           | number          | 20                              | no        |

# 🚀 I'm are always open to your feedback.  Please contact as bellow information:
### [Contact ]
* [Name: nho Luong]
* [Skype](luongutnho_skype)
* [Github](https://github.com/nholuongut/)
* [Linkedin](https://www.linkedin.com/in/nholuong/)
* [Email Address](luongutnho@hotmail.com)

![](https://i.imgur.com/waxVImv.png)
![](Donate.png)
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/nholuong)

# License
* Nho Luong (c). All Rights Reserved.🌟