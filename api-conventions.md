# **Api Conventions**

## Introduction

Most modern web applications expose APIs that can be used by clients to interact with the application

A properly designed Web API should support:

**Platform independence**
- Any client should be able to call the API regardless of how it is implemented internally. To achieve this, it is necessary to use:

**Standard protocols**
- A mechanism that allows the client and the Web service to agree on the format of the data to be exchanged.

**Service evolution**
- The web API must have the ability to evolve and add functionalities independently from client applications.

- With the evolution of the API:
  - Client applications should continue to function without modifications.
  - All functionalities should be discoverable in order to be fully utilized by client applications.

The following URI definition will help us identify the entry points for different modeling and versioning strategies.

```
URI = scheme:[//authority]path[?query][#fragment]
authority = [userinfo@]
host[:port]
```
![URI_syntax_diagram.svg](./pic/URI_syntax_diagram.svg.png)

## REST

## API Security

In the context of security by design, these topics are intentionally mentioned before further details on API modeling.

- **Authentication** and **authorization** are two distinct concepts. The first deals with subjects, while the second concerns the objects of the requests made.

  Often abbreviated as **authn** and **authz**, the authentication process ensures that the presented credentials are correct, while the authorization process checks that the permissions granted to the requesting subject are sufficient for the operation they want to perform on a specific resource.

APIs must support authentication using the OAuth 2.0 protocol family, implementing at least the following flows:

- **Authorization Code Flow** for integrations with web frontends
- **Client Credentials Flow** for server-to-server integrations

In any case, the API implementation should not prevent support for other flows defined by the OAuth 2.0 family.

APIs must also apply appropriate authorization schemes for API calls based on the roles contained in the claims, mapping granularly which operations are allowed for each role, to:

- Prevent unauthorized calls based on the user’s roles
- Limit and/or filter the data available based on the user’s roles
- Provide the ability to enable or disable various flows specifically for each API method (for example, a method is available only for the Client Credentials flow)


## API Model

### Entity

In a cloud provider domain, for example, some primary entities could be virtual machines and networks. 

Such an example, a disk can be created by sending an HTTP PUT request containing the resource information. 
- The HTTP response indicates whether the request was successfully submitted. 
- Whenever possible, resource URIs should be based on nouns (i.e., the resource) rather than verbs (i.e., the operations performed on the resources).

  ```
  // Correct
  https://mycloud.eu/${scope}/disks
 
  // Not Correct
  https://mycloud.eu/${scope}/create-disks
  ```

  
- Sending an HTTP GET request to the collection's URI retrieves a list of the elements within it. Each element in the collection also has its own unique URI. An HTTP GET request to an element's URI returns the details of that element.

### Relationship

It is also important to consider the relationships between different types of resources and how those associations could be exposed. 
- For example, `/virtualMachines/my-vm/disks` could represent all the disks for the virtual machine my-vm. 
- It is also possible to go in the opposite direction and represent the association from a disk to a virtualMachine with a URI like `/disks/disk-test/virtualMachines`. 

However, if this model is adopted excessively, its implementation could become complex. It is preferable to provide discoverable links to associated resources in the body of the HTTP response. This mechanism is described in more detail in the **HATEOAS** section to enable navigation to related resources.

### URI Naming Convention

1. It is necessary to adopt a consistent naming convention for URIs. In general, it is useful to use plural nouns for URIs referring to collections. 
   - when the resource being modeled has a name consisting of multiple words, it is necessary to use **camelCase**
   - Resource collections should be all **plurals**
 
   For example:
    - `/virtualMachines/`
    - `/securityGroups/`
    - `/networkInterfaces/`

 2. It is advisable to organize the URIs for collections and elements in a hierarchy. For example, if `/networks` is the path for the network collection, then `/networks/my-net` will be the path for the network whose name is my-net. This approach helps to keep the web API intuitive. Many web API frameworks can also route requests based on URI paths with parameters, so it is possible to define a route for the path `/networks/{name}`.


 3. In more complex systems, there may be a temptation to provide URIs that allow a client to traverse multiple levels of relationships, such as `/virtualMachines/my-vm/disks/disk-00/snapshots`. However, this level of complexity can be difficult to maintain and would likely become overly rigid if the relationships between resources change in the future. 
    - It is better to try to keep URIs relatively simple. When an entity contains a reference to a resource, it should be possible to use that reference to find the elements related to that resource. The previous query can be replaced with the URI `/virtualMachines/my-vm/disks` to find all disks for virtual machine my-vm, and then `/disks/my-disk/snapshots` to find the snapshots for that disk.

4. Another factor to consider is that all web requests impose a load on the server. The greater the number of requests, the greater the load. Therefore, try to avoid "fragmented" APIs that expose a large number of small resources. Such an API may require a client application to send multiple requests to retrieve all the necessary data. It may be more appropriate to denormalize the data and combine related information into larger resources that can be retrieved with a single request. However, this approach must be balanced against the overhead of retrieving unnecessary data for the client. Retrieving large objects can increase request latency and add bandwidth costs.

5. Avoid introducing dependencies between the resource APIs and the underlying data sources. For example, if the data is persisted in a relational database, it is not necessary for the resource API to expose each table as a collection of resources, as this could likely be a design flaw. Instead, consider the web API as an abstraction over the database. If necessary, introduce a mapping layer between the database and the web API. This way, client applications are isolated from changes to the underlying database schema.

6. Finally, it may not always be possible to map every operation implemented by a web API to a specific resource. Such scenarios, which do not correspond to a resource, can be handled through HTTP requests that invoke a function and return the results as an HTTP response. A web API that implements simple arithmetic operations like addition and subtraction, for example, might provide URIs that expose these operations as pseudo-resources and use the query string to specify the necessary parameters. For example, a GET request to the URI `/add?op1=99&op2=1` returns a response with a body containing the value 100. However, the use of such URI formats is extremely rare and should be limited as much as possible.
