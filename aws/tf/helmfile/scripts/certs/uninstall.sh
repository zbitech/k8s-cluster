#!/bin/bash

CERTS_NS=$1
CERTS_NAME=$2

CERTS_MGR_NS=$3
CERTS_MGR_NAME=$4

[ -z "${CERTS_NS}" ] && CERTS_NS=zbi
[ -z "${CERTS_NAME}" ] && CERTS_NAME=certs
[ -z "${CERTS_MGR_NS}" ] && CERTS_MGR_NS=cert-manager
[ -z "${CERTS_MGR_NAME}" ] && CERTS_MGR_NAME=cert-manager

helm -n "${CERTS_NS}" uninstall "${CERTS_NAME}"

helm -n "${CERTS_MGR_NS}" uninstall "${CERTS_MGR_NAME}"
kubectl delete ns "${CERTS_MGR_NS}"
