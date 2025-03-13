SET SERVEROUTPUT ON;



-------------------------------
   --INSERTAR PACIENTES--    
-------------------------------
-- Crear el procedimiento para insertar pacientes
CREATE OR REPLACE PROCEDURE Insertar_Paciente(
    nombre IN VARCHAR2,
    apellidos IN VARCHAR2,
    telefono IN NUMBER,
    fecha_nacimiento IN DATE,
    ciudad IN VARCHAR2,
    calle IN VARCHAR2,
    email IN VARCHAR2,
    pin IN NUMBER
)
IS
    v_direccion Tipo_Direccion := Tipo_Direccion(ciudad, calle);
BEGIN
    -- Insertar datos en la tabla Paciente
    INSERT INTO Tabla_Paciente(Nombre, Apellidos, Telefono, Fecha_nacimiento, Direccion, Email, PIN)
    VALUES (nombre, apellidos, telefono, fecha_nacimiento, v_direccion, email, pin);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Paciente insertado correctamente');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN -- Capturar la excepción de clave duplicada (violación de restricción única)
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al insertar el paciente: El correo electrónico ya existe');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al insertar el paciente: ' || SQLERRM);
END;
/


----------------------------
   --INSERTAR MEDICOS--    
----------------------------
--Procedimiento para insertar datos en Tabla_Medico-
create or replace PROCEDURE Insertar_Medico(
    nombre_hospital IN VARCHAR2,
    nombre_departamento IN VARCHAR2,
    nombre IN VARCHAR2,
    apellidos IN VARCHAR2,
    telefono IN NUMBER,
    fecha_nacimiento IN DATE,
    ciudad IN VARCHAR2,
    calle IN VARCHAR2,
    email IN VARCHAR2,
    pin IN NUMBER
)
IS
    v_direccion Tipo_Direccion := Tipo_Direccion(ciudad, calle);
    v_id_hospital Tabla_Hospital.Id_Hospital%TYPE;
    v_id_departamento Tabla_Departamento.Id_Departamento%TYPE;
BEGIN
    -- Obtener el ID del hospital dado su nombre
    SELECT Id_Hospital INTO v_id_hospital
    FROM Tabla_Hospital
    WHERE Nombre = nombre_hospital;

    -- Obtener el ID del departamento dado su nombre y el ID del hospital
    SELECT Id_Departamento INTO v_id_departamento
    FROM Tabla_Departamento
    WHERE Nombre = nombre_departamento
    AND Id_Hospital = v_id_hospital;

    -- Insertar datos en la tabla Medico
    INSERT INTO Tabla_Medico(Id_Departamento, Nombre, Apellidos, Telefono, Fecha_Nacimiento, Direccion, Email, PIN)
    VALUES (v_id_departamento, nombre, apellidos, telefono, fecha_nacimiento, v_direccion, email, pin);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('M�dico insertado correctamente');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El departamento especificado no existe para el hospital dado');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al insertar el m�dico: ' || SQLERRM);
END;
/


-----------------------------
   --INSERTAR DEPARTAMENTOS--    
-----------------------------
-- Procedimiento para insertar datos en la Tabla_Departamento
CREATE OR REPLACE PROCEDURE Insertar_Departamento(
    nombre_hospital IN VARCHAR2,
    nombre IN VARCHAR2,
    ubicacion IN VARCHAR2
)
IS
    v_id_hospital Tabla_Hospital.Id_Hospital%TYPE;
BEGIN
    -- Obtener el ID del hospital dado su nombre
    SELECT Id_Hospital INTO v_id_hospital
    FROM Tabla_Hospital
    WHERE Nombre = nombre_hospital;

    -- Insertar datos en la tabla Departamento
    INSERT INTO Tabla_Departamento(Id_Hospital, Nombre, Ubicacion)
    VALUES (v_id_hospital, nombre, ubicacion);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Departamento insertado correctamente');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El hospital especificado no existe');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al insertar el departamento: ' || SQLERRM);
END;
/



-----------------------------
   --INSERTAR HOSPITALES--    
