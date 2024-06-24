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
DIRECTORIO_TEST="$DIRECTORIO_BASE/src/test/java/$(echo $PAQUETE | tr . /)"
DIRECTORIO_TEST_ENTIDAD="$DIRECTORIO_TEST/domain/model"
DIRECTORIO_TEST_REPOSITORIO="$DIRECTORIO_TEST/domain/repository"
DIRECTORIO_TEST_SERVICIO="$DIRECTORIO_TEST/application/service"
DIRECTORIO_TEST_CONTROLADOR="$DIRECTORIO_TEST/infrastructure/controller"

mkdir -p "$DIRECTORIO_TEST_ENTIDAD"
mkdir -p "$DIRECTORIO_TEST_REPOSITORIO"
mkdir -p "$DIRECTORIO_TEST_SERVICIO"
mkdir -p "$DIRECTORIO_TEST_CONTROLADOR"

# Crear el test de la entidad
TEST_ENTIDAD_FILE="$DIRECTORIO_TEST_ENTIDAD/${ENTIDAD}Test.java"
cat <<EOF > "$TEST_ENTIDAD_FILE"
package $PAQUETE.domain.model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class ${ENTIDAD}Test {

    @Test
    void test${ENTIDAD}Creation() {
        ${ENTIDAD} ${ENTIDAD,,} = new ${ENTIDAD}();
        assertNotNull(${ENTIDAD,,});
    }
}
EOF

# Crear el test del repositorio
TEST_REPOSITORIO_FILE="$DIRECTORIO_TEST_REPOSITORIO/${ENTIDAD}RepositoryTest.java"
cat <<EOF > "$TEST_REPOSITORIO_FILE"
package $PAQUETE.domain.repository;

import $PAQUETE.domain.model.${ENTIDAD};
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.data.mongo.DataMongoTest;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;

@DataMongoTest
class ${ENTIDAD}RepositoryTest {

    @Autowired
    private ${ENTIDAD}Repository ${ENTIDAD,,}Repository;

    @Test
    void testSaveAndFind() {
        ${ENTIDAD} ${ENTIDAD,,} = new ${ENTIDAD}();
        ${ENTIDAD} saved${ENTIDAD} = ${ENTIDAD,,}Repository.save(${ENTIDAD,,});
        assertNotNull(saved${ENTIDAD});
        List<${ENTIDAD}> ${ENTIDAD,,}s = ${ENTIDAD,,}Repository.findAll();
        assertFalse(${ENTIDAD,,}s.isEmpty());
    }
}
EOF

# Crear el test del servicio
TEST_SERVICIO_FILE="$DIRECTORIO_TEST_SERVICIO/${ENTIDAD}ServiceTest.java"
cat <<EOF > "$TEST_SERVICIO_FILE"
package $PAQUETE.application.service;

import $PAQUETE.domain.model.${ENTIDAD};
import $PAQUETE.domain.repository.${ENTIDAD}Repository;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.junit.jupiter.api.extension.ExtendWith;
import java.util.List;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
class ${ENTIDAD}ServiceTest {

    @Mock
    private ${ENTIDAD}Repository ${ENTIDAD,,}Repository;

    @InjectMocks
    private ${ENTIDAD}Service ${ENTIDAD,,}Service;

    @Test
    void testCreate${ENTIDAD}() {
        ${ENTIDAD} ${ENTIDAD,,} = new ${ENTIDAD}();
        when(${ENTIDAD,,}Repository.save(${ENTIDAD,,})).thenReturn(${ENTIDAD,,});
        ${ENTIDAD} created${ENTIDAD} = ${ENTIDAD,,}Service.create${ENTIDAD}(${ENTIDAD,,});
        assertNotNull(created${ENTIDAD});
        verify(${ENTIDAD,,}Repository, times(1)).save(${ENTIDAD,,});
    }

    @Test
    void testGetAll${ENTIDAD}s() {
        when(${ENTIDAD,,}Repository.findAll()).thenReturn(List.of(new ${ENTIDAD}()));
        List<${ENTIDAD}> ${ENTIDAD,,}s = ${ENTIDAD,,}Service.getAll${ENTIDAD}s();
        assertFalse(${ENTIDAD,,}s.isEmpty());
        verify(${ENTIDAD,,}Repository, times(1)).findAll();
    }
}
EOF

# Crear el test del controlador
TEST_CONTROLADOR_FILE="$DIRECTORIO_TEST_CONTROLADOR/${ENTIDAD}ControllerTest.java"
cat <<EOF > "$TEST_CONTROLADOR_FILE"
package $PAQUETE.infrastructure.controller;

import $PAQUETE.application.service.${ENTIDAD}Service;
import $PAQUETE.domain.model.${ENTIDAD};
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.http.MediaType;
import java.util.List;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import com.fasterxml.jackson.databind.ObjectMapper;

@WebMvcTest(${ENTIDAD}Controller.class)
class ${ENTIDAD}ControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ${ENTIDAD}Service ${ENTIDAD,,}Service;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void testCreate${ENTIDAD}() throws Exception {
        ${ENTIDAD} ${ENTIDAD,,} = new ${ENTIDAD}();
        when(${ENTIDAD,,}Service.create${ENTIDAD}(any(${ENTIDAD}.class))).thenReturn(${ENTIDAD,,});

        mockMvc.perform(post("/${ENTIDAD,,}s")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(${ENTIDAD,,})))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").exists());

        verify(${ENTIDAD,,}Service, times(1)).create${ENTIDAD}(any(${ENTIDAD}.class));
    }

    @Test
    void testGetAll${ENTIDAD}s() throws Exception {
        when(${ENTIDAD,,}Service.getAll${ENTIDAD}s()).thenReturn(List.of(new ${ENTIDAD}()));

        mockMvc.perform(get("/${ENTIDAD,,}s")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray());

        verify(${ENTIDAD,,}Service, times(1)).getAll${ENTIDAD}s();
    }
}
EOF

echo "Archivos de tests creados para la entidad $ENTIDAD en el paquete $PAQUETE en la ruta $DIRECTORIO_BASE."
