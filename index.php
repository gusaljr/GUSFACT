<?php
session_start();
require_once 'config/database.php';
require_once 'controllers/AuthController.php';

$controller = new AuthController($pdo);
$controller2 = new AuthController($pdo);

if (!isset($_SESSION['user'])) {
    // Si no hay sesión iniciada, redirige al login
    $controller->login();
    } else {
        // Si la sesión está activa, usar switch para evaluar el rol
        $rol_id = $_SESSION['user']['rol_id'] ?? 0; // Aseguramos que rol_id exista

        switch ($rol_id) {
                
                
                

                case 1:
                    
                    
                case 2:
                        // Acciones para el rol 1 (Administrador)
                        //echo "Bienvenido, Gerente.";
                    // Si el rol es 2 (Usuario regular)
                    if (isset($_GET['web'])) {
                        // Verificamos el valor del parámetro 'web'
                        if ($_GET['web'] == 'profile') {
                            // Si 'web' es igual a 'profile', mostramos el perfil
                            $controller->login_profile(); // Método para cargar el perfil
                            $controller->usuario($_SESSION['user']['persona_id']);  //Método para cargar perfil del usuario
                            $controller->empresaProfile($_SESSION['user']['persona_id']);
                          
                        }
                        elseif ($_GET['web'] == 'editP') {
                            // Si 'web' es igual a 'editP', editar el perfil
                            if (isset($_GET['id'])) {
                                $id = $_GET['id'];
                                $controller->editP($id);
                            
                            }
                            
                            $controller->login_profile(); // Método para cargar el perfil
                            $controller->usuario($_SESSION['user']['persona_id']);  //Método para cargar perfil del usuario
                          
                        }
                        elseif ($_GET['web'] == 'editPass') {
                            // Si 'web' es igual a 'editP', editar el perfil
                            if (isset($_GET['id'])) {
                                $id = $_GET['id'];
                                $controller->editPass($id);
                            
                            }
                            
                            $controller->login_profile(); // Método para cargar el perfil
                            $controller->usuario($_SESSION['user']['persona_id']);  //Método para cargar perfil del usuario
                          
                        }
                        elseif ($_GET['web'] == 'out') {
                            // Si 'web' es igual a 'profile', mostramos el perfil
                            
                            $controller->login_out(); // Método para cargar el perfil
                        }
                        elseif ($_GET['web'] == 'blank') {
                            // Si 'web' es igual a 'profile', mostramos el perfil
                            
                            $controller->login_addUser(); // Método para cargar el perfil
                        }
                        elseif ($_GET['web'] == 'CImg') {
                            $target_dir="";
                            if (isset($_POST['submit'])) {
                                // Directorio donde se guardará el archivo
                                $target_dir = "fotos/";
                            
                                // Crear la carpeta si no existe
                                if (!file_exists($target_dir)) {
                                    mkdir($target_dir, 0755, true); // Crea la carpeta con permisos
                                }
                            
                                // Nombre del archivo limpio
                                $filename = basename($_FILES["file"]["name"]);
                                $target_file = $target_dir . $filename;
                                // Variable para controlar el proceso
                                $uploadOk = 1;
                            
                                // Obtener la extensión del archivo
                                $fileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));
                            
                                // Variable para los mensajes
                                $mensaje = '';
                            
                                // Verificar si el archivo es una imagen (opcional)
                                $check = getimagesize($_FILES["file"]["tmp_name"]);
                                if ($check !== false) {
                                    $mensaje .= "El archivo es una imagen - " . $check["mime"] . ".<br>";
                                    $target_dir .=$filename;
                                } else {
                                    $mensaje .= "El archivo no es una imagen.<br>";
                                    $uploadOk = 0;
                                }
                            
                                // Verificar si el archivo ya existe
                                if (file_exists($target_file)) {
                                    $mensaje .= "El archivo ya existe.<br>";
                                    $uploadOk = 0;
                                }
                            
                                // Limitar el tamaño del archivo (opcional)
                                if ($_FILES["file"]["size"] > 500000) { // 500 KB
                                    $mensaje .= "El archivo es demasiado grande.<br>";
                                    $uploadOk = 0;
                                }
                            
                                // Permitir solo ciertos tipos de archivos
                                $allowed_types = ['jpg', 'png', 'jpeg', 'gif'];
                                if (!in_array($fileType, $allowed_types)) {
                                    $mensaje .= "Solo se permiten archivos JPG, JPEG, PNG y GIF.<br>";
                                    $uploadOk = 0;
                                }
                            
                                // Comprobar si no hubo errores
                                if ($uploadOk == 0) {
                                    $mensaje .= "El archivo no se pudo subir.<br>";
                                } else {
                                    // Mover el archivo subido a la carpeta de destino
                                    if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_file)) {
                                        $mensaje .= "El archivo " . htmlspecialchars($filename) . " ha sido subido correctamente.<br>". $target_dir;;
                                    } else {
                                        $mensaje .= "Hubo un error subiendo el archivo.<br>". $target_dir;
                                    }
                                }
                                $controller->subirFoto($_SESSION['user']['persona_id'],$target_dir,);                           
                                $controller->login_profile(); // Método para cargar el perfil
                                $controller->usuario($_SESSION['user']['persona_id']);  //Método para cargar perfil del usuario
                            }
                            
                            
                        }
                        elseif ($_GET['web'] == 'login_blank') {
                            // Si 'web' es igual a 'profile', mostramos el perfil
                            
                            $controller->login_blank(); // Método para cargar el perfil
                        }
                        elseif ($_GET['web'] == 'login_addUser2') {
                            // Si 'web' es igual a 'profile', mostramos el perfil
                            
                            $controller->login_addUser2(); // Método para cargar el perfil
                        }
                        elseif ($_GET['web'] == 'addCliente') {
                            // Si 'web' es igual a 'profile', mostramos el perfil
                            
                            $controller->login_addCliente(); // Método para cargar el perfil
                        }
                        elseif ($_GET['web'] == 'add_cliente') {
                            // Si 'web' es igual a 'profile', mostramos el perfil
                            
                            $controller->add_cliente(); // Método para cargar el perfil
                        }
                        elseif ($_GET['web'] == 'addUser') {
                            // Si 'web' es igual a 'profile', mostramos el perfil
                            
                            $controller->login_addUser(); // Método para cargar el perfil
                            $controller->login_addUser_Empresa($_SESSION['user']['persona_id']);
                        } 
                        elseif ($_GET['web'] == 'fact') {
                            // Si 'web' es igual a 'profile', mostramos el perfil
                            
                            $controller->login_fact(); // Método para cargar el perfil
                            $controller->listarClientes(); // Método listar clientes
                            $controller->listarSerieFact('Gene',1 ); // Método listar Series de Facturacion
                            $controller->listarArticulos(1);
                            // Verificar si se recibieron los datos
                            $clienteid ="";
                            if (isset($_POST['clienteid']) && isset($_POST['serie']) && isset($_POST['fecha']) && isset($_POST['empresaid']) && isset($_POST['username'])) {
                                
                                // Asignar los valores recibidos a variables PHP
                                $clienteid = $_POST['clienteid'];
                                $serie = $_POST['serie'];
                                $fecha = $_POST['fecha'];
                                $empresaid = $_POST['empresaid'];
                                $username = $_POST['username'];
                                
                                // Puedes manejar las variables o devolver una respuesta
                                echo "Datos recibidos:\n";
                                echo "Cliente ID: " . $clienteid . "\n";
                                echo "Serie: " . $serie . "\n";
                                echo "Fecha: " . $fecha . "\n";
                                echo "Empresa ID: " . $empresaid . "\n";
                                echo "Username: " . $username;
                            } else {
                                echo "No se recibieron todos los datos.". $clienteid;
                            }
                        }
                        else {
                            // Si 'web' está definido, pero no es 'profile', muestra el contenido estándar
                        
                            // Otras acciones según sea necesario
                        }
                    } else {
                        // Si no está definido 'web', mostrar pantalla predeterminada para el rol 2
                        
                        $controller->login_IN(); // Método para la pantalla principal
                    }
                    break;
                        // Aquí puedes agregar la lógica específica del rol 2
                     break;

                    case 3:
                        // Acciones para el rol 3 (Otro tipo de rol)
                        echo "Bienvenido, Moderador.";
                        // Aquí puedes agregar la lógica específica del rol 3
                        break;

                    default:
                        // Si el rol no es reconocido, redirigir o mostrar un mensaje de error
                        echo "Rol no reconocido. Contacta con el administrador.";
                        break;
                }
}
?>
