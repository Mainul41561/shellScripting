#!/bin/bash
set -euo pipefail

check_awscli() {
    if command -v aws &> /dev/null; then
        echo "AWS CLI is already installed. Version: $(aws --version 2>&1)"
        return 0
    else
        return 1
    fi
}

install_awscli() {
    echo "Installing AWS CLI v2 on Linux..."

    local url="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
    local zip_file="awscliv2.zip"

    curl -s "$url" -o "$zip_file"
    sudo apt-get update &> /dev/null
    sudo apt-get install -y unzip &> /dev/null

    unzip -q "$zip_file"
    sudo ./aws/install --update  # --update allows reinstall if needed

    echo "AWS CLI installed successfully: $(aws --version 2>&1)"

    # Clean up
    rm -rf "$zip_file" ./aws
}

wait_for_instance() {
    local instance_id="$1"
    echo "Waiting for instance $instance_id to be in 'running' state..."

    while true; do
        local state
        state=$(aws ec2 describe-instances \
            --instance-ids "$instance_id" \
            --query 'Reservations[0].Instances[0].State.Name' \
            --output text 2>/dev/null || echo "unknown")

        if [[ "$state" == "running" ]]; then
            echo "Instance $instance_id is now running."
            break
        elif [[ "$state" == "terminated" || "$state" == "stopped" ]]; then
            echo "Instance $instance_id entered terminal state: $state" >&2
            exit 1
        fi
        sleep 10
    done
}

create_ec2_instance() {
    local ami_id="$1"
    local instance_type="$2"
    local key_name="$3"
    local subnet_id="$4"
    local security_group_id="$5"  # Accept only one for simplicity
    local instance_name="$6"

    # Validate inputs
    if [[ -z "$ami_id" || -z "$key_name" || -z "$subnet_id" || -z "$security_group_id" ]]; then
        echo "Error: Missing required parameters for EC2 instance creation." >&2
        exit 1
    fi

    echo "Launching EC2 instance with:"
    echo "  AMI: $ami_id"
    echo "  Type: $instance_type"
    echo "  Key: $key_name"
    echo "  Subnet: $subnet_id"
    echo "  Security Group: $security_group_id"
    echo "  Name: $instance_name"

    local instance_id
    instance_id=$(aws ec2 run-instances \
        --image-id "$ami_id" \
        --instance-type "$instance_type" \
        --key-name "$key_name" \
        --subnet-id "$subnet_id" \
        --security-group-ids "$security_group_id" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" \
        --query 'Instances[0].InstanceId' \
        --output text
    )

    if [[ -z "$instance_id" || "$instance_id" == "None" ]]; then
        echo "Failed to create EC2 instance." >&2
        exit 1
    fi

    echo "Instance $instance_id created successfully."
    wait_for_instance "$instance_id"
}

main() {
    # Install AWS CLI if not present
    if ! check_awscli; then
        install_awscli
    fi

    # === CONFIGURE THESE VALUES ===
    AMI_ID="" # Replace with a valid AMI
    INSTANCE_TYPE="t2.micro"
    KEY_NAME=""  # Must exist in your AWS account
    SUBNET_ID="" # Public subnet recommended
    SECURITY_GROUP_ID="" # Single security group ID
    INSTANCE_NAME="Shell-Script-EC2-Create"

    echo "Creating EC2 instance..."

    create_ec2_instance \
        "$AMI_ID" \
        "$INSTANCE_TYPE" \
        "$KEY_NAME" \
        "$SUBNET_ID" \
        "$SECURITY_GROUP_ID" \
        "$INSTANCE_NAME"

    echo "EC2 instance creation completed."
}

main "$@"
