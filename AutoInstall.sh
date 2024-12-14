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
WALLPAPER_PATH="$DEST_DIR/Wallpapers/wallpaper1.jpg"
PANEL_PATH="$DEST_DIR/Paneles/Paneles.bz2"

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

# Importar panel
if [ -f "$PANEL_PATH" ]; then
    echo "Importando panel desde $PANEL_PATH"
    
    # Ruta del archivo descomprimido
    PANEL_FILE="${PANEL_PATH%.bz2}"

    # Verificar y descomprimir el archivo
    if [[ "$PANEL_PATH" == *.bz2 ]]; then
        bunzip2 -f "$PANEL_PATH"
        if [ -f "$PANEL_FILE" ]; then
            echo "Archivo descomprimido correctamente: $PANEL_FILE"
        else
            echo "Error: La descompresión falló. Asegúrate de que bunzip2 está instalado."
            exit 1
        fi
    else
        echo "Error: El archivo no tiene la extensión .bz2."
        exit 1
    fi

    # Copiar el archivo descomprimido a la configuración de XFCE
    echo "Copiando el archivo descomprimido a la configuración de XFCE..."
    cp "$PANEL_FILE" "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/"
    
    # Reiniciar el panel para aplicar los cambios
    echo "Reiniciando el panel para aplicar la configuración..."
    xfce4-panel --restart
    
    echo "Panel importado y configurado correctamente."
else
    echo "Error: El archivo $PANEL_PATH no existe."
    exit 1
fi
