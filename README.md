# SECA - Sovereign European Cloud API

## Mission

Unite top European providers to create a European cloud standard attracting the public sector.

## Key advantages

* sovereignty, e.g. immunity from foreign government interference keeping API control with founding members
* common standards reduces costs, e.g. less training, common tooling, faster adoption, …
* broad provider support will incentivize ISVs to build profitable tools and software ecosystems
* build-in alignment with EU regulations for resilience, data protection and privacy
* long-term support of APIs provide reliability and maintainability
* comparison of compliant providers and increased resources using multiple providers
* directly address the demand of the public sector to have no vendor login

## Open Development Model

The SECA API is designed with extensibility in mind, allowing for the seamless integration of new products and features as they emerge. To facilitate this, the API framework is open to proposals from any member of the SECA community. Members can submit suggestions for new features, enhancements, or extensions to the API council, which will review and evaluate them based on the established API guidelines. This collaborative approach ensures that the SECA API remains adaptable, innovative, and aligned with the evolving needs of its users, while maintaining the integrity and consistency of the API framework.

## High Level architecture

![./assets/high-level-separation.png](./assets/high-level-separation.png)

The SECA API is designed with a clear separation of concerns, dividing its architecture into two distinct planes: the Control-Plane and the Data-Plane. This design allows for flexibility in implementation, supporting both regional and fully-global API deployment strategies.

The Control-Plane serves as the management interface, handling resource creation, configuration, and provisioning. In contrast, the Data-Plane provides customers with access to their provisioned resources, enabling them to utilize the allocated services.

A key principle of the SECA API is its adaptability, allowing implementers to deploy it regionally or globally, depending on their specific requirements. To achieve this, resources are separated by provider, with provider-specific APIs defined to operate at either a regional or global scope.

By building upon existing Cloud Service Provider APIs, the SECA API facilitates a seamless integration with established cloud infrastructure, enabling a more efficient and streamlined deployment process.

## Foundation Compliance

![./assets/dependencies.png](./assets/dependencies.png)

To achieve foundation compliance, a Cloud Service Provider (CSP) must implement the necessary providers to establish a foundational Infrastructure-as-a-Service (IaaS) layer. This involves deploying a comprehensive set of providers that enable the creation and management of essential resources.

New CSPs can ideally achieve foundation compliance within a short timeframe by implementing the required providers from scratch. Alternatively, existing CSPs with pre-existing APIs can leverage these to expedite the compliance process. In such cases, a simple API proxy or translator can be employed to map the control plane resources, enabling seamless integration with the SECA API framework. This approach minimizes the need for extensive re-architecture, allowing CSPs to rapidly adapt to the SECA standard.

## TODO Products / Functionalities

### SECA Foundation (v1) **WIP**

* [ ] Compute
  * [x] SKU
  * [x] Quota
  * [x] Basic API
  * [ ] Group
  * [ ] SSH Keys
* [ ] Network
  * [x] SKU
  * [x] Quota
  * [x] Basic API
  * [ ] Routing API
* [x] Storage
  * [x] SKU
  * [x] Quota
  * [x] Basic API
* [x] Workspace
  * [x] Basic API
* [ ] Regions
  * [ ] Basic API
* [ ] Authorization
  * [ ] Basic API

### SECA Object-Storage (v1) **WIP**

* [ ] SKU
* [ ] Basic API

### SECA Load-Balancer (v1) **WIP**

* [ ] SKU
* [ ] Basic API

### SECA Activity-Log (v1) **WIP**

* [ ] SKU
* [ ] Basic API

### SECA KMS (v1) **TODO**

* [ ] SKU
* [ ] Basic API

### SECA Kubernetes (v1) **TODO**

* [ ] SKU
* [ ] Basic API
