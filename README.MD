# Static Website w/ S3, CloudFront and Terraform

Generates the necessary infrastructure and permissions to create a static website using AWS s3 as the host, and distributing it via CloudFront. 
<hr />


## Table of contents
- [Static Website hosting using CloudFront, S3 and Terraform](#static-website-hosting-using-cloudfront-s3-and-terraform)
    - [Prerequisites](#prerequisites)
    - [Deployment](#deployment)
    - [WWH - what, why, how](#wwh---what-why-how)
    - [Input arguments](#input-arguments)
    - [Output](#output)
    - [Security](#security)
    - [Reading material](#reading-material)
    - [ToDo's](#todos)
<hr />


## Folder structure
```
cfsw
├── (remote)            | remote state directory
├── cloudfront.tf       | cloudfront distribution
├── input.tf            | required input arguments
├── main.tf             | load state from backend
├── outputs.tf          | output 
├── policies.tf         | create policies
├── provider.tf         | config provider
├── README.MD           | this file
├── s3.tf               | create S3 resources
└── variables.tf        | optional variables
```
<hr />




## Prerequisites
This project is configured to use a remote backend state. To do this, it is suggested to use an already existing [terraform-remote-state module](https://registry.terraform.io/modules/rafaelmarques7/remote-state/aws/1.1.0).

To generate the remote backend, follow the steps provided in the module you are using. **How to setup remote state**:

1. Create a folder called remote in the root directory;
2. Create a `main.tf` file and `variables.tf`;
3. Set `variables.tf` according to the module input arguments;
4. Invoke the remote-state-module on `main.tf`, and pass it the variables;
2. Run Terraform apply (make sure you pass the variables - read the docs!);
3. **Save the output** - it will be necessary later;
<hr />

## Deployment
To deploy a static website using this terraform script, follow these steps:

1. organize your static content:
    1. gather it into a directory ( call that directory *build* );
    2. paste that directory in the root of this project;
    3. in case you did not use *build* as the name on step 1.1, configure the *build_dir_name* variable to reflect your choice. 
2. setup your remote state:
    1. follow  the steps specified in [Prerequisites](#prerequisites);
    2. make sure to save the result of the above step (2.1). In particular, save the output of *state_bucket.id*;
    3. go to *main. tf* and configure the terraform backend (see [note 2.3](#note-2.3) below).
3. run the terraform scripts:
    1. full command available in [note 3.1](#note-3.1).


### **Note 2.3** - backend configuration

The configuration of the backend requires the hardcoding of the variables, as it does not accept variable interpolation. 
```
# Terraform backend configuration - hardcode these variables
terraform {
  backend "s3" {
    bucket = "remote_state_bucket_name"       # <--- use the output variable from step 2.2)
    key    = "remote_state_file_name"         # <--- use the same name as the corresponding variable
    region = "region"                         # <--- use the same region as the corresponding variable
  }
}
```

### **Note 3.1** - deployment command
```
terraform apply \
--var state_bucket_name=$REMOTE_STATE_BUCKET_NAME  \
--var aws_access_key=$AWS_ACCESS_KEY \
--var aws_secret_key=$AWS_SECRET_KEY \
-auto-approve
```
<hr />

## WWH - what, why, how
**What?** This is a Terraform project to deploy and manage a static website, using S3, CloudFront and Route53.

**Why?** To save time, using automatic deployment and update of a website. 

**How?** This project creates an S3 bucket, and uploads the static files to it. This is followed by the setup of a CloudFront distribution, which uses the bucket as origin to serve the website. (**ToDo**) This also provides a Route53.

<hr />


## Input arguments
There are 3 **required** input arguments:
```
      VARIABLE NAME           |      DETAILS
-------------------------------------------------------------------------------------------
- aws_access_key              | The AWS account access key (id).
- aws_secret__key             | The AWS account secret key (password).
- state_bucket_name           | The S3 bucket name that contains the remote state file.
```

There are 4 **optional** input arguments:
```
      VARIABLE NAME           |    DEFAULT                    |  DETAILS
-------------------------------------------------------------------------------------------------------------------------------------     
- region                      | us-east-1                     | The AWS region where the terraform stack is created.
- s3_filename_state           | state_terraform               | The file name of the state inside the state_bucket.
- s3_bucket_website_name      | website-terraform-aws-cfsw    | The websites' S3 bucket name.
- build_dir_name             | build                         | The name of the directory that contains the static frontend files.
```

<hr />


## Output 
This terraform script produces two resources with the following output:
```
- s3_bucket_website
  * id                 
  * arn               
  * bucket_domain_name 
- cloudfront_distribution
  * id          
  * arn         
  * domain_name 
```
<hr />


## Security
The following properties are related to security:
  
  * the website's bucket may be accessed by anyone in the respective AWS account;
  * howevers, its content (like index.html) can only be accessed by CloudFront directly!
<hr />

## Reading material
Here is some useful reading material (for multiple purposes):

* Terraform [remote state module](https://registry.terraform.io/modules/rafaelmarques7/remote-state/aws/1.0.0) - be careful with the version - at the time, version v1.0 is being used;
* Terraform AWS [cloudfront distribution](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html) and [OAI](https://www.terraform.io/docs/providers/aws/r/cloudfront_origin_access_identity.html)
* [Route53 supported DNS record types](https://docs.aws.amazon.com/en_us/Route53/latest/DeveloperGuide/ResourceRecordTypes.html)
* [403 Bad request](https://aws.amazon.com/pt/premiumsupport/knowledge-center/resolve-cloudfront-bad-request-error/)
* Terraform AWS [route53_zone](https://www.terraform.io/docs/providers/aws/r/route53_zone.html) and [route53_record](https://www.terraform.io/docs/providers/aws/r/route53_record.html)
<hr />

## ToDo's
  * bulletproof everything
  * verify re-usability;
<hr />