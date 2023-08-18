#/bin/bash

# This script is run after the creation of the terraform resources so that the
# cluster is ready to use. It will install the kubernetes dashboard and join
# the worker nodes to the cluster.

control_plane="ssh -oStrictHostKeyChecking=accept-new -i ec2-login-key ubuntu@$(terraform output control_plane_public_ip | tr -d '"') "
join_command=$($control_plane "cat ~/join-command.txt && sudo rm ~/join-command.txt")

for worker in $(terraform output workers_public_ips |  tr -d '" {}' | cut -d'=' -f2); do
    echo "Joining $worker to the cluster"
    ssh -oStrictHostKeyChecking=accept-new -i ec2-login-key ubuntu@$worker "sudo $join_command"
done

echo "Installing the kubernetes dashboard"
$control_plane "sudo kubectl get nodes"