-----------------------------
-- Procedimiento para insertar datos en la Tabla_Hospital-
CREATE OR REPLACE PROCEDURE Insertar_Hospital(
    nombre IN VARCHAR2,
    ciudad IN VARCHAR2,
    calle IN VARCHAR2
)
IS
    v_direccion Tipo_Direccion := Tipo_Direccion(ciudad, calle);
BEGIN
    -- Insertar datos en la tabla Hospital
    INSERT INTO Tabla_Hospital(Nombre, Direccion)
    VALUES (nombre, v_direccion);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Hospital insertado correctamente');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al insertar el hospital: ' || SQLERRM);
END;
/



-----------------------------
   --INSERTAR DIAGNOSTICOS--    
-----------------------------
create or replace PROCEDURE Insertar_Diagnostico(
    cita_id IN NUMBER,
    descripcion IN VARCHAR2,
    recomendacion IN VARCHAR2
)
IS
    v_diagnostico_id NUMBER;
BEGIN
    -- Insertar datos en la tabla Diagnostico
    INSERT INTO Tabla_Diagnostico(Descripcion, Recomendacion)
    VALUES (descripcion, recomendacion)
    RETURNING Id_Diagnostico INTO v_diagnostico_id;

    -- Actualizar la cita con el ID del diagnóstico
    UPDATE Tabla_Cita SET Id_Diagnostico = v_diagnostico_id, Estado = 'Diagnostico Completo'
    WHERE Id_Cita = cita_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Diagnóstico insertado correctamente');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al insertar el diagnóstico: ' || SQLERRM);
END;
/

-----------------------------
   --INSERTAR MEDICAMENTO--    
-----------------------------
CREATE OR REPLACE PROCEDURE Insertar_Medicamento(
    id_diagnostico IN NUMBER,
    nombre_medicamento IN VARCHAR2,
    frecuencia IN VARCHAR2
)
IS
BEGIN
    -- Insertar el medicamento asociado al diagnóstico
    INSERT INTO Tabla_Medicamento(Id_diagnostico, Nombre, Frecuencia)
    VALUES (id_diagnostico, nombre_medicamento, frecuencia);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Medicamento insertado correctamente');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al insertar el medicamento: ' || SQLERRM);
END;
/


-------------------------------
  --ELIMINAR PACIENTES--    
-------------------------------
-- Crear el procedimiento para eliminar pacientes
CREATE OR REPLACE PROCEDURE Eliminar_Paciente(
    email_paciente IN VARCHAR2
)
IS
BEGIN
    -- Eliminar el paciente basado en su dirección de correo electrónico
    DELETE FROM Tabla_Paciente
    WHERE Email = email_paciente;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Paciente eliminado correctamente');
EXCEPTION
    WHEN NO_DATA_FOUND THEN -- Capturar la excepción cuando no se encuentra ningún dato
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El paciente especificado no existe');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar el paciente: ' || SQLERRM);
END;
/


-------------------------------
  --ELIMINAR MEDICOS --    
-------------------------------
CREATE OR REPLACE PROCEDURE Eliminar_Medico(
    email_medico IN VARCHAR2
)
IS
BEGIN
    -- Eliminar el médico basado en su dirección de correo electrónico
    DELETE FROM Tabla_Medico
    WHERE Email = email_medico;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Médico eliminado correctamente');
EXCEPTION
    WHEN NO_DATA_FOUND THEN -- Capturar la excepción cuando no se encuentra ningún dato
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El médico especificado no existe');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar el médico: ' || SQLERRM);
END;
/





-------------------------------
  --ELIMINAR DEPARTAMENTOS--    
-------------------------------
CREATE OR REPLACE PROCEDURE Eliminar_Departamento(
    nombre_departamento IN VARCHAR2,
    nombre_hospital IN VARCHAR2
)
IS
BEGIN
    -- Obtener el ID del hospital dado su nombre
    DECLARE
        v_id_hospital Tabla_Hospital.Id_Hospital%TYPE;
    BEGIN
        SELECT Id_Hospital INTO v_id_hospital
        FROM Tabla_Hospital
        WHERE Nombre = nombre_hospital;

        -- Eliminar el departamento basado en su nombre y el ID del hospital
        DELETE FROM Tabla_Departamento
        WHERE Nombre = nombre_departamento
        AND Id_Hospital = v_id_hospital;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Departamento eliminado correctamente');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN -- Capturar la excepción cuando no se encuentra ningún dato
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('El departamento especificado no existe');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error al eliminar el departamento: ' || SQLERRM);
    END;
