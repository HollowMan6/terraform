# Terraform code to spin a AMD SEV-SNP Confidential Kubernetes cluster using AWS EC2 instances

Refered to https://github.com/regisftm/aws-ec2-k8s-tf

The Terraform code here will build a Kubernetes cluster using AWS EC2 instances and kubeadm with AMD SEV-SNP technology.

You will need an AWS account and Terraform installed on your computer. Set up the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` in advance by refering to the docs [here](https://docs.aws.amazon.com/keyspaces/latest/devguide/access.credentials.html).

1. Start by cloning this repository:

```bash
git clone https://github.com/HollowMan6/terraform
```

2. Change the directory to Terraform, and run the Terraform initialization:

```bash
cd terraform
terraform init
```

3. Edit the `variables.tf` file and change accordingly. The default value will generate 1 EC2 instance type c6a.large for the control-plane and 1 EC2 instance type c6a.large for the worker node. The AWS region selected is `eu-west-1`.

```bash
vi variables.tf
```

4. Apply the Terraform code. This code will build the EC2 instances and install Kubernetes and other software used in this demonstration.

```bash
terraform apply --auto-approve
```
5. After a few minutes, you will see the output containing the created public IPs for the EC2 instances. 

<pre>
Apply complete! Resources: 12 added, 0 changed, 0 destroyed.

Outputs:

control_plane_public_ip = "3.96.49.113"
workers_public_ips = {
  "worker-01" = "3.99.20.164"
}
</pre>

6. Join the worker node(s) to the cluster automatically by running the [`post-creation.sh`](post-creation.sh).

7. From the terminal connected to the control-plane, verify if the node successfully joined the cluster by running the following command as `root` (use `sudo su - root`):

   ```bash
   $ ssh -i ec2-login-key ubuntu@$(terraform output control_plane_public_ip | tr -d '"')
   $ sudo su - root
   $ kubectl get nodes
   ```

   The output should be:

   <pre>
   NAME            STATUS     ROLES           AGE     VERSION
   control-plane   Ready      control-plane   14m     v1.28.0
   worker-01       Ready      &lt;none&gt;          2m36s   v1.28.0
   </pre>

### Congratulation, you did it! Now go enjoy your confidential Kubernetes cluster!

---

## Clean up

Use the command below.

```bash
terraform destroy --auto-approve
```
