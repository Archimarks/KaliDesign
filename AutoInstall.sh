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
# Crear directorio de configuración si no existe
mkdir -p ~/.config/KaliDesign

echo "Copiando archivos desde ~/KaliDesign/Elementos a ~/.config/KaliDesign/"

# Copiar archivos
cp -r ~/KaliDesign/Elementos/* ~/.config/KaliDesign/

# Establecer fondo de pantalla usando xfconf-query
WALLPAPER_PATH="$HOME/.config/KaliDesign/Wallpapers/wallpaper1.jpg"

if [ -f "$WALLPAPER_PATH" ]; then
    echo "Estableciendo fondo de pantalla: $WALLPAPER_PATH"
    xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/workspace0/last-image --set "$WALLPAPER_PATH"
else
    echo "Error: El archivo $WALLPAPER_PATH no existe."
    exit 1
fi

echo "Fondo de pantalla configurado correctamente."
