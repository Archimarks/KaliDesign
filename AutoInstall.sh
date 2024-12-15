#!/bin/bash
# AUTOR

echo '
==============================================================================
 █████╗ ██████╗  ██████╗██╗  ██╗██╗███╗   ███╗ █████╗ ██████╗ ██╗  ██╗███████╗
██╔══██╗██╔══██╗██╔════╝██║  ██║██║████╗ ████║██╔══██╗██╔══██╗██║ ██╔╝██╔════╝
███████║██████╔╝██║     ███████║██║██╔████╔██║███████║██████╔╝█████╔╝ ███████╗
██╔══██║██╔══██╗██║     ██╔══██║██║██║╚██╔╝██║██╔══██║██╔══██╗██╔═██╗ ╚════██║
██║  ██║██║  ██║╚██████╗██║  ██║██║██║ ╚═╝ ██║██║  ██║██║  ██║██║  ██╗███████║
╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝                                                                              
==============================================================================
'

# Configuración
SOURCE_DIR="$HOME/KaliDesign/Elementos"
DEST_DIR="$HOME/.config/KaliDesign"
WALLPAPER_PATH="$DEST_DIR/Wallpapers/wallpaper.jpg"
PANEL_PATH="$SOURCE_DIR/Paneles/Panel.tar.bz2"

# Crear directorio de destino
if [ ! -d "$DEST_DIR" ]; then
    echo "Creando directorio de configuración en $DEST_DIR"
    mkdir -p "$DEST_DIR"
fi

# Copiar archivos
if [ -d "$SOURCE_DIR" ]; then
    echo "Copiando archivos desde $SOURCE_DIR a $DEST_DIR"
    cp -r "$SOURCE_DIR"/* "$DEST_DIR/"
    echo "Archivos copiados correctamente."
else
    echo "Error: No se encontró el directorio $SOURCE_DIR."
    exit 1
fi

# Verificar fondo de pantalla
if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Error: El archivo $WALLPAPER_PATH no existe."
    exit 1
fi

# Establecer fondo de pantalla permanentemente
MONITORS=$(xfconf-query -c xfce4-desktop -l | grep '/backdrop/screen0/monitor.*/last-image')

if [ -z "$MONITORS" ]; then
    echo "Error: No se encontraron monitores configurables."
    exit 1
fi

for MONITOR in $MONITORS; do
    echo "Estableciendo fondo de pantalla en $MONITOR"
    xfconf-query --channel xfce4-desktop --property "$MONITOR" --set "$WALLPAPER_PATH" --create --type string
done

echo "Fondo de pantalla configurado correctamente."

# Verificar si el archivo Panel.tra.bz2 existe antes de intentar descomprimir
if [ -f "$PANEL_PATH" ]; then
    echo "Restaurando configuración de los paneles desde $PANEL_PATH   "
    # Descomprimir el archivo en la ubicación correcta
    tar -xjf "$PANEL_PATH" -C "$HOME/.config/xfce4/"
    echo "Configuración de paneles restaurada correctamente."
else
    echo "Error: No se encontró el archivo $PANEL_PATH   "
    exit 1
fi

# Recargar paneles XFCE
echo "Recargando configuración de los paneles XFCE"
xfce4-panel --restart
echo "Paneles XFCE recargados correctamente."

# Asegurarse de que los cambios sean permanentes (crear o modificar archivo de configuración)
# Asegurar que la configuración se guarde permanentemente
echo "Guardando configuración permanentemente..."
# Copiar la configuración de los paneles a la ubicación correcta
cp -r "$HOME/.config/xfce4/panel" "$HOME/.config/KaliDesign/xfce4-panel-backup"

echo "La configuración de los paneles se ha guardado correctamente."
