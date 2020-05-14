# Exercise #3
Deploy a Cloud-Based Web Server. 

The chosen infrastructure orchestration tool is Terraform and the cloud platform is AWS

The code register a ssh-key pair, creates security group, creates a S3 storage and upload two files, and creates an EC2 VM, then install an NGINX webserver and configure it to use the index.html page stored in the S3 bucket. The VM has the following charaxteristics

The EC2 instance is:

OS: Ubuntu 16.04 LTS

Size: T2-MICRO

Region: EU-WEST-3
