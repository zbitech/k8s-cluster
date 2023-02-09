#!/bin/bash

CONTOUR_NS=$1
CONTOUR_NAME=$2

[ -z "${CONTOUR_NS}" ] && CONTOUR_NS=contour
[ -z "${CONTOUR_NAME}" ] && CONTOUR_NAME=contour

helm -n "${CONTOUR_NS}" uninstall "${CONTOUR_NAME}"
kubectl delete ns "${CONTOUR_NS}"