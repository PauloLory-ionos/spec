# Operations and HTTP Methods

The HTTP protocol defines a series of methods that assign semantic meaning to a request. Below you can find the spec to use the methods and when for the Sovereign European Cloud API.

- **PUT** - Creates or replaces the resource at the specified URI. The request body specifies the resource to be created or updated.
- **GET** - Retrieves a representation of the resource at the specified URI. The response body contains the details of the requested resource.
- **DELETE** - Removes the resource at the specified URI.

The effect of a specific request varies depending on the type of resource (collection or a single item). The table below summarizes common conventions adopted by most RESTful implementations. Not all of these requests may be implemented because would depend on the specific scenario.

| HTTP Method | Collection URI (e.g: `/compute/instances`) | Element URI (e.g. `/compute/instances/my-vm`)          |
|-------------|----------------------------|---------------------------------------|
| PUT         | Not Applicable  | The Virtual Machine Resource is created or replaced with the representations contained in the body of the request   |
| DELETE      | Not Applicable | Removes the Virtual Machine Resource and any nested Element Resources.  |
| GET         | The List of the Virtual Machines Members is returned in the body of the response | Retrieves the representation of the Virtual Machine Resource, which will be contained in the body of the response. |

| Resource | PUT | DELETE | GET |
|-------------|-------------|-------------|-------------|-------------|
| /instances |  405 Method Not Allowed |  405 Method Not Allowed | Retrieve all virtual machines | 
| /instances/my-vm | Create or Replace the Virtual Machine **my-vm** | Remove the virtual machine **my-vm** | Retrieve details of **my-vm** virtual machine | 
| /instances/my-vm/power-Off | 405 Method Not Allowed | 405 Method Not Allowed  | 405 Method Not Allowed |
| /network/vpcs/my-net/subnets/my-sub/network-interfaces | 405 Method Not Allowed | 405 Method Not Allowed | Retrieve all network interfaces within network **my-net** in subnet **my-sub** |
| /network/vpcs/my-net/subnets/my-sub/network-interfaces/my-nic | Create or Replace the  network Interface **my-nic**  | Delete the network interface **my-nic** in the subnet my-sub of network my-net | Retrieve the **my-nic** network interface detail attached to the subnet my-sub of network my-net |

A **PUT** request creates a resource or updates an existing one. The client specifies the URI for the resource. The request body contains a complete representation of the resource. If a resource with that URI already exists, it is replaced. Otherwise, a new resource is created, if this operation is supported by the server. PUT requests are applied to individual items, like a specific virtual machine, rather than to collection resources. Requests must be idempotent. If a client sends the same PUT request multiple times, the results must always be the same, meaning the same resource will be updated with the same values.
