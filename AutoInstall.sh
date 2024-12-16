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
SOURCE_DIR="$HOME/KaliDesign"
DEST_DIR=".config/KaliDesign"
WALLPAPER_PATH="$DEST_DIR/Elementos/Wallpapers/wallpaper1.jpg"
PANEL_PATH="$SOURCE_DIR/Elementos/Paneles/Panel.tar.bz2"
DEST_DIR_XFCE4="$HOME/.config"

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

    # Copiar el archivo Panel.tar.bz2 al escritorio
    DESKTOP_DIR="$HOME/Desktop" # Directorio del escritorio

    echo "Ruta de PANEL_PATH: $PANEL_PATH" # Diagnóstico de ruta
    if [ -f "$PANEL_PATH" ]; then
        echo "Copiando $PANEL_PATH al escritorio en $DESKTOP_DIR"
        cp "$PANEL_PATH" "$DESKTOP_DIR/"
        echo "Archivo copiado correctamente al escritorio."
    else
        echo "Error: No se encontró el archivo $PANEL_PATH."
        exit 1
    fi

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

cd 

# Dar permiso de ejecución a todos los archivos en $DEST_DIR
echo "Otorgando permisos de ejecución a todos los archivos en $DEST_DIR"
find "$DEST_DIR" -type f -exec chmod +x {} \;

echo "Permisos de ejecución configurados correctamente."


# Eliminar la carpeta original
echo "Eliminando la carpeta original en $HOME/KaliDesign"
rm -rf "$HOME/KaliDesign"
echo "Carpeta original eliminada correctamente."

exit