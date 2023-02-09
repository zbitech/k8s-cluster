#!/bin/bash

event=$1
[ -z "${event}" ] && event=prepare

SNAPSHOTTERVERSION=$2
AWS_ROLE_NAME=$3
AWS_ACCOUNT_ID=$4
AWS_REGION=$5
EKS_HASH_ID=$6
NAMESPACE=$7

if [[ $event == "prepare" ]]; then

  [ -z "${SNAPSHOTTERVERSION}" ] && SNAPSHOTTERVERSION=release-5.0

#  echo "Creating role: $ROLE_NAME"
  # generate assume-role json
#  aws iam create-role --role-name "$ROLE_NAME" --assume-role-policy-document file://config/csi-driver/ebs-iam-assume-role.json

#  echo "Attaching policy to role: $ROLE_NAME"
#  aws iam put-role-policy --role-name "$ROLE_NAME" --policy-name ebs-policy --policy-document file://config/csi-driver/ebs-iam-policy.json

  kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTERVERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
  kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTERVERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
  kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTERVERSION}/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml

elif [[ $event == "postsync" ]]; then

  storageClass=$(kubectl get sc csi-sc -o json | jq .kind -r)

  if [[ -z "$storageClass" ]]; then
  # create storageclass
  cat <<EOF | kubectl create --filename -
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: csi-sc
provisioner: ebs.csi.aws.com
parameters:
  type: gp2
  encrypted: 'true'
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Delete
allowVolumeExpansion: true
EOF
  else
    echo "StorageClass already created"
  fi

  volumeSnapshot=$(kubectl get volumesnapshotclass csi-snapclass -o json | jq .kind -r)

  if [[ -z "$volumeSnapshot" ]]; then
  # create volumesnapshotclass
  cat <<EOF | kubectl create --filename -
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata:
  name: csi-snapclass
deletionPolicy: Delete
driver: ebs.csi.aws.com
EOF
  else
    echo "VolumeSnapshotClass already created"
  fi

fi
