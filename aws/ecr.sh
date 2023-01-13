#!/bin/bash

set -e

usage() {
  cat <<EOF
usage: ${0} [OPTIONS]
The following flags are required.
       --action - create or remove
       --environment - sandbox, qa, prod
EOF
  exit 1
}

[ -z ${ZBI_REPO_NAME} ] && ZBI_REPO_NAME=zbi-repo
[ -z ${ZBI_REPO_MUTABLE} ] && ZBI_REPO_MUTABLE=MUTABLE

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

if [[ ${action} == "create" ]]; then
  echo "creating container registry repositories"

  aws ecr create-repository --repository-name zbi-controller --image-tag-mutability ${ZBI_REPO_MUTABLE} --region ${AWS_REGION}
  aws ecr create-repository --repository-name zbi-authz --image-tag-mutability ${ZBI_REPO_MUTABLE} --region ${AWS_REGION}

elif [[ ${action} == "remove" ]]; then
  echo "deleting container registry repositories"

  aws ecr delete-repository --repository-name zbi-controller --region ${AWS_REGION}
  aws ecr delete-repository --repository-name zbi-authz --region ${AWS_REGION}
else
  echo "Unknown action ${action}"
fi

