# Glossary SEC-API

Cloud Server (CS) = a fully virtualized os running over a fully virtualized hardware; similar to EC2/Azure Virtual Machines/Google Compute Engine
Isolated Network Environment (INE) or SNE (Segregated Network Environment) = similar concept as the VPC in AWS, and Google Cloud; represents a logical environment, isolated from the other INE, which can contain one or more network.
Network = is contained inside an INE and is a sum of technology and configurations put together to provide network connectivity to your SCS
Virtual Network Card = a pieace of virtualized hardware which will be created every time an Cloud Server is assigned to a Network
Security Group (SG) = a logical container for Security Group Rules; to be assigned to a Virtual Network Card or a SCS
Security Group Rule (SGR) = a logical rule policing the traffic from and to a CIDR/Security Group and Port towards a specific port or port range; to be assigned to a Security Group
Block Storage (BS) = a logical aggregation of disk space to be used by your CSC as OS or Data disk.
Public IP = an IP address which is part of a public network and will allow traffic to enter the INE if the correct SG is put in place
Private IP = an IP adress which is part of a private network and with the right Security Group Rules will allow or deny access to/from other servers/CIDR/Security Group towards port/port range.
Image = is a deplyment artifact, a preconfigured template of a barebone OS (usually Linux or Windows)