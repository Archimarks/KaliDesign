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

# ACTUALIZAMOS EL SISTEMA

apt update 
apt upgrade -y

# COPIAMOS LOS ARCHIVOS
echo "Copiando archivos desde ~/KaliDesign/Elementos a ~/.config/KaliDesign/"

cp -r ~/KaliDesign/Elementos/* ~/.config/KaliDesign/

# VERIFICAMOS SI SE COPIARON LOS ARCHIVOS
if [ $? -eq 0 ]; then
    echo "Archivos copiados con éxito."
else
    echo "Hubo un error al copiar los archivos."
fi

rm ~/.config/xfce4/panel/*
tar -xvjf ~/KaliDesign/Elementos/Paneles/Paneles Version 1.tar.bz2 -C ~/KaliDesign/Elementos/Paneles/
xfce4-panel --restart

