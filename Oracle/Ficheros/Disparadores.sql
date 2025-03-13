--TRIGGER ID_PACIENTE
CREATE OR REPLACE TRIGGER trg_paciente_id
BEFORE INSERT ON Tabla_Paciente
FOR EACH ROW
BEGIN
  :new.Id_paciente := seq_paciente_id.NEXTVAL;
END;
/

--TRIGGER ID_MEDICO
CREATE OR REPLACE TRIGGER trg_medico_id
BEFORE INSERT ON Tabla_Medico
FOR EACH ROW
BEGIN
  :new.Id_medico := seq_medico_id.NEXTVAL;
END;
/

--TRIGGER ID_CITA
CREATE OR REPLACE TRIGGER trg_cita_id
BEFORE INSERT ON Tabla_Cita
FOR EACH ROW
BEGIN
  :new.Id_cita := seq_cita_id.NEXTVAL;
END;
/

--TRIGGER ID_DIAGNOSTICO
CREATE OR REPLACE TRIGGER trg_diagnostico_id
BEFORE INSERT ON Tabla_Diagnostico
FOR EACH ROW
BEGIN
  :new.Id_diagnostico := seq_diagnostico_id.NEXTVAL;
END;
/

--TRIGGER ID_MEDICAMENTO
CREATE OR REPLACE TRIGGER trg_medicamento_id
BEFORE INSERT ON Tabla_Medicamento
FOR EACH ROW
BEGIN
  :new.Id_medicamento := seq_medicamento_id.NEXTVAL;
END;
/

--TRIGGER ID_DEPARTAMENTO
CREATE OR REPLACE TRIGGER trg_departamento_id
BEFORE INSERT ON Tabla_Departamento
FOR EACH ROW
BEGIN
  :new.Id_departamento := seq_departamento_id.NEXTVAL;
END;
/

--TRIGGER ID_HOSPITAL
CREATE OR REPLACE TRIGGER trg_hospital_id
BEFORE INSERT ON Tabla_Hospital
FOR EACH ROW
BEGIN
  :new.Id_hospital := seq_hospital_id.NEXTVAL;
END;
/