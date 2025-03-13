
-----------------------------
--                  --
-- PAQUETE INSERTAR --
--                  --
-----------------------------
CREATE OR REPLACE PACKAGE Insertar AS 
    PROCEDURE Insertar_Paciente(
    nombre IN VARCHAR2,
    apellidos IN VARCHAR2,
    telefono IN NUMBER,
    fecha_nacimiento IN DATE,
    ciudad IN VARCHAR2,
    calle IN VARCHAR2,
    email IN VARCHAR2,
    pin IN NUMBER);

    PROCEDURE Insertar_Medico(
    nombre_hospital IN VARCHAR2,
    nombre_departamento IN VARCHAR2,
    nombre IN VARCHAR2,
    apellidos IN VARCHAR2,
    telefono IN NUMBER,
    fecha_nacimiento IN DATE,
    ciudad IN VARCHAR2,
    calle IN VARCHAR2,
    email IN VARCHAR2,
    pin IN NUMBER);

    PROCEDURE Insertar_Departamento(
    nombre_hospital IN VARCHAR2,
    nombre IN VARCHAR2,
    ubicacion IN VARCHAR2);

    PROCEDURE Insertar_Hospital(
    nombre IN VARCHAR2,
    ciudad IN VARCHAR2,
    calle IN VARCHAR2);

    PROCEDURE Insertar_Diagnostico(
    cita_id IN NUMBER,
    descripcion IN VARCHAR2,
    recomendacion IN VARCHAR2);

    PROCEDURE Insertar_Medicamento(
    id_diagnostico IN NUMBER,
    nombre_medicamento IN VARCHAR2,
    frecuencia IN VARCHAR2);
END Insertar;
/

