# ansible-azure-playbooks
Collection of Ansible playbooks to buld various Azure architectures


# Execution

To run a playbook and change variables, add --extra-vars to the command line. For example,

```shell
ansible-playbook ./playbooks/build-vm-playbook-with-terraform.yaml --extra-vars "resourceGroupName=my-other-rg network.name=my-vnet"
```