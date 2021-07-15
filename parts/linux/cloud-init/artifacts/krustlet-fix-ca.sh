#!/usr/bin/env bash
set -o nounset
set -o pipefail
set -o errexit
set -x

DONE="$(grep certificate-authority-data /var/lib/kubelet/bootstrap-kubeconfig)"

# TODO(ace): always use /etc/kubernetes/certs/ca.crt?
CA_FILE=$(grep certificate-authority /var/lib/kubelet/bootstrap-kubeconfig | cut -d" " -f6)
CA_CONTENT="$(cat $CA_FILE | base64 -w 0)"
sed -i "s~certificate-authority: /etc/kubernetes/certs/ca.crt~certificate-authority-data: $CA_CONTENT~g" /var/lib/kubelet/bootstrap-kubeconfig 
