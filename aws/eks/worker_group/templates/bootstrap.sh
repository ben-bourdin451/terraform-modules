#!/usr/bin/env bash

set -e
set -o xtrace

# Allow user supplied pre userdata code
${pre_bootstrap_script}

# Bootstrap and join the cluster
/etc/eks/bootstrap.sh --b64-cluster-ca '${certificate_authority}' --apiserver-endpoint '${endpoint}' ${bootstrap_extra_args} --kubelet-extra-args '${kubelet_extra_args}' '${cluster_name}'

# Allow user supplied userdata code
${post_bootstrap_script}