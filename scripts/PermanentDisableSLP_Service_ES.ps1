# PermanentDisableSLP_Service_ES.ps1
#
# Detiene y deshabilita permanentemente el servicio SLP en un host VMware ESXi.
# El script se conecta al host por SSH utilizando PuTTY Plink.

$ESXI_HOST = "your ip address"
$SSH_USERNAME = "root"
$SSH_PASSWORD = "CHANGE_ME"
$PLINK_PATH = "C:\Temp\plink.exe"

$RemoteCommand = "/etc/init.d/slpd stop && chkconfig slpd off"

& $PLINK_PATH -ssh -batch $SSH_USERNAME@$ESXI_HOST -pw $SSH_PASSWORD $RemoteCommand
