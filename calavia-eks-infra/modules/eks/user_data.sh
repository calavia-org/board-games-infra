#!/bin/bash
set -o xtrace
# shellcheck disable=SC2154
/etc/eks/bootstrap.sh ${cluster_name}
/opt/aws/bin/cfn-signal --exit-code $? --stack  --resource AutoScalingGroup --region
