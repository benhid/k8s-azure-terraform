<p align="center">
  <br/>
  <img src=resources/header.png alt="header">
  <br/>
</p>

# K8s cluster with Azure + Terraform

## Authenticating to Azure using a Service Principal 

[Terraform](https://www.terraform.io/) supports authenticating to Azure through a [Service Principal](https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html#creating-a-service-principal-in-the-azure-portal) or the Azure CLI. Replace the your values for the `client_id`, `client_secret`, `subscription_id` and `tenant_id` in the [variables.tfvars](/variables.tfvars) file.

## Create the Kubernetes cluster

The [main.tf](main.tf) file contains the definition of the infrastructure for the cluster. Download [Terraform](https://www.terraform.io/) and run the following command to set it up:

```bash
$ terraform init
$ terraform plan –var-file variables.tfvars -out out.plan
```

This will create a new resource group (`k8s-resource`) and a new Kubernetes cluster (`k8s-cluster`) with two worker nodes.
From the [docs](https://docs.microsoft.com/es-es/azure/terraform/terraform-create-k8s-cluster-with-tf-and-aks):

> The preceding code sets the name of the cluster, location, and the `resource_group_name`. In addition, the `dns_prefix` value - that forms part of the fully qualified domain name (FQDN) used to access the cluster - is set.

> The `linux_profile` record allows you to configure the settings that enable signing into the worker nodes using SSH. With AKS, you pay only for the worker nodes.

> The `agent_pool_profile` record configures the details for these worker nodes. The `agent_pool_profile` record includes the number of worker nodes to create and the type of worker nodes. If you need to scale up or scale down the cluster in the future, you modify the count value in this record.

For applying changes, run:

```bash
terraform apply out.plan
```

It might take up to ~15 minutes before the cluster is ready.

## Manage the cluster

Connect to the Kubernetes cluster using [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/):

```bash
$ echo "$(terraform output kube_config)" > ./azurek8s
$ export KUBECONFIG=./azurek8s
$ kubectl get nodes
```

In order to access the dashboard the `kubectl proxy` command needs to be run which starts a proxy to the Kubernetes API server:

```bash
$ kubectl proxy
```

The dashboard will be available at [/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy/](http://localhost:8001/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy/).

## Install Helm -- Tiller

```bash
$ export KUBECONFIG=./azurek8s
$ helm init
```

After `helm init`, you should be able to run `kubectl get pods --namespace kube-system` and see Tiller running.