# helm repo add stakater https://stakater.github.io/stakater-charts
# helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
# helm repo add backube https://backube.github.io/helm-charts/
# helm repo add jetstack https://charts.jetstack.io
# helm repo add bitnami https://charts.bitnami.com/bitnami
# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm repo add grafana https://grafana.github.io/helm-charts

# helm repo update

# helm upgrade --install velero vmware-tanzu/velero -n velero --create-namespace

# helm upgrade --install stakater stakater/reloader

# # snapscheduleer
# helm upgrade --install snapscheduler backube/snapscheduler \
#     -n snapscheduler \
#     --create-namespace

# # cert-manager
# helm upgrade --install cert-manager jetstack/cert-manager -n cert-manager --create-namespace \
#     --set installCRDs=true --set serviceAccount.annotations

# # contour
# helm upgrade --install contour bitnami/contour \
#     -n contour \
#     --create-namespace \
#     --values config/contour/local/values.yaml

# helm upgrade --install external-dns bitnami/external-dns -n external-dns --create-namespace -f external-dns.values

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

# export DNS_MANAGER_ROLE=xx
# export ROUTE53_HOSTED_ZONE=xx
# export DOMAIN_NAME=zbitech.io
# export DB_ADMIN_URL=db-dev.zbitech.io
# export GRAFANA_URL=monitor-dev.zbitech.io

#helmfile sync --environment "${environment}" -f helmfile-aws.yaml
helmfile sync -f helmfile-aws.yaml --debug