CREATE OR REPLACE PACKAGE BODY Insertar AS
-------------------------------
--INSERTAR PACIENTES--    
-------------------------------
    PROCEDURE Insertar_Paciente(
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
    END Insertar_Paciente;

    
    
----------------------------
   --INSERTAR MEDICOS--    
----------------------------
    PROCEDURE Insertar_Medico(
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
    END Insertar_Medico;


-----------------------------
   --INSERTAR DEPARTAMENTOS--    
-----------------------------
    PROCEDURE Insertar_Departamento(
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
    END Insertar_Departamento;


-----------------------------
   --INSERTAR HOSPITALES--    
-----------------------------
    PROCEDURE Insertar_Hospital(
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
    END Insertar_Hospital;



-----------------------------
   --INSERTAR DIAGNOSTICOS--    
-----------------------------
    PROCEDURE Insertar_Diagnostico(
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
    END Insertar_Diagnostico;



-----------------------------
   --INSERTAR MEDICAMENTO--    
-----------------------------
    PROCEDURE Insertar_Medicamento(
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
    END Insertar_Medicamento;
END Insertar;
/











-----------------------------
--                  --
-- PAQUETE ELIMINAR --
--                  --
-----------------------------
CREATE OR REPLACE PACKAGE Eliminar AS
    PROCEDURE Eliminar_Paciente(
    email_paciente IN VARCHAR2);

    PROCEDURE Eliminar_Medico(
    email_medico IN VARCHAR2);

    PROCEDURE Eliminar_Departamento(
    nombre_departamento IN VARCHAR2,
    nombre_hospital IN VARCHAR2);

    PROCEDURE Eliminar_Hospital(
    nombre_hospital IN VARCHAR2);
END Eliminar;
/


CREATE OR REPLACE PACKAGE BODY Eliminar AS
-------------------------------
  --ELIMINAR HOSPITALES --    
-------------------------------
    PROCEDURE Eliminar_Hospital(
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
    END Eliminar_Hospital;
    

-------------------------------
--ELIMINAR DEPARTAMENTOS--    
-------------------------------
    PROCEDURE Eliminar_Departamento(
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
    END Eliminar_Departamento;




-------------------------------
  --ELIMINAR MEDICOS --    
-------------------------------
    PROCEDURE Eliminar_Medico(
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
    END Eliminar_Medico;



-------------------------------
  --ELIMINAR PACIENTES--    
-------------------------------
    PROCEDURE Eliminar_Paciente(
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
    END Eliminar_Paciente;
END Eliminar;
/









-----------------------------
--                  --
--  PAQUETE OBTENER --
--                  --
-----------------------------
CREATE OR REPLACE PACKAGE Obtener AS
    FUNCTION Obtener_Departamentos_Hospitales_Cursor RETURN SYS_REFCURSOR;

    FUNCTION Obtener_Max_Id_Diagnostico RETURN NUMBER;

    FUNCTION Obtener_Hospitales_Cursor RETURN SYS_REFCURSOR;

    FUNCTION Obtener_Medicos_Cursor RETURN SYS_REFCURSOR;

    FUNCTION Obtener_Pacientes_Cursor RETURN SYS_REFCURSOR;

    FUNCTION Obtener_Citas_Pendientes_Cursor(
        p_hospital IN VARCHAR2,
        p_departamento IN VARCHAR2,
        p_fecha IN VARCHAR2
    ) RETURN SYS_REFCURSOR;

END Obtener;
/

CREATE OR REPLACE PACKAGE BODY Obtener AS
---------------------------------------
  --OBTENER DEPARTAMENTOS HOSPITALES--
---------------------------------------
    FUNCTION Obtener_Departamentos_Hospitales_Cursor RETURN SYS_REFCURSOR AS
    v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT 
                d.Id_departamento,
                d.Nombre AS Nombre_departamento,
                d.Ubicacion AS Ubicacion_departamento,
                h.Id_hospital,
                h.Nombre AS Nombre_hospital,
                h.Direccion.Ciudad AS Ciudad_hospital,
                h.Direccion.Calle AS Calle_hospital
            FROM 
                Tabla_Departamento d
                JOIN Tabla_Hospital h ON d.Id_hospital = h.Id_hospital;

        RETURN v_cursor;
    END Obtener_Departamentos_Hospitales_Cursor;


    
-------------------------------
  --OBTENER DIAGNOSTICO--    
-------------------------------
    FUNCTION Obtener_Max_Id_Diagnostico
    RETURN NUMBER
    IS
        max_id_diagnostico NUMBER;
    BEGIN
        -- Seleccionar el mÃ¡ximo ID de diagnÃ³stico de la tabla Tabla_Diagnostico
        SELECT MAX(Id_diagnostico) INTO max_id_diagnostico FROM Tabla_Diagnostico;
        
        -- Devolver el mÃ¡ximo ID de diagnÃ³stico
        RETURN max_id_diagnostico;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL; -- En caso de error, devolver NULL
    END Obtener_Max_Id_Diagnostico;


-------------------------------
  --OBTENER HOSPITALES --    
-------------------------------
    FUNCTION Obtener_Hospitales_Cursor RETURN SYS_REFCURSOR IS
    resultado SYS_REFCURSOR;
    BEGIN
        OPEN resultado FOR
        SELECT 
            h.Id_hospital,
            h.Nombre AS Nombre_hospital,
            h.Direccion.Ciudad AS Ciudad_hospital,
            h.Direccion.Calle AS Calle_hospital
        FROM 
            Tabla_Hospital h;
        RETURN resultado;
    END Obtener_Hospitales_Cursor;



-------------------------------
  --OBTENER MEDICOS --    
-------------------------------
    FUNCTION Obtener_Medicos_Cursor RETURN SYS_REFCURSOR IS
    resultado SYS_REFCURSOR;
    BEGIN
        OPEN resultado FOR
        SELECT 
            m.Id_medico,
            m.Nombre,
            m.Apellidos,
            m.Telefono,
            m.Fecha_nacimiento,
            m.Direccion.Ciudad AS Ciudad,
            m.Direccion.Calle AS Calle,
            m.Email,
            m.PIN,
            d.Id_departamento,
            d.Nombre AS Nombre_departamento,
            h.Id_hospital,
            h.Nombre AS Nombre_hospital
        FROM 
            Tabla_Medico m
            JOIN Tabla_Departamento d ON m.Id_departamento = d.Id_departamento
            JOIN Tabla_Hospital h ON d.Id_hospital = h.Id_hospital;
        RETURN resultado;
    END Obtener_Medicos_Cursor;




-------------------------------
  --OBTENER PACIENTES --    
-------------------------------
    FUNCTION Obtener_Pacientes_Cursor RETURN SYS_REFCURSOR IS
        resultado SYS_REFCURSOR;
    BEGIN
        OPEN resultado FOR
        SELECT 
            p.Id_paciente,
            p.Nombre,
            p.Apellidos,
            p.Telefono,
            p.Fecha_nacimiento,
            p.Direccion.Ciudad AS Ciudad,
            p.Direccion.Calle AS Calle,
            p.Email,
            p.PIN
        FROM 
            Tabla_Paciente p;
        RETURN resultado;
    END Obtener_Pacientes_Cursor;


-------------------------------
  --OBTENER CITAS--    
-------------------------------
    FUNCTION Obtener_Citas_Pendientes_Cursor(
        p_hospital IN VARCHAR2,
        p_departamento IN VARCHAR2,
        p_fecha IN VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        resultado SYS_REFCURSOR;
    BEGIN
        OPEN resultado FOR
        SELECT 
            c.Id_Cita, 
            c.Fecha, 
            TO_CHAR(c.Hora, 'HH24:MI:SS') AS Hora_Cita, 
            c.Id_Medico, 
            m.Nombre AS Nombre_Medico
        FROM 
            Tabla_Cita c
            JOIN Tabla_Medico m ON c.Id_medico = m.Id_medico
            JOIN Tabla_Departamento d ON m.Id_departamento = d.Id_departamento
            JOIN Tabla_Hospital h ON d.Id_hospital = h.Id_hospital
        WHERE 
            h.Nombre = p_hospital 
            AND d.Nombre = p_departamento 
            AND c.Estado = 'Paciente sin asignar'
            AND c.Fecha = TO_DATE(p_fecha, 'DD/MM/YYYY');

        RETURN resultado;
    END Obtener_Citas_Pendientes_Cursor;
END Obtener;
/
























-----------------------------
--                  --
--  PAQUETE OTROS   --
--                  --
-----------------------------
CREATE OR REPLACE PACKAGE Otros AS
    PROCEDURE Crear_Citas;

    PROCEDURE Asignar_Cita(
        id_paciente_param IN NUMBER,
        id_cita_param IN NUMBER
    );

    FUNCTION Verificar_Credenciales_Paciente(email_in VARCHAR2, pin_in VARCHAR2) RETURN NUMBER;

    FUNCTION Verificar_Credenciales_Medico(email_in VARCHAR2, pin_in VARCHAR2) RETURN NUMBER;
END Otros;
/

CREATE OR REPLACE PACKAGE BODY Otros AS
---------------------------
  --CREAR CITAS --    
---------------------------
    PROCEDURE Crear_Citas AS
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
    END Crear_Citas;


    PROCEDURE Asignar_Cita(
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
    END Asignar_Cita;


-------------------------------
  --VERFICAR PACIENTE--    
-------------------------------
    FUNCTION Verificar_Credenciales_Paciente(email_in VARCHAR2, pin_in VARCHAR2) RETURN NUMBER AS
    paciente_id NUMBER;
    BEGIN
        SELECT Id_paciente INTO paciente_id
        FROM Tabla_Paciente
        WHERE Email = email_in AND PIN = pin_in;
        
        RETURN paciente_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END Verificar_Credenciales_Paciente;


    
-------------------------------
  --VERFICAR MEDICO--    
-------------------------------
    FUNCTION Verificar_Credenciales_Medico(email_in VARCHAR2, pin_in VARCHAR2) RETURN NUMBER AS
        id_medico NUMBER;
    BEGIN
        SELECT Id_Medico INTO id_medico
        FROM Tabla_Medico
        WHERE Email = email_in AND PIN = pin_in;
        
        RETURN id_medico;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END Verificar_Credenciales_Medico;

END Otros;