#!/bin/bash
# Collect the names of the servers to be snapshot.

cd /path/to/ansible/directory
SERVER="string"
while [[ ! -z "$SERVER" ]]
  do
     echo "Enter target server(s) to snapshot.**Press Enter if you are finished!**"
     read SERVER
     echo $SERVER >> /path/to/snapshot/list
  done

# Set server names to uppercase and remove any extra lines
cat /path/to/snapshot/list | tr '[:lower:]' '[:upper:]' > /path/to/snapshot/list-upper
sed -i '/^$/d' /path/to/snapshot/list-upper 

# Collect the snapshot name and description.

echo "What is the snapshot name?"
read SNAPSHOTNAME
SNAPSHOTNAME=$SNAPSHOTNAME-$(date +%D)

echo "What is the snapshot description?"
read SNAPDESCRIPTION
echo

echo "What is your username? "
read VMUSERNAME
echo

echo "What is your elevated password? "
read -s VMWARE_PASSWORD
echo

export SNAPSHOTNAME
export SNAPDESCRIPTION
export VMUSERNAME
export VMWARE_PASSWORD

# Execute the snapshot ansible command

for GUEST in $(cat /path/to/snapshot/list-upper)
  do
    if [[ $GUEST =~ ^SITE1 ]]
      then
        VM_DATACENTER=SITE1
        VMHOSTNAME=SITE1-vcenter
        export VMHOSTNAME
        export VM_DATACENTER
        export GUEST
        ansible-playbook /path/to/ansible/vmware-snapshot-playbook.yml 
    elif [[ $GUEST =~ ^SITE2 ]]
      then
        VM_DATACENTER=SITE2
        VMHOSTNAME=SITE2-vcenter
        export VMHOSTNAME
        export VM_DATACENTER
        export GUEST
        ansible-playbook /path/to/ansible/vmware-snapshot-playbook.yml 
    elif [[ $GUEST =~ ^SITE3 ]]
      then
        VM_DATACENTER=SITE3
        export VM_DATACENTER
        VMHOSTNAME=SITE3-vcenter
        export VMHOSTNAME
        export GUEST
        ansible-playbook /path/to/ansible/vmware-snapshot-playbook.yml 
    else
        VM_DATACENTER=SITE4
        export VM_DATACENTER
        VMHOSTNAME=SITE4-vcenter
        export VMHOSTNAME
        export GUEST
        ansible-playbook /path/to/ansible/vmware-snapshot-playbook.yml  
    fi 
done

# Remove snapshot list files
rm /path/to/snapshot/list
