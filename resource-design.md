# **Resource Design**

# Table of Contents
- [Introduction](#introduction)
- [Architecture](#resource-model)
  - [Control Plane](#architecture)
  - [Data Plane](#resource-model)
- [Resource Model](#resource-model)
  - [Resource Definition](#resource-definition)
  - [Resource Lifecycle](#resource-lifecycle)

## **Introduction**
The aim of this document is to define guidelines to design resource model for the eurocloud APIs

## **Architecture**

Cloud Requests can be divided in two categories:
  - **Control plane** 
    - Those APIs are used to create and manage cloud resources in a specific tenant
    - All requests are sent to a Cloud Resource Manager;
    - Control plane APIs manage **resources**.
    - Control plane returns configurations(e.g., metadata, resource properties, states).
    - It's easier to define Control plane resources to follow a more standardized Resource schema
    - These APIs return resource management data, such as metadata, configuration details, status.
  - **Data plane**
    - Requests for Data Plane operations are sent to an endpoint that's specific to your instance.
    - The purpose is to interact with the actual data or service provided by a Cloud Resource (e.g., reading/writing to a object storage, querying a database, etc.).
    - Data plane APIs manage **data**.
    - Data plane returns actual data (e.g., files, query results, or data manipulation responses)
    - Data plane schemas vary widely based on the type of data and the service object (e.g., NFS, SQL, Key/Value, Kubernetes API, Vaults, etc.).
    - These APIs return and operate on actual data rather than metadata or configuration

### **Control Plane**

Control Plan APIs have all the following template:

```bash
`https://{service}.{domain}/{scope}/providers/{resourceProviderNamespace}/{resourceType}[/{resourceName}][/{action}]?api-version={api-version}[&{queryStringParameters}]`
```


| Parameter | Description |
|---------- | ----------- |
| service   | Name of the cloud service, ”api” in our case |
| domain    | Cloud Service Provider domain name (ad es. aruba.it, arubacloud.com, etc.) |
| scope    | A hierarchical set of key-value pairs that identify the origin of the resource. <br/> Scopes answer questions like: “What cloud account contains this resource?<br/>"Which department or organizational unit this resource belongs to ?"<br/>"What logical group this resource belongs to ?"<br/>|
| resourceProviderNamespace    | The namespace and type of a resource. These are defined together because resource types are usually two segments - a vendor namespace and a type name. For example Aruba.Compute. Each Resource is managed by a Resource Provider. The implementation of Resource Provider is CSP specific. A single Resource Provider can manage multiple resource types|
| resourceType    | The type of Resource|
| resourceName    | The name of the Resource. Sub-resources are allowed. They follow the parent resource in the URL path|

### **Data Plane**

```bash
`https://{tenant}.{region}.{service}.{cloud}/{service-root}/{resource-collection}/{resource-id}`
```

****TO DO****
| Field | Description |
|---------- | ----------- |
| tenenat | what is a tenant?  |
| region  | what is a region?   |
| service | what is a service? |
| cloud   | the cloud domain (es: arubacloud.com) |
| service-root   | Service Specific path (es: kaas) |
| resource-collection   | Name of the collection pluralized |
| resource-id   | Id of resource within the resource-collection. This MUST be the raw string/number/guid value with no quoting but properly escaped to fit in a URL segment. |

## **Resource Model**

- Every object managed by the APIs is a Resource. It can be created, updated, read, listed and disposed of.
- Generally, each Resource has a provisioning state, managed by a specific Resource Provider that owns one or more Resources, grouped by shared characteristics.


### **Resource Definition**

| Section | Description |
|-------------|---------|
|metadata|Additional data that convey some system information related to the control loop mechanisms that regulate the system’s dynamic equilibrium.<br/> Some of their functions are:<br/> Search, which consists of identifying the existence of a document;<br/>Localization, meaning to trace a specific occurrence of the document;<br/>Selection, achievable by analyzing, evaluating, and filtering a series of documents;<br/> Semantic interoperability, which allows searching across different disciplinary fields through a series of equivalences between descriptors;<br/>Resource management, i.e., managing document collections through the mediation of databases and catalogs;<br/>Availability, which means obtaining information about the actual availability of the document.<br/>|
|properties|The record of intent that describes the changes to be applied to a resource; in other words, the desired state of the resource|
|status|The current state of the resource. Resource Controllers use the desired state of the resource as a reference to modify its current state in one or more transitions.<br/>It is possible for the Resource Controller to apply changes to the current state of the resource regardless of the record of intent to realign it with the infrastructure, when necessary.<br/>The data contained in 'status' are structurally symmetrical to those present in 'properties'|
|data|Private data of the resource that cannot be exposed through properties or status|

### **Resource Lifecycle**

| Operation | HTTP Verb | Description |
|-------------|---------|-------------|
| Read   |  GET   |Retrieve the representation of a specific resource|
| Create |  PUT   |creates a resource|
| Update |  PATCH |updates a resource|
| Delete |  DELETE|Deletes a specific resource|
| List   |  GET   |Retrieve the representations of a set of resources. The output set can be determined based on a filter passed on input|
| Action |  POST  |Control Plan APIs can be extended by Actions (for example PowerOff and Restart for Virtual Machines)|
