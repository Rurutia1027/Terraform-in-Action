# Creating VPCs and Subnets Manually in AWS 

## Introduction 

In this exercise, we will focus on manually building a simple VPC-subnet infrastructure on the AWS Console. 
This includes creating a VPC, two subnets(one public and one private), an Internet Gateway, and a public route table. 
By creating these elements manually, we will gain a deeper understanding of how intricate and challenging the process of creating and managing infrastructure can be.  This will provide a foundation for appreciating the benefits Infrastructure as Code(IaC) in automating these tasks and maintaining consistency across environments. 

--- 

## Desired Outcome 
If you wish to give it shot before looking detailed step-by-step and the solution videos, here is an overview of what the created solution deploy: 

* 1. A VPC with a CIDR block of `10.0.0.0/16`. 
    _CIDR: Classless Inter-Domain Routing, a method for assigning IP addresses and routing Internet Protocol(IP) packets. CIDR replaces the older system based on classes(Class A,B,C) and provides a more efficient and flexible way to allocate IP addresses_
* 2. One public subnet with a **CIDR** block of `10.0.0.0/24`.
* 3. One private subnet with a CIDR block of `10.0.1.0/24`.
* 4. One Internet Gateway.
* 5. One public route table with a route to the internet Gateway, and the correct association between public subnet and public route table. 

--- 

## Step-by-Step Guide 
* 1. Login to your AWS console.
* 2. Navigate to the VPC Dashboard.
* 3. Click on "Your VPCs" then "Create VPC".
* 4. Enter a Name tag and the CIDR block of `10.0.0.0/24`.
* 5. Go back to the VPC Dashboard and click on "Subnets".
* 6. Click "Create sunet".
* 7. Fill in the Name tag, select the VPC you just created, and enter the CIDR block `10.0.0.0/24` to create the public subnet. 
* 8. Repeat this process with the CIDR block `10.0.1.0/24` to create the private subnet. 
* 9. Go back to the VPC Dashboard and click on "Internet Gateways".
* 10. Click "Create Internet gateway", give it a Name tag, then click "Create".
* 11. Select the Internet Gateway you just created click "Actions", then "Attach to VPC", and select your VPC. (Gateway --> attach to VPC). 
* 12. Go back to the VPC Dashboard and click on "Route Tables".
* 13. Click "Create route table", enter a Name tag, select your VPC, and then click "Create". 
* 14. Select the Route Table you just created and click on the "Routes" tab, then click "Edit routes".
* 15. Click "Add route", for the Destination enter `0.0.0.0/0`, for the Target select the Internet Gateway you created, then click "Save routes". 
* 16. Click on the "Subnet Associations" tab, then click "Edit subnet associations".
* 17. Select the public subnet, then click "Save". 