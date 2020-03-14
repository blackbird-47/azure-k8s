# aks-multi-nodepool
**Terraform implementation to create an Azure K8s cluster.**<br/>

- Tfstate is configured to be stored in a storage account container making it easier to manage across multiple users.<br/>

- Service principal is needed for azurerm provider to connect to the account. Sensitive values can be exported to environment for terraform to pick up as follows,<br/>
    ```
    export TF_VAR_client_id=<client_id>
    export TF_VAR_client_secret=<client_secret>
    export TF_VAR_subscription_id=<subscription_id>
    export TF_VAR_tenant_id=<tenant_id>
    ```
  
- Azure RM terraform plugin - **v1.33.1**

- The implementation uses advanced Azure CNI networking profile, and expects a subnet to be already created to deploy agent pools.

- A resource group is expected to be already created to deploy AKS.

- Kubernetes version deployed - **v1.14.7**

- Microsoft log analytics solution is used to node logging.

- The implementation creates multiple agent pools on which pods will be deployed. Dynamics tag (v0.12 or greater) is used as opposed to static, making the agent pool count flexible. Two agent pools are tainted which can be leveraged to make them exclusive to pods which have toleration defined. The following agent pool sku are created,

    *1. Standard_Ds2_v2*<br/>
    *2. Standard_F4s_v2*<br/>
    *3. Standard_F8s_v2*<br/>

- *output.tf* generates raw kube config. Contains certs and info to connect to the cluster. 