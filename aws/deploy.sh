#!/bin/bash

set -e

usage() {
  cat <<EOF
usage: ${0} [OPTIONS]
The following flags are required.
       --action action to take - verify, create or remove
       --environment installation environment - sandbox, qa, prod
EOF
  exit 1
}

while [[ $# -gt 0 ]]; do
  case ${1} in
    --action)
        action="$2"
        shift
        ;;
    --environment)
        environment="$2"
        shift
        ;;
    *)
        usage
        ;;
  esac
  shift
done

[ -z ${action} ] && action=verify
[ -z ${environment} ] && environment=sandbox

CURR_DIR=${PWD}

SCRIPT_PATH="${BASH_SOURCE[0]:-$0}";
cd "$( dirname -- "$SCRIPT_PATH"; )" > '/dev/null';

echo ${SCRIPT_PATH}

if [[ ${action} == "init" ]]; then
  echo "initializing terraform"
  cd tf
  terraform init

elif [[ ${action} == "format" ]]; then
  echo "verifying canonical format"
  cd tf
  terraform fmt -check

elif [[ ${action} == "verify" ]]; then
  echo "verifying cluster config"
  cd tf
  terraform plan -var-file=${environment}.tfvars -var region=${AWS_REGION} -var environment=${environment} -input=false

elif [[ ${action} == "create" ]]; then
  echo "creating cluster"

  cd tf
  terraform apply -var-file=${environment}.tfvars -var region=${AWS_REGION} -var environment=${environment} -input=false --auto-approve && \
#  terraform output > output.env

  aws eks update-kubeconfig --name zbi-sandbox --kubeconfig ${CURR_DIR}/kubeconfig --verbose

elif [[ ${action} == "remove" ]]; then
  echo "deleting cluster"

  cd tf
  terraform destroy -var-file=${environment}.tfvars -var region=${AWS_REGION} -var environment=${environment} -input=false --auto-approve

else
  echo "Unknown action ${action}"
fi
