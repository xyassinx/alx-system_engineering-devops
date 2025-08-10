# Secured and Monitored Web Infrastructure

## Overview
This infrastructure design for `www.foobar.com` enhances the distributed web stack with **security**, **encrypted traffic**, and **monitoring**. It uses a three-server setup with firewalls, HTTPS, and monitoring agents for improved reliability and observability.

## Whiteboard Diagram
https://docs.google.com/document/d/1vm4HeNCd4S152IMH7dbef4qUfmZ78_SbYlcslDn-GKo/edit?usp=sharing
## Infrastructure Components
- **Load Balancer (HAProxy):**
  - Distributes incoming traffic to application servers.
  - Uses **least-connections** algorithm for balanced load distribution.
  - Performs SSL termination for HTTPS traffic.
- **Application Servers (App-01, App-02):**
  - Run Nginx for static file serving and reverse proxy to the application runtime.
  - Process dynamic requests using the application codebase.
  - Query the database for data-driven requests.
- **Database (MySQL Primary-Replica):**
  - **Primary Node:** Handles write operations.
  - **Replica Node:** Supports read operations, enhancing performance through read-write separation.
  - Asynchronous replication ensures data redundancy.

## Additional Components
- **Firewalls (3 total):**
  - **Purpose:** Secure each server (Load Balancer, App-01, App-02, Database) by restricting access.
  - **Function:** Permits only essential traffic (e.g., 80/443 for web, 3306 for internal MySQL connections).
  - **Benefit:** Reduces attack surface and protects against unauthorized access.
- **SSL Certificate (HTTPS):**
  - **Purpose:** Encrypts client-server communication.
  - **Function:** Prevents interception of sensitive data (e.g., via man-in-the-middle attacks).
  - **Benefit:** Enhances user trust, improves SEO, and ensures compliance with security standards.
- **Monitoring Clients (3 total):**
  - Installed on Load Balancer, App servers, and Database.
  - **Purpose:** Collects metrics on uptime, performance, and anomalies.
  - **Tools:** Examples include Prometheus, Datadog, or Sumologic agents.
  - **Benefit:** Enables proactive issue detection and performance optimization.

## Monitoring Details
- **Objective:** Track availability, performance (e.g., queries per second - QPS), error rates, and resource usage (CPU, memory, disk).
- **Implementation:** Agents collect logs, metrics, and traces, sending them to a centralized monitoring system for analysis.
- **QPS Monitoring:** Configure tools to parse Nginx or MySQL query logs, visualizing data on dashboards for real-time insights.

## Security Measures
- **Firewalls:** Restrict inbound/outbound traffic to authorized ports and sources.
- **HTTPS:** Ensures encrypted communication between clients and the load balancer.
- **Internal Database Access:** MySQL is only accessible within the private network, reducing exposure to external threats.

## Infrastructure Issues
- **SSL Termination at Load Balancer:**
  - **Issue:** Traffic between HAProxy and application servers is unencrypted, risking data exposure if the internal network is compromised.
  - **Mitigation:** Implement end-to-end TLS encryption.
- **Single MySQL Primary Node:**
  - **Issue:** Primary node failure halts write operations until failover to a replica occurs.
  - **Mitigation:** Add automated failover and multiple replicas.
- **Uniform Server Configuration:**
  - **Issue:** Identical setups across servers complicate isolating and scaling individual components.
  - **Mitigation:** Optimize server roles for specific workloads (e.g., dedicated database hosts).

## Domain Name and DNS
- **Domain Name:** `foobar.com` with a `www` subdomain.
- **DNS Record:** A record mapping `www.foobar.com` to the load balancer’s public IP.
- **Function:** Directs user requests to the load balancer for traffic distribution.

## Communication Flow
1. User enters `https://www.foobar.com` in their browser.
2. DNS resolves the domain to the load balancer’s IP.
3. HAProxy receives the HTTPS request, terminates SSL, and forwards it to an application server (App-01 or App-02).
4. The application server processes the request:
   - For static content, Nginx serves files directly.
   - For dynamic content, the application runtime queries the MySQL database (writes to Primary, reads from Replica).
5. The response is sent back through HAProxy to the user’s browser over HTTPS.