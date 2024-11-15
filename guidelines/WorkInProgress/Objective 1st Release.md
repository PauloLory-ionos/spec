# Sovereign European Cloud API

## Abstract
This is the first release of the SECAPI.
For this release we decided to restrict the scope of the API to take in consideration only a small subset of operations; this will allow us to provide a correct API interface, documentation, and examples.

### Scope of the API interface
- Select an image
  - Images are going to be provided by the ISP
- Select a Block Storage type and size
  - In this version only one type available
- Select a Cloud Server Flavour
  - SECA t-shirt size
- Set up a VPC (Network Segregated Environment)
  - Will be use to create all the subnet connected by the same Router 
- Set up a network
  - Specify the netmask
  - In this version the DHCP will always be active
  - IP range cannot be updated once set up (User capabilities not here)
- Create a Security Group to be attached to Network Cards or Virtual Machine
- Create Security Group Rules allow traffic on certain ports from/to certain networks/Security Groups 
- Reserve a Public Ip address

In this release a user will be able to:
- 