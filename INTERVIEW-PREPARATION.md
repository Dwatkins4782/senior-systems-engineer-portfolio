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
- [CyberArk Conjur & Secrets Management](#cyberark-conjur--secrets-management)
- [DevSecOps Pipeline Security](#devsecops-pipeline-security)
- [Python Gen AI & SQL Experience](#python-gen-ai--sql-experience)
- [API Platform & Java Middleware Operations](#api-platform--java-middleware-operations)
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

### Terraform Drift Detection & Management

**What is Drift?**
Drift occurs when actual infrastructure state differs from the Terraform state file.

**Common Causes:**
- **Manual Changes**: Portal/CLI modifications (VM resize, tag changes, NSG rules)
- **Auto-Scaling**: AKS autoscaler, VM scale sets changing instance counts
- **External Systems**: Azure Policy adding tags, backup solutions modifying resources
- **Time-Based**: Certificate rotation, secret updates, credential expiration
- **Concurrent Runs**: Multiple pipelines modifying infrastructure simultaneously

**How Terraform Detects Drift:**
```bash
# During terraform plan, Terraform:
1. Reads state file (last known configuration)
2. Queries Azure API (current reality)
3. Compares the two
4. Shows differences as drift

# Example output:
  ~ resource "azurerm_virtual_machine" "main" {
      ~ vm_size = "Standard_D4s_v3" -> "Standard_D2s_v3"
        # Someone manually resized in portal
    }
```

**Detection Commands:**
```bash
# Standard drift detection
terraform plan -detailed-exitcode
# Exit code 0 = no changes
# Exit code 2 = drift detected

# Show only drift (ignore code changes)
terraform plan -refresh-only

# Update state to match reality
terraform apply -refresh-only
```

**Prevention Strategies:**
```hcl
# 1. Ignore expected changes (autoscaling)
resource "azurerm_kubernetes_cluster" "main" {
  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,  # Autoscaler manages
      tags["LastUpdated"]                # Auto-updated tag
    ]
  }
}

# 2. RBAC restrictions
# Remove Owner/Contributor from humans
# Require all changes through Terraform

# 3. Azure Policy enforcement
# Tag all resources with ManagedBy=Terraform
# Detect manually created resources
```

**Automated Drift Detection:**
```yaml
# .github/workflows/drift-detection.yml
name: Nightly Drift Check
on:
  schedule:
    - cron: '0 2 * * *'  # 2 AM daily

jobs:
  detect-drift:
    steps:
      - name: Check for Drift
        run: terraform plan -detailed-exitcode
        continue-on-error: true
      
      - name: Alert on Drift
        if: steps.plan.outputs.exitcode == '2'
        run: |
          # Send Slack/Teams notification
          echo "🚨 Drift detected in production!"
```

**Interview Answer Template:**
> "Terraform detects drift during the refresh phase of `terraform plan` by querying Azure APIs and comparing actual state with the state file. I've implemented automated nightly drift detection that runs `terraform plan -detailed-exitcode` and alerts via Slack when exit code 2 is returned. For resources managed by autoscalers, I use lifecycle `ignore_changes` blocks to prevent false positives. We also enforce RBAC policies requiring all production changes go through Terraform."

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
- Use managed services (Azure Key Vault, AWS Secrets Manager, CyberArk Conjur)
- Rotate secrets regularly (automated via Conjur rotators)
- Audit access to secrets (Conjur access logging)
- Use managed identities when possible (Azure AD + Conjur authn-azure)

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

## CyberArk Conjur & Secrets Management

### Conjur Enterprise Architecture
- **Leader + Standbys**: 3-node cluster for HA with automatic failover
- **Followers**: Deployed in each target environment (AKS clusters, VMSS pools) for local reads
- **Policy-as-Code**: Declarative YAML/HCL policies stored in Git defining host identities, permissions, and secret access
- **Authenticators**: authn-azure (Azure AD), authn-jwt (JWT/OIDC), authn-k8s (Kubernetes SA), authn (API key)

### Secret Lifecycle Management
1. **Creation**: Generated via Conjur API or synced from CyberArk Privilege Cloud safes
2. **Storage**: AES-256 encrypted in PostgreSQL backend; master data key in HSM
3. **Access Control**: Policy-as-code defines which hosts/layers can read/execute/update each secret
4. **Retrieval**: Via Summon CLI (env injection), REST API, CyberArk ADO extension, or K8s sidecar
5. **Rotation**: Automated rotation for SQL Server, Azure AD app registrations, API keys, certificates
6. **Revocation**: Immediate revocation by policy update or forced rotation
7. **Audit**: Every retrieval/rotation/policy change logged with timestamp, identity, IP

### CyberArk Synchronizer & Vault-Conjur Sync
- One-way sync: CyberArk Privilege Cloud (PAM vault) -> Conjur Enterprise
- Secrets from CyberArk safes auto-sync to Conjur variables when rotated
- Conjur-to-Azure Key Vault sync via custom Python automation for Azure-native consumers
- Single source of truth (CyberArk PAM) with distributed retrieval points (Conjur, Key Vault)

### CI/CD Integration Patterns
1. **CyberArk ADO Marketplace Extension**: Task-based secret retrieval in Azure DevOps pipelines
2. **Summon CLI**: Multi-secret injection via secrets.yml provider file - secrets exist only for process lifetime
3. **REST API**: Custom Python/Bash retrieval for complex scenarios
4. **Kubernetes**: External Secrets Operator (ESO) with Conjur provider creating native K8s Secrets

### My Conjur Experience
- **Navy Federal**: Deployed Conjur Enterprise, configured Azure AD/JWT authenticators, Vault-to-AKV sync, full pipeline integration
- **Fineos**: Conjur policy-as-code for K8s secret injection, Privilege Cloud sync for DB credential rotation (.NET/C# teams)
- **Bank of America**: CyberArk Conjur + Privilege Cloud + ESO for PCI-DSS compliant secrets management

---

## DevSecOps Pipeline Security

### Pipeline Security Integration (Shift-Left)
| Stage | Tools | What It Catches |
|-------|-------|-----------------|
| Pre-commit | git-secrets, detect-secrets | Hardcoded credentials, API keys |
| SAST | Checkmarx, SonarQube, Fortify | SQL injection, XSS, insecure code patterns |
| SCA | Black Duck, Snyk, OWASP Dependency-Check | Known CVEs in libraries, license violations |
| Container Scan | Twistlock/Prisma Cloud, Trivy | Base image vulnerabilities, misconfigurations |
| IaC Scan | Checkov, tfsec, OPA | Terraform/Bicep misconfigurations, insecure defaults |
| DAST | OWASP ZAP, Contrast | Runtime vulnerabilities, auth bypass |

### IaC Security Enforcement
- **Checkov/tfsec**: Pre-deployment scanning in CI pipeline
- **OPA Gatekeeper**: Runtime admission control on AKS/OpenShift
  - Enforce resource limits, image registries, labeling standards, security contexts
  - PCI-DSS network segmentation policies (Bank of America)
  - HIPAA-compliant configurations (Fineos)
- **ArgoCD**: GitOps drift detection and self-healing

### Container & Kubernetes Security
- **Image Hardening**: Minimal base images, non-root, read-only rootfs, drop all capabilities, CIS Benchmarks
- **Pod Security**: Restricted pod security standards, seccomp profiles, no privilege escalation
- **Network**: Default-deny NetworkPolicies, service mesh mTLS (Istio), namespace isolation
- **Runtime**: Falco/Prisma Cloud for anomalous behavior detection
- **Registry**: OPA policies restricting to approved container registries only

### IAM & Encryption
- **Azure**: RBAC, Managed Identities, PIM (just-in-time), Conditional Access
- **AWS**: IAM Roles, STS AssumeRole, SCPs, Permission Boundaries
- **Encryption at Rest**: AES-256 storage encryption, TDE for SQL Server, etcd encryption for K8s
- **Encryption in Transit**: TLS 1.2+, mTLS via service mesh, SSL-required DB connections

### Vulnerability Management Workflow
1. Scan detects vulnerability -> Auto-triage (CVSS + exploitability + business context)
2. Jira ticket auto-created with remediation guidance
3. Developer notification via Slack/Teams
4. SLA tracking: Critical=24h, High=7d, Medium=30d, Low=90d
5. Verification scan on next pipeline run
6. Metrics: MTTR, open count, team compliance rates

### Compliance-as-Code
- **PCI-DSS**: OPA policies for CDE segmentation, secret rotation evidence via Conjur, CIS container hardening
- **HIPAA**: Pipeline gates for PHI handling, encryption enforcement, access audit logging
- **SOC 2 / ISO 27001**: OPA policies enforcing encryption, access controls, change management evidence
- Terraform state as infrastructure evidence, Conjur audit logs as credential evidence, OPA decision logs as policy evidence

### Threat Modeling (STRIDE)
| Threat | Mitigation |
|--------|-----------|
| Spoofing | Azure AD MFA, Conjur host identity, mTLS |
| Tampering | Signed images, immutable infra, Git-signed commits |
| Repudiation | Conjur + K8s audit logs, centralized SIEM |
| Info Disclosure | Encryption, secrets management, network segmentation |
| Denial of Service | Rate limiting (Kong), autoscaling, HA/DR |
| Elevation of Privilege | Least-privilege RBAC, pod security contexts |

---

## Python Gen AI & SQL Experience

### Python Gen AI Projects
1. **Pipeline Log Anomaly Detection** (Navy Federal): LLM-powered tool analyzing CI/CD logs, auto-classifying failures, and generating incident summaries with remediation steps
2. **Infrastructure Documentation Generator** (Navy Federal): Parse Terraform modules to auto-generate security-focused docs, threat models, and compliance mappings
3. **Vulnerability Report Summarization**: Gen AI tool producing executive summaries, developer remediation guides, and compliance impact assessments from SAST/DAST/SCA results
4. **Runbook Auto-Generation**: Reads incident history and infra configs to generate operational runbooks
5. **HIPAA Audit Documentation** (Fineos): Auto-generates compliant audit docs from CI/CD telemetry, reducing audit prep time by 70%

### SQL Experience
1. **Credential Rotation Tracking** (Navy Federal): SQL Server queries/stored procedures tracking rotation history, identifying stale credentials, generating compliance reports
2. **Vulnerability Tracking** (Bank of America): Trend analysis, MTTR calculations, team compliance scoring against vuln management database
3. **HIPAA Compliance Reporting** (Fineos): PostgreSQL queries for access auditing - who accessed what, when, from where
4. **Application Health Dashboards**: MySQL/PostgreSQL queries for deployment tracking and configuration management
5. **Conjur Rotation Verification**: SQL queries confirming Conjur-managed credential rotations completed successfully on target databases

---

## API Platform & Java Middleware Operations

### RESTful API Configuration on OpenShift
- **DeploymentConfig**: Java API containers with JVM tuning (`-XX:+UseG1GC`, heap sizing), resource limits, readiness/liveness probes
- **Service & Route**: ClusterIP service with TLS edge-terminated Route; re-encryption for sensitive APIs
- **3Scale Integration**: APIcast gateway fronting APIs with rate limiting, OAuth2/OIDC authentication, developer portal
- **API Design**: Resource-oriented URLs, proper HTTP methods, versioning (`/api/v1/`), standard error formats, pagination

### How I Configure 3Scale API Management
1. **Admin Portal**: Create API Product, define backend URL (OpenShift service), configure application plans with rate limits
2. **APIcast Gateway**: Deploy on OpenShift; configure caching, response code tracking, TLS
3. **Authentication**: OAuth2, API key, or OIDC based on security requirements
4. **Mapping Rules**: URL paths mapped to methods for analytics
5. **Developer Portal**: Published OpenAPI specs, self-service key provisioning, usage dashboards

### How I Monitor API Services (RED Method)
| Metric | What I Watch | Alert Threshold |
|--------|-------------|-----------------|
| Request Rate (RPS) | 3Scale analytics + Prometheus | >50% deviation from baseline |
| Error Rate (4xx/5xx) | Prometheus + access logs | >1% 5xx, >5% 4xx |
| Duration (latency) | Prometheus histograms | p95 >2s, p99 >5s |
| JVM Heap | JMX Exporter | >85% after GC |
| DB Connection Pool | JMX (`ActiveCount`, `AvailableCount`) | Available <10% |
| Pod Restarts | kube-state-metrics | >3 in 15 min |
| 3Scale Rate Limits | 3Scale analytics | Consumers consistently hitting limits |

### JBoss/EAP Operations
- **Configuration**: standalone.xml - datasources (connection pools, validation), JVM options, subsystem tuning
- **Monitoring**: JMX Exporter for heap, threads, GC, datasource pool; access logs for response times
- **Troubleshooting**: Thread dumps (`jstack`), heap dumps (`jmap`), GC log analysis, slow query identification
- **Containerized JBoss**: Red Hat EAP images on OpenShift with `JAVA_OPTS_APPEND` for JVM tuning
- **My experience**: Macy's (JBoss/WebSphere middleware), Disney (WebSphere->Chef migration), Bank of America (JBoss on OpenShift)

### How I Handle API Outages
1. **Detection**: Grafana alerts on error rate/latency; 3Scale analytics showing traffic drops
2. **Quick triage**: `oc get pods`, `oc logs`, `oc get events`, `oc adm top pods`
3. **Identify scope**: Single pod? All pods? Database? External dependency? 3Scale gateway?
4. **Communicate**: Update Jira incident ticket, notify team on Slack/Teams
5. **Fix or rollback**: Apply fix if root cause clear, otherwise rollback to last known good
6. **Post-incident**: Blameless post-mortem in Confluence, update runbooks, create preventive Jira tickets

### How I Roll Back Changes
```bash
# OpenShift DeploymentConfig rollback
oc rollout history dc/payment-api              # View history
oc rollout undo dc/payment-api                 # Rollback to previous
oc rollout undo dc/payment-api --to-revision=5 # Rollback to specific version
oc rollout status dc/payment-api               # Verify

# ArgoCD GitOps rollback
git revert HEAD && git push origin main        # ArgoCD auto-syncs

# Database rollback
mvn flyway:undo                                # Flyway reverse migration
```

### CI/CD: Jenkins vs Tekton
| Aspect | Jenkins | Tekton |
|--------|---------|--------|
| Best for | Complex orchestration, legacy | Cloud-native, OpenShift-native |
| Config | Groovy Jenkinsfile | YAML CRDs |
| My usage | Fineos, Bank of America, Wells Fargo, Keysight, Macy's | Fineos (OpenShift Pipelines) |

**Pipeline stages**: Checkout -> Maven Build/Test -> SAST/SCA Scan -> Build Image -> Deploy Dev -> Integration Tests -> Deploy Staging -> DAST -> Approve -> Deploy Prod

### Maven Build Management
- POM configuration, dependency management, multi-module projects
- `mvn clean package` with Surefire for unit tests, Failsafe for integration tests
- Artifact publishing to JFrog Artifactory / Nexus
- OWASP Dependency Check plugin for SCA scanning in build

### How I Manage Security Issues
- **3Scale**: API key/OAuth2 validation at gateway; rate limiting; IP blocking for malicious actors
- **Pipeline security**: SAST (Checkmarx/SonarQube), SCA (Black Duck), DAST (OWASP ZAP) with security gates
- **Secrets**: CyberArk Conjur for all credentials; never in code, config maps, or pipeline variables
- **Container**: Image scanning (Trivy/Prisma), non-root execution, restricted SCC, approved registries only
- **Compromised credentials**: Revoke immediately in 3Scale/Conjur -> rotate -> audit usage -> investigate root cause

### Jira & Confluence Documentation
- **Jira workflows**: Backlog -> Sprint Planning -> In Progress -> Code Review -> QA -> Done
- **Story estimation**: Fibonacci story points (1, 2, 3, 5, 8, 13)
- **Automation**: Jira transitions triggered by pipeline events (deploy -> Done)
- **Confluence**: API docs, ADRs, runbooks, incident post-mortems, onboarding guides, release notes

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
