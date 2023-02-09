#!/bin/bash

set +e

event=$1
[ -z "${event}" ] && event=prepare

if [[ $event == "prepare" ]]; then
  SNAPSHOTTERVERSION=$2
  [ -z "${SNAPSHOTTERVERSION}" ] && SNAPSHOTTERVERSION=release-5.0

  kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTERVERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
  kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTERVERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
  kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTERVERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml

  # Create snapshot controller
  kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTERVERSION}/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml
  kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTERVERSION}/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml

  #  kubectl apply -f csi-driver/manifest/crds.yaml

  rm -rf csi-driver-host-path
  git clone https://github.com/kubernetes-csi/csi-driver-host-path.git
  currDIR=${PWD}
  cd csi-driver-host-path/deploy/kubernetes-latest
  ./deploy.sh
  cd "${currDIR}"
  rm -rf csi-driver-host-path

elif [[ $event == "postsync" ]]; then

  storageClass=$(kubectl get sc csi-sc -o json | jq .kind -r)

  echo "Storage class => $storageClass"
  if [[ -z "$storageClass" ]]; then
    # create storageclass
    cat <<EOF | kubectl create --filename -
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: csi-sc
provisioner: hostpath.csi.k8s.io
volumeBindingMode: Immediate
reclaimPolicy: Delete
allowVolumeExpansion: true
EOF
  else
    echo "StorageClass already created"
  fi

  volumeSnapshot=$(kubectl get volumesnapshotclass csi-snapclass -o json | jq .kind -r)

  if [[ -z "$volumeSnapshot" ]]; then
    # create volumesnapshot
    cat <<EOF | kubectl create --filename -
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata:
  name: csi-snapclass
deletionPolicy: Delete
driver: hostpath.csi.k8s.io
EOF
  else
    echo "VolumeSnapshotClass already created"
  fi

elif [[ $event == "remove" ]]; then
  SNAPSHOTTERVERSION=$2
  [ -z "${SNAPSHOTTERVERSION}" ] && SNAPSHOTTERVERSION=release-5.0

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

fi