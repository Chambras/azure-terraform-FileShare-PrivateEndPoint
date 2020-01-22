# Azure File Share with Private End Point

It creates:

* A new Resource Group
* A new Storage Account
* A new File Share
* A new Private End Point for File Share
* A Private DNS Zone to access the File Share using the a fully qualified domain name (FQDN).
* A test RedHat 7.7 VM to mount the file share and test connectivity.

## Project Structure

This project has the following files which make them easy to reuse, add or remove.

```ssh
.
├── LICENSE
├── README.md
├── dns.tf
├── main.tf
├── networking.tf
├── outputs.tf
├── security.tf
├── storage.tf
├── variables.tf
└── vm.tf
```

## Pre-requisites

It is assumed that you have azure CLI and Terraform installed and configured.
More information on this topic [here](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure). I recommend using a Service Principal with a certificate.

### * __Versions__

* Terraform =>0.12.19
* Azure provider 1.40.0
* Azure CLI 2.0.80

### * __Ensure the cifs-utils package is installed__

The cifs-utils package can be installed using the package manager on the Linux distribution of your choice.

This terraform script takes care of that, but if you are testing this on an existing VM or creating one manually, make sure it is installed. Instructions on how to do it are [here](https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-linux#prerequisites).

### * __Ensure port 445 is open__

SMB communicates over TCP port 445 - check to see if your firewall is not blocking TCP ports 445 from client machine. More information and a way to test if the port is open can be found [here](https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-linux#prerequisites).

## Authentication

It uses key based authentication and it assumes you already have a key and you can configure the path using the _sshKeyPath_ variable in _`variables.tf`_ You can create one using this command:

```ssh
ssh-keygen -t rsa -b 4096 -m PEM -C vm@mydomain.com -f ~/.ssh/vm_ssh
```

## Usage

Just run these commands to initialize terraform, get a plan and approve it to apply it.

```ssh
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
```

I also recommend using a remote state instead of a local one. You can change this configuration in _`main.tf`_
You can create a free Terraform Cloud account [here](https://app.terraform.io).

## Verify Private End Point

ssh into the VM using the following command

```ssh
ssh storageAdmin@{{IP ADDRESS}} -i ~/.ssh/vm_ssh
```

_`storageAdmin`_ is the user name that can be customized using the variable _`vmUserName`_ in _`variables.tf`_ file. Also remember to whitelist your source IP or IPs in the variable _`sourceIPs`_. Otherwise you might not be able to ssh into the VM.

Once logged in test using _`nslookup`_ command and you should receive a message similar to this:

```ssh
[storageAdmin@mainServer ~]$ nslookup prvtndpntstrg.file.core.windows.net
Server:         168.63.129.16
Address:        168.63.129.16#53

Non-authoritative answer:
prvtndpntstrg.file.core.windows.net     canonical name = prvtndpntstrg.privatelink.file.core.windows.net.
Name:   prvtndpntstrg.privatelink.file.core.windows.net
Address: 10.70.0.5
```

_`prvtndpntstrg`_ is your storage account name that could be customized using the variable _`storageAccountName`_ in _`variables.tf`_ file.

## Mount File Share

More information on how to mount the file share on Linux can be found [here](https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-linux).

## Private Link Documentation

Official documentaion about Private Link is [here](https://docs.microsoft.com/en-us/azure/private-link/) with more samples and quick starts using [Azure portal](https://docs.microsoft.com/en-us/azure/private-link/create-private-endpoint-portal), [Azure CLI](https://docs.microsoft.com/en-us/azure/private-link/create-private-endpoint-cli) and [Azure PowerShell](https://docs.microsoft.com/en-us/azure/private-link/create-private-endpoint-powershell
).

## Clean resources

It will destroy everything that was created.

```ssh
terraform destroy --force
```

## Caution

Be aware that by running this script your account might get billed.

## Authors

* Marcelo Zambrana