# **Api Conventions**

## Table of Contents
- [Introduction](#introduction)
- [Core Principles](#core-principles)
- [API Security](#api-security)
  - [Authentication](#authentication)
  - [Authorization](#authorization)
- [Core API Concepts](#core-api-concepts)
  - [Entity](#entity)
  - [Relationship](#relationship) 
    - [Composition & Aggregation](#composition--aggregation)
    - [Cardinalities](#cardinalities) 
  - [URI Naming Convention](#uri-naming-convention)
- [Operations and HTTP Methods](#operations-and-http-methods)
- [HTTP Semantics](#http-semantics)
  - [Media Type](#media-type)
    - [JSON](#json)
      - [Casing](#casing)
      - [Naming](#naming)
      - [Type Conversion](#type-conversion)
  - [GET Method](#get-method)
  - [HEAD Method](#head-method)
  - [PUT Method](#put-method)
  - [POST Method](#post-method)
  - [PATCH Method](#patch-method)
  - [DELETE Method](#delete-method)
  - [Conditional Requests](#conditional-requests)
  - [Status Code](#status-code)
    - [Group By Category](#group-by-category)
    - [Status Detail](#status-detail)
    - [Problem Details - Response Body for 4xx and 5xx Categories](#problemdetails---response-body-for-4xx-and-5xx-categories)
- [API Enhancements](#api-enhancements)
  - [Filtering](#filtering)
  - [Pagination](#pagination) 
- [Versioning](#versioning)
  - [Usage](#usage)
  - [Breaking Change Definition](#breaking-change-definition)
    - [Examples of additive modifications that are not necessarily breaking](#examples-of-additive-modifications-that-are-not-necessarily-breaking)
    - [Universal examples of breaking changes](#universal-examples-of-breaking-changes)
- [Asynchronous Operations](#asynchronous-operations)
  - [Asynchronous Request-Reply Pattern](#asynchronous-request-reply-pattern)
  - [Solution](#solution)
  - [Considerations and Issues](#considerations-and-issues)
  - [When should you use this model?](#when-should-you-use-this-model)


## Introduction

This document provides comprehensive guidelines for designing and implementing control plane APIs for the **Sovereign European Cloud API (SECA)** initiative, establishing a consistent standard to ensure a high-quality developer experience and robust cloud resource management. 

These standards focus on achieving:

**Developer-Friendly Interfaces**: By following consistent patterns and widely accepted web standards (HTTP, REST, JSON), these APIs facilitate ease of use and seamless integration.

**Efficient, Reliable Operations**: Built with scalability in mind, these APIs are designed to support reliable, fault-tolerant applications through idempotency, retries, and version control mechanisms.

**Cross-Platform Compatibility**: Designed to be accessible via SDKs in multiple programming languages, enabling a broad range of development environments.

**Future-Proofing and Stability**: Through clear API contracts and versioning practices, these guidelines ensure that customer workloads remain stable and backward-compatible, even as the APIs evolve.

In a rapidly evolving technology landscape, this document serves as a living reference, adaptable to new ideas and ongoing improvements to meet the evolving needs of developers and cloud consumers.

## Core Principles

Cloud providers' APIs enable seamless integration and management of cloud resources through programmable interfaces. 
These APIs allow developers and system administrators to interact with various cloud services, such as computing power, storage, databases, networking, and machine learning, directly through code or command-line tools. By using these APIs, users can automate workflows, scale resources, and perform tasks like provisioning new instances, configuring virtual networks, or managing user permissions with precision and efficiency. Cloud APIs offer flexibility and control, making it easier to build, deploy, and manage applications in dynamic and scalable environments.

A properly designed REST API should support:

**Platform independence**
- Any client should be able to call the API regardless of how it is implemented internally.

**Standard protocols**
- No platform independence would be possible without a mechanism that allows the client and the Web service to agree on the format of the data to be exchanged.

**Service evolution**
- The REST API must have the ability to evolve and add functionalities independently from client applications.
- With the evolution of the API:
  - Client applications should continue to function without modifications.
  - All functionalities should be discoverable in order to be fully utilized by client applications.


## API Security

In the context of security by design, these topics are intentionally mentioned before further details on API modeling.

- **Authentication** and **authorization** are two distinct concepts. The first deals with subjects, while the second concerns the objects of the requests made.

  Often abbreviated as **authn** and **authz**, the authentication process ensures that the presented credentials are correct, while the authorization process checks that the permissions granted to the requesting subject are sufficient for the operation they want to perform on a specific resource.

### Authentication 

APIs must support authentication using the **JSON Web Token (JWT)** standard. 

Using JSON Web Token (JWT) for authentication provides several advantages, particularly for cloud-based APIs:

- **Stateless and Scalable**: JWTs are self-contained, storing all necessary information within the token itself. This eliminates the need for the server to maintain session data, allowing for more scalable, stateless API architectures.
- **Enhanced Security**: JWTs are cryptographically signed, which means they can be verified by the server, ensuring that the token has not been tampered with. They can also include claims (additional metadata) that help control and secure access, such as user roles and permissions.
- **Interoperability**: As an industry standard, JWTs are widely supported across programming languages and frameworks, making them highly compatible and easier to implement across various platforms and devices.
- **Efficiency**: Since JWTs are compact, they can be passed in headers, minimizing overhead and reducing response times for client-server interactions.
- **Flexibility with Single Sign-On (SSO)**: JWTs are ideal for SSO implementations, as a token generated by one service can be securely used to access multiple applications, improving the user experience and reducing authentication complexity.

JWT’s main function is to authenticate the user’s identity by validating the token, not to directly handle authorization or dictate permissions. Overall, JWT provides a secure, efficient, and flexible authentication solution well-suited for modern API-driven environments.

### Authorization

We suggest to use a foundational authorization mechanism used in systems like Kubernetes to manage permissions at runtime, ensuring that only authorized users or services (**principals**) can perform specific actions on resources.

-  In this model, users or service accounts are associated with predefined roles that encapsulate a set of permissions, such as read, write, or delete
- When a principal attempts an action, the control plane API consults an authorization provider to evaluate whether the associated roles permit the requested operation.
- This process, independent of any data in an authentication token like JWT, allows the system to make dynamic, context-aware authorization decisions

One of the widely used approach to do so is Role-Based-Access-Control (**RBAC**) model even though there are also other models, such as Attribute-Based Access Control (**ABAC**) and Policy-Based Access Control (**PBAC**), which provide flexibility and can be used in combination with or as alternatives to RBAC depending on the system’s security requirements.

## Core API Concepts

### Entity
The primary resources or objects within the API, often corresponding to domain-specific nouns. 
In a cloud provider, for example, some primary entities could be virtual machines and networks. 

Such an example, a disk can be created by sending an HTTP PUT request containing the resource information. 
- The HTTP response indicates whether the request was successfully submitted. 
- Whenever possible, resource URIs should be based on nouns (i.e., the resource) rather than verbs (i.e., the operations performed on the resources).

  ```
  // Correct
  https://mycloud.eu/${scope}/storage/block-storages
 
  // Not Correct
  https://mycloud.eu/${scope}/create-storage/block-storages
  ```

  
- Sending an HTTP GET request to the collection's URI retrieves a list of the elements within it; each element in the collection also has its own unique URI. 
- An HTTP GET request to an element's URI returns the details of that element.

### Relationship
Relationships describe how entities connect or interact with each other, helping structure API endpoints for clarity and hierarchy.

It is important to consider the relationships between different types of resources and how those associations could be exposed. 
- For example, `/compute/instances/my-vm/storage/block-storages` **could** represent all the storage/block-storages for the virtual machine my-vm. 
- It is also possible to **go in the opposite direction** and represent the association from a disk to a virtualMachine with a URI like `/storage/block-storages/disk-test/instances`. 

**However, if this model is adopted excessively, its implementation could become complex.**

*Let's describe below the **SECA specifications** for Entity Relationship.*

#### Composition & Aggregation

When designing REST APIs, it’s important to understand and model the relationship type between entities accurately, especially when considering **composition** (strong) relationships (structural) and **aggregation** (weak) relationships.

Here’s a breakdown of each and how to represent them effectively in REST API design.

##### **Structural Relationship - Composition**
- In a composition relationship, one entity (**the parent**) strongly **owns** another (**the child**), and the child cannot exist independently without the parent. 
- If the parent entity is deleted, so is the child entity.

Example: security-group and security-group-rule. A security-group-rule only makes sense within the context of a security-group and is deleted if the parent is deleted.

**Design Considerations**
- Reflect the dependency by nesting the child resource under the parent.
- The child resource’s lifecycle is directly tied to the parent resource.
- Enforce deletion cascades so that deleting a parent removes all associated children

**API Design**
- Parent resource: GET /security-groups/{securityGroupName}
- Child resources as sub-resources: 
  - GET /security-groups/{securityGroupName}/security-rules 
  - GET /security-groups/{securityGroupName}/security-group-rules/{securityGroupRuleName}
  - Create child resource: 
    - PUT /security-groups/{securityGroupName}/security-group-rules/{securityGroupRuleName}
  - Delete child along with parent: 
    - DELETE /security-groups/{securityGroupName} would delete both the securityGroup and its securityGroupRules.

**Best Practices**:
- Do not provide a top-level endpoint for the child resource if it makes no sense without the parent, emphasizing the dependency.

##### Aggregation Relationship 
- In an aggregation relationship, one entity is **loosely associated** with another, meaning the child can exist independently of the parent. 
- The parent may reference the child, but if the parent is deleted, the child remains.

Example: Virtual Machine and Disk. A Disk can exist with or without a VirtualMachine, and deleting a VirtualMachine could not affect the Disk entity.

**Design Considerations**
- Use references or links rather than nesting, as the child can stand alone.
- Provide separate top-level endpoints for each entity, enabling access to the child independently of the parent.
- Use relationship or linking endpoints to associate entities instead of tying them together structurally.

**API Design**
- Separate resources: 
  - GET /compute/instances/{instanceName}  
  - GET /storage/block-storages/{diskName}
- Linking endpoints: 

```json
{
  "type": "ssd",
  "size_gb": 500,
  "attached_instance": {
    "instance": "/compute/instances/my-instance",
    "device_name": "/dev/sda1",
    "mount_point": "/mnt/data"
  },
  "encryption": {
    "enabled": true,
    "key": "/keys/my-key"
  }
}
```

- Manage relationships independently: 
  - DELETE /virtual-machines/{virtualMachineName} only deletes the virtualMachine without impacting the storage/block-storages.


##### Differences in API Design for Composition vs. Aggregation

| Aspect | Composition (Structural) | Aggregation (Weak) |
|------- |--------------------------|---------------------------------------|
|Endpoint Structure | Nested within the parent resource | Separate endpoints, linked by reference|
|Resource Independence |Child depends on parent; no standalone endpoint| Child is independent; standalone endpoint allowed|
|Lifecycle Dependency | Child is deleted when parent is deleted| Child remains if parent is deleted|
|Use Case | Strong ownership, e.g., Network and Subnets| Loose association, e.g., VM and storage/block-storages|
|Deletion Behavior |Cascading delete (parent and children)| No cascade; deletion affects only the entity being removed|

##### Additional Design Tips

1. Document relationship types clearly: explain in the API documentation which relationships are compositional (structural) and which are aggregational (weak), so developers know if deleting one entity affects others.
2. When aggregating, leverage hypermedia links to indicate connections rather than deeply nesting endpoints. For example, in a response for a disk, include links to virtualMachine: { "attached_instance": "/virtual-machines/{virtualMachineName}" }
3. Separate resource ownership logic: if the relationship requires logic specific to the parent-child relationship, consider defining an intermediate resource, such as a vm-attachment relationship resource to better manage the association.

Using this approach will help you model these relationships in a way that reflects real-world dependencies and ownership, while keeping the API design clean and intuitive.

#### Cardinalities

### URI Naming Convention

1. It is necessary to adopt a consistent naming convention for URIs. In general, it is useful to use plural nouns for URIs referring to collections. 
   - when the resource being modeled has a name consisting of multiple words, it is necessary to use **kebab-case**
   - Resource collections should be all **plurals**
 
   For example:
    - `/providers/compute/instances/`
    - `/providers/network/security-groups/`
    - `/providers/network/network-interfaces/`

 2. It is advisable to organize the URIs for collections and elements in a hierarchy. For example, if `/networks` is the path for the network collection, then `/networks/my-net` will be the path for the network whose name is **my-net**. 
 - This approach helps to keep the web API intuitive. Many web API frameworks can also route requests based on URI paths with parameters, so it is possible to define a route for the path `/networks/{name}`.

 3. In more complex systems, there may be a temptation to provide URIs that allow a client to traverse multiple levels of relationships, such as `/compute/instances/my-vm/storage/block-storages/disk-00/snapshots`. However, this level of complexity can be difficult to maintain and would likely become overly rigid if the relationships between resources change in the future. 
    - It is better to try to keep URIs relatively simple. When an entity contains a reference to a resource, it should be possible to use that reference to find the elements related to that resource. The previous query can be replaced with the URI `/compute/instances/my-vm/storage/block-storages` to find all storage/block-storages for virtual machine my-vm, and then `/storage/block-storages/my-disk/snapshots` to find the snapshots for that disk.
    - A rule of thumb is a maximum nesting depth of two. Sometimes a depth of three is also okay

4. Another factor to consider is that all web requests impose a load on the server. The greater the number of requests, the greater the load. Therefore, try to avoid "fragmented" APIs that expose a large number of small resources. Such an API may require a client application to send multiple requests to retrieve all the necessary data. It may be more appropriate to denormalize the data and combine related information into larger resources that can be retrieved with a single request. However, this approach must be balanced against the overhead of retrieving unnecessary data for the client. Retrieving large objects can increase request latency and add bandwidth costs.

5. Avoid introducing dependencies between the resource APIs and the underlying data sources. For example, if the data is persisted in a relational database, it is not necessary for the resource API to expose each table as a collection of resources, as this could likely be a design flaw. Instead, consider the web API as an abstraction over the database. If necessary, introduce a mapping layer between the database and the web API. This way, client applications are isolated from changes to the underlying database schema.

6. Finally, it may not always be possible to map every operation implemented by a web API to a specific resource. Such scenarios, which do not correspond to a resource, can be handled through HTTP requests that invoke a function and return the results as an HTTP response. A web API that implements simple arithmetic operations like addition and subtraction, for example, might provide URIs that expose these operations as pseudo-resources and use the query string to specify the necessary parameters. For example, a GET request to the URI `/add?op1=99&op2=1` returns a response with a body containing the value 100. However, the use of such URI formats is extremely rare and should be limited as much as possible.

## Operations and HTTP Methods

The HTTP protocol defines a series of methods that assign semantic meaning to a request. Below you can find the spec to use the methods and when for the Sovereign European Cloud API.


- **PUT** - Creates or replaces the resource at the specified URI. The request body specifies the resource to be created or updated.
- **GET** - Retrieves a representation of the resource at the specified URI. The response body contains the details of the requested resource.
- **POST** - Used to initiate operations that do not actually create resources such as actions.
- **DELETE** - Removes the resource at the specified URI.

The effect of a specific request varies depending on the type of resource (collection or a single item). The table below summarizes common conventions adopted by most RESTful implementations. Not all of these requests may be implemented because would depend on the specific scenario.

| HTTP Method | Collection URI (e.g: `/compute/instances`) | Element URI (e.g. `/compute/instances/my-vm`)          |
|-------------|----------------------------|---------------------------------------|
| PUT         | Not Applicable  | The Virtual Machine Resource is created or replaced with the representations contained in the body of the request   |
| DELETE      | Not Applicable | Removes the Virtual Machine Resource and any nested Element Resources.  |
| GET         | The List of the Virtual Machines Members is returned in the body of the response | Retrieves the representation of the Virtual Machine Resource, which will be contained in the body of the response. |
| POST        | Not Applicable | Performs an action on the Element Resource. Therefore the action path should be added at the end like **power-on**   |

| Resource | PUT | DELETE | GET | POST |
|-------------|-------------|-------------|-------------|-------------|
| /instances |  405 Method Not Allowed |  405 Method Not Allowed | Retrieve all virtual machines | 405 Method Not Allowed |
| /instances/my-vm | Create or Replace the Virtual Machine **my-vm** | Remove the virtual machine **my-vm** | Retrieve details of **my-vm** virtual machine | 405 Method Not Allowed |
| /instances/my-vm/power-Off | 405 Method Not Allowed | 405 Method Not Allowed  | 405 Method Not Allowed | Stop the virtual machine **my-vm** if makes sense  |
| /network/vpcs/my-net/subnets/my-sub/network-interfaces | 405 Method Not Allowed | 405 Method Not Allowed | Retrieve all network interfaces within network **my-net** in subnet **my-sub** | 405 Method Not Allowed |
| /network/vpcs/my-net/subnets/my-sub/network-interfaces/my-nic | Create or Replace the  network Interface **my-nic**  | Delete the network interface **my-nic** in the subnet my-sub of network my-net | Retrieve the **my-nic** network interface detail attached to the subnet my-sub of network my-net | 405 Method Not Allowed |

**Notes**

- A **PUT** request creates a resource or updates an existing one. The client specifies the URI for the resource. The request body contains a complete representation of the resource. If a resource with that URI already exists, it is replaced. Otherwise, a new resource is created, if this operation is supported by the server. PUT requests are applied to individual items, like a specific virtual machine, rather than to collection resources. 
  - requests must be idempotent. If a client sends the same PUT request multiple times, the results must always be the same, meaning the same resource will be updated with the same values. 

## HTTP Semantics
This section describes some typical considerations for designing an API that complies with the HTTP specification. However, it does not cover every possible detail or scenario. In case of doubt, consult the HTTP specifications.

### Media Type

As mentioned earlier, clients and servers exchange representations of resources. In a PUT request, for example, the request body contains a representation of the resource to be created. In a GET request, the response body contains a representation of the retrieved resource.

- In the HTTP protocol, formats are specified using Media Types, also known as MIME types. For non-binary data, most Web APIs support JSON (i.e., the media type application/json) and possibly XML (i.e., the media type application/xml).

The Content-Type header specifies the format of the representation. Below is an example of a PUT request containing JSON data:

```javascript
PUT https://api.cloud.eu/${scope}/compute/instances/my-vm HTTP/1.1
Content-Type: application/json; charset=utf-8
Content-Length: 47

{"profile":"K0063","OS":"Ubuntu24.01"}
```

-  If the server does not support the media type, it must return the HTTP status code 415 (Unsupported Media Type).

A client request can include an Accept header containing a list of media types that the client will accept in the server’s response. For example:

```javascript
GET https://api.cloud.eu/${scope}/compute/instances/my-vm HTTP/1.1
Accept: application/json
```

- If the server cannot provide a media type matching those listed, it must return the HTTP status code 406 (Not Acceptable).

#### JSON

##### Casing
- The field casing adopted is **camelCase**.

##### Naming
- The identifier field of an object will be expressed in the following form: objectId.

##### Type Conversion
- For those media types where there is no 1:1 conversion between the server-side data type and the one transmitted to clients, we adopt the following convention:

| Native Type | JSON Type | Format Spec | Note |
|-------------|-------------|-------------|-------------|
| null| null | | |
| boolean | bool | | |
| byte, sbyte, int32, int64, uint32, uint64, float, double | number culture-invariant string | All numbers up to a maximum precision of 64 bits ([IEEE 754](https://en.wikipedia.org/wiki/IEEE_754), [binary64](https://en.wikipedia.org/wiki/Double-precision_floating-point_format)). | { "add": 123.5 }<br/>{ "add": 5 }<br/>{ "add": "136573525573.86576576" }| 
| decimal/arbitrary precision numbers | culture-invariant string |(?<sign>[+\|-])?(?<number>\d+)(?<digits>(?<separator>.)\d+)? | { "add": "136573525573.86576576" }|  
| string | string | [UTF-8](https://en.wikipedia.org/wiki/UTF-8) | If necessary, [UTF-16](https://en.wikipedia.org/wiki/UTF-16) surrogate pairs should be used for escape sequences of glyphs outside the [Basic Multilingual Plane](https://en.wikipedia.org/wiki/Plane_(Unicode)#Basic_Multilingual_Plane) (U+10000 to U+10FFFF)| 
| guid/uuid/ulid | string | (?<uuid>[0123456789abcdef]{32})| Example: a2b4c746c71745a8ad8f3cf7a1cede9b |
| blob | string | [base64](https://en.wikipedia.org/wiki/Base64) | |
| date, time, datetime, duration, time intervals | string | [RFC339](https://datatracker.ietf.org/doc/html/rfc3339) ([ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) profile) | Time: 09:30,<br/> UtcTime: 09:30Z,<br/> DateTime: 2020-02-26T16:23:11.1196470+01:00,<br/> UtcDateTime: 2020-02-26T15:23:11.1280371Z,<br/> Duration: P3Y6M4DT12H30M5S,<br/> StartAndEndTimeInterval: 2007-03-01T13:00:00Z/2008-05-11T15:30:00Z,<br/> StartAndDurationTimeInterval: 2007-03-01T13:00:00Z/P1Y2M10DT2H30M,<br/> DurationAndEndTimeInterval: P1Y2M10DT2H30M/2008-05-11T15:30:00Z,<br/> DurationOnlyTimeInterval: P1Y2M10DT2H30M``` |
| enum | string | conversion to string with camelCase |  |

#### GET Method
- A successful GET method typically returns the HTTP status code 200 (OK). If the resource is not found, the method should return 404 (Not Found)

#### HEAD Method
- The **HEAD** method requires a response identical to the GET method (using the same semantics as GET), but without returning the response body to the client. It can be used to check the existence of a resource.

#### PUT Method
- If a **PUT** method creates a new resource, it must return the HTTP status code 201 (Created). The URI of the new resource is included in the Location header of the response. The body will contain a representation of the resource
- If the method updates an existing resource, it will return 200 (OK) or 204 (No Content). In some cases, it may not be possible to update an existing resource. In such circumstances, consider returning the HTTP status code 409 (Conflict).

#### POST Method
- When it performs a processing task the method may return the HTTP status code 200 and include the result of the operation in the response body. 
- If there are no results, the method can return the HTTP status code 204 (No Content) without a response body, or HTTP 202 (Accepted) if an asynchronous process has been initiated.  
  - In this case, the Location header will contain a reference to a resource that can provide the status of the request's progress.

If the client submits invalid data in the request, the server must return the HTTP status code 400 (Bad Request). The response body should contain additional information about the error or a link to a URI providing more details

#### DELETE Method
- The API will respond with the HTTP status code 204 indicating that the process was handled correctly and that the response body will not contain further information.

#### Conditional Requests

See the dedicated [reference](https://datatracker.ietf.org/doc/html/rfc7232) for further details. In short, it's possible to define precondition needed to consider a request valid.

- These preconditions are usually expressed through specific headers and are used in scenarios where multiple actors are simultaneously modifying a resource. Preconditions (based on an ETag, for example) help prevent the lost update phenomenon.

#### Status Code

##### Group By Category

| Category | Description |
|----------| ------------|
|1xx Informational| Not to be used except in experimental conditions, as they are not standardized |
|2xx Success| This class of status codes indicates that the action requested by the client has been received, understood, and accepted. |
|3xx Redirection| This class of status codes indicates that the client must take further action to complete the request. Many of these status codes are used for [URL redirection](https://en.wikipedia.org/wiki/URL_redirection). <br/> A user agent may perform the action without user intervention only if the method to be used is GET or HEAD. A user agent may automatically redirect a request. A user agent should detect and prevent any cyclic redirects. |
|4xx Client Error| This class of status codes is to be used in cases where the client is the cause of the error. Except for HEAD requests, the server should include an entity/representation containing an explanation of the error and whether it is transient or permanent. These status codes are applicable to all methods. User agents should display the information to users. |
|5xx Server Error| The server was unable to fulfill the request.<br/>Status codes that begin with the digit "5" indicate cases where the server encountered an error or was otherwise unable to process the request. Except for HEAD requests, the server should include an entity/representation containing an explanation of the error and whether it is transient or permanent. These status codes are applicable to all methods. User agents should display the information to users. |

##### Status Detail

[Reference](https://httpstatuses.com/)

| Code | Description |
|----------| ------------|
|200 OK | Indicates that the client's request has been successfully processed and that there is no more appropriate status code in the 2xx category.<br/><br/> Unlike status code 204, a response with a 200 code should include a body. The information returned depends on the method used in the request, for example: <br/> **GET** - the requested entity. <br/> **HEAD** - the HTTP headers of the requested entity (e.g., ETag, etc.).<br/> **POST** - an entity that describes or contains the result of the request. |
|201 Created| This status code indicates that the resource has been successfully created. <br/>If the action cannot be completed immediately, the server must respond with a 202 Accepted status code.<br/>|
|202 Accepted|  This status code signifies that the request has been accepted for processing, but the operation has not been completed yet. This is common for long-running operations.The outcome of the request is therefore not yet known and could be prevented if attempted again before the previous process has finished.<br/> The purpose is to allow the server to accept a request for another process (normally asynchronous/long-running/scheduled) without forcing the user agent to keep a connection open until the procedure is completed.<br/>The entity returned with the response should include an indication of the current status of the request and a pointer to a resource that shows the progress of the task.<br/>The Location header can be used instead of a body.<br/>The response might also include, in its headers, an estimated time for when the asynchronous process will be completed.  |
|204 No Content| The server has successfully processed the request, and there is no body in the response. |
|302 Found| The target resource resides temporarily under a different URI. Since the redirection might be altered on occasion, the client ought to continue to use the effective request URI for future requests. |
|303 See Other| The server is redirecting the user agent to a different resource, as indicated by a URI in the Location header field, which is intended to provide an indirect response to the original request. |
|304 Not Modified| If the client makes a conditional request (e.g., using the If-Modified-Since or ETag headers), and the resource has not changed. The returned status code indicates that a cached version would be still considered valid |
|400 Bad Request| 400 is the generic client-side error status, used when no other code in the 4xx error category is more appropriate. Request errors (body or parameters) can fall into this category.<br/>The client should not repeat the request without making the appropriate changes, which may be indicated in the response of the previous invalid request. |
|401 Unauthorized| A 401 error indicates that the client attempted to operate on a resource without providing the necessary credentials. The response must include the WWW-Authenticate header containing a challenge applicable to the requested resource.<br/> The client may repeat the request with the appropriate Authorization header. If the initial request already included the header, the 401 response indicates that authorization was denied for those credentials. |
|403 Forbidden| A 403 code indicates that the request is formally valid, even from an authentication perspective, but the server refuses to process it because the user lacks the necessary permissions, or the resource's state does not allow this particular operation. A 403 response is not a case of incorrect credentials; that would be the 401 Unauthorized code.<br/> Re-authenticating would not resolve the issue, and the request should not be repeated, as the problem lies with permissions, not credentials. |
|404 Not Found | The 404 status indicates that the requested resource could not be found by the client via the URI, but it may become available in the future, so further requests from the client are allowed.<br/>No indication is given as to whether the condition is permanent or temporary.|
|405 Method Not Allowed | The requested URL exists, but the HTTP method used in the request is not allowed for that URL.|
|409 Conflict | The request could not be completed due to a conflict with the current state of the target resource. This code is used in situations where the user might be able to resolve the conflict and resubmit the request.|
|412 Precondition Failed | The 412 code indicates that the preconditions expressed by the client in the request headers could not be met by the server (e.g[If-Match](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/If-Match)|
|415 Unsupported Media Type| The origin server is refusing to service the request because the payload is in a format not supported by this method on the target resource.|
|429 Too Many Requests| The client has sent too many requests in a given amount of time, often due to rate limiting on the server.  The server response should include a Retry-After header, which tells the client how long to wait before making additional requests|
|500 Server Error| 500 is a generic error code. Most web application frameworks return this error when an exception occurs in one of the components handling the requests.<br/>A 500 error is not caused by the client, so it is reasonable for a client to retry the operation to obtain a valid response.|
|503  Service Unavailable| The server is temporarily unable to handle the request. Unlike a 500 Internal Server Error, which suggests an unexpected issue, a 503 means the downtime is intentional or anticipated. In this case we aim Service Maintenance use cases|

##### ProblemDetails - Response Body for 4xx and 5xx Categories
- It is necessary to adopt a shared data model for error responses.

This model is outlined in [RFC 7807 - Problem Details](https://tools.ietf.org/html/rfc7807). Libraries and frameworks for various server-side technologies should provide functionalities to easily adopt this model.

A ProblemDetails object, as specified, can contain the following elements:
|type (string)| A [URI reference](https://tools.ietf.org/html/rfc3986) that identifies the type of problem. When dereferenced, it should provide human-readable documentation (e.g., using [HTML](https://html.spec.whatwg.org/multipage/)). When this value is not present, it is considered populated with "about:blank"|
|title (string)|A brief, human-readable description of the problem. It should not change between occurrences of the same problem, except for localization needs (e.g., using proactive content negotiation; see [RFC7231](https://tools.ietf.org/html/rfc7231#section-3.4), Section 3.4). |
|status (number)|The HTTP status code ([RFC7231 Section 6](https://tools.ietf.org/html/rfc7231#section-6), ) generated by the origin server for this occurrence of the problem. |
|detail (string)|A human-readable explanation that describes this specific occurrence of the problem.|
|instance (string)|A URI reference that uniquely identifies this specific occurrence of the problem.<br/>It is useful for tracking the instance of the problem within a structured log.<br/>It may be dereferenced to obtain more information, but this is not mandatory.|

It may also contain a series of elements that provide additional information for the particular type of problem encountered. For example:

```json
HTTP/1.1 404 Not Found
Content-Type: application/problem+json
Content-Language: en
 
{
    "type": "https://api.seca.eu/problems/resource-not-existing",
    "title": "Resource Not Found",
    "detail": "The resource my-vm does not exist",
    "instance": "/providers/compute/instances/my-vm"
}
```

Or, in the case of validation problems with a request:

```json
HTTP/1.1 400 Bad Request
Content-Type: application/problem+json
Content-Language: en
 
{
    "type": "https://api.seca.eu/problems/resource-not-valid",
    "title": "Resource Not Valid",
    "detail": "The resource field size of my-block cannot be empty",
    "instance": "/providers/storage/block-storages/my-block"
}
```

## API Enhancements

### Filtering

By exposing a collection of resources through a single URI, applications might retrieve large amounts of data when only a subset of information is needed. For example, a client application needs to find a resources subset. It could retrieve all resources from the URI collection and then filter. This process is clearly inefficient.

To improve client and server needs the API can allow passing a filter in the query string of the URI. We support to filter out only by labels and therefore clients should define a labelSelector queryParam.

The **labelSelector** parameter allows you to filter resources based on their labels.

#### Equality-Based Selectors
Equality-based selectors allow you to filter resources by exact label matches. They support two operators:

- = or ==: Selects resources that match the label key-value pair.
- !=: Excludes resources that match the label key-value pair.

1. Single Label Match

Selects resources where the label environment is production.
> labelSelector=environment=production


2. Multiple Labels (AND Condition):

Selects resources where app=myapp and environment=production
> labelSelector=app=myapp,environment=production

3. Label Exclusion:

Selects resources where environment is not production.
> labelSelector=environment!=production

#### Set-Based Selectors
Set-based selectors are more advanced and allow you to specify lists of possible values. They use three operators:

- **in**: Selects resources with a label key that matches any value in a given set.
- **notin**: Selects resources with a label key that does not match any value in a given set.
- **exists**: Selects resources with a particular label key, regardless of its value.

1. Label Value in Set

Selects resources where environment is either production or staging
> labelSelector=environment in (production, staging)

2. Label Value Not in Set:

Selects resources where environment is not development or test.
> labelSelector=environment notin (development, test)

3. Label Key Exists:

Selects resources that have the app label, regardless of its value.
> labelSelector=app


#### Combining Selectors
You can combine equality-based and set-based selectors to create more complex filters. When using multiple conditions, each is treated as an **AND** condition.

Example:
- app=myapp
- environment is either production or staging
- tier is not frontend

> labelSelector=app=myapp,environment in (production, staging),tier!=frontend

**Notes**
- **Logical OR is not supported**: Multiple label conditions in a single selector are implicitly combined with AND logic.
- **URL Encoding**: When using labelSelector in a URL, certain characters (=, !=, ,, in, notin, exists) need URL encoding. For example, labelSelector=app%3Dmyapp.

This flexible labeling structure enables precise filtering of resources like in Kubernetes

### Pagination

Pagination helps manage large data sets by dividing responses into "pages" of data. This prevents overwhelming the API consumer and ensures efficient API performance.

For endpoints returning continuously changing data, cursor-based pagination offers better performance and consistency. A cursor token is used to fetch the next page of data.

We call this param **skipToken**

- It's a query parameter used in API requests to handle pagination in responses for large datasets. The skip token is essentially a marker that tells the API where to continue retrieving results from, allowing clients to navigate through paginated data efficiently.
- When an API returns a skip token, the client includes it in the next request to retrieve the subsequent set of results; In the response it's included in the metadata structure.

This process is repeated, with each nextLink providing a new skip token, until there are no further results.

**Notes**

Using a skip token for pagination in APIs can introduce consistency challenges, especially in systems where data is frequently updated. This is because data may change between paginated requests, potentially leading to gaps, duplicates, or outdated information in the results. Here’s how consistency issues arise and strategies to manage them when using skip tokens.

- As you retrieve pages of data using a skip token, items may be added, deleted, or modified between requests.

Skip tokens are state-based, meaning they’re associated with a specific snapshot of the data state. As data changes, the relevance of the token might diminish, leading to inconsistencies in paginated responses if not handled well.

## Versioning

We need to implement API versioning to manage changes and maintain compatibility across their services. SECA's approach to API versioning is guided by principles that ensure stability and flexibility for developers.

**SECA API versioning** helps manage changes and compatibility within the API as SECA evolves. Each API resource in SECA (like Compute.Instance, Network.VPC, Authorization.Role) is versioned to ensure stability, consistency, and backward compatibility. SECA API versions, inspired by Kubernetes, are  denoted by **vXalphaY**, **vXbetaY**, or **vX**, where:

- **Alpha (vXalphaY)** - Represents early-stage features that are experimental.
  - APIs in this stage are subject to breaking changes, meaning they may change or be removed entirely.
  - X is the major version number (e.g., v1alpha1).

- **Beta (vXbetaY)** - Considered stable enough for more extensive testing but may still have breaking changes.

  - Beta features are expected to stay around for at least a few releases, though feedback may lead to further changes before they’re marked as stable.

- **Stable (vX)** - Represents APIs that are considered production-ready and highly stable.
  - Changes here are rare, non-breaking, and backward-compatible.
  - Once an API reaches v1 or another stable version, breaking changes are avoided, though deprecation policies apply to manage the gradual removal of older API versions.
  - When using the SECA Cloud Service Provider, selecting the correct version for each resource is essential for ensuring stability and compatibility.

### Usage

The SECA Resource Versioning is specified as part of the URL path when making API calls.

```bash
GET /v1beta1/workspaces/my-workspace/providers/network/vpcs
```

However, when referencing resources within API responses or configurations, the version is omitted from the resource name. This approach ensures that resource identifiers remain consistent and unaffected by version changes, promoting stability and ease of use.

```json
{
  "metadata": {
    "name": "primary-load-balancer",
    "labels": []
  },
  "spec": {
    "routingTableRef": "/providers/network/routing-tables/default"
  }
```

### Breaking Change Definition

The API represents a contract between parties. Changes that directly or indirectly impact the backward compatibility of an API are to be considered breaking changes.
- Services must explicitly define their understanding of breaking changes, especially regarding additive modifications—new fields, new parameters, both potentially with default values.
- Services must be consistent in their definition of the extensibility of a contract.

The definition of backward compatibility also partially depends on technical and business requirements. For some teams, adding a new field may fall under the category of a breaking change. For others, it may be considered an additive modification and therefore not necessarily impactful for existing clients.

#### Examples of additive modifications that are not necessarily breaking:
- Adding a new feature expressed in terms not previously available (therefore new).
- Adding an element (property, query string parameters, etc.) without making it mandatory and assigning a default value.

#### Universal examples of breaking changes:
- Removal, renaming, or alteration of part of a contract in the form of data models, types, paths, parameters, or other elements. Examples:
- Removing a method.
- Adding a mandatory parameter to a method without providing a default.
- Adding a mandatory attribute without providing a default.
- Removing attributes.
- Changing the type of an attribute.
- Expanding or modifying the range of allowed values for a particular element.
- Changes in behavior even with the same contract/API.
- Changes in error codes and so-called Fault Contracts, which express the result of an error condition.
- Anything that violates the principle of least surprise.

## Asynchronous Operations

Sometimes a POST, PUT, or DELETE operation may require processing that takes some time to complete. Waiting for the operation to finish before sending a response to the client can cause unacceptable latency. In such cases, consider making the operation asynchronous. Return the HTTP status code 202 (Accepted) to indicate that the request has been accepted for processing but has not yet been completed.

It is recommended to expose an endpoint that returns the status of an asynchronous request, allowing the client to monitor the status by performing polling. Include the URI of the status endpoint in the Location header of the 202 response, for example:


    HTTP/1.1 202 Accepted
    Location: /v1beta1/workspaces/my-workspace/providers/network/vpcs/my-vpc/status

If the client sends a GET request to this endpoint, the response must contain the current status of the request. Optionally, it can also include the estimated time for completion or a link to cancel the operation.



    
    HTTP/1.1 200 OK
    Content-Type: application/json
     
    {

        "status": {
            "state": "Creating",
            "conditions": [
                {
                  "type:": "VPCScheduled",
                  "status: "True",
                  "lastTransitionTime": ""2024-11-06T14:25:18Z",
                  "reason": "VPCInitialized",
                  "message": "The VPC has been initialized successfully"
                }
            ]
        }
    }

### Asynchronous Request-Reply Pattern

Scenario: Executing a long-running server-side process while returning information that allows clients to track its execution without waiting.

In modern application development, it is common for client applications—often code running in a web client (browser)—to rely on APIs to provide business logic with additional features.

These APIs may be directly tied to the application or may be services provided by third parties. Commonly, these API calls occur over the HTTP(S) protocol and follow REST semantics. In most cases, APIs for clients are designed to respond quickly, typically within 100 ms or less. Many factors can affect response latency, including:

Application hosting stack
- Security components
- Geolocation of the caller relative to the back-end
- Network infrastructure
- Current workload
- Request payload size
- Processing queue length
- Time taken by the back-end to process the request

Each of these factors can add latency to the response. Some can be mitigated by scaling the back-end horizontally, while others, such as network infrastructure, are largely beyond the control of the application developer.

Most APIs can respond quickly enough that the responses arrive through the same connection. However, in some scenarios, the work performed by the back-end may be long-running and not easily predicted. In such cases, it is not possible to wait for the work to complete before providing a response to the client. This situation creates a potential problem for any synchronous request/reply model.

Some architectures solve this issue by using a message broker to separate the request and response phases. This separation is often done using a load-balancing model based on queues. It allows for the independent scaling of both the client and the back-end. However, this comes at the cost of increased complexity, especially since the client expects a result in the short term.

Many of the same considerations mentioned for client applications also apply to REST API calls from server to server in distributed systems—such as in a microservices architecture.

### Solution

A solution to this problem is to use HTTP polling. Polling is useful for client-side code, as it can be difficult to provide callback endpoints or use long-lived connections. Even when callbacks are possible, the additional libraries and services required can sometimes add too much complexity.

The client application makes a synchronous call to the API, initiating a long-running back-end operation.

The API responds synchronously as quickly as possible. It returns an HTTP status code 202 (Accepted), acknowledging that the request has been received for processing.

*The API must validate both the request and the action to be performed before starting the long-running process. If the request is invalid, it should respond immediately with an error code, such as HTTP 400 (Bad Request).*

- The response includes a reference to an endpoint that the client can use for polling and to check the result of the long-running operation.
- The API allows offloading the processing to another component, such as a message queue.
- While the work is still pending, the status endpoint returns HTTP 202. Once the operation is completed, the status endpoint can return a resource indicating the completion or redirect to another resource URL. For example, if the asynchronous operation creates a new resource, the status endpoint will redirect to the URL for the resource.

The below picture shows the typical flow:

![Async-request.png](./pic/async-request.png)

- The client sends a request and receives an HTTP 202 (Accepted) response.
- The client sends an HTTP GET request to the status endpoint. Since the work is still pending, this call will also return an HTTP 202.
- At some point, once the work is completed, the status endpoint will return a 302 (Found) with a redirect to the resource.
- The client retrieves the resource at the specified URL

### Considerations and Issues

There are several possible ways to implement this model using HTTP, and not all underlying services necessarily have the same semantics.

For example, most services will not return an HTTP 202 response from a GET method. Rather, to adhere to pure REST semantics, they should return an HTTP 404 (Not Found). This response makes sense when considering that the result of the call is not yet available.

An HTTP 202 response must indicate a URI and how often the client should poll to get the result. It should therefore include the following headers:

| Header | Description | Note|
|--------|-------------|-----|
| Location | URL where the client can retrieve information about the execution status of the long-running task.|This URL could be a token to temporarily access a resource subject to access control (e.g., an object storage in case the result of the long-running operation is a processed file).|
| Retry-After |An estimate of when the processing will be completed.|This header is designed to prevent clients from overloading the back-end with repeated polling attempts.|

- A façade might be necessary to modify the response headers, or even the payload, depending on the underlying services used.
- If the status endpoint for the operation involves a redirect upon completion, the status codes 302 (Found) or 303 (See Other) are the most appropriate.
- Upon completion of the processing, the resource specified by the Location header must return an appropriate HTTP status code, such as 200 (OK), 201 (Created), or 204 (No Content).
- If an error occurs during processing, the error should be persisted at the resource URL described in the Location header, and an appropriate HTTP status code (4xx category) should be returned to the client from that resource.
- Not all solutions will implement this model in the same way, and some services might include additional or alternative headers.
- In some scenarios, it may also be useful to provide clients with a way to cancel the long-running request. In such cases, the backend service must support a form of cancellation command for the ongoing operation.

### When should you use this model?

Use this model for:

- Client-side code, such as browser applications, where it is difficult or impossible to provide callback endpoints or use long-lived connections.
- When only the HTTP protocol is available, and due to client-side firewall restrictions, invoking callbacks is not possible.
- Integrations with legacy architectures that do not support newer technologies like web hooks or WebSocket.

This model might not be suitable in the following cases:
- The architecture already includes notifications based on asynchronous messaging.
- The client expects real-time progress updates.
- The client needs to monitor more than one long-running operation and process the results once received—consider using a Process Manager on the backend.
- It is possible to use persistent server-side network connections, such as WebSocket. These services can be used to notify the caller of the result.
- The network and architectural design allow opening ports to receive asynchronous callbacks or webhooks.