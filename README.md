# Bikestats (Backend app)
 
API y backend que guarda y actualiza cada minuto los datos del API publico de API Bik.es (http://api.citybik.es/v2/networks/bikesantiago)

¿Como funciona?
---------

Este API expone un unico endpoint que retorna las estadisticas de utilizacion de toda la red, junto con la de cada estacion

¿Como usar?
-------
Para usarlo es necesario tener [docker-compose](https://docs.docker.com/compose/install/) instalado.

1. Clonar este repositorio
2. Ejecutar el comando `docker-compose up`
3. Espera varios minutos hasta que se recolecte informacion de las diversas estaciones
4. ya puedes probar.

Luego de que ya quede corriendo el servidor se puede acceder a los siguiente endpoints:

#### GET /v1/stations
Retorna la informacion de toda la red de bicicletas y da cada una de las estaciones.

-----------------------------

Aplicación de reclutamiento de Recorrido.cl

Desarrollada por Jorge Fuentes, 2019