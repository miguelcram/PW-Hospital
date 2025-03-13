-- Creacion de tipos propios

-- Direccion
CREATE OR REPLACE TYPE Tipo_Direccion AS OBJECT (
    Ciudad VARCHAR2(50),
    Calle VARCHAR2(50)
);
/

--Paciente
CREATE OR REPLACE TYPE Tipo_Paciente AS OBJECT (
    Id_paciente NUMBER,
    Nombre VARCHAR2(50), 
    Apellidos VARCHAR2(50),
    Telefono NUMBER(9),
    Fecha_nacimiento DATE,
    Direccion Tipo_Direccion,   
    Email VARCHAR2(50),
    PIN NUMBER(8)
);
/

-- Medico
CREATE OR REPLACE TYPE Tipo_Medico AS OBJECT (
    Id_medico NUMBER,
    Id_departamento NUMBER,
    Nombre VARCHAR2(50), 
    Apellidos VARCHAR2(50),
    Telefono NUMBER(9),
    Fecha_nacimiento DATE,
    Direccion Tipo_Direccion,   
    Email VARCHAR2(50),
    PIN NUMBER(8)
);
/

-- Primero definimos los tipos sin referencias cruzadas
CREATE OR REPLACE TYPE Tipo_Diagnostico AS OBJECT (
    Id_diagnostico NUMBER,
    Descripcion VARCHAR(100),
    Recomendacion VARCHAR(100)
);
/

-- Cita
CREATE OR REPLACE TYPE Tipo_Cita AS OBJECT (
    Id_cita NUMBER,
    Id_medico NUMBER,
    Id_paciente NUMBER,
    Id_diagnostico NUMBER,
    Fecha DATE,
    Hora TIMESTAMP(0),
    Estado VARCHAR(50)
);
/

-- Medicamento
CREATE OR REPLACE TYPE Tipo_Medicamento AS OBJECT (
    Id_medicamento NUMBER,
    Id_diagnostico NUMBER,
    Nombre VARCHAR(50),
    Frecuencia VARCHAR2(100)
);
/



-- Departamento
CREATE OR REPLACE TYPE Tipo_Departamento AS OBJECT (
    Id_departamento NUMBER,
    Id_hospital NUMBER,
    Nombre VARCHAR2(50),
    Ubicacion VARCHAR2(50)
);
/


-- Hospital
CREATE OR REPLACE TYPE Tipo_Hospital AS OBJECT (
    Id_hospital NUMBER,
    Nombre VARCHAR2(50),
    Direccion Tipo_Direccion
);
/