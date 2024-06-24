# Proyecto Hexagonal Demo con Spring Boot

Este proyecto es una demostración de una aplicación utilizando arquitectura hexagonal implementada con Spring Boot. A continuación se detallan los componentes principales y cómo puedes ejecutar y probar la aplicación.

## Arquitectura Generada

La estructura del proyecto ha sido generada utilizando el script `crear_estructura_hexagonal.sh` pasandole como parámetro un archivo json con un mapeo básico del modelo principal.

```
./crear_estructura_hexagona.sh datos_entidad.json
```

Dicho script configura los siguientes directorios y archivos:

- **Entidades**: Modelos de dominio en `src/main/java/com/pablo/hexagonal_demo/domain/model/`
- **Repositorios**: Interfaces de repositorio en `src/main/java/com/pablo/hexagonal_demo/domain/repository/`
- **Servicios**: Implementaciones de servicios en `src/main/java/com/pablo/hexagonal_demo/application/service/`
- **Controladores**: Controladores REST en `src/main/java/com/pablo/hexagonal_demo/infrastructure/controller/`
- **Configuración**: Configuraciones específicas en `src/main/java/com/pablo/hexagonal_demo/infrastructure/configuration/`
- **Repositorios de Infraestructura**: Implementaciones de repositorio específicas en `src/main/java/com/pablo/hexagonal_demo/infrastructure/repository/`

## Tests Generados

Los tests unitarios y de integración han sido creados automáticamente con el script `crear_tests_hexagonal.sh`, proporcionando cobertura para las funcionalidades del proyecto y asegurando su correcto funcionamiento.

```
./crear_tests_hexagonal.sh datos_entidad.json
```

Además, una vez arrancada la aplicación, se ha añadido un test básico `test_curl.sh` para probar la funcionalidad de creación de tareas. Este test verifica que la API REST para crear tareas funciona correctamente.

## Entorno de Desarrollo con DevContainer

Se ha configurado un entorno de desarrollo utilizando DevContainer para asegurar un ambiente consistente y replicable para todos los desarrolladores. Este entorno incluye todas las dependencias y configuraciones necesarias para ejecutar y probar la aplicación sin problemas de compatibilidad.

## Levantamiento de MongoDB con Docker Compose

Para facilitar el desarrollo local, MongoDB se puede levantar utilizando Docker Compose. Asegúrate de tener Docker instalado y sigue estos pasos:

1. Crea un archivo `docker-compose.yml` en la raíz del proyecto con el siguiente contenido:

    ```yaml
    version: '3.8'

    services:
      mongo:
        image: mongo
        container_name: mongodb
        ports:
          - "27017:27017"
        volumes:
          - mongo-data:/data/db
        networks:
          - backend

    networks:
      backend:

    volumes:
      mongo-data:
        driver: local
    ```

2. Ejecuta `docker-compose up -d` en la raíz del proyecto para levantar MongoDB en un contenedor.
3. Después de asegurarte de que MongoDB está en funcionamiento, puedes iniciar la aplicación Spring Boot con `./mvnw spring-boot:run`.
4. La aplicación estará disponible en `http://localhost:8080`.

## Documentación con Swagger

La API de la aplicación está documentada utilizando Swagger. Puedes acceder a la documentación en formato interactivo visitando [Swagger UI](http://localhost:8080/swagger-ui/index.html). Aquí podrás explorar y probar los endpoints disponibles.

## Fallos conocidos

1. Se ha intentado levantar el proyecto con docker-compose y la aplicación dockerizada pero había problemas de conectividad con mongodb.
2. No ha dado tiempo a generar el javadoc
3. Los archivos generados por shell pueden dar fallos de imports que hay que ajustar. Tambien generan la inyección de clases con autowired en vez de con el contructor.

