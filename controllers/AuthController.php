<?php
require_once 'models/User.php';

class AuthController {
    private $userModel;

    public function __construct($pdo) {
        $this->userModel = new User($pdo);
    }
    public function login() {
       

        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            // Obtener y sanitizar los datos del formulario
            $username = filter_input(INPUT_POST, 'username', FILTER_SANITIZE_STRING);
            $password = filter_input(INPUT_POST, 'password', FILTER_SANITIZE_STRING);

            // Llamar al método authenticate del modelo
            $userData = $this->userModel->authenticate($username, $password);

            // Verificar los resultados de la autenticación
            if ($userData && !empty($userData['username_result'])) {
                // Autenticación exitosa
                $_SESSION['user'] = [
                    'username' => $userData['username_result'],
                    'rol_id' => $userData['rol_id'],
                    'persona_id' => $userData['persona_id'],
                    'perfil' => $userData['perfil']
                ];
                 var_dump($_SESSION['user']);
               
                // Redirigir al dashboard
                require_once( 'public/static/index.php');
                exit();
            } else {
                // Autenticación fallida
                $error = 'Nombre de usuario o contraseña incorrectos.';
                include 'views/login.php'; // Mostrar el formulario de login con el mensaje de error
            }
        } else {
            // Mostrar el formulario de inicio de sesión
            include 'views/login.php';
        }
    }
    public function login_IN() {
        require_once 'public/static/index.php';  
    }
    public function login_profile() {
        require_once 'public/static/pages-profile.php';  
    }
    public function login_addUser() {
        require_once 'public/static/pages-AddUser.php';  
    }
    public function login_addCliente() {
        require_once 'public/static/pages-clientes.php';  
    }
    public function login_blank() {
        require_once 'public/static/pages-blank.php';  
    }
    public function login_fact() {
        require_once 'public/static/pages-fact.php';  
    }
    public function login_addUser2() {
        $empleados = [];

        // Recorre todas las variables GET
        foreach ($_GET as $key => $value) {
            // Verifica si la clave comienza con 'emp' seguido de un número
            if (preg_match('/^emp\d+$/', $key)) {
                // Agrega el valor al array de empleados
                $empleados[] = $value;
            }
        }
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            // Obtener datos del formulario
            $nombre = $_POST['nombre'];
            $apellidos = $_POST['apellidos'];
            $dni = $_POST['dni'];
            $email = $_POST['email'];
            $telefono = $_POST['telefono'];
            $direccion = $_POST['direccion'];
            $fecha_nacimiento = $_POST['fecha_nacimiento'];
            $username = $_POST['username'];
            $password = $_POST['password'];
            $pais=$_POST['pais'];
            $localidad=$_POST['localidad'];
            $cp=$_POST['cp'];
            $provincia=$_POST['provincia'];
            $rol_id = $_POST['rol_id'];

            // Llamar al modelo para agregar el usuario
            $success = $this->userModel->addUser2_1(
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
            );
            $call= "CALL crear_persona_y_usuario(". $nombre.",".$apellidos.",".$dni.",".$email.",".$telefono.",".$direccion.",".$fecha_nacimiento.",".$username.",".$password.",".$rol_id.",".$pais.",".$provincia.",".$localidad.",".$cp.")";
            echo $call;
            if ($success) {
                echo "Usuario creado con éxito.";
                // Redirigir o mostrar una página de éxito
                header("Location: index.php?web=addUser");
                exit();
            } else {
                echo "Error al crear usuario.";
            }
        } else {
            echo "Método no permitido.";
        }
    }
    public function editP($id) {
        
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            // Obtener datos del formulario
            $nombre = $_POST['nombre'];
            $apellidos = $_POST['apellidos'];
            $dni = $_POST['dni'];
            $email = $_POST['email'];
            $telefono = $_POST['telefono'];
            $direccion = $_POST['direccion'];
            $fecha_nacimiento = $_POST['fecha_nacimiento'];
            $pais=$_POST['pais'];
            $localidad=$_POST['localidad'];
            $cp=$_POST['cp'];
            $provincia=$_POST['provincia'];

            // Llamar al modelo para agregar el usuario
            $success = $this->userModel->editP(
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
            );
            $call= "CALL crear_persona_y_usuario(". $nombre.",".$apellidos.",".$dni.",".$email.",".$telefono.",".$direccion.",".$fecha_nacimiento.",".$username.",".$password.",".$rol_id.",".$pais.",".$provincia.",".$localidad.",".$cp.")";
            echo $call;
            if ($success) {
                echo "Usuario creado con éxito.";
                // Redirigir o mostrar una página de éxito
                header("Location: index.php?web=profile");
                exit();
            } else {
                echo "Error al crear usuario.";
            }
        } else {
            echo "Método no permitido.";
        }
    }
    public function editPass($id) {
        
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            // Obtener datos del formulario
            $nombre = $_POST['oldPassword'];
            $passold = $_POST['oldPassword'];
            $pass1 = $_POST['newPassword'];
           
            // Llamar al modelo para agregar el usuario
            $success = $this->userModel->editPass(
                $id,
                $passold, 
                $pass1
            );
           // $call= "CALL crear_persona_y_usuario(". $nombre.",".$apellidos.",".$dni.",".$email.",".$telefono.",".$direccion.",".$fecha_nacimiento.",".$username.",".$password.",".$rol_id.",".$pais.",".$provincia.",".$localidad.",".$cp.")";
          //  echo $call;
            if ($success) {
                echo "Usuario creado con éxito.";
                // Redirigir o mostrar una página de éxito
                header("Location: index.php?web=profile");
                exit();
            } else {
                echo "Error al crear usuario.";
            }
        } else {
            echo "Método no permitido.";
        }
    }
    public function add_Cliente() {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            // Obtener datos del formulario
            $nombre = $_POST['nombre'];
            $apellidos = $_POST['apellidos'];
            $dni = $_POST['dni'];
            $email = $_POST['email'];
            $telefono = $_POST['telefono'];
            $direccion = $_POST['direccion'];
            $fecha_nacimiento = $_POST['fecha_nacimiento'];
            $pais=$_POST['pais'];
            $localidad=$_POST['localidad'];
            $cp=$_POST['cp'];
            $provincia=$_POST['provincia'];
           

            // Llamar al modelo para agregar el usuario
            $success = $this->userModel->addCliente(
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
            );
            $call= "CALL crear_persona(". $nombre.",".$apellidos.",".$dni.",".$email.",".$telefono.",".$direccion.",".$fecha_nacimiento.",".$pais.",".$provincia.",".$localidad.",".$cp.")";
            echo $call;
            if ($success) {
                echo "Usuario creado con éxito.";
                // Redirigir o mostrar una página de éxito
                header("Location: index.php?web=blank");
                exit();
            } else {
                echo "Error al crear usuario.";
            }
        } else {
            echo "Método no permitido.";
        }
    }
    public function listarClientes() {
        // Obtener los datos del modelo
        $clientes = $this->userModel->listarClientes();
         //var_dump($clientes);
        
        // Verificar si se obtuvieron resultados
        if ($clientes) {
            // Aquí puedes pasar los datos a la vista o retornar en formato JSON si es una API
           // Convertir el array PHP a JSON
            $jsonClientes = json_encode($clientes);

            // Insertar el JSON en el JavaScript con echo
            echo "<script type='text/javascript'>
                    var clientes = $jsonClientes;
                    console.log(clientes);
                 </script>";
        } else {
            // Manejo de error en caso de que la consulta falle
            echo json_encode(["error" => "No se pudieron obtener los clientes."]);
        }
    }
    public function usuario($id) {
        // Obtener los datos del modelo
        $clientes = $this->userModel->usuario($id);
        $jsonClientes = json_encode($clientes);

        // Insertar el JSON en el JavaScript con echo
        echo "<script type='text/javascript'>
                var clientes = $jsonClientes;
                console.log(clientes[0]);
                document.getElementById('titulo').innerHTML =clientes[0].Nombre1;
                document.getElementById('texto').innerHTML ='<strong>DNI: </strong>'+clientes[0].dni+'<br><strong>Email: </strong>'+clientes[0].email + '<br><strong>TLF: </strong>'+clientes[0].telefono+'<br><strong>Dirección </strong><br>'+clientes[0].Pais+' '+clientes[0].provincia+'<br>'+clientes[0].Localidad+' - '+clientes[0].CP+'<br>'+clientes[0].direccion;
                document.getElementById('nombre').value=clientes[0].Nombre;
                document.getElementById('apellidos').value=clientes[0].apellidos;
                document.getElementById('dni').value=clientes[0].dni;
                document.getElementById('email').value=clientes[0].email;
                document.getElementById('fecha_nacimiento').value=clientes[0].fecha_nacimiento;
                document.getElementById('direccion').value=clientes[0].direccion;
                document.getElementById('pais').value=clientes[0].Pais;
                document.getElementById('localidad').value=clientes[0].Localidad;
                document.getElementById('cp').value=clientes[0].CP;
                document.getElementById('provincia').value=clientes[0].provincia;
                document.getElementById('telefono').value=clientes[0].telefono;
                document.getElementById('editProfile').action='index.php?web=editP&&id='+clientes[0].id;
                document.getElementById('passwordForm').action='index.php?web=editPass&&id='+clientes[0].id;

                

                </script>";       
    }
    public function empresaProfile($id) {
        // Obtener la lista de empresas
        $clientes = $this->userModel->listarEmpresas($id);
    
        // Convertir el array PHP a JSON, escapando los caracteres especiales para evitar problemas en HTML/JS
        $jsonEmpresa = json_encode($clientes, JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT);
    
        // Incluir el JSON seguro en el JavaScript dentro del HTML
        echo '
        <script type="text/javascript">
            var empresas = ' . $jsonEmpresa . ';
            console.log(empresas);
        
            var tabla = "<table class=\'table table-striped table-hover\'>\
                <thead class=\'table-dark\'>\
                    <tr>\
                        <th>ID</th>\
                        <th>Empresa</th>\
                        <th>Razón Social</th>\
                        <th>NIF</th>\
                    </tr>\
                </thead>\
                <tbody>";
    
            for (var i = 0; i < empresas.length; i++) {
                tabla += "<tr onclick=\'mostrarDetalles(" + i + ")\'>\
                            <td>" + (i + 1) + "</td>\
                            <td>" + empresas[i].nombre_empresa + "</td>\
                            <td>" + empresas[i].NOMBRE_FISCAL + "</td>\
                            <td>" + empresas[i].nif + "</td>\
                        </tr>";
            }
            
            tabla += "</tbody></table>";
            document.getElementById("tEmp").innerHTML = tabla;
    
            function mostrarDetalles(index) {
                var empresa = empresas[index];
                var detalles = "<h3>Detalles de la Empresa</h3>\
                                <p><strong>Nombre:</strong> " + empresa.nombre_empresa + "<br>\
                                <strong>Razón Social:</strong> " + empresa.NOMBRE_FISCAL + "<br>\
                                <strong>NIF:</strong> " + empresa.nif + "<br>\
                                <strong>Dirección:</strong> " + empresa.direccion_empresa + "<br>\
                                <strong>Localidad:</strong> " + empresa.Localidad + "<br>\
                                <strong>Provincia:</strong> " + empresa.Provincia + "<br>\
                                <strong>CP:</strong> " + empresa.CP + "<br>\
                                <strong>País:</strong> " + empresa.Pais + "<br>\
                                <strong>Email:</strong> " + empresa.email_empresa + "<br>\
                                <strong>Teléfono:</strong> " + empresa.telefono_empresa + "<br>\
                                <strong>Fecha de Inicio:</strong> " + empresa.fecha_inicio + "<br>\
                                <strong>Fecha de Fin:</strong> " + empresa.fecha_fin + "</p>"+
                                "<a class=\"btn btn-primary \">Editar Empresa</a>   "+
                                "<a class=\"btn btn-primary \">Cambiar Logo</a>   "+
                                "<a class=\"btn btn-primary \">Solicitud de Renovacion</a>  "+
                                "<a class=\"btn btn-primary \">Accesos</a>"
                                
                                ;
                        
                                var div = document.getElementById("imgEmp");

                                // Crear un nuevo elemento img
                                var imagen = document.createElement("img");
                                
                                // Asignar la URL de la imagen
                                imagen.src = empresa.logo_empresa;  // Aquí pones la URL de la imagen que quieras
                                
                                // Añadir atributos opcionales como el ancho y el alto
                                imagen.width = 300;  // Ajusta el ancho
                                imagen.height = 300; // Ajusta la altura
                                imagen.alt = "Descripción de la imagen"; // Texto alternativo para la imagen

                                // Insertar la imagen en el div
                                div.appendChild(imagen);

                document.getElementById("detallesEmpresa").innerHTML = detalles;
                document.getElementById("detallesEmpresa").style.display = "block"; // Mostrar el div
            }
        </script>';
    
        
    }
    public function login_addUser_Empresa($id) {
        // Obtener la lista de empresas
        $clientes = $this->userModel->listarEmpresas($id);
    
        // Convertir el array PHP a JSON, escapando los caracteres especiales para evitar problemas en HTML/JS
        $jsonEmpresa = json_encode($clientes, JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT);
    
        // Incluir el JSON seguro en el JavaScript dentro del HTML
        echo '
        <script type="text/javascript">
            // Variable JavaScript para almacenar las empresas
            var empresas = ' . $jsonEmpresa . ';
            console.log(empresas);
    
            // Generar los botones dinámicamente
            var text = "";
            for (var i = 0; i < empresas.length; i++) {
                text += "<a class=\'btn btn-primary mb-3\' href=\'#\' onclick=\"empr(" + empresas[i].id_empresa + ", this)\">" + empresas[i].nombre_empresa + "</a> ";
            }
            document.getElementById(\'Empbtn\').innerHTML = text;
    
            var url = "index.php?web=login_addUser2";
            var i = 0;
    
            // Función para manejar el clic en cada empresa
            function empr(id, element) {
                // Actualizamos la URL con los parámetros seleccionados
                url += "&&emp" + i + "=" + id;
                i++;
                console.log(url);
    
                // Simular desactivación: deshabilitar la acción de clic del enlace
                element.classList.add(\'disabled\');  // Añadir una clase CSS que lo deshabilite
                element.onclick = function(event) { event.preventDefault(); };  // Prevenir futuros clics
    
                // Asignar la nueva URL al formulario
                document.getElementById("formRU").action = url;
            }
        </script>';
    }
    public function listarSerieFact($serie,$id){
       // Obtener los datos del modelo
       $clientes = $this->userModel->listarSerieFact($serie,$id);
       //var_dump($clientes);
      
      // Verificar si se obtuvieron resultados
      if ($clientes) {
            // Convertir el array PHP a JSON
            $jsonClientes = json_encode($clientes);
        
            // Insertar el JSON en el JavaScript con echo
            echo "<script type='text/javascript'>
                    var series = JSON.parse('$jsonClientes'); // Parsear el JSON en un objeto de JavaScript
                    console.log(series);  // Mostrar el array parseado en la consola
        
                    var selectElement = document.getElementById('SerieFact');
                        serie=series[0].id_serie;
                        empresaid=series[0].id_empresa;
                        console.log('serie='+ serie);
                        console.log('empresaid='+ empresaid);
                     var option = document.createElement('option');
                     
                        option.value = series[0].id_serie
                        option.text =series[0].nombre_serie+' - '+series[0].prefijo_serie;
                        selectElement.appendChild(option);
        
                   
                  
                       
                   
                </script>";
        } else {
            // Manejo de error en caso de que la consulta falle
            echo "<script type='text/javascript'>
                    console.error('No se pudieron obtener las series de facturación.');
                </script>";
        }
    }
    public function listarArticulos($id) {
        // Obtener los datos del modelo
        $articulos = $this->userModel->listarArticulos($id);
        
        // Verificar si se obtuvieron resultados
        if ($articulos) {
            // Convertir el array PHP a JSON
            $jsonArticulos = json_encode($articulos);
    
            // Escapar las comillas para evitar errores de JavaScript
            $jsonArticulos = addslashes($jsonArticulos);
    
            // Insertar el JSON en el JavaScript con echo
            echo "<script type='text/javascript'>
                    var articulos = JSON.parse('$jsonArticulos'); // Parsear el JSON en un objeto de JavaScript
                    console.log(articulos);  // Mostrar el array parseado en la consola
                  </script>";
        } else {
            // Manejo de error en caso de que la consulta falle
            echo "<script type='text/javascript'>
                    console.error('No se pudieron obtener los artículos.');
                  </script>";
        }
    
        echo "<script type='text/javascript'>
        function showSuggestions(value) {
            const suggestionsContainer = document.getElementById('suggestions');
            suggestionsContainer.innerHTML = '';
            
            // Solo busca si hay texto en el input
            if (value.length > 0) {
                const filteredArticulos = articulos.filter(function(item) {
                    return item.nombre.toLowerCase().includes(value.toLowerCase());
                });
        
                // Muestra un máximo de 5 sugerencias
                for (let i = 0; i < Math.min(filteredArticulos.length, 5); i++) {
                    const item = filteredArticulos[i];
                    const suggestionItem = document.createElement('li');
                    suggestionItem.textContent = item.nombre + ' - ' + item.descripcion;
                    suggestionItem.onclick = function() {
                        // Coloca el nombre del artículo en el input
                        document.getElementById('art').value = item.nombre;
        
                        // Asume que la cantidad es 1
                        const cantidad = 1;
                        
                        // Rellenar el campo cantidad (por defecto 1)
                        document.getElementById('cantidad').value = cantidad;
                        
                        // Rellenar el precio unitario
                        document.getElementById('precio_unitario').value = item.precio_base;
                        
                        // Rellenar el IVA
                        document.getElementById('iva').value = item.iva;
        
                        // Función para actualizar los cálculos
                        function actualizarCalculos() {
                            // Obtener los valores actuales
                            const cantidad = parseFloat(document.getElementById('cantidad').value);
                            const precioUnitario = parseFloat(document.getElementById('precio_unitario').value);
                            const iva = parseFloat(document.getElementById('iva').value);
                            const descuento = parseFloat(document.getElementById('descuento').value) || 0;
        
                            // Calcular el subtotal (cantidad * precio unitario)
                            const subtotal = precioUnitario * cantidad;
                            document.getElementById('subtotal').value = subtotal.toFixed(2);
        
                            // Calcular el descuento
                            const descuentoAplicado = (subtotal * descuento) / 100;
                            const subtotalConDescuento = subtotal - descuentoAplicado;
                            document.getElementById('subtotal').value = subtotalConDescuento.toFixed(2);
        
                            // Calcular el impuesto (subtotal con descuento * iva / 100)
                            const impuesto = (subtotalConDescuento * iva) / 100;
                            document.getElementById('impuesto').value = impuesto.toFixed(2);
        
                            // Calcular el total de línea (subtotal con descuento + impuesto)
                            const totalLinea = subtotalConDescuento + impuesto;
                            document.getElementById('total_linea').value = totalLinea.toFixed(2);
                        }
        
                        // Llamar a la función de cálculos inicialmente
                        actualizarCalculos();
        
                        // Añadir eventos para actualizar al cambiar la cantidad, el precio unitario y el descuento
                        document.getElementById('cantidad').oninput = actualizarCalculos;
                        document.getElementById('precio_unitario').oninput = actualizarCalculos;
                        document.getElementById('descuento').oninput = actualizarCalculos;
        
                        // Ocultar las sugerencias
                        suggestionsContainer.style.display = 'none';
                    };
                    suggestionsContainer.appendChild(suggestionItem);
                }
        
                // Muestra las sugerencias si hay resultados
                suggestionsContainer.style.display = filteredArticulos.length > 0 ? 'block' : 'none';
            } else {
                suggestionsContainer.style.display = 'none'; // Oculta si no hay texto
            }
        }
        </script>";
        
        
        
    }
    
    
    
    
    public function login_out(){
        session_destroy();
       $this-> login();

    }
    public function subirFoto($id,$url){
        $clientes = $this->userModel->subirFoto($id,$url);        
    }
}
?>
