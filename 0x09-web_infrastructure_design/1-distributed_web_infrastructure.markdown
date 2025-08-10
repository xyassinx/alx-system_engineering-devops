# Distributed Web Infrastructure

## Whiteboard Diagram
https://docs.google.com/document/d/1KcC45fMspXb9ZWb4YrL5J3UZwd2CuWW2It0_enjWhb0/edit?usp=sharing
## User Journey
1. A user navigates to `www.foobar.com` in their browser.
2. DNS resolves `www.foobar.com` to the public IP of the load balancer.
3. The browser sends an HTTP/HTTPS request to the load balancer (HAProxy).
4. HAProxy distributes the request to one of two application servers (App-01 or App-02) using the configured algorithm.
5. The selected application server (Nginx + application runtime) serves static files or forwards dynamic requests to the application runtime.
6. For data-driven requests, the application server queries the MySQL primary database.
7. The database responds, and the application server constructs the response.
8. The response travels back through HAProxy to the user’s browser.

## Infrastructure Components
- **Total Servers: 3**
  - **Server 1: Load Balancer** — Runs HAProxy to handle incoming public traffic.
  - **Server 2: Application Server A (App-01)** — Hosts Nginx, application runtime, and codebase.
  - **Server 3: Application Server B (App-02) + Database** — Hosts Nginx, application runtime, codebase, and MySQL primary.
- **Web Server:** Nginx on both application servers to serve static files and act as a reverse proxy to the application runtime.
- **Application Servers:** Two identical servers (App-01, App-02) running the same codebase for redundancy and load balancing.
- **Load Balancer:** HAProxy distributes traffic across application servers.
- **Application Files:** Identical codebase deployed on both application servers.
- **Database:** MySQL primary on Server 3 for all write operations; supports adding replicas for read scaling.

## Purpose of Added Components
- **Second Application Server (App-02):** Ensures redundancy and supports horizontal scaling, allowing continued service if App-01 fails or is overloaded.
- **Load Balancer (HAProxy):** Centralizes traffic entry, distributes load, and enables failover for high availability.
- **Nginx on Application Servers:** Optimizes static file serving and acts as a reverse proxy, improving performance and allowing application restarts without disrupting static content.
- **Dedicated Database Host:** Isolates database I/O from application processes, simplifying scaling, backups, and maintenance.

## Load Balancer Algorithm
- **Algorithm:** Least Connections
- **Mechanism:** HAProxy directs each new connection to the application server with the fewest active connections, balancing load effectively for requests with variable durations.
- **Rationale:** Ideal for applications with inconsistent request processing times, preventing overburdening of busy servers.

## Active-Active vs. Active-Passive Load Balancing
- **Active-Active:**
  - Multiple HAProxy instances simultaneously handle traffic, often behind a virtual IP (VIP) or DNS-based clustering.
  - **Advantages:** Eliminates single-point-of-failure (SPOF) for the load balancer, increases throughput, and supports seamless failover.
- **Active-Passive:**
  - One HAProxy instance handles traffic, with a standby instance ready to take over if the active instance fails.
  - **Advantages:** Simpler configuration, with the passive instance synchronized for quick failover.
- **Chosen Setup:** The diagram shows a single HAProxy for simplicity. For production, an **Active-Active** configuration with two HAProxy instances and a VIP (using keepalived) is recommended to eliminate SPOF.

## MySQL Primary-Replica Cluster
- **Replication:** Asynchronous or semi-synchronous replication from Primary to Replica(s).
- **Primary Node:** Handles all write operations (INSERT/UPDATE/DELETE), logging changes to a binary log for replication.
- **Replica Node(s):** Applies binary log events from the primary to maintain data consistency, used for read scaling and backups.
- **Failover Process:** If the primary fails, a replica can be promoted to primary (manually or via automation), ensuring coordination to prevent split-brain scenarios.
- **Application Interaction:** Writes are sent to the primary; reads can be directed to replicas for load distribution.

## Primary vs. Replica Node for Application
- **Primary Node:**
  - Processes both read and write queries.
  - Maintains the authoritative dataset for writes.
  - Acts as the single source of truth for data changes.
- **Replica Node:**
  - Handles read-only queries and supports backups.
  - May experience slight replication lag.
  - Only accepts writes if promoted to primary.

## Single Points of Failure (SPOF)
- **Primary Database:** A single MySQL primary without replicas or automated failover creates a SPOF, as database failure disrupts write operations and potentially reads.
- **Single HAProxy Instance:** Without clustering, a single load balancer is a SPOF.
- **Single Region Dependency:** Hosting all components in one data center risks service disruption if the region fails.

## Security Concerns
- **Unencrypted Traffic:** Without HTTPS, data between client, HAProxy, and backends is vulnerable to interception. Implement TLS termination at HAProxy or end-to-end TLS.
- **Missing Firewalls:** Exposed services risk unauthorized access. Restrict ports (e.g., 80/443 for HAProxy, 3306 for MySQL internally, SSH to specific IPs).
- **Credential Management:** Database and application secrets must be securely stored (e.g., using environment variables and a vault solution).
- **No DDoS Protection:** Lack of rate-limiting or Web Application Firewall (WAF) leaves the system open to application-layer attacks.

## Monitoring & Observability
- **Current State:** No monitoring implemented.
- **Recommendations:**
  - Deploy monitoring agents (e.g., Prometheus, Datadog) to collect metrics (CPU, memory, disk, network).
  - Implement Application Performance Monitoring (APM) for latency and error tracking (e.g., New Relic).
  - Set up health checks, uptime monitoring, and alerting for rapid issue detection.
  - Create dashboards for real-time visibility into system performance.

## Production-Ready Improvements
- Add MySQL replicas with automated failover or use a managed database service.
- Deploy dual HAProxy instances with a VIP for Active-Active or Active-Passive configurations.
- Enable HTTPS with TLS termination at HAProxy and consider end-to-end encryption.
- Implement firewall rules and security groups to restrict network access.
- Integrate monitoring, logging, and health checks across all components.
- Automate deployments with CI/CD pipelines and use rolling updates to minimize downtime.