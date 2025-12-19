# Enterprise Foundation - Hub Network

Centralized hub network providing shared services to all project spokes.

## Architecture

```
Hub VNet (10.0.0.0/16)
├── GatewaySubnet (10.0.0.0/26)        # VPN/ExpressRoute Gateway
├── AzureFirewallSubnet (10.0.1.0/26)  # Azure Firewall
├── AzureBastionSubnet (10.0.2.0/26)   # Azure Bastion
├── SharedServicesSubnet (10.0.10.0/24) # DNS, AD, monitoring
└── ManagementSubnet (10.0.11.0/24)    # Jump boxes, tools
```

## Resources

### Network Security
- Azure Firewall (outbound filtering)
- DDoS Protection Standard
- Network Security Groups
- Application Security Groups

### Connectivity
- VPN Gateway (S2S, P2S)
- ExpressRoute Gateway (optional)
- VNet Peering to all spokes

### Management
- Azure Bastion (secure RDP/SSH)
- Private DNS Zones
- Network Watcher

## Deployment

```bash
cd enterprise/foundation/networking
terraform init
terraform plan -var-file=production.tfvars
terraform apply
```

## Hub Services

All spoke networks peer to hub and inherit:
- Centralized internet egress via Azure Firewall
- On-premises connectivity via VPN/ExpressRoute
- Private DNS resolution
- Secure management via Bastion
- Centralized network monitoring
