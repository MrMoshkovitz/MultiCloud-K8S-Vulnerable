# Terravuln -Multi Cloud Infrastructure Vulnerability Generator for Terraform

## Original TerraVuln
The Original Terravuln App had 2 Apps and Worked for all the 3 Cloud providers (AWS, Azure, GCP) - Azure Resources were event more mature
Both of the apps had all the resources below (Communicating) and the only difference was the vulnerabilities.
AWS Windows VM's with Native Windows Vulnerabilities were included - could not re prodoce this part in the time given
1. HackCloud
2. ProCloud

In Addition to that both of the Apps had Shared Resources:
* IAM Users
* S3 Buckets
* VPCs
* EKS Clusters
* Lambdas
* EC2 Instances

This was In order to check:
* Communication between the apps and the shared resources
* Lateral Movement
* Privilege Escalation
* Reconnaissance - Finding 1 app from the other or from the Both


## Terravuln - Zoom Info AWS Resources
> **Note**
>  Unfortunatly, Due to lack of time not all of the original application is presented here, most of the vulnerabilities are presented but not all of them




## Terravuln - AWS Infrastructure Vulnerability Generator for Terraform
* Multiple Native Versions of AWS Infrastructure Vulnerabilities
* Both Encryption at Rest Vulnerabilities and Encryption in Transit Vulnerabilities
* Vulnerable & Permissive IAM Policies & Roles
* No Seperation of Duties & Privilege Escalation Vulnerabilities
* Open Ports & Permissive Networks Access Vulnerabilities
* Vulnerable VPCs
* Permissive Containers Registries Repositories Actions & Permissions
* Vulnerable Web Applications & APIs & Web Servers
* Publicly Accessible Resources
  * Databases
  * Virtual Machines
  * S3 Buckets
  * Clusters
* Vulnerable & Insecure Lmabda Function
  * Insecure Environment Variables
  * Permissive Actionable Permissions - Inlcuding Execution




### S3 Buckets - 2
---
* [1] - app1 Bucket - Unathorized User Access Allowed - No Restrictions
  * Publicly Accessible Bucket
  * Public Access Policy
  * Not Ignoring Public Access Lists
  * Not Restricting Public Buckets
  * Force Destroy - Enabled (Data Loss)
    * Bucket will be deleted with its objects 
  * Object Lock - Disabled (Data Loss)
    * Objects & Buckets can be deleted & modified without any version control
  * ACL - Public Read & Write Access - Enabled
  * Insecure Bucket Cors - Sensitive Data Exposure
    * Allowes from Any Origin (*) - Cross Origin Attacks
      * Unauthorized & Unrestrticted Access 
    * Permissive & Insecure Cors Methods: 
    * GET - View Bucket Objects
    * PUT - Update Objects in Bucket
    * POST - Upload Objects to Bucket
    * DELETE - Delete Objects from Bucket
    * HEAD - View Bucket Objects Metadata
      * Unauthorized & Unrestrticted Access
    * Exposed Headers
      * ETag = Chaching & Versioning - not inscecure but can be used for cache poisoning
      * x-amz-server-side-encryption - Encryption in Transit - Not Revealing Keys bu Reveal Encription type & status
      * x-amz-request-id - Not Sensitive but add more information to the response (Generally not recommended)
      * x-amz-version-id - Reveal Pervious Versions of Objects - Sensitive Data - Can cause Data Loss & Fixed Securityu Issues Vulnerabilities
      * x-amz-delete-marker - No Sensitive Data but can be used to detect if an object was deleted
      * x-amz-tagging - Reveal Object Tags Metadata which can reveal sensitive data (from Prefixes to Credentials)
      * x-amz-storage-class - Reveal Object Storage Class - Not Sensitive but can be used to detect The bucket Storage class for later vulnerability analysis
      * x-amz-website-redirect-location - Reveal Website Redirection Location - Add more and potentially Insecure Victim Target to the response (Generally not recommended to be exposed)
      * x-amz-restore, x-amz-restore-output-path - Reveal Important Informaion about Restoring objects - Not Sensitive but can be used to detect The bucket Storage class for later vulnerability analysis
      * x-amz-copy-source-version-id - Reveals Version ID of the Source Object - Sensitive Data - Can cause Data Loss & Previous Vulnerable Versions of Objects Access 
      * x-amz-encrypted - Client Side Encryption - Not Revealing Keys bu Reveal Encription type & status
      * Max Age Second - 50 Minutes
    * Sensitive Data in Tags 
      * User - admin
      * Password - password
