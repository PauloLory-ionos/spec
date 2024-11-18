# Sovereign European Cloud API

## Abstract
This is the first release of the SECAPI.
For this release we decided to restrict the scope of the API to take in consideration only a small subset of operations; this will allow us to provide a correct API interface, documentation, and examples.

### Scope of the API interface
#### Images
- Be able to select an image
  - Images are going to be provided by the ISP
#### Block Storage
- Select a Block Storage type and size
  - In this version only one type available
  - In this version only the OS disk will be available
  - In this version only bootable disks will be provisioned
#### Cloud Server
- Select a Cloud Server Flavour
  - SECA t-shirt size
  - Provider size/type
  - Use Cloud Init to initialize the Cloud Server
  - Use the API to set up the ssh Public-Key for the Cloud Server
#### INE 
- Set up an INE (Isolated Network Environment)
  - Will be a logical container for the Networks, all the Networks inside a INE will have the same Router
#### Network 
- Set up a network
  - Specify the CIDR for the network
  - In this version the DHCP will always be active
  - IP range cannot be updated once set up
#### Security Group and Security Group Rules
- Create a Security Group to be attached to Network Cards or Virtual Machine
- Create Security Group Rules allow traffic on certain ports from/to certain networks/Security Groups 
- Reserve a Public Ip address
#### Public IP
- Reserve a Public IP address
- Assign the Public IP address to a nic
#### Workspace
- Create one or more Workspace/s