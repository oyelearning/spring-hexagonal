#!/bin/bash

# Verificar que se haya proporcionado un archivo JSON
if [ -z "$1" ]; then
  echo "Por favor, proporciona un archivo JSON con los datos de la entidad."
  exit 1
fi

# Nombre del archivo JSON
JSON_FILE=$1

# Verificar que el archivo JSON existe
if [ ! -f "$JSON_FILE" ]; then
  echo "El archivo JSON especificado no existe: $JSON_FILE"
  exit 1
fi

# Leer datos desde el archivo JSON
ENTIDAD=$(jq -r '.entidad' "$JSON_FILE")
PAQUETE=$(jq -r '.paquete' "$JSON_FILE")
PROPIEDADES=$(jq -r '.propiedades | keys[]' "$JSON_FILE")

# Crear la estructura de directorios si no existe
DIRECTORIO_BASE=$(pwd)
DIRECTORIO_ENTIDAD="$DIRECTORIO_BASE/src/main/java/$(echo $PAQUETE | tr . /)/domain/model"
DIRECTORIO_REPOSITORIO="$DIRECTORIO_BASE/src/main/java/$(echo $PAQUETE | tr . /)/domain/repository"
DIRECTORIO_SERVICIO="$DIRECTORIO_BASE/src/main/java/$(echo $PAQUETE | tr . /)/application/service"
DIRECTORIO_CONTROLADOR="$DIRECTORIO_BASE/src/main/java/$(echo $PAQUETE | tr . /)/infrastructure/controller"
DIRECTORIO_CONFIGURACION="$DIRECTORIO_BASE/src/main/java/$(echo $PAQUETE | tr . /)/infrastructure/configuration"

mkdir -p "$DIRECTORIO_ENTIDAD"
mkdir -p "$DIRECTORIO_REPOSITORIO"
mkdir -p "$DIRECTORIO_SERVICIO"
mkdir -p "$DIRECTORIO_CONTROLADOR"
mkdir -p "$DIRECTORIO_CONFIGURACION"

# Crear la entidad
ENTIDAD_FILE="$DIRECTORIO_ENTIDAD/${ENTIDAD}.java"
cat <<EOF > "$ENTIDAD_FILE"
package $PAQUETE.domain.model;

import java.time.LocalDate;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ${ENTIDAD} {

    private String id;

EOF

# Añadir propiedades a la entidad
for PROP in $PROPIEDADES; do
  TIPO=$(jq -r ".propiedades.$PROP" "$JSON_FILE")
  echo "    private $TIPO $PROP;" >> "$ENTIDAD_FILE"
done

# Cerrar la entidad
echo "}" >> "$ENTIDAD_FILE"

# Crear el repositorio
REPOSITORIO_FILE="$DIRECTORIO_REPOSITORIO/${ENTIDAD}Repository.java"
cat <<EOF > "$REPOSITORIO_FILE"
package $PAQUETE.domain.repository;

import $PAQUETE.domain.model.${ENTIDAD};
import java.util.List;

public interface ${ENTIDAD}Repository {
    ${ENTIDAD} save(${ENTIDAD} ${ENTIDAD,,});
    List<${ENTIDAD}> findAll();
    ${ENTIDAD} findById(String id);
    void deleteById(String id);
}
EOF

# Crear el servicio
SERVICIO_FILE="$DIRECTORIO_SERVICIO/${ENTIDAD}Service.java"
cat <<EOF > "$SERVICIO_FILE"
package $PAQUETE.application.service;

import $PAQUETE.domain.model.${ENTIDAD};
import $PAQUETE.domain.repository.${ENTIDAD}Repository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ${ENTIDAD}Service {

    private final ${ENTIDAD}Repository ${ENTIDAD,,}Repository;

    public ${ENTIDAD}Service(${ENTIDAD}Repository ${ENTIDAD,,}Repository) {
        this.${ENTIDAD,,}Repository = ${ENTIDAD,,}Repository;
    }

    public ${ENTIDAD} create${ENTIDAD}(${ENTIDAD} ${ENTIDAD,,}) {
        return ${ENTIDAD,,}Repository.save(${ENTIDAD,,});
    }

    public List<${ENTIDAD}> getAll${ENTIDAD}s() {
        return ${ENTIDAD,,}Repository.findAll();
    }

    public ${ENTIDAD} get${ENTIDAD}ById(String id) {
        return ${ENTIDAD,,}Repository.findById(id);
    }

    public void delete${ENTIDAD}ById(String id) {
        ${ENTIDAD,,}Repository.deleteById(id);
    }
}
EOF

# Crear el controlador
CONTROLADOR_FILE="$DIRECTORIO_CONTROLADOR/${ENTIDAD}Controller.java"
cat <<EOF > "$CONTROLADOR_FILE"
package $PAQUETE.infrastructure.controller;

import $PAQUETE.application.service.${ENTIDAD}Service;
import $PAQUETE.domain.model.${ENTIDAD};
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/${ENTIDAD,,}s")
public class ${ENTIDAD}Controller {

    @Autowired
    private ${ENTIDAD}Service ${ENTIDAD,,}Service;

    @PostMapping
    public ${ENTIDAD} create${ENTIDAD}(@RequestBody ${ENTIDAD} ${ENTIDAD,,}) {
        return ${ENTIDAD,,}Service.create${ENTIDAD}(${ENTIDAD,,});
    }

    @GetMapping
    public List<${ENTIDAD}> getAll${ENTIDAD}s() {
        return ${ENTIDAD,,}Service.getAll${ENTIDAD}s();
    }

    @GetMapping("/{id}")
    public ${ENTIDAD} get${ENTIDAD}ById(@PathVariable String id) {
        return ${ENTIDAD,,}Service.get${ENTIDAD}ById(id);
    }

    @DeleteMapping("/{id}")
    public void delete${ENTIDAD}ById(@PathVariable String id) {
        ${ENTIDAD,,}Service.delete${ENTIDAD}ById(id);
    }
}
EOF

# Crear la configuración de MongoDB
CONFIGURACION_FILE="$DIRECTORIO_CONFIGURACION/MongoConfig.java"
cat <<EOF > "$CONFIGURACION_FILE"
package $PAQUETE.infrastructure.configuration;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.config.AbstractMongoClientConfiguration;

@Configuration
public class MongoConfig extends AbstractMongoClientConfiguration {

    @Override
    protected String getDatabaseName() {
        return "task_management_db";
    }
}
EOF

echo "Archivos creados para la entidad $ENTIDAD en el paquete $PAQUETE en la ruta $DIRECTORIO_BASE."