END;
/


-------------------------------
  --ELIMINAR HOSPITALES --    
-------------------------------
CREATE OR REPLACE PROCEDURE Eliminar_Hospital(
    nombre_hospital IN VARCHAR2
)
IS
BEGIN
    -- Eliminar el hospital basado en su nombre
    DELETE FROM Tabla_Hospital
    WHERE Nombre = nombre_hospital;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Hospital eliminado correctamente');
EXCEPTION
    WHEN NO_DATA_FOUND THEN -- Capturar la excepción cuando no se encuentra ningún dato
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('El hospital especificado no existe');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al eliminar el hospital: ' || SQLERRM);
END;
/








---------------------------
  --CREAR CITAS --    
---------------------------
--Procedimiento para que el 
CREATE OR REPLACE PROCEDURE Crear_Citas AS
    v_fecha DATE;
    v_hora TIMESTAMP(0);
    v_estado VARCHAR2(50) := 'Paciente sin asignar';
    v_citas_existen NUMBER;
BEGIN
    -- Obtener la fecha actual
    SELECT TRUNC(SYSDATE) INTO v_fecha FROM dual;

    -- Verificar si ya existen citas para la fecha actual
    SELECT COUNT(*) INTO v_citas_existen FROM Tabla_Cita WHERE Fecha = v_fecha;
    IF v_citas_existen > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Ya existen citas para la fecha actual.');
    END IF;

    -- Bucle a través de todos los hospitales
    FOR hospital_rec IN (SELECT * FROM Tabla_Hospital) LOOP

        -- Bucle a través de todos los departamentos del hospital actual
        FOR departamento_rec IN (SELECT * FROM Tabla_Departamento WHERE Id_hospital = hospital_rec.Id_hospital) LOOP

            -- Bucle a través de todos los médicos del departamento actual
            FOR medico_rec IN (SELECT * FROM Tabla_Medico WHERE Id_departamento = departamento_rec.Id_departamento) LOOP

                -- Calcular la hora de la cita (de 8 a 14)
                v_hora := TO_TIMESTAMP(TO_CHAR(v_fecha, 'YYYY-MM-DD') || ' 08:00:00', 'YYYY-MM-DD HH24:MI:SS');

                -- Crear la cita
                INSERT INTO Tabla_Cita (Id_cita, Id_medico, Id_paciente, Id_diagnostico, Fecha, Hora, Estado)
                VALUES (seq_cita_id.NEXTVAL, medico_rec.Id_medico, NULL, NULL, v_fecha, v_hora, v_estado);

                -- Incrementar la hora en 1 hora (60 minutos)
                v_hora := v_hora + INTERVAL '60' MINUTE;

                -- Crear más citas hasta las 14:00
                WHILE EXTRACT(HOUR FROM v_hora) < 14 LOOP
                    INSERT INTO Tabla_Cita (Id_cita, Id_medico, Id_paciente, Id_diagnostico, Fecha, Hora, Estado)
                    VALUES (seq_cita_id.NEXTVAL, medico_rec.Id_medico, NULL, NULL, v_fecha, v_hora, v_estado);
                    v_hora := v_hora + INTERVAL '60' MINUTE;
                END LOOP;

            END LOOP; -- Fin del bucle de médicos

        END LOOP; -- Fin del bucle de departamentos

    END LOOP; -- Fin del bucle de hospitales
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Citas creadas correctamente');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al crear las citas: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE Asignar_Cita(
    id_paciente_param IN NUMBER,
    id_cita_param IN NUMBER
)
IS
BEGIN
    -- Actualizar el ID del paciente y el estado de la cita
    UPDATE Tabla_Cita
    SET Id_paciente = id_paciente_param,
        Estado = 'Paciente Asignado'
    WHERE Id_cita = id_cita_param;
    
    -- Confirmar que se ha actualizado la cita
    IF SQL%ROWCOUNT = 1 THEN
        DBMS_OUTPUT.PUT_LINE('La cita ha sido asignada correctamente.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error al asignar la cita.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
