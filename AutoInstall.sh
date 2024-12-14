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
# Copiar archivos
mkdir -p ~/.config/KaliDesign

echo "Copiando archivos desde ~/KaliDesign/Elementos a ~/.config/KaliDesign/"

cp -r ~/KaliDesign/Elementos/* ~/.config/KaliDesign/

if [ $? -eq 0 ]; then
    echo "Archivos copiados con éxito."
else
    echo "Hubo un error al copiar los archivos."
    exit 1
fi

# Dar permisos de ejecución a todos los elementos en ~/.config/KaliDesign/
echo "Otorgando permisos de ejecución a todos los elementos en ~/.config/KaliDesign/"

find ~/.config/KaliDesign/ -type f -exec chmod +x {} \;

if [ $? -eq 0 ]; then
    echo "Permisos de ejecución asignados con éxito."
else
    echo "Hubo un error al asignar permisos de ejecución."
    exit 1
fi

# Configurar el fondo de pantalla
WALLPAPER_PATH=".config/KaliDesign/Wallpapers/wallpaper1.jpg"

if [ -f "$WALLPAPER_PATH" ]; then
    echo "Configurando fondo de pantalla..."

    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$WALLPAPER_PATH"

    if [ $? -eq 0 ]; then
        echo "Fondo de pantalla configurado exitosamente."
    else
        echo "Error al configurar el fondo de pantalla."
        exit 1
    fi
else
    echo "El archivo $WALLPAPER_PATH no existe. Abortando."
    exit 1
fi

# Importar configuración de paneles
PANEL_CONFIG=".config/KaliDesign/Paneles/Paneles.bz2"
XFCE_PANEL_PATH=".config/xfce4/panel/"

if [ -f "$PANEL_CONFIG" ]; then
    echo "Extrayendo configuración de paneles desde $PANEL_CONFIG..."
    mkdir -p "$XFCE_PANEL_PATH"
    tar -xvjf "$PANEL_CONFIG" -C "$XFCE_PANEL_PATH"

    if [ $? -eq 0 ]; then
        echo "Configuración de paneles extraída con éxito."
    else
        echo "Error al extraer la configuración de paneles."
        exit 1
    fi

    echo "Reiniciando panel de XFCE..."
    if command -v xfce4-panel >/dev/null 2>&1; then
        xfce4-panel --restart
        echo "Panel de XFCE reiniciado correctamente."
    else
        echo "El comando xfce4-panel no está disponible. Asegúrate de estar usando XFCE."
        exit 1
    fi
else
    echo "El archivo $PANEL_CONFIG no existe. Abortando."
    exit 1
fi

# Asegurarse de que los cambios sean permanentes (autoinicio)
echo "Creando archivo de autoinicio para garantizar la persistencia de la configuración..."

AUTOSTART_DIR=".config/autostart"
mkdir -p "$AUTOSTART_DIR"

cat <<EOF > "$AUTOSTART_DIR/set-config.desktop"
[Desktop Entry]
Type=Application
Exec=/bin/bash -c "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s '$WALLPAPER_PATH' && xfce4-panel --restart"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Set XFCE Config
EOF

if [ $? -eq 0 ]; then
    echo "Archivo de autoinicio creado exitosamente."
else
    echo "Hubo un error al crear el archivo de autoinicio."
    exit 1
fi

echo "Configuración completada. Los cambios deberían ser permanentes después de reiniciar."
