#! /usr/bin/fish

# settings
set rgName "cd-docker"
set location "westus"
set adminName "vsts"
set adminPassword "myL0ngS3cur3P@ssw0rd"
set storageAccName "cddockerstore"
set vmName "cd-dockerhost"
set addrPrefix "10.2.0.0/24"
set dockerHost "tcp://$vmName.$location.cloudapp.azure.com:2376"
set $vstsAcc "myVSTSAccountName"
set $pat "myPAT"

# use npm to install the azure CLI
#npm install -g azure-cli

# log in to azure
azure login

# select the correct subscription
azure account set "mySubscription"

# create a resource group
azure resource group create $rgName $location

# get the image urn
azure vm image list –l westus –p Canonical
set imageUrn "Canonical:UbuntuServer:16.04-LTS:16.04.201702240"

# create the host
azure vm docker create 
    --data-disk-size 22 --vm-size "Standard_d1_v2" --image-urn $imageUrn --admin-username $adminName
    --admin-password $adminPassword --nic-name "$vmName-nic" --vnet-address-prefix $addrPrefix
    --vnet-name "$vmName-vnet" --vnet-subnet-address-prefix $addrPrefix --vnet-subnet-name "default"
    --public-ip-domain-name $vmName --public-ip-name "$vmName-pip" --public-ip-allocationmethod "dynamic"
    --name $vmName --resource-group $rgName --storage-account-name $storageAccName 
    --location $location --os-type "Linux"

# test the host
docker -H $dockerHost --tls info

# run a vsts agent
docker -H $dockerHost --tls run -e VSTS_ACCOUNT=$vstsAcc -e VSTS_TOKEN=$pat -e VSTS_POOL=docker -it microsoft/vsts-agent