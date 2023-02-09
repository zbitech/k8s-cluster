#!/bin/bash

set +e

echo "attaching policy to role: $dns_manager_role"

sed -e "s/ACCOUNT_ID/${webhost_account_id}/g" \
    -e "s/CERT_MANAGER_ROLE/${cert_manager_role}/g" \
    config/aws/dns-manager-trust-policy.tmpl > config/aws/dns-manager-trust-policy.json

aws iam put-role-policy --role-name "${dns_manager_role}" --policy-name "${dns_manager_perm_policy}" --policy-document file://config/aws/dns-manager-permission-policy.json

aws iam update-assume-role-policy --role-name "${dns_manager_role}" --policy-document file://config/aws/cert-manager-trust-policy.json


# certificate manager roles
#echo "attaching policy to role: $CERT_MANAGER_ROLE"
#aws iam put-role-policy --role-name "${CERT_MANAGER_ROLE}" --policy-name "${CERT_MANAGER_PERM_POLICY}" --policy-document file://config/aws/cert-manager-permission-policy.json

# ebs csi-driver roles
#echo "attaching policy to role: $EBS_CSI_ROLE"
#aws iam put-role-policy --role-name "${EBS_CSI_ROLE}" --policy-name "${EBS_CSI_PERM_POLICY}" --policy-document file://config/aws/ebs-iam-permission-policy.json

# efs csi-driver role
#echo "attaching policy to role: $EFS_CSI_ROLE"
#aws iam put-role-policy --role-name "${EFS_CSI_ROLE}" --policy-name "${EFS_CSI_PERM_POLICY}" --policy-document file://config/aws/efs-iam-permission-policy.json

