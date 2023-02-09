#!/bin/bash

SNAPSHOTTERVERSION=$1
[ -z "${SNAPSHOTTERVERSION}" ] && SNAPSHOTTERVERSION=release-5.0

remove_hostpath() {
  rm -rf csi-driver-host-path
  git clone https://github.com/kubernetes-csi/csi-driver-host-path.git
  currDIR=${PWD}
  cd csi-driver-host-path/deploy/kubernetes-latest
  ./destroy.sh
  cd "${currDIR}"
  rm -rf csi-driver-host-path


  kubectl delete -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTERVERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
  kubectl delete -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTERVERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
  kubectl delete -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTERVERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml

  kubectl delete -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTERVERSION}/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml
  kubectl delete -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTERVERSION}/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml
}

remove_ebs() {
  helm -n kube-system uninstall aws-ebs-csi-driver

  kubectl delete -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTERVERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
  kubectl delete -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTERVERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
  kubectl delete -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTERVERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml
}