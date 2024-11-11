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
