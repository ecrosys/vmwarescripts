# PermanentDisableSLP_Service_EN.ps1
#
# Permanently stops and disables the SLP service on a VMware ESXi host.
# The script connects to the host over SSH using PuTTY Plink.

$ESXI_HOST = "your ip address"
$SSH_USERNAME = "root"
$SSH_PASSWORD = "CHANGE_ME"
$PLINK_PATH = "C:\Temp\plink.exe"

$RemoteCommand = "/etc/init.d/slpd stop && chkconfig slpd off"

& $PLINK_PATH -ssh -batch $SSH_USERNAME@$ESXI_HOST -pw $SSH_PASSWORD $RemoteCommand
