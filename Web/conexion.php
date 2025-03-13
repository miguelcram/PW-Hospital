<DOCTYPE HTML>
<meta charset = "utf8"/>

<?php
function conexion() {

    $usuario = 'usuario';
    $contrasenna = 'usuario';
    $servidor_baseDeDatos = '//localhost:1521/XEPDB1';

    // $usuario = /*INTRODUZCA AQUI SU USUARIO*/;
    // $contrasenna = /*INTRODUZCA AQUI SU CONTRASEÑA*/;
    // $servidor_baseDeDatos = /*INTRODUZCA AQUI SU SERVIDOR DE BASE DE DATOS*/;
    
    $conn = oci_connect($usuario, $contrasenna, $servidor_baseDeDatos);
    if (!$conn) {
        $e = oci_error();
        trigger_error(htmlentities($e['Error de conexión'], ENT_QUOTES), E_USER_ERROR);
    }else{
        //echo "Conexión con Oracle exitosa";
    }
    return $conn;
}
?>