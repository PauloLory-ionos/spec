## **API Access Control**

API access control refers to the mechanisms and policies that manage and restrict access to APIs, ensuring that only authorized users or systems can access specific resources and perform certain actions. At its core, API access control is about maintaining data security, preventing unauthorized access, and ensuring compliance with regulatory standards.

In essence, API access control defines **who** can interact with an API, **what** they are allowed to do, and under what circumstances(**how**). This control process usually involves authentication (verifying identity) and authorization (determining access levels), each implemented with specific tools, protocols, and frameworks.

The significance of API access control has grown alongside the increasing reliance on APIs for business operations and customer interactions. A robust access control strategy is essential to:
- **Data Protection**: APIs often expose endpoints that allow access to critical or sensitive information. Effective access control prevents unauthorized entities from reaching this data.
- **System Integrity**: By controlling access, organizations can safeguard their APIs from malicious actors who might attempt to misuse API endpoints for unauthorized actions.
- **Compliance**: Regulatory standards often require strict access control mechanisms to be in place to protect personal data and ensure auditability.
- **Enhance Customer Trust** - When users know their data is secure and only authorized entities can access it, trust is built, fostering stronger relationships and potentially improving business outcomes.

Based on **SECA Standard API Server** we adopted the below architecture:

![API Access Control](./pic/API%20Access%20Control.png)

- More in detail, every custom request (coming from both user or client app) goes to the Control Plane API Server. 
  - first check is **identify** who is the customer
  - after authentication we need to verify if the customer has the **privilege** to perform the requst
  - afterwards we can **validate** and/or **manipulate** the request to fullfill domain requirements

### **Authentication**

As stated in the [REST API Guidelines](./rest-api-guidelines.md), we identify the user based on a **JSON Web Token (JWT)** transmitted by the client in every request.
- This is included in a **Authorization Header** as Bearer Token.

In order to perform and fullfill the authentication step of the CSP Control Plane the customer should get the JWT Token.
- **TODO** (describe here how to get that if defined a common API URI or not)


### **Authorization**

Resource Authorization Model makes sure users or applications have the right to invoke Control Plane APIs. <br/>We need a specific service within the cloud environment being responsible for managing access controls and enforcing permissions for other resources
- according to the Control Plane API organization we have a  provider workspace for every resource type.
- we define an **authorization** provider workspace to take care of authorization concepts.

 This model centralizes authorization logic, making it scalable, consistent, and easier to manage across a wide range of resources.

 The Key Elements of this model are listed below:

 - **Dedicated Resource Provider** - This is a centralized service that acts as the authority for all authorization decisions. Instead of each resource handling its own access controls, the dedicated provider manages policies, roles, and permissions for all resources
 - **Authorization Policies** - Policies define the permissions granted to users, groups, or services. These policies are managed by the dedicated provider and applied consistently across resources. Policies typically define **who** (identity) has access to **what** (resource) and **how** (permissions, such as read, write, or delete).
- **Roles and Role-Based Access Control (RBAC)**: The provider offers a way to define roles that encapsulate a set of permissions. Roles can be applied to users, groups, or other identities. For example, roles might include "Viewer," "Editor," or "Administrator," each with different levels of access. RBAC simplifies authorization management by assigning roles instead of individual permissions.
- **Access Control Enforcement**: Once policies and roles are defined, the cloud API enforces them consistently across resources. When a user or service tries to access a resource, the dedicated provider validates the request based on the permissions associated with the user’s role or policies.

A resource authorization model with a dedicated resource provider centralizes access control across resources, offering an efficient, consistent, and secure way to manage permissions and enforce policies at scale in a cloud environment. This model enhances security by reducing complexity and enabling centralized governance over resource access.

#### Role

A **Role** is a resource that defines a set of permissions within a specific workspace, allowing controlled access to resources within that workspace. Roles are a key part of **SECA RBAC (Role-Based Access Control)** mechanism, which provides fine-grained access control for users and customer applications interacting with cloud resources.

Key Concepts of a SECA Role:
- **workspace-scoped**: A Role is confined to a single workspace, meaning it grants permissions to resources within that specific workspace only. For tenant-wide permissions, a TenantRole would be used instead.

- **Permissions (Rules)**: A Role contains rules that specify which actions are permitted on particular resources. These rules are defined using:
  - **Resources** (e.g., instance, subnets, security-group) that the role can access.
  - **Verbs** (e.g., get, list, create, delete) that indicate what actions can be taken on the resources.
  - **Resource Names** (optional) to specify individual resources by name for more precise control.

- **Least Privilege Principle**: Roles enable Tenant Administrators to grant minimal permissions necessary for a user or application to perform its tasks, enhancing tenant security by limiting access to only what is needed.

This is essential for applying granular access control within a workspace, aligning with the principle of least privilege to keep CSP tenants secure and manageable.

#### RoleBinding

A **RoleBinding** is a resource used to associate a Role with specific users, groups, or customer applications, granting them the permissions defined in the role. RoleBindings are a fundamental part of SECA RBAC (Role-Based Access Control) system, as they are the mechanism through which permissions are actually applied to subjects.

Key Concepts of a RoleBinding
- **Workspace-Specific**: A RoleBinding grants access within a single Workspace. It binds a Role (which is also Workspace-scoped) to specific subjects within that Workspace. For granting tenant-wide permissions, a TenantRoleBinding is used instead, which can apply to resources across all Workspaces.

- **Subjects**: RoleBindings specify the subjects (such as users, groups, or customer applications) that will receive the permissions defined in the Role. These subjects can be:
  - **Users**: Individual user accounts.
  - **Groups**: Collections of users.
  - **customer applications**: Accounts used by applications or other processes running within the SECA tenant.
- **Reference to a Role**: A RoleBinding references an existing Role to grant permissions within a single Workspace.
- **Applying Permissions**: RoleBindings do not contain permissions themselves; they simply bind a set of permissions (defined in a Role) to one or more subjects.

#### TenantRole

A **TenantRole** is a resource that defines a set of permissions across the entire tenant, not limited to a single workspace. Unlike a Role, which is workspace-scoped, a TenantRole can apply to resources across all workspaces or to tenant-level resources that do not belong to any workspace.

#### TenantRoleBinding

A **TenantRoleBinding** is a resource used to associate a TenantRole with specific users, groups, or customer applications across the entire tenant. TenantRoleBindings are crucial in SECA Role-Based Access Control (RBAC) system because they apply permissions globally, enabling administrators to manage access across all workspaces or to tenant-wide resources.

### **Admission Control**

**Admission control** in the SECA API Access Control is a mechanism that intercepts requests to the Control Plane before they are persisted in the database, allowing the SECA CSP to enforce policies, apply security rules, and manage resource allocation. Admission controllers act as "gatekeepers" that can accept, modify, or deny requests based on custom or predefined policies, helping ensure a consistent and secure tenant environment.

Key Concepts of Admission Control are the below listed:
- **Request Interception**: When a user or application sends a request to create, update, delete, or connect to a cloud resource, the Control Plane Cloud API processes it through a sequence of admission controllers. These controllers evaluate the request before it is applied to the cluster.
- **Types of Admission Controllers**:
  - **Validating Controllers**: Validate requests according to certain rules. For example, they might check that a cloud resource requests are within limits defined in the tenant subscription.
  - **Mutating Controllers**: Modify requests as needed. For example, they may inject some metadata or other mandatory fields if they would be skip by the user but are needed in the Resource API specification.