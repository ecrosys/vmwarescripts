# Objetivo: mejorar y reforzar la ciberseguridad de VMware 6.7 mediante la aplicación de parches y el ajuste de servicios específicos como primer paso.

# Actualiza versiones antiguas de servidores de producción con VMware ESXi 6.7.0 U3 o anteriores a la compilación más reciente disponible dentro de la misma rama 6.7.
# Este script aplica específicamente a este escenario: actualizar desde la imagen 6.0.7-201908020001 U3 o anterior hacia 6.0.7-202210001,
# utilizando el parche más reciente disponible para esta versión de VMware, publicado en octubre de 2022, y aplicando además una medida sobre el servicio SLP
# siguiendo una recomendación de VMware publicada en 2023.
# Ref: https://docs.vmware.com/en/VMware-vSphere/6.7/rn/esxi670-202210001.html and https://kb.vmware.com/s/article/76372

# AUTOR: ecrosys 2023-10-17
# Nota: puedes actualizar y personalizar este script según tus necesidades.
# Requisitos: Windows 10, PowerShell y acceso de red al host ESXi.
# Debes tener previamente los siguientes archivos ubicados en c:\temp:
#   ESXi670-202210001.zip (disponible en www.vmware.com)
#   plink.exe (https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
#   pscp.exe (mismo origen)
#   putty.exe (mismo origen)

# Datos del servidor ESXi
$ESXI_HOST = "your ip address"
$SSH_USERNAME = "root"
$SSH_PASSWORD = "CHANGE_ME"

# Ruta de destino del respaldo en el equipo local
$BACKUP_DESTINATION = "C:\Temp"

# Ruta de plink.exe (cliente SSH por línea de comandos de PuTTY)
$PLINK_PATH = "C:\Temp\plink.exe"

# Ruta de pscp.exe (cliente SCP de PuTTY)
$PSCP_PATH = "C:\Temp\pscp.exe"

# Comando SSH para sincronizar la configuración mediante plink
$SSHCommandA = "$PLINK_PATH -ssh -batch $ESXI_HOST -l $SSH_USERNAME -pw $SSH_PASSWORD 'vim-cmd hostsvc/firmware/sync_config'"

# Espera unos segundos para asegurar que la sincronización finalice correctamente
Start-Sleep -Seconds 5

# Ejecuta el comando SSH para sincronizar la configuración
Invoke-Expression -Command $SSHCommandA

# Comando SSH para generar un respaldo mediante plink
$SSHCommandB = "$PLINK_PATH -ssh -batch $ESXI_HOST -l $SSH_USERNAME -pw $SSH_PASSWORD 'vim-cmd hostsvc/firmware/backup_config'"

# Espera unos segundos para asegurar que la operación de respaldo finalice
Start-Sleep -Seconds 10

# Ejecuta el comando SSH para generar el archivo de respaldo
Invoke-Expression -Command $SSHCommandB

# Comando remoto para crear un archivo tar.gz con los archivos de respaldo
$RemoteCommand = "cd /scratch/downloads/ && tar czf $ESXI_HOST.tar.gz ./"

# Ejecuta el comando remoto mediante plink
$PLINKCommand = "$PLINK_PATH -ssh -batch $SSH_USERNAME@$ESXI_HOST -pw $SSH_PASSWORD '$RemoteCommand'"

# Ejecuta el comando remoto para crear el archivo comprimido
Invoke-Expression -Command $PLINKCommand

# Ruta remota del archivo tar.gz comprimido en el servidor ESXi
$REMOTE_TARBALL_PATH = "/scratch/downloads/$ESXI_HOST.tar.gz"

# Comando SCP para copiar el archivo tar.gz desde el servidor ESXi al equipo local
$SCPCommand = "${PSCP_PATH} -l ${SSH_USERNAME} -pw ${SSH_PASSWORD} ${SSH_USERNAME}@${ESXI_HOST}:${REMOTE_TARBALL_PATH} ${BACKUP_DESTINATION}"

# Ejecuta el comando SCP para copiar el archivo de respaldo
Invoke-Expression -Command $SCPCommand

Write-Output "Backup completed successfully and saved to $BACKUP_DESTINATION"

# PROCESO DE ACTUALIZACIÓN
# Ruta local del archivo ZIP utilizado para la actualización
$LOCAL_ZIP_PATH = "C:\Temp\ESXi670-202210001.zip"

# Ruta remota donde se copiará el archivo ZIP en el servidor ESXi
$REMOTE_ZIP_PATH = "/var/tmp/"

# Comando SCP para copiar el ZIP desde el equipo local al servidor ESXi
$SCPCommandB = "${PSCP_PATH} -l ${SSH_USERNAME} -pw ${SSH_PASSWORD} ${LOCAL_ZIP_PATH} ${SSH_USERNAME}@${ESXI_HOST}:'${REMOTE_ZIP_PATH}'"

# Ejecuta el comando SCP para copiar el archivo ZIP
Invoke-Expression -Command $SCPCommandB

# Comando remoto para poner el host ESXi en modo mantenimiento
$RemoteCommandB = "esxcli system maintenanceMode set --enable true"

# Ejecuta el comando remoto mediante plink
$PLINKCommandB = "$PLINK_PATH -ssh -batch $SSH_USERNAME@$ESXI_HOST -pw $SSH_PASSWORD '$RemoteCommandB'"

# Ejecuta el comando remoto
Invoke-Expression -Command $PLINKCommandB

# Espera unos segundos para asegurar que la operación finalice correctamente
Start-Sleep -Seconds 10

# Comando remoto para actualizar ESXi al perfil de imagen 20221004001-standard
$RemoteCommandC = "esxcli software profile update -p ESXi-6.7.0-20221004001-standard -d /var/tmp/ESXi670-202210001.zip"

# Ejecuta el comando remoto mediante plink
$PLINKCommandC = "$PLINK_PATH -ssh $SSH_USERNAME@$ESXI_HOST -pw $SSH_PASSWORD '$RemoteCommandC'"

# Ejecuta el comando remoto de actualización
Invoke-Expression -Command $PLINKCommandC
