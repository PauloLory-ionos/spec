# Glossary SEC-API

## Region
A geographical area containing a set of data centers, often isolated from other regions for purposes of fault tolerance, redundancy, and availability.
## Zone
A set of data centers within a region, each designed to be isolated from failures in other zones, but connected to them via low-latency links to provide high availability, fault tolerance, and scalability
## Seca Cloud Server (SCS)/Cloud Server (CS)/Instance (I)
A fully virtualized os running over a fully virtualized hardware; similar to EC2/Azure Virtual Machines/Google Compute Engine
## Isolated Compute Network (ICN)/Isolated Network Environment (INE)/Segregated Network Environment (SNE))/Virtual Private Network (VPN)
Similar concept as the VPC in AWS, and Google Cloud; represents a logical environment, isolated from the other INE, which can contain one or more network.
## Network/Subnet
Contained inside an INE and is a sum of technology and configurations put together to provide network connectivity to your SCS
## Virtual Network Card
A pieace of virtualized hardware which will be created every time an Cloud Server is assigned to a Network
## Security Group (SG)
A logical container for Security Group Rules; to be assigned to a Virtual Network Card or a SCS
## Security Group Rule (SGR)
A logical rule policing the traffic from and to a CIDR/Security Group and Port towards a specific port or port range; to be assigned to a Security Group
## Block Storage (BS)
A logical aggregation of disk space to be used by your CSC as OS or Data disk.
## Public IP
An IP address which is part of a public network and will allow traffic to enter the INE if the correct SG is put in place
## Private IP
An IP adress which is part of a private network and with the right Security Group Rules will allow or deny access to/from other servers/CIDR/Security Group towards port/port range.
## Image
Is a deplyment artifact, a preconfigured template of a barebone OS (usually Linux or Windows)