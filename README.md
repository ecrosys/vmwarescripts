# VMware ESXi Scripts

PowerShell scripts for patching, updating and hardening VMware ESXi hosts.

## Scripts

### CybSec_ESXi670to670_202210001.ps1

Located at `scripts/CybSec_ESXi670to670_202210001.ps1`.

Automates the update of ESXi 6.7.0 U3 (or older builds) to build **6.7.0-202210001** (October 2022 patch), including security-hardening steps.

The original file `CybSec_ESXi670to670_202210001` is intentionally retained in the repository root.

### PermanentDisableSLP_Service.ps1

Located at `scripts/PermanentDisableSLP_Service.ps1`.

Placeholder for a script intended to permanently disable the SLP service on VMware ESXi hosts as part of a security-hardening process.

## Requirements

- Windows with PowerShell
- Network access to the ESXi host
- SSH enabled on the ESXi host where required
- PuTTY command-line utilities where required by the script

## References

- VMware ESXi 6.7 patch documentation
- VMware guidance related to the SLP service

## License

Apache-2.0
