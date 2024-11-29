# Changelog

All notable changes to this project will be documented in this file.

This changelog follows a **channel-based versioning** approach with versions like `v1alpha1`, `v2alpha2`, etc.

---

## [v1alpha1] - 2024-11-29
### Added
- Documentation: introduced REST Guideline and Resource Design.
- Design: introduced the Seca Core Resources (Tenant,Workspace,Region)
- Design: introduced Resource Provider Based Design. Every Resource endpoint is based on the Resource Scope + Resource Name.
- Design: defined a Resource Read Model based on the Kubernetes Standard Definition (apiVersion,kind,spec,status)..
- Design: make use of PUT to create/update resource; DELETE to eliminate and POST to run long-running actions on the resource.
- API: Introuced Core,Authorization,Compute,Network,Storage Resource Providers.
- API: Introduced `/v1alpha1/` endpoint.
- API: added Compute.Instance ad Instance Lifecycle actions (power-on, power-off, power-cycle).
- API: added Network.Lan, Network.Subnet, Network.NIC,Network.Security-Group, Network.Public-Ip.
- API: addeed Storage.Block-Storage.
- API: added Authorization.Role, Authorization.Role-Assignment.
- API: added the Catalogue concept for each resource provider by using the Skus Endpoint for Seca.Storage,Seca.Compute,Seca.Network.
- API: added Seca Defined Labels for SKU to determine recognized method to describe resources based on some criteria.

### Changed

### Fixed

---
