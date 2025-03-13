-- Tabla Paciente
CREATE TABLE Tabla_Paciente OF Tipo_Paciente (
    CONSTRAINT pk_paciente PRIMARY KEY (Id_paciente),
    CONSTRAINT ak_paciente UNIQUE(Email)
);
/

-- Tabla Departamento
CREATE TABLE Tabla_Departamento OF Tipo_Departamento (
    CONSTRAINT pk_departamento PRIMARY KEY (Id_departamento),
    CONSTRAINT ak_departamento UNIQUE(Nombre, Id_hospital)
);
/

-- Tabla Medico
CREATE TABLE Tabla_Medico OF Tipo_Medico (
    CONSTRAINT pk_medico PRIMARY KEY (Id_medico),
    CONSTRAINT ak_medico UNIQUE(Email),
    CONSTRAINT fk_medico_departamento FOREIGN KEY (Id_departamento) REFERENCES Tabla_Departamento(Id_departamento)
);
/

-- Tabla Diagnostico
CREATE TABLE Tabla_Diagnostico OF Tipo_Diagnostico (
    CONSTRAINT pk_diagnostico PRIMARY KEY (Id_diagnostico)
);
/

-- Tabla Cita
CREATE TABLE Tabla_Cita OF Tipo_Cita (
    CONSTRAINT pk_cita PRIMARY KEY (Id_cita),
    CONSTRAINT fk_cita_medico FOREIGN KEY (Id_medico) REFERENCES Tabla_Medico(Id_medico),
    CONSTRAINT fk_cita_paciente FOREIGN KEY (Id_paciente) REFERENCES Tabla_Paciente(Id_paciente),
    CONSTRAINT fk_cita_diagnostico FOREIGN KEY (Id_diagnostico) REFERENCES Tabla_Diagnostico(Id_diagnostico)
);
/

-- Tabla Medicamento
CREATE TABLE Tabla_Medicamento OF Tipo_Medicamento (
    CONSTRAINT pk_medicamento PRIMARY KEY (Id_medicamento),
    CONSTRAINT fk_medicamento_diagnostico FOREIGN KEY (Id_diagnostico) REFERENCES Tabla_Diagnostico(Id_diagnostico)
);
/

-- Tabla Hospital
CREATE TABLE Tabla_Hospital OF Tipo_Hospital (
    CONSTRAINT pk_hospital PRIMARY KEY (Id_hospital),
    CONSTRAINT ak_hospital_nombre UNIQUE(Nombre)
);
/