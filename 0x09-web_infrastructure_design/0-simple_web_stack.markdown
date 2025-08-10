# Simple Web Stack

## Whiteboard Diagram
https://docs.google.com/document/d/1NfeyOKXKw8kAd_w4rhiZXxWbMOyYMl6nHXC4erJ6nOY/edit?usp=sharing

## User Journey
1. A user enters `www.foobar.com` in their browser.
2. DNS resolves `www.foobar.com` to the server’s public IP (e.g., 8.8.8.8) via an A record.
3. The browser sends an HTTP/HTTPS request to the server.
4. The server’s web server (Nginx) handles the request, serving static files (e.g., HTML, CSS, JS) directly.
5. For dynamic content, Nginx forwards the request to the application server.
6. The application server processes the request using the codebase’s business logic.
7. If data is needed, the application server queries the MySQL database.
8. The database returns data, and the response flows back through the application server, Nginx, and to the user’s browser.

## Infrastructure Components
- **Server:** A single physical or virtual machine hosting all services.
- **Domain Name:** `foobar.com` with a `www` subdomain, mapped to the server’s IP (8.8.8.8).
- **DNS Record:** A record resolving `www.foobar.com` to the server’s IPv4 address.
- **Web Server:** Nginx, handling HTTP/HTTPS requests and serving static content.
- **Application Server:** Executes the application codebase for business logic.
- **Application Files:** The website’s codebase, deployed on the server.
- **Database:** MySQL, storing structured application data.
- **Communication:** HTTP/HTTPS over TCP/IP between client and server.

## Issues with Infrastructure
- **Single Point of Failure (SPOF):** The single server is a critical failure point; if it goes down, the entire website becomes unavailable.
- **Maintenance Downtime:** Restarting Nginx or deploying updates interrupts service.
- **Limited Scalability:** A single server cannot handle traffic spikes, leading to performance degradation under high load.