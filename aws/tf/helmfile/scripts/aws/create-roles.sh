#!/bin/bash

set +e

# update value files with environment variables
var_file_name="vars/${ENVIRONMENT}/${PROVIDER}.yaml.tmpl"
WEBHOST_ACCOUNT_ID="662737177474"
AWS_REGION="us-east-1"
ZBI_CLUSTER_HASH_ID=""
NAMESPACE=""
CERT_MANAGER_ROLE="cert-manager"

# update place-holder with sed
sed -e "s/WEBHOST_ACCOUNT_ID/$WEBHOST_ACCOUNT_ID/g" \
    config/aws/cert-manager-trust-policy.tmpl > config/aws/cert-manager-trust-policy.json

echo "Creating certificate manager role: $CERT_MANAGER_ROLE"
aws iam create-role --role-name "$CERT_MANAGER_ROLE" --assume-role-policy-document file://config/aws/cert-manager-trust-policy.json

echo "Creating ebs role: $EBS_CSI_ROLE"
aws iam create-role --role-name "$EBS_CSI_ROLE" --assume-role-policy-document file://config/aws/ebs-csi-permission-policy.json

echo "Creating ebs role: $EFS_CSI_ROLE"
aws iam create-role --role-name "$EFS_CSI_ROLE" --assume-role-policy-document file://config/aws/efs-csi-permission-policy.json

sed -e "s/ACCOUNT_ID/$ACCOUNT_ID/g" \
    config/aws/dns-manager-trust-policy.tmpl > config/aws/dns-manager-trust-policy.json
aws iam put-role-policy --role-name "${DNS_MANAGER_ROLE}" --policy-name "${EFS_CSI_PERM_POLICY}" --policy-document file://config/aws/dns-manager-permission-policy.json
