# Front de Geocluster para Metabuilding

## Configuración del proyecto

Este proyecto Front hace uso de la librería **Onesait GIS**. Para montar el proyecto:

1. Descargar el proyecto Onesait GIS desde el GitLab de Onesait en una carpeta.
2. Descargar el proyecto Geocluster desde aquí en otra carpeta al mismo nivel que la carpeta del proyecto GIS.
3. Cambiarse a la rama de «develop» del proyecto Geocluster y a la rama interesada en el proyecto Onesait GIS.
4. Generar un enlace desde el proyecto Onesait GIS:
```
yarn link
```
5. Enlazar la librería GIS desde el proyecto de Front Vue:
```
yarn link os-map-library
```
6. Ejecutar watch desde el proyecto Onesait GIS para poder editar y ver los cambios directamente:
```
yarn watch
```
7. Ejecutar el proyecto Front Vue:
```
yarn serve
```