* [2] - app21 Bucket - Unathorized User Access Allowed - No Restrictions
  * Publicly Accessible Bucket
  * Public Access Policy
  * ACL - Public Read & Write Access - Enabled
  * Not Ignoring Public Access Lists
  * Not Restricting Public Buckets
  * Force Destroy - Enabled (Data Loss)
    * Bucket will be deleted with its objects 
  * Object Lock - Disabled (Data Loss)
    * Objects & Buckets can be deleted & modified without any version control
  * Allow All Buckets Actions on All Resources - Overly Permissive
    * Action = s3:*
  * Allow Anyone to Read Write and Delete Bucket Objects
    * Prinicpal = *

### CloudWatch - 1
---

* [1] Log Group for EKS Cluster
  * Retention - 7 Days
  * No Encryption


### IAM - Multiple IAM Users & Roles & Policies Allows Privilege Escalation - 9
---
* [1] - IAM User for ECR
  * Allow Get, Put, Upload, Delete and List Actions on ECR
  * Overely Permissive Access to ECR ()
* [2] - IAM User for ECS
  * Assume Role - Allows Assume Role to ECS Service Role - No Seperation of Duites
    * Insecure Privilege Escalation
    * Overely Permissive Access
* [3] - IAM User for EC2 - 2
  * Assume Role - Allows Assume Role to EC2 Service Role - No Seperation of Duites
    * Insecure Privilege Escalation
    * Overely Permissive Access
* [4] - IAM Admin User - All Access to All AWS Services -
  * Assume Role - Allows Access to All AWS Resources - No Seperation of Duites
    * Insecure Privilege Escalation
    * Overely Permissive Access
* [4] - IAM High Priviledge Shdaow Admin User - (Assume Roles for Usage in Privilege Escalation)
  * Assume Role - Allows Access to All AWS Resources - No Seperation of Duites
    * Insecure Privilege Escalation
    * Overely Permissive Access
  * [4.1] - Assume Role from Shdaow Admin User - for Privilege Escalation
    * Assume Role - Allows Access to All AWS Resources - No Seperation of Duites
      * Copy (Assume Role) from IAM High Priviledge Shdaow Admin User - for Privilege Escalation
      * Overely Permissive Access
  * [4.2] - Assume Role from The New Assume Role - Shdaow Admin User - for Privilege Escalation
    * Assume Role - Allows Access to All AWS Resources - No Seperation of Duites
      * Copy (Assume Role) from IAM High Priviledge Shdaow Admin User - for Privilege Escalation
      * Overely Permissive Access
  * [4.4] - Assume Role from The New2 Assume Role - Shdaow Admin User - for Privilege Escalation
    * Assume Role - Allows Access to All AWS Resources - No Seperation of Duites
      * Copy (Assume Role) from IAM High Priviledge Shdaow Admin User - for Privilege Escalation
      * Overely Permissive Access
* [5] - IAM Role for Lambda Execution - Insecure & Permissive Execution of Lambda Functions & Keys Access
      * Overely Permissive Permision to Exec Lambda Functions
      * logs:CreateLogGroup - Create Log Groups
      * logs:CreateLogStream - Create Log Streams
      * logs:PutLogEvents - Put Log Events
      * iam:ListAccessKeys - List IAM User Access Keys
      * iam:CreateAccessKey - Create IAM User Access Keys
      * iam:DeleteAccessKey - Delete IAM User Access Keys
      * iam:UpdateAccessKey - Update IAM User Access Keys
      * iam:ListUsers - List IAM Users
        * Credentials Stuffing & Phising
      * iam:CreateUser - Create IAM Users
      * iam:ChangePassword - Change IAM User Password
* [6] - IAM Assume Role for ECS Execution - Insecure Execution of ECS Tasks 
      * Overely Permissive Permision to Exec ECS Tasks
* [7] - IAM Role for S3 - Insecure S3 & S3 Object Actions
  * s3:GetObject - Get S3 Objects
  * s3:PutObject - Put S3 Objects
  * s3:DeleteObject - Delete S3 Objects
  * s3:CreateBucket - Create S3 Buckets
  * s3:DeleteBucket - Delete S3 Buckets
  * s3:DeleteBucketPolicy - Delete S3 Bucket Policy
  * s3:DeleteBucketCors - Delete S3 Bucket CORS
  * s3:ListBuckets - List All S3 Buckets
