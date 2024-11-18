# Glossary SEC-API

# Scope
### Region
A geographical area containing a set of data centers, often isolated from other regions for purposes of fault tolerance, redundancy, and availability.

### Zone
A set of data centers within a region, each designed to be isolated from failures in other zones, but connected to them via low-latency links to provide high availability, fault tolerance, and scalability

### Seca Compute Instance (SCI) - Scope: Zone
A fully virtualized os running over a fully virtualized hardware; similar to EC2/Azure Virtual Machines/Google Compute Engine

### Local Area Network (LAN) - Scope: Region
Similar concept as the VPC in AWS, and Google Cloud; represents a logical environment, isolated from the other INE, which can contain one or more network.

### Subnet - Scope: Zone
Contained inside an LAN and is a sum of technologies and configurations put together to provide network connectivity to your SCI

### Network Interface Card (NIC) - Scope: Zone
A pieace of virtualized hardware which will be created every time an SCI is assigned to a Subnet

### Security Group (SG) - Scope: Region
A logical container for Security Group Rules; to be assigned to a NIC

### Security Group Rule (SGR) - Scope: Region
A logical rule policing the traffic from and to a CIDR/Security Group and Port towards a specific port or port range; to be assigned to a Security Group

### Block Storage (BS) - Scope: Zone
A logical aggregation of disk space to be used by your SCI as OS or Data disks.

### Public IP - Scope: Region
An IP address which is part of a public network and will allow traffic to enter the NIC if the correct SG is put in place

### Private IP - Scope: Region
An IP adress which is part of a private network and with the right Security Group Rules will allow or deny access to/from other servers/CIDR/Security Group towards port/port range.

### Image - Scope: Region
Is a deplyment artifact, a preconfigured template of a barebone OS (usually Linux or Windows)