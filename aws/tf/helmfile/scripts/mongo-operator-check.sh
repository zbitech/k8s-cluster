#!/bin/bash

set +e

# wait for completion of operator
kubectl -n mongodb rollout status deployment mongodb-kubernetes-operator