# Changelog

All notable changes to this project will be documented in this file.

This changelog follows a **channel-based versioning** approach with versions like `v1alpha1`, `v2alpha2`, etc.

---

## [v1-pre1] - 2025-01-17

- Added: improved build and linting
- Changed: [v1alpha1] to [v1] since the SECA API should not start with a beta version
- Changed: separated the API into multiple files
- Changed: removed all path files and integrated them into the respective API
- Fixed: fixed all definition errors

## [v1alpha1] - 2024-11-29

- Added: Documentation: introduced REST Guideline and Resource Design.
- Added: Design: introduced the Seca Core Resources (Tenant,Workspace,Region)
- Added: Design: introduced Resource Provider Based Design. Every Resource endpoint is based on the Resource Scope + Resource Name.
- Added: Design: defined a Resource Read Model based on the Kubernetes Standard Definition (apiVersion,kind,spec,status)..
- Added: Design: make use of PUT to create/update resource; DELETE to eliminate and POST to run long-running actions on the resource.
- Added: API: Introuced Core,Authorization,Compute,Network,Storage Resource Providers.
- Added: API: Introduced `/v1alpha1/` endpoint.
- Added: API: added Compute.Instance ad Instance Lifecycle actions (power-on, power-off, power-cycle).
- Added: API: added Network.Lan, Network.Subnet, Network.NIC,Network.Security-Group, Network.Public-Ip.
- Added: API: addeed Storage.Block-Storage.
- Added: API: added Authorization.Role, Authorization.Role-Assignment.
- Added: API: added the Catalogue concept for each resource provider by using the Skus Endpoint for Seca.Storage,Seca.Compute,Seca.Network.
- Added: API: added Seca Defined Labels for SKU to determine recognized method to describe resources based on some criteria.
