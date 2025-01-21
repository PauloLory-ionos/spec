
## Architecture

Cloud Requests can be divided in two categories Control-Plane and Data-Plane.

### Control plane

- Those APIs are used to create and manage cloud resources in a specific tenant
- All requests are sent to a Cloud Resource Manager;
- Control plane APIs manage **resources**.
- Control plane returns configurations(e.g., metadata, resource properties, states).
- It's easier to define Control plane resources to follow a more standardized Resource schema
- These APIs return resource management data, such as metadata, configuration details, status.

### Data plane

- Requests for Data Plane operations are sent to an endpoint that's specific to your instance.
- The purpose is to interact with the actual data or service provided by a Cloud Resource (e.g., reading/writing to a object storage, querying a database, etc.).
- Data plane APIs manage **data**.
- Data plane returns actual data (e.g., files, query results, or data manipulation responses)
- Data plane schemas vary widely based on the type of data and the service object (e.g., NFS, SQL, Key/Value, Vaults, etc.).
- These APIs return and operate on actual data rather than metadata or configuration
- Data plane APIs are out of scope for the SECA API.
