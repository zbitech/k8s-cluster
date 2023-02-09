#!/bin/bash

set +e

CURR_DIR="${PWD}"
[ -z "${ENVIRONMENT}" ] && ENVIRONMENT=dev

cd deploy/helmfile

helmfile sync --environment "${ENVIRONMENT}"
