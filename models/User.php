<?php
require_once 'config/database.php';

class User {
    private $pdo;

    public function __construct($pdo) {
        $this->pdo = $pdo;
    }
    public function authenticate($username, $password) {
        try {
            $stmt = $this->pdo->prepare("CALL iniciar_sesion(:username, :password, @username_result, @rol_id, @persona_id ,@perfil)");
            $stmt->bindParam(':username', $username);
            $stmt->bindParam(':password', $password);
            $stmt->execute();

            $resultStmt = $this->pdo->query("SELECT @username_result AS username_result, @rol_id AS rol_id, @persona_id AS persona_id, @perfil as perfil");
            $result = $resultStmt->fetch(PDO::FETCH_ASSOC);

            return $result;
        } catch (PDOException $e) {
            error_log("Error en User::authenticate: " . $e->getMessage());
            return false;
        }
    }
    public function addUser2(
        $nombre, 
        $apellidos, 
        $dni, 
        $email, 
        $telefono, 
        $direccion, 
        $fecha_nacimiento, 
        $username, 
        $password, 
        $rol_id,
        $pais,
        $provincia,
        $localidad,
        $cp

        ) 
        {
            $empleados = [];

        // Recorre todas las variables GET
        foreach ($_GET as $key => $value) {
            // Verifica si la clave comienza con 'emp' seguido de un número
            if (preg_match('/^emp\d+$/', $key)) {
                // Agrega el valor al array de empleados
                $empleados[] = $value;
            }
        }
        var_dump($empleados);
        try {
            // Preparar la llamada al procedimiento almacenado
            $stmt = $this->pdo->prepare("CALL crear_persona_y_usuario(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)");

            // Ejecutar la consulta con los parámetros proporcionados
            $stmt->execute([
                $nombre, 
                $apellidos, 
                $dni, 
                $email, 
                $telefono, 
                $direccion, 
                $fecha_nacimiento, 
                $username, 
                $password, 
                $rol_id, 
                $pais,
                $provincia,
                $localidad,
                $cp
            ]);

            // Si todo va bien, retorna true
            return true;
        } catch (PDOException $e) {
            // Manejo de errores
            echo "Error al agregar usuario: " . $e->getMessage();
            return false;
        }
    }
    public function addUser2_1(
        $nombre,
        $apellidos,
        $dni,
        $email,
        $telefono,
        $direccion,
        $fecha_nacimiento,
        $username,
        $password,
        $rol_id,
        $pais,
        $provincia,
        $localidad,
        $cp
        ) {
        $empleados = [];
    
        // Recorre todas las variables GET
        foreach ($_GET as $key => $value) {
            // Verifica si la clave comienza con 'emp' seguido de un número
            if (preg_match('/^emp\d+$/', $key)) {
                // Agrega el valor al array de empleados
                $empleados[] = $value;
            }
        }
    
        try {
            // Inicia una transacción para asegurar que todas las operaciones se ejecuten correctamente
            $this->pdo->beginTransaction();
    
            // Preparar la llamada al procedimiento almacenado para crear persona y usuario
            $stmt = $this->pdo->prepare("CALL crear_persona_y_usuario(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    
            // Ejecutar la consulta con los parámetros proporcionados
            $stmt->execute([
                $nombre,
                $apellidos,
                $dni,
                $email,
                $telefono,
                $direccion,
                $fecha_nacimiento,
                $username,
                $password,
                $rol_id,
                $pais,
                $provincia,
                $localidad,
                $cp
            ]);
    
            // Preparar la llamada al procedimiento almacenado para insertar en usuario_empresa
            $stmt = $this->pdo->prepare("CALL insertar_usuario_empresaID(?)");
    
            // Recorre el array de empleados y ejecuta la consulta para cada uno
            foreach ($empleados as $empleado) {
                $stmt->execute([$empleado]);
            }
    
            // Si todo ha ido bien, confirma la transacción
            $this->pdo->commit();
    
            // Retorna true si todo fue exitoso
            return true;
        } catch (PDOException $e) {
            // Si hay un error, revertir la transacción
            $this->pdo->rollBack();
            // Manejo de errores
            echo "Error al agregar usuario: " . $e->getMessage();
            return false;
        }
    } 
    public function addCliente(
        $nombre, 
        $apellidos, 
        $dni, 
        $email, 
        $telefono, 
        $direccion, 
        $fecha_nacimiento, 
        $pais,
        $provincia,
        $localidad,
        $cp

        ) {
        try {
            // Preparar la llamada al procedimiento almacenado
            $stmt = $this->pdo->prepare("CALL crear_persona(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)");

            // Ejecutar la consulta con los parámetros proporcionados
            $stmt->execute([
                $nombre, 
                $apellidos, 
                $dni, 
                $email, 
                $telefono, 
                $direccion, 
                $fecha_nacimiento, 
                $pais,
                $provincia,
                $localidad,
                $cp
            ]);

            // Si todo va bien, retorna true
            return true;
        } catch (PDOException $e) {
            // Manejo de errores
            echo "Error al agregar usuario: " . $e->getMessage();
            return false;
        }
    }
    public function editP( 
        $id, 
        $nombre, 
        $apellidos, 
        $dni, 
        $email, 
        $telefono, 
        $direccion, 
        $fecha_nacimiento, 
        $pais,
        $provincia,
        $localidad,
        $cp
        ) {
        try {
            // Preparar la llamada al procedimiento almacenado
            $stmt = $this->pdo->prepare("CALL EditarPersona(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    
            // Ejecutar la consulta con los parámetros proporcionados
            $stmt->execute([
                $id, 
                $nombre, 
                $apellidos, 
                $dni, 
                $email, 
                $telefono, 
                $direccion, 
                $pais, 
                $localidad, 
                $cp, 
                $provincia, 
                $fecha_nacimiento
            ]);
    
            // Si todo va bien, retorna true
            return true;
        } catch (PDOException $e) {
            // Manejo de errores
            echo "Error al editar persona: " . $e->getMessage();
            return false;
        }
    } 
    public function editPass( 
        $id, 
        $pass1,
        $pass2
        ) {
        try {
            // Preparar la llamada al procedimiento almacenado
            $stmt = $this->pdo->prepare("call CambiarContraseña(?, ?, ?)");
    
            // Ejecutar la consulta con los parámetros proporcionados
            $stmt->execute([
                $id,
                $pass1,
                $pass2  
            ]);
    
            // Si todo va bien, retorna true
            return true;
        } catch (PDOException $e) {
            // Manejo de errores
            echo "Error al editar persona: " . $e->getMessage();
            return false;
        }
    }   
    public function listarClientes() {
        try {
            // Consulta SQL que une las tablas empresas y personas para devolver todos los registros
            $sql = "SELECT emp.nombre AS Nombre, emp.cif AS DNI, emp.direccion AS dir, emp.telefono AS tlf, 'EMP'as 'tipo',emp.id AS 'ID',emp.provincia as 'Provincia',emp.Pais as 'Pais',emp.Localidad as 'Localidad', emp.cp as 'CP' FROM empresas emp UNION SELECT CONCAT(per.nombre, ' ', per.apellidos) AS Nombre, per.dni AS DNI, per.direccion AS dir, per.telefono AS tlf , 'Cliente' as 'tipo',per.id AS 'ID',per.provincia as 'Provincia',per.Pais as 'Pais',per.Localidad as 'Localidad', per.cp as 'CP' FROM personas per";
    
            // Prepara y ejecuta la consulta
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute();
    
            // Recupera todos los resultados
            $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
            return $resultados;
        } catch (PDOException $e) {
            error_log("Error en listarClientes: " . $e->getMessage());
            return false;
        }
    }
    public function listarEmpresas($id) {
        try {
            // Consulta SQL que une las tablas empresas y personas para devolver todos los registros
            $sql = "SELECT emp.* FROM usuarios usu join usuario_empresas ue on ue.usuario_id=usu.id join empresas_id emp on emp.id_empresa=ue.empresa_id where usu.persona_id=".$id;
    
            // Prepara y ejecuta la consulta
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute();
    
            // Recupera todos los resultados
            $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
            return $resultados;
        } catch (PDOException $e) {
            error_log("Error en listarClientes: " . $e->getMessage());
            return false;
        }
    }
    public function listarArticulos_add() {
        try {
            // Consulta SQL que une las tablas empresas y personas para devolver todos los registros
            $sql = "SELECT emp.nombre AS Nombre, emp.cif AS DNI, emp.direccion AS dir, emp.telefono AS tlf, 'EMP'as 'tipo',emp.id AS 'ID',emp.provincia as 'Provincia',emp.Pais as 'Pais',emp.Localidad as 'Localidad', emp.cp as 'CP' FROM empresas emp UNION SELECT CONCAT(per.nombre, ' ', per.apellidos) AS Nombre, per.dni AS DNI, per.direccion AS dir, per.telefono AS tlf , 'Cliente' as 'tipo',per.id AS 'ID',per.provincia as 'Provincia',per.Pais as 'Pais',per.Localidad as 'Localidad', per.cp as 'CP' FROM personas per";
    
            // Prepara y ejecuta la consulta
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute();
    
            // Recupera todos los resultados
            $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
            return $resultados;
        } catch (PDOException $e) {
            error_log("Error en listarClientes: " . $e->getMessage());
            return false;
        }
    }
    public function usuario() {
        try {
            // Consulta SQL que une las tablas empresas y personas para devolver todos los registros
            $sql = "select per.id, per.nombre as 'Nombre',concat(per.nombre,' ',per.apellidos) as 'Nombre1',per.fecha_nacimiento, per.apellidos,per.dni,per.email,per.telefono,per.direccion,per.Pais,per.provincia,per.Localidad,per.CP from usuarios us JOIN personas per  on us.persona_id=per.id where us.persona_id=".$_SESSION['user']['persona_id'] ;
    
            // Prepara y ejecuta la consulta
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute();
    
            // Recupera todos los resultados
            $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
            return $resultados;
        } catch (PDOException $e) {
            error_log("Error en listarClientes: " . $e->getMessage());
            return false;
        }
    }
    public function subirFoto(
        $id,
        $url
        ) {
        try {
            // Preparar la llamada al procedimiento almacenado
            $stmt = $this->pdo->prepare("CALL subirFoto(?, ?)");

            // Ejecutar la consulta con los parámetros proporcionados
            $stmt->execute([
                $id,
                $url
            ]);
            $_SESSION['user']['perfil']=$url;
            

            // Si todo va bien, retorna true
            return true;
        } catch (PDOException $e) {
            // Manejo de errores
            echo "Error al agregar usuario: " . $e->getMessage();
            echo "call subirFoto(".$id." ,".$url.")";
            return false;
        }
    }
    public function listarUsuarioE($id) {
        try {
            // Consulta SQL que une las tablas empresas y personas para devolver todos los registros
          //  $sql = "select u.username,u.rol_id , concat(nombre," ", Apellidos) as nombre, ei.NOMBRE_FISCAL, ei.nombre_empresa, ei.id_empresa,ue.fecha_inicio as Desde , ue.fecha_fin as Hasta from personas p join usuarios  u on p.id=u.persona_id join usuario_empresas ue on ue.usuario_id=u.id join empresas_id ei on ei.id_empresa=ue.empresa_id where ei.id_empresa in (select empresa_id from usuario_empresas up join usuarios u on u.id= up.usuario_id where u.id=$id")";
    
            // Prepara y ejecuta la consulta
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute();
    
            // Recupera todos los resultados
            $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
            return $resultados;
        } catch (PDOException $e) {
            error_log("Error en listar Usuarios Empresas: " . $e->getMessage());
            return false;
        }
    }
    public function listarSerieFact($serie,$id){
        try {
            // Consulta SQL que une las tablas empresas y personas para devolver todos los registros
            $sql = "select * from series_facturacion s where s.nombre_serie like '%gene%' and  s.id_empresa=1" ;
    
            // Prepara y ejecuta la consulta
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute();
    
            // Recupera todos los resultados
            $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
            return $resultados;
        } catch (PDOException $e) {
            error_log("Error en listar Series de Facturacion: " . $e->getMessage());
            return false;
        }
    }
    public function listarArticulos($id){
        try {
            // Consulta SQL que une las tablas empresas y personas para devolver todos los registros
            $sql = "select a.*, p.porcentaje_iva from articulos a join iva_productos p on p.id_articulo=a.id where a.id_empresa=1" ;
    
            // Prepara y ejecuta la consulta
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute();
    
            // Recupera todos los resultados
            $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
            return $resultados;
        } catch (PDOException $e) {
            error_log("Error en listar Articulo: " . $e->getMessage());
            return false;
        }
    }
    
}
?>
