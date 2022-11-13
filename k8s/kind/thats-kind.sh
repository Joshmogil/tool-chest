#!/bin/bash

#create encryption secret
encryption_secret=$(head -c 32 /dev/urandom | base64)

echo "generated encryption secret: ${encryption_secret}"
echo "!WARNING! Do not log the encryption secret and be sure to save it in some location."

echo "apiVersion: v1
kind: EncryptionConfiguration
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${encryption_secret}
      - identity: {}" > enc.yaml

kind create cluster
control_plane_node=$(docker container ls | grep control-plane | sed 's/ .*//')
echo $control_plane_node
docker exec -ti "${control_plane_node}" sh -c "mkdir /etc/kubernetes/enc"
docker cp ./enc.yaml "${control_plane_node}:/etc/kubernetes/enc/"
docker cp ./kube-apiserver-override.yaml "${control_plane_node}:/etc/kubernetes/manifests/"
docker exec -ti "${control_plane_node}" sh -c "cat /etc/kubernetes/manifests/kube-apiserver-override.yaml > /etc/kubernetes/manifests/kube-apiserver.yaml"