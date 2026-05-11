# VMware ESXi Scripts

PowerShell scripts for patching, updating and hardening VMware ESXi 6.7 servers.

## CybSec_ESXi670to670_202210001

Script that automates the update of ESXi 6.7.0 U3 (or older builds) to build **6.7.0-202210001** (October 2022 patch), including a security hardening step for the SLP service.

### What it does

1. **Backup** - Syncs and backs up the ESXi host configuration via SSH
2. **Download backup** - Compresses and copies the backup to your local machine via SCP
3. **Upload patch** - Transfers the update ZIP to the ESXi host
4. **Maintenance mode** - Puts the host in maintenance mode
5. **Update** - Applies the ESXi-6.7.0-20221004001-standard profile

### Requirements

- Windows 10 with PowerShell
- Network access to the ESXi host (SSH enabled)
- The following files in `C:\Temp`:
  - `ESXi670-202210001.zip` (from [VMware](https://www.vmware.com))
  - `plink.exe`, `pscp.exe`, `putty.exe` (from [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html))

### Usage

1. Edit the script and set your ESXi host IP and credentials
2. Place all required files in `C:\Temp`
3. Run from PowerShell:

```powershell
.\CybSec_ESXi670to670_202210001
```

### References

- [ESXi 6.7 Patch Release Notes](https://docs.vmware.com/en/VMware-vSphere/6.7/rn/esxi670-202210001.html)
- [VMware KB 76372 - SLP Service](https://kb.vmware.com/s/article/76372)

## License

Apache-2.0
