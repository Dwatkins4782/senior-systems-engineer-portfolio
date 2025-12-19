# Senior Systems Engineer Interview Preparation

**Portfolio Reference**: This guide complements the [Senior Systems Engineer Portfolio](README.md) which demonstrates enterprise infrastructure, multi-project onboarding, and operational excellence.

## Table of Contents
- [Portfolio Walkthrough](#portfolio-walkthrough)
- [Technical Knowledge Areas](#technical-knowledge-areas)
- [System Design & Architecture](#system-design--architecture)
- [Cloud & Infrastructure](#cloud--infrastructure)
- [Kubernetes & Container Orchestration](#kubernetes--container-orchestration)
- [Infrastructure as Code](#infrastructure-as-code)
- [Security & Compliance](#security--compliance)
- [Incident Response & Troubleshooting](#incident-response--troubleshooting)
- [CI/CD & DevOps](#cicd--devops)
- [Behavioral Questions](#behavioral-questions)
- [Leadership & Communication](#leadership--communication)
- [Common Interview Questions](#common-interview-questions)

---

## Portfolio Walkthrough

### How to Present This Portfolio in Interviews

**Opening Statement**: 
"I've built an enterprise-grade infrastructure portfolio that demonstrates both single-project infrastructure and multi-tenant onboarding at scale. It includes hub-and-spoke networking, landing zones, governance, and a complete 5-day enterprise onboarding process."

### Key Projects to Highlight

#### 1. **Enterprise Multi-Project Onboarding** 
**Location**: `enterprise/` directory  
**Talking Points**:
- "Designed hub-and-spoke architecture with centralized Azure Firewall, VPN Gateway, and Bastion"
- "Created 9-phase onboarding process covering identity, networking, security, cost management, and CI/CD"
- "Implemented landing zone pattern with foundation hub providing shared services to project spokes"
- "Developed enterprise naming standards with automated validation and Azure Policy enforcement"

**Technical Depth**:
- Hub VNet peering to all project spoke networks
- Centralized private DNS zones for Azure services
- Route tables forcing traffic through hub firewall
- RBAC hierarchy: Owners, Contributors, Readers per project/environment

#### 2. **Production Infrastructure** 
**Location**: `terraform/` directory  
**Talking Points**:
- "Fully validated Terraform configuration with modular architecture (networking, AKS)"
- "Implemented Azure AD RBAC, private endpoints, and Key Vault secrets provider for AKS"
- "Multi-stage CI/CD with Checkov/tfsec security scanning and manual approval gates for prod"

#### 3. **Security Hardening** 
**Location**: `ansible/playbooks/linux-hardening.yml`  
**Talking Points**:
- "360-line Ansible playbook implementing CIS benchmarks for Linux"
- "Covers filesystem hardening, SSH configuration, firewall rules, audit logging, user account security"
- "Automated compliance validation in CI/CD pipeline"

#### 4. **Operational Automation** 
**Location**: `scripts/powershell/Rotate-Secrets.ps1`  
**Talking Points**:
- "441-line PowerShell script for automated Azure Key Vault secret rotation"
- "Scheduled via GitHub Actions every 90 days with notification integration"
- "Maintains version history and audit trail"

### Demonstrating Enterprise Concepts

When asked about **enterprise infrastructure**, reference:
- [Enterprise Onboarding Guide](docs/ENTERPRISE-ONBOARDING.md) - Shows you understand multi-team operations
- [Naming Standards](enterprise/governance/NAMING-STANDARDS.md) - Demonstrates governance maturity
- Hub-and-spoke architecture - Shows network design at scale

When asked about **onboarding new teams**, walk through:
- Phase 1: Project registration, AAD groups, RBAC
- Phase 2: Network provisioning, VNet peering
- Phase 3: Security baseline, Key Vault
- Phase 4: Monitoring, budgets, alerts
- Phase 5: CI/CD setup, documentation handoff

---

## Technical Knowledge Areas

### Core Competencies to Review
- Linux/Windows system administration
- Networking (TCP/IP, DNS, Load Balancing, VPN)
- Monitoring and observability (Prometheus, Grafana, ELK Stack)
- Database administration (SQL, NoSQL)
- Scripting and automation (PowerShell, Bash, Python)
- Version control (Git)
- Performance tuning and optimization

### Key Metrics to Know
- **SLA/SLO/SLI**: Service Level Agreement vs Objective vs Indicator
- **MTTR**: Mean Time To Recovery
- **MTBF**: Mean Time Between Failures
- **RTO/RPO**: Recovery Time Objective / Recovery Point Objective
- **Availability calculations**: 99.9% vs 99.99% vs 99.999%

---

## System Design & Architecture

### High-Availability Design Patterns
1. **Active-Active**: Multiple instances serving traffic simultaneously
2. **Active-Passive**: Primary instance with standby failover
3. **Multi-Region**: Geographic distribution for disaster recovery
4. **Load Balancing**: Distribute traffic across multiple servers
5. **Circuit Breaker**: Prevent cascade failures

### Scalability Concepts
- **Horizontal Scaling**: Add more machines (scale out)
- **Vertical Scaling**: Add more resources to existing machines (scale up)
- **Auto-scaling**: Dynamic resource adjustment based on demand
- **Stateless vs Stateful**: Design implications
- **Caching strategies**: CDN, Redis, in-memory caching

### Microservices Architecture
- Service discovery and registration
- API gateway patterns
- Event-driven architecture
- Message queues (RabbitMQ, Kafka, Azure Service Bus)
- Database per service pattern
- Saga pattern for distributed transactions

### Sample Question
**"Design a highly available web application that can handle 10 million requests per day"**

*Key points to address:*
- Load balancer with health checks
- Auto-scaling web tier (minimum 2 AZs)
- Database replication (read replicas)
- Caching layer (Redis/Memcached)
- CDN for static content
- Monitoring and alerting
- Backup and disaster recovery

---

## Cloud & Infrastructure

### Azure Core Services
- **Compute**: Virtual Machines, AKS, App Service, Functions
- **Networking**: VNet, NSG, Application Gateway, Traffic Manager
- **Storage**: Blob Storage, File Storage, Disk Storage
- **Database**: SQL Database, Cosmos DB, PostgreSQL
- **Identity**: Azure AD, RBAC, Managed Identities
- **Monitoring**: Azure Monitor, Application Insights, Log Analytics

### Azure Networking Deep Dive
- VNet peering vs VPN Gateway
- Network Security Groups vs Application Security Groups
- Azure Firewall vs NSG
- Private Endpoints and Service Endpoints
- ExpressRoute for hybrid connectivity

### Cost Optimization Strategies
- Reserved Instances vs Spot Instances
- Right-sizing resources
- Auto-shutdown for non-production environments
- Storage lifecycle management
- Monitoring and tagging for cost allocation

### Multi-Cloud Considerations
- Why organizations use multi-cloud
- Challenges (complexity, skill gaps, cost)
- Common patterns (disaster recovery, vendor lock-in avoidance)

---

## Kubernetes & Container Orchestration

### Core Concepts
- **Pods**: Smallest deployable unit
- **Deployments**: Declarative updates for Pods
- **Services**: Expose Pods to network traffic
  - ClusterIP, NodePort, LoadBalancer
- **ConfigMaps & Secrets**: Configuration management
- **Namespaces**: Logical cluster partitioning
- **Ingress**: HTTP/HTTPS routing
- **Persistent Volumes**: Stateful storage

### Advanced Topics
- StatefulSets for stateful applications
- DaemonSets for node-level services
- Jobs and CronJobs
- Horizontal Pod Autoscaler (HPA)
- Vertical Pod Autoscaler (VPA)
- Custom Resource Definitions (CRDs)
- Operators pattern

### Security Best Practices
- RBAC (Role-Based Access Control)
- Pod Security Policies/Standards
- Network Policies
- Secrets management (Azure Key Vault, HashiCorp Vault)
- Image scanning and vulnerability management
- Service mesh (Istio, Linkerd)

### AKS-Specific Knowledge
- Node pools and scaling
- Azure AD integration
- Azure CNI vs kubenet networking
- Managed identity integration
- Azure Policy for AKS
- Upgrade strategies (node image, Kubernetes version)

### Common Troubleshooting Scenarios
```bash
# Pod not starting
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl get events --sort-by='.lastTimestamp'

# Service not accessible
kubectl get svc
kubectl get endpoints
kubectl describe svc <service-name>

# Resource constraints
kubectl top nodes
kubectl top pods
kubectl describe node <node-name>
```

---

## Infrastructure as Code

### Terraform Best Practices
- **State Management**: Remote state with locking (Azure Storage)
- **Modules**: Reusable, versioned components
- **Workspaces**: Environment separation
- **Variables & Outputs**: Parameterization
- **Data Sources**: Reference existing resources
- **Depends_on**: Explicit dependencies
- **Lifecycle rules**: Prevent destruction, ignore changes

### Code Organization
```
terraform/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── modules/
│   ├── networking/
│   ├── compute/
│   └── database/
└── global/
```

### Terraform Workflow
1. `terraform init` - Initialize backend and providers
2. `terraform plan` - Preview changes
3. `terraform apply` - Apply changes
4. `terraform destroy` - Remove infrastructure

### Ansible Best Practices
- **Idempotency**: Safe to run multiple times
- **Inventory Management**: Dynamic vs static
- **Roles**: Reusable playbook components
- **Variables**: Group_vars, host_vars, defaults
- **Vault**: Encrypt sensitive data
- **Handlers**: Trigger actions on change
- **Tags**: Selective execution

### Sample Question
**"How do you manage infrastructure across multiple environments with Terraform?"**

*Key points:*
- Separate state files per environment
- Use Terraform workspaces or separate directories
- Shared modules for consistency
- Environment-specific variable files
- CI/CD integration for automated deployments
- State locking and backup strategies

---

## Security & Compliance

### Security Layers (Defense in Depth)
1. **Physical Security**: Data center security
2. **Network Security**: Firewalls, NSGs, segmentation
3. **Identity & Access**: MFA, RBAC, least privilege
4. **Application Security**: Input validation, OWASP Top 10
5. **Data Security**: Encryption at rest and in transit
6. **Monitoring & Response**: SIEM, threat detection

### Zero Trust Architecture
- Never trust, always verify
- Assume breach mindset
- Verify explicitly (authentication & authorization)
- Use least privilege access
- Segment access
- Monitor and log everything

### Compliance Frameworks
- **SOC 2**: Security, Availability, Confidentiality
- **ISO 27001**: Information security management
- **HIPAA**: Healthcare data protection
- **PCI DSS**: Payment card industry standards
- **GDPR**: EU data protection

### Secrets Management
- Never commit secrets to source control
- Use managed services (Azure Key Vault, AWS Secrets Manager)
- Rotate secrets regularly
- Audit access to secrets
- Use managed identities when possible

### Security Hardening (Linux)
```bash
# Common hardening tasks
- Disable root SSH login
- Use SSH keys instead of passwords
- Configure firewall (iptables/firewalld)
- Keep systems patched
- Disable unnecessary services
- Implement audit logging (auditd)
- Use SELinux/AppArmor
- Regular security scanning
```

---

## Incident Response & Troubleshooting

### Incident Response Process
1. **Detection**: Monitoring alerts, user reports
2. **Triage**: Assess severity and impact
3. **Investigation**: Root cause analysis
4. **Containment**: Limit damage
5. **Resolution**: Fix the issue
6. **Recovery**: Restore normal operations
7. **Post-Mortem**: Document and improve

### Troubleshooting Methodology
1. **Define the problem**: What is broken? What should it do?
2. **Gather information**: Logs, metrics, recent changes
3. **Form hypothesis**: What could cause this?
4. **Test hypothesis**: Systematically eliminate possibilities
5. **Resolve**: Apply fix
6. **Verify**: Confirm resolution
7. **Document**: Share knowledge

### Key Diagnostic Commands

#### Linux Troubleshooting
```bash
# System resources
top / htop
free -m
df -h
iostat
vmstat

# Network
netstat -tulpn
ss -tulpn
tcpdump
traceroute
dig / nslookup

# Processes
ps aux
lsof
strace

# Logs
journalctl -u <service>
tail -f /var/log/syslog
grep -r "error" /var/log/
```

#### Windows Troubleshooting
```powershell
# System resources
Get-Process
Get-Service
Get-EventLog
Get-Counter

# Network
Test-NetConnection
Get-NetTCPConnection
Resolve-DnsName
Test-Connection

# Performance
Get-WmiObject Win32_Processor
Get-WmiObject Win32_LogicalDisk
```

### Post-Mortem Template
- **Date & Time**: When did it occur?
- **Duration**: How long was the outage?
- **Impact**: Who/what was affected?
- **Root Cause**: What caused the incident?
- **Timeline**: Chronological sequence of events
- **Resolution**: How was it fixed?
- **Action Items**: Prevent recurrence
- **Lessons Learned**: What did we learn?

---

## CI/CD & DevOps

### CI/CD Pipeline Stages
1. **Source**: Code commit triggers pipeline
2. **Build**: Compile, unit tests
3. **Test**: Integration tests, security scans
4. **Package**: Create artifacts (Docker images)
5. **Deploy**: Push to environment
6. **Validate**: Smoke tests, health checks
7. **Monitor**: Track performance and errors

### GitOps Principles
- Git as single source of truth
- Declarative infrastructure and applications
- Automated synchronization
- Pull-based deployment (ArgoCD, Flux)

### Deployment Strategies
- **Blue-Green**: Two identical environments, instant rollback
- **Canary**: Gradual rollout to subset of users
- **Rolling**: Sequential update of instances
- **Feature Flags**: Toggle features without deployment

### Azure DevOps / GitHub Actions
- YAML pipeline definitions
- Secrets management
- Environment approvals
- Matrix builds for multiple platforms
- Artifact management
- Branch protection policies

### Pipeline Best Practices
- Fail fast (quick feedback)
- Keep builds fast (<10 minutes)
- Separate build and deploy stages
- Use caching for dependencies
- Immutable artifacts
- Automated rollback capability
- Security scanning in pipeline

---

## Behavioral Questions

### STAR Method
- **Situation**: Set the context
- **Task**: Explain your responsibility
- **Action**: Describe what you did
- **Result**: Share the outcome (quantify if possible)

### Common Behavioral Questions

**1. Tell me about a time you resolved a critical production incident.**
- Focus on your troubleshooting methodology
- Highlight communication with stakeholders
- Mention post-mortem and preventive measures

**2. Describe a situation where you had to work with a difficult team member.**
- Emphasize empathy and professional communication
- Show how you found common ground
- Outcome: successful collaboration

**3. Tell me about a time you made a mistake. How did you handle it?**
- Own the mistake
- Explain corrective actions
- Share what you learned
- Implemented safeguards to prevent recurrence

**4. Describe a complex technical problem you solved.**
- Break down the complexity
- Explain your approach
- Highlight innovative solution
- Quantify the impact

**5. How do you prioritize when you have multiple urgent requests?**
- Assess impact and urgency (Eisenhower Matrix)
- Communicate with stakeholders
- Delegate when appropriate
- Follow-up to ensure resolution

**6. Tell me about a time you disagreed with your manager.**
- Present data to support your position
- Listen to their perspective
- Find compromise or accept decision
- Maintain professional relationship

**7. Describe a project where you improved efficiency.**
- Baseline metrics (before state)
- Your solution/automation
- Results (time saved, cost reduced, errors eliminated)
- Adoption by team

**8. How do you stay current with technology?**
- Continuous learning (courses, certifications)
- Hands-on experimentation (home lab, side projects)
- Community engagement (conferences, meetups, blogs)
- Internal knowledge sharing

---

## Leadership & Communication

### Technical Leadership
- **Mentoring**: Help junior engineers grow
- **Documentation**: Create runbooks and guides
- **Knowledge Sharing**: Tech talks, brown bags
- **Standard Setting**: Establish best practices
- **Influence Without Authority**: Convince through expertise

### Stakeholder Communication
- **Executives**: Business impact, ROI, risk mitigation
- **Product Managers**: Feasibility, timelines, trade-offs
- **Developers**: Technical details, APIs, constraints
- **Operations**: Runbooks, monitoring, on-call procedures

### Managing Up
- Proactive communication about progress
- Bring solutions, not just problems
- Understand business priorities
- Request resources effectively
- Share credit, take responsibility

### Cross-Functional Collaboration
- Participate in planning meetings
- Understand customer requirements
- Balance technical debt vs features
- Bridge communication between teams

---

## Common Interview Questions

### Technical Questions

**Q: How would you design a monitoring solution for a microservices application?**

A: 
- **Metrics**: Prometheus for time-series data, Grafana for visualization
- **Logs**: Centralized logging (ELK/EFK stack or Azure Log Analytics)
- **Traces**: Distributed tracing (Jaeger, Zipkin, Application Insights)
- **Alerts**: Based on SLOs (error rate, latency, saturation)
- **Dashboards**: Service-level and system-level views
- **On-call**: Integration with PagerDuty/Opsgenie

**Q: Explain the difference between horizontal and vertical scaling.**

A:
- **Vertical**: Add CPU/RAM to existing server (limited by hardware, downtime)
- **Horizontal**: Add more servers (better for cloud, requires load balancer, stateless design)
- **When to use**: Horizontal for web/API tiers, vertical for databases (until sharding)

**Q: How do you secure Kubernetes clusters?**

A:
- Network policies for pod-to-pod traffic
- RBAC for access control
- Secrets in external vault (Azure Key Vault)
- Image scanning in CI/CD
- Pod security standards (privileged, baseline, restricted)
- Regular updates and patching
- Audit logging enabled
- Private cluster endpoints

**Q: What's your approach to disaster recovery?**

A:
- Define RTO and RPO requirements
- Regular backups (automated, tested)
- Multi-region deployment for critical services
- Document runbooks for restoration
- Conduct DR drills quarterly
- Immutable infrastructure (redeploy rather than repair)
- Monitoring and alerting for backup failures

**Q: How do you handle database migrations with zero downtime?**

A:
- Blue-green deployment pattern
- Backward-compatible schema changes
- Multi-phase deployment:
  1. Add new columns (nullable)
  2. Write to both old and new
  3. Migrate data
  4. Switch reads to new columns
  5. Remove old columns
- Database replication for rollback capability

**Q: Explain your experience with Infrastructure as Code.**

A:
- Terraform for cloud resources (Azure, AWS)
- State management in remote backend
- Modules for reusability
- CI/CD integration for automated deployments
- Version control for all infrastructure
- Peer review process for changes
- Ansible for configuration management
- Benefits: consistency, repeatability, version control, disaster recovery

**Q: How do you troubleshoot high CPU usage on a Linux server?**

A:
```bash
# Identify process consuming CPU
top
ps aux --sort=-%cpu | head

# Check for specific process
pidstat 1

# Investigate the process
strace -p <PID>
lsof -p <PID>

# Check for runaway scripts
pgrep -a bash/python

# Review system logs
journalctl -xe

# Long-term solution: resource limits, monitoring, auto-scaling
```

**Q: What's your experience with containerization?**

A:
- Docker for container packaging
- Multi-stage builds for smaller images
- Security scanning (Trivy, Snyk)
- Kubernetes for orchestration
- Helm for package management
- Private registries (ACR, Harbor)
- Best practices: non-root users, minimal base images, .dockerignore

### Scenario-Based Questions

**Scenario 1: Production database is running slow**

*Approach:*
1. Check current queries (slow query log)
2. Review resource utilization (CPU, memory, disk I/O)
3. Analyze execution plans for slow queries
4. Check for missing indexes
5. Review recent changes (deployments, schema changes)
6. Consider read replicas if read-heavy
7. Implement query optimization or caching

**Scenario 2: Application suddenly returns 500 errors**

*Approach:*
1. Check application logs for error messages
2. Verify all dependent services are healthy
3. Check resource limits (memory, connections)
4. Review recent deployments (consider rollback)
5. Scale horizontally if traffic spike
6. Check configuration changes
7. Implement circuit breaker for failing dependencies

**Scenario 3: Need to migrate legacy application to cloud**

*Approach:*
1. Assessment: Dependencies, compatibility, data
2. Strategy: Rehost, Refactor, or Rebuild
3. Pilot: Migrate non-critical component first
4. Testing: Functional, performance, security
5. Migration: Phased approach with rollback plan
6. Validation: Monitor and verify
7. Optimize: Cost, performance, security post-migration

---

## Interview Day Tips

### Before the Interview
- [ ] Research the company and recent news
- [ ] Review the job description thoroughly
- [ ] Prepare questions for the interviewer
- [ ] Test your equipment (camera, microphone)
- [ ] Have a clean, professional background
- [ ] Keep resume and notes handy

### During the Interview
- **Technical Questions**: Think out loud, explain your reasoning
- **Whiteboarding**: Start with clarifying questions, discuss trade-offs
- **Behavioral Questions**: Use STAR method, be concise
- **Ask Questions**: Show genuine interest in role, team, challenges
- **Be Honest**: Say "I don't know" if you don't, explain how you'd find out

### Questions to Ask Interviewers

**About the Role:**
- What does success look like in this role in the first 90 days?
- What are the biggest technical challenges the team is facing?
- How does this role contribute to the organization's goals?

**About the Team:**
- How is the team structured?
- What's the on-call rotation like?
- How does the team handle knowledge sharing?
- What's the approach to professional development?

**About Technology:**
- What's the current tech stack?
- How do you balance technical debt vs new features?
- What's the deployment frequency?
- How do you measure success for infrastructure/operations?

**About Culture:**
- How would you describe the company culture?
- What do you enjoy most about working here?
- How does the company support work-life balance?

### Red Flags to Watch For
- Unclear expectations or responsibilities
- Lack of investment in tooling/automation
- Excessive on-call burden without compensation
- No clear career progression path
- Poor communication or disorganized interview process

---

## Key Points to Remember

### Your Value Proposition
- **Problem Solver**: Focus on business impact of technical solutions
- **Automation Advocate**: Reduce toil, increase reliability
- **Team Player**: Collaboration across functions
- **Continuous Learner**: Stay current with evolving technology
- **Operational Excellence**: Balance innovation with stability

### Elevator Pitch Template
"I'm a Senior Systems Engineer with [X years] of experience designing and operating cloud infrastructure at scale. I specialize in [key technologies], and I'm passionate about [automation/reliability/security]. In my current role, I [major achievement with quantified impact]. I'm excited about this opportunity because [specific reason related to company/role]."

### Final Preparation Checklist
- [ ] Review this document thoroughly
- [ ] Practice explaining complex systems simply
- [ ] Prepare 3-5 stories using STAR method
- [ ] Review recent projects and quantify impact
- [ ] Be ready to discuss failures and lessons learned
- [ ] Practice whiteboarding system designs
- [ ] Get good sleep the night before
- [ ] Be yourself and be confident

---

## Resources for Continued Learning

### Books
- "Site Reliability Engineering" - Google
- "The Phoenix Project" - Gene Kim
- "Designing Data-Intensive Applications" - Martin Kleppmann
- "Kubernetes Up & Running" - Kelsey Hightower

### Online Platforms
- Microsoft Learn (Azure certifications)
- Linux Academy / A Cloud Guru
- Pluralsight
- KodeKloud (Kubernetes)

### Practice
- Home lab with Kubernetes
- Contribute to open source
- Build side projects
- Write blog posts about learnings

---

**Good luck with your interview! Remember: You've got this! 🚀**
