#!/bin/bash

set +e

# helm -n monitoring list
helm -n monitoring uninstall grafana
helm -n monitoring uninstall prometheus
helm -n monitoring uninstall loki

helm -n zbi uninstall dashboard
helm -n zbi uninstall controller

helm -n mongodb uninstall community-operator

helm -n zbi uninstall certs
helm -n cert-manager uninstall cert-manager

helm -n contour uninstall contour

helm -n kube-system uninstall csi-driver
helm uninstall csi-driver
helm uninstall stakater

helm -n snapscheduler uninstall snapscheduler

kubectl delete ns cert-manager contour snapscheduler mongodb monitoring zbi