* [8] IAM User for ECS - EC2 Permissions
  * Read Access to all EC2 Resources -  Sensiive Data Exposure (ec2:Describe*)
  * Create & Run New EC2 Resources - Costly & Insecure (ec2:RunInstances)
  * Terminate & Delete EC2 Resources - Costly & Insecure (ec2:TerminateInstances)
    * Includes Terminate EC2 EBS Storage - Costly & Insecure (ec2:DeleteVolume)
  * Delete Access to all EC2 Resources -  Sensiive Data Exposure (ec2:Terminate*)
  * Overely Permissive Access - Privilege Escalation - Laterally Move to Other AWS Services
    * ssm:* - Full Access to SSM Actions
      * Unauthorized Access to change & managed instances, create, delete, or modify SSM documents, and manage SSM parameters.
    * ssmmessages:* - Full Access to SSM Messages Actions
      * Unauthorized access to communication between SSM agents and the SSM service.
    * ec2:Describe* - Full Access to EC2 Actions
      * Unauthorized access to view and manage EC2 resources.
    * ec2:RunInstances - Full Access to EC2 Actions
      * Unauthorized access to create EC2 instances.
    * ec2:TerminateInstances - Full Access to EC2 Actions
      * Unauthorized access to terminate EC2 instances.
    * ec2:DeleteVolume - Full Access to EC2 Actions
      * Unauthorized access to delete EBS volumes.
* [9] - api_gateaway Lambda Permissions
  * Unauthorized Access to All Lambda Functions
  * Overly Permissive Actions & Permitted Resources 
  * Excessive Privileges to the API Gateaway
  * Principal = * - Unauthorized Access from other AWS Accounts
  * Easily Gussed & Weakt Statement ID
  * Insecure Authentication & Authorization
    * Unatuthorized Lambda Exection
  * Informative & Excessive Logging & Error messages - Sensitive Information Leakage


### Database - 2
---
#### MySQL - 2
* [1] MySQL 5.7
  * Vulnerable Admin User - admin
  * Vulnerable Admin Password - admin123456
  * Vulnerable VPC Network & Subnets 
* [2] MySQL 8.00
  * Vulnerable Admin User - mysqladmin
  * Vulnerable admin Password - mysqlpassword



### EC2
---
#### Linux - 2
---
* [1] - app1 - Ubuntu t3.micro
  * DDOS Vulnerable Security Group - Allows All Ports From Anywhere
  * Not Encrypted
  * Container Hopping Vulnerable
  * Vulnerable Environement Variables
    * AWS Access Key 
    * aws Secret Access Key
  * [1.1] EBS Volume
    * Not Encrypted
* [2] - DB APP - Ubuntu t3.nano
  * DDOS Vulnerable Security Group - Allows All Ports From Anywhere
  * Container Hopping Vulnerable
  * Not Encrypted
  * Vulnerable PHP Webserver Application
  * Public DNS Name - Enabled
  * Public Endpoint - Enabled
    * No Content Filtering
    * DB Name
    * DB Server Endpoint URL 
    * DB Usernmame
    * DB Password
    * SQLI Vulnerabilities
  * Vulnerable Environement Variables
    * AWS Access Key 
    * aws Secret Access Key
  * [2.1] EBS Volume Attached
    * Not Encrypted
* 

### EKS - 1
---
* [1] - app1 - Elastic Kubernetes Cluster
  * Vulnerable & Permissive IAM Policy
  * Vulnerable & Permissive Network Access & Security Group
  * Insecure Node Group Name
  * Mazximum Scaling Capacity - 5 (Can be Manipulated)



### ECR - 1
---
* [1] - gm-vulny - AWS ECR
  * IAM Policy - Allows All Actions From Anywhere
  * 

### ECS - 1
---
* [1] - vulny_ecs_cluster - AWS ECS - t2.micro
  * Nginx Vulnerable Webserver Application
    * Vulnerable Environment Variables
      * MYSQL_ROOT_PASSWORD
      * MYSQL_DATABASE
      * MYSQL_USER
      * MYSQL_PASSWORD
  * [1.1] Auto Scaling Launch Configuration & Group
    * Vulnerable IAM Instance Profile
      * Permissive IAM Policy
      * Permissive IAM Role
    * Vulnerbale Security Groups - Allows All Ports From Anywhere
  * [1.2] Task - Nginx Vulnerable Webserver Application
    * Publicly Accessible
    * Port 80 - To & From Anywhere to Container
    * Vulnerable Environment Variables
  * [1.3] Service - Nginx Vulnerable Webserver Application
    * Publicly Accessible
    * Public IP - Enabled
    * Port 80 - To & From Anywhere to Container
    * Vulnerable Environment Variables
    * Launchh Type - FARGATE

