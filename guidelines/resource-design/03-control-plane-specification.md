## **Control Plane Specification**

Control Plan APIs have all the following template:

```bash
`https://{service}.{domain}/{scope}/providers/{resourceProviderworkspace}/{resourceType}[/{resourceName}][/{action}]?api-version={api-version}[&{queryStringParameters}]`
```


| Parameter | Description |
|---------- | ----------- |
| service   | Name of the cloud service, ”api” in our case |
| domain    | Cloud Service Provider domain name (ad es. aruba.it, arubacloud.com, etc.) |
| scope    | A hierarchical set of key-value pairs that identify the origin of the resource. <br/> Scopes answer questions like: “What cloud account contains this resource?<br/>"Which department or organizational unit this resource belongs to ?"<br/>"What logical group this resource belongs to ?"<br/>For example, the resource paths /workspace/ws1/vpc/my-vpc and /workspace/ws2/vpc/my-vpc can coexist without creating a naming collision for 'my-vpc'.|
| resourceProviderworkspace    | The workspace and type of a resource. These are defined together because resource types are usually two segments - a vendor workspace and a type name. For example Aruba.Compute. Each Resource is managed by a Resource Provider. The implementation of Resource Provider is CSP specific. A single Resource Provider can manage multiple resource types|
| resourceType    | The type of Resource|
| resourceName    | The name of the Resource. Sub-resources are allowed. They follow the parent resource in the URL path|
| action    | Optional operations to perform on the resource (e.g., start, stop, restart, delete). These are specific actions beyond the standard CRUD operations. |
| api-version | The version of the API being used for the request. This ensures compatibility and proper handling of the request format. |
| query-string-parameters | Optional parameters that modify or filter the request (e.g., $filter, $select, $expand, $orderby, pagination parameters like $top and $skipToken). |