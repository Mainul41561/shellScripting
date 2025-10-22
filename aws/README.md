
# Create AWS EC2 Instance Using Shell Script

This Bash script automates the creation of an EC2 instance on AWS using the AWS CLI. It checks for AWS CLI installation, installs it if missing, and launches a new instance with your specified configuration.

## 🔐 Prerequisites

### 1. **AWS Account**
You must have an active [AWS account](https://aws.amazon.com/).

### 2. **IAM User with EC2 Permissions**
Create an IAM user with **EC2 full access**:

1. Go to the [AWS IAM Console](https://console.aws.amazon.com/iam).
2. Click **Users** → **Add user**.
3. Enter a username (e.g., `ec2-deployer`).
4. Select **Access key - Programmatic access**.
5. Under **Permissions**, choose:
   - **Attach existing policies directly**
   - Search for and select: `AmazonEC2FullAccess`
6. Click **Next** → **Create user**.
7. **Download the CSV** containing your `Access Key ID` and `Secret Access Key`.

## Configure AWS CLI

Run the following command and enter your IAM user credentials:

```bash
aws configure
```
## You’ll be prompted for:

1. AWS Access Key ID → from your IAM CSV
2. AWS Secret Access Key → from your IAM CSV
3. Default region name → e.g., us-east-1 (use the region where you want your instance)
4. Default output format → press Enter for 

## 🔑 How to Get Required AWS Resource IDs

Before running the script, replace the placeholder values with real IDs from your AWS account — all in the **same region**. Below are both **CLI and Console (graphical) methods**.

---

### 1. **`AMI_ID` – Amazon Machine Image**

We recommend **Ubuntu 22.04 LTS** (free tier eligible).

#### ✅ Graphical Method (AWS Console):
1. Go to the [**EC2 Dashboard**](https://console.aws.amazon.com/ec2) in your AWS Console.
2. In the left sidebar, click **Instances** → then click the blue **Launch instances** button.
3. Under **Application and OS Images (Amazon Machine Image)**, choose:
   - **Quick Start** → **Ubuntu**
   - Select **Ubuntu 22.04 LTS** (look for "Free tier eligible" label)
4. **Do NOT launch the instance!**  
   Instead, note the **AMI ID** shown below the image name (e.g., `ami-0a49b57c8f8d9e012`).

   ![Example: AMI ID displayed under Ubuntu 22.04 in launch screen](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/images/ami-select-ubuntu.png)

5. Copy this **AMI ID** — this is your `AMI_ID`.

> 💡 Tip: Make sure you’re in the correct region (top-right corner of AWS Console).


## 🔑 How to Find AWS Resource IDs (Using AWS Console)

If you're not comfortable with the AWS CLI, you can easily find all required IDs using the **AWS Management Console**. Follow these steps:

---

### 1. **Key Pair (`KEY_NAME`)**

> Used to securely connect (SSH) to your EC2 instance.

#### Steps:
1. Open the [**EC2 Console**](https://console.aws.amazon.com/ec2).
2. In the left sidebar, under **Network & Security**, click **Key Pairs**.
3. You’ll see a list of existing key pairs.
   - ✅ **If you already have one**: note its **Name** (e.g., `my-ec2-key`). This is your `KEY_NAME`.
   - ➕ **If you don’t have one**: click **Create key pair**.
     - Enter a **Name** (e.g., `django-notes-key`)
     - Choose **`.pem`** as the file format (for Linux/macOS)
     - Click **Create key pair**
     - The private key (`.pem` file) will download automatically — **save it securely!**
4. Use the **key pair name** (not the filename) as your `KEY_NAME`.

> 🔐 Never share your `.pem` file. Store it in a safe place like `~/.ssh/`.

---

### 2. **Subnet ID (`SUBNET_ID`)**

> Your instance must launch in a **public subnet** (one that auto-assigns public IPs).

#### Steps:
1. Open the [**VPC Console**](https://console.aws.amazon.com/vpc).
2. In the left sidebar, click **Subnets**.
3. Look for a subnet with:
   - **Auto-assign public IP** = `Yes`
   - Belongs to the same **Availability Zone** and **VPC** you plan to use
4. Select the subnet row, and in the **Details** panel (or in the list), copy the **Subnet ID** (e.g., `subnet-ab12cd34`).
5. Use this as your `SUBNET_ID`.

> 💡 Tip: If you’re using the **default VPC**, any subnet in it is usually public.

---

### 3. **Security Group ID (`SECURITY_GROUP_ID`)**

> Controls what traffic is allowed to your instance (e.g., SSH, HTTP).

#### Steps:
1. Go back to the [**EC2 Console**](https://console.aws.amazon.com/ec2).
2. In the left sidebar, under **Network & Security**, click **Security Groups**.
3. You’ll see a list of security groups.
   - ✅ **Use an existing one** (e.g., the default security group), **OR**
   - ➕ **Create a new one** by clicking **Create security group**:
     - **Name**: `django-notes-sg`
     - **Description**: "Allow SSH and HTTP for Django Notes App"
     - **VPC**: Choose your default VPC
     - Add inbound rules:
       - Type: **SSH**, Source: **My IP**
       - Type: **HTTP**, Source: **0.0.0.0/0** (or restrict to your IP)
     - Click **Create security group**
4. From the list, copy the **Group ID** (e.g., `sg-98765432`) — **not the name**.
5. Use this **Group ID** as your `SECURITY_GROUP_ID`.

---

### ✅ Final Check

Ensure all resources are in the **same AWS region** (check top-right corner of AWS Console).

## Update these values (lines near the main() function):

```shell script
AMI_ID="ur value"
INSTANCE_TYPE="t2.micro"
KEY_NAME="ur key name"
SUBNET_ID="ur sunet id"
SECURITY_GROUP_ID="ur scurity group id"
INSTANCE_NAME="Shell-Script-EC2-Create"
```
## Now Run the Script just using only this two command
```bash
chmod 700 createEc2.sh
./createEc2.sh
```

