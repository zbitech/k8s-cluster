#!/bin/bash

set +e

NAMESPACE=monitoring
NODE_EXPORTER=prometheus-node-exporter

kubectl -n "${NAMESPACE}" patch ds \
  "${NODE_EXPORTER}" --type "json" -p '[{"op": "remove", "path" : "/spec/template/spec/containers/0/volumeMounts/2/mountPropagation"}]'
