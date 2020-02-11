# Bill Of Materials builder webside project

The goal is to deploy a simple public web site with a back-end database running on a database server.

The main characteristics are:

- It is an interactive IT BOM builder. It will consist of an online tool that allows authenticated users to create BOMs for IT deployments based on the company’s up-to-date list of vendors, standard components and negotiated prices.

- The tool will be offered through a public faced web front-end. The target users are internal employees, mainly the site’s IT administrators and managers. Regardless of if the users are inside or outside the corporate network, they will access using any Internet access without the need to set up a VPN first. When the user is on-net, it will use the closest company’s Internet gateway.

- The tool will use a database that collects the full list of IT standard components including the up-to-date negotiated price lists. The data will be hosted in the cloud as there isn't personal or other sensitive data that results in any concern in terms of GDPR compliance.

- Users’ authentication is based on Active Directory, which is on-prem. In regards to network security, servers at each layer of the structure will just be allowed to exchange the traffic required for the solution to work and moreover SSH and SCP from a well-known management jump station.

- The tool is not business-critical so that it high-availability countermeasures are just nice to have.

- As the solution relies on an Active Directory integration it will require a connection to our on-prem DC. The expected data volume exchange will be low, so we’ll rely on VPN connection/s from CSP to a new DMZs in three of our tier1 Internet gateways. 

- The VPN connection will be also used by web-admins to operate, develop and manage the solution.

- The BOM form will show images of the selected components (not all vendors at this point in time), for the ones that offer this capability it will require a connection to our partners' databases also in the cloud.
