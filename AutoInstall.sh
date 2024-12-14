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

# Actualizar el sistema
apt update && apt upgrade -y

# Copiar archivos
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
find ~/KaliDesign/Elementos -type f -exec chmod +x {} \;

if [ $? -eq 0 ]; then
    echo "Permisos de ejecución asignados con éxito."
else
    echo "Hubo un error al asignar permisos de ejecución."
    exit 1
fi


# Verificar y limpiar configuración anterior del panel
if [ -d "~/.config/xfce4/panel/" ]; then
    rm -f ~/.config/xfce4/panel/*
fi

# Extraer el perfil de panel
if [ -f "~/KaliDesign/Elementos/Paneles/Paneles Version 1.tar.bz2" ]; then
    tar -xvjf "~/KaliDesign/Elementos/Paneles/Paneles Version 1.tar.bz2" -C ~/.config/xfce4/panel/
else
    echo "El archivo Paneles Version 1.tar.bz2 no existe. Abortando."
    exit 1
fi

# Reiniciar el panel
if command -v xfce4-panel >/dev/null 2>&1; then
    xfce4-panel --restart
else
    echo "El comando xfce4-panel no está disponible. Asegúrate de estar usando XFCE."
    exit 1
fi

# Establecer el fondo de pantalla
WALLPAPER_PATH="$HOME/KaliDesign/Elementos/Wallpapers/wallpaper1.jpg"

if [ -f "$WALLPAPER_PATH" ]; then
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s "$WALLPAPER_PATH"
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