### KMS - 1
---
* [1] - kms_key - Insecure & Permissive KMS Policy - Privilege Escalation & Lateral Movement
  * Allows Access from All Principal in the Account


### Lambda - 2
---
* [1] - Lambda Node.js 14.x Function from local zip Folder 
  * Insecure Docker Image
  * Insecure Node.js Application Code
* [2] -Lambda Node.js 14.x Function from imported zip Folder
  * Insecure & Integrated Environment Variables
    * NODE_ENV - production
    * ACCOUNT_ID - 123456789
    * REGION - us-east-1
  * Insecure Docker Image
  * Insecure Node.js Application Code
* 


# Networking
---

#### VPC - 1
---
* [1] - app1 VPC -
  * DNS Hostnames - Enabled
  * DNS Support - Enabled


#### Subnets - 3
---
* [1] app1 Subnet - 
  * Permissive Network Security Groups
  * No Isolation or Segregation
* [2] app1-db - Subnet Group - app1-db1 Subnet -
  * Permissive Network Security Groups
  * No Isolation or Segregation
* [3] app1-db - Subnet Group - app1-db2 Subnet -
  * Permissive Network Security Groups
  * No Isolation or Segregation

### Network Interfaces - 1
---
* [1] - app1 - Network Interface - 
  * Publicly Accessible
  * Include Private IPs



#### Route Tables - 1
---
* [1] - app1 Route Table
  * Routing Traffic to and from the Internet 
  * No Explict Security Group and ACL
    * Not Denying Inbound Traffic & Allow all Outbound Traffic

#### API Gateway - 1
---
* [1] api_gateaway - API Gatewaway
  * Endpoint - Enabled
  * API Key Selection Expression - Enabled
  * API Execution Endpoint - Enabled
  * HTTP API - Enabled (Not Secure)
  * Allowed HTTP Methods - Enabled
    * POST
  * Access to prod Stage - Enabled
  * Automatice Deployment - Enabled - 
  * If not properly monitored - Can cause insecure deployment 
  * Both Encryption at Rest Vulnerabilities and Encryption in Transit Vulnerabilities


#### Internet Gateway - 1
---
* [1] - app1 - AWS Internet Gateaway
* 


#### Security Groups - 3
---
* [2] - app1 - Security Group
    * Inbound Ports Allowed
      * Allow from 0.0.0.0 (All)
      * TCP/1433 - MYSQL
      * TCP/22 - SSH
      * TCP/3306 - MYSQL
      * TCP/25 - SMTP
      * TCP/80 - HTTP
      * TCP/443 - HTTPS
      * TCP/445 - SMB
      * TCP/3389 - RDP
      * TCP/5432 - POSTGRESQL
      * TCP/6379 - REDIS
      * TCP/11211 - MEMCACHED
      * TCP/27017 - MONGODB
      * TCP/9200 - ELASTICSEARCH
      * TCP/9300 - ELASTICSEARCH
    * Oubound Ports Allowed
      * Allow from All
      * All Networks - 0.0.0.0/0
      * All Ports - 0
      * All Protocols - -1
      * To All Ports - 0
      * Specifically Allow Access to RDP Port (In Case of User Restricting the Ports Access)
    * Insecure Data in NSG Tags
      * User - admin
      * Password - password
    * No Timeout for Idle Connections
* [2] - app1-db - DB Security Group
  * Allowed MYSQL Inbound Port - 3306
  * Allow Access to All Networks (0.0.0.0/0)
* [3] - db_instance - DB Instance Security Group
  * Allowed MYSQL Inbound Port - 3306
  * Allow Access to All Networks (0.0.0.0/0)




#### Elastic IP - 1
---
* [1] - app1 - Elastic IP


#### Application Load Balancer
---
* [1] Application Load Balancer
  * DNS Name - Enabled
  * Dont have a WAF
    * Or WAF Fail Open
  * Not Dropping invalid headers
  * Not Enable deletion protection
  * Dont have Internal Load Balancer
  * Vulnerable Security Group[AllowingPorts] - Allows Multiple Ports From Anywhere
  * Access Logs - Disabled
  * 
