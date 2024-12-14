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
PANEL_PATH="$DEST_DIR/Paneles/Paneles.bz2.bz2"

# Crear directorio de destino
if [ ! -d "$DEST_DIR" ]; then
    echo "Creando directorio de configuración en $DEST_DIR"
    mkdir -p "$DEST_DIR"
fi

# Copiar archivos
if [ -d "$SOURCE_DIR" ]; then
    echo "Copiando archivos desde $SOURCE_DIR a $DEST_DIR"
    cp -r "$SOURCE_DIR"/* "$DEST_DIR/"
else
    echo "Error: No se encontró el directorio $SOURCE_DIR."
    exit 1
fi

# Verificar fondo de pantalla
if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Error: El archivo $WALLPAPER_PATH no existe."
    exit 1
fi

# Establecer fondo de pantalla
MONITORS=$(xfconf-query -c xfce4-desktop -l | grep '/backdrop/screen0/monitor.*/last-image')

if [ -z "$MONITORS" ]; then
    echo "Error: No se encontraron monitores configurables."
    exit 1
fi

for MONITOR in $MONITORS; do
    echo "Estableciendo fondo de pantalla en $MONITOR"
    xfconf-query --channel xfce4-desktop --property "$MONITOR" --set "$WALLPAPER_PATH"
done

echo "Fondo de pantalla configurado correctamente."

# Importar el archivo de configuración del panel (sin descomprimirlo)
if [ -f "$PANEL_PATH" ]; then
    echo "Importando panel desde $PANEL_PATH"
    xfce4-panel --load-panel="$PANEL_PATH"
else
    echo "Error: No se encontró el archivo de panel $PANEL_PATH."
    exit 1
fi

echo "Panel importado correctamente."
