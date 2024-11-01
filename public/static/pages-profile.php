<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="description" content="Responsive Admin &amp; Dashboard Template based on Bootstrap 5">
	<meta name="author" content="Fact-Gus">
	<meta name="keywords"
		content="Fact-Gus, bootstrap, bootstrap 5, admin, dashboard, template, responsive, css, sass, html, theme, front-end, ui kit, web">

	<link rel="preconnect" href="https://fonts.gstatic.com">
	<link rel="shortcut icon" href="public/static/img/icons/icon-48x48.png" />

	<link rel="canonical" href="https://demo-basic.Fact-Gus.io/pages-profile.php" />

	<title>Profile | Fact-Gus Demo</title>

	<link href="public/static/css/app.css" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>

<body>
	<div class="wrapper">
		<nav id="sidebar" class="sidebar js-sidebar">
			<div class="sidebar-content js-simplebar">
				<a class="sidebar-brand" href="index.php">
					<span class="align-middle">Fact-Gus</span>
				</a>

				<ul class="sidebar-nav">
					<li class="sidebar-header">
						Pages
					</li>

					<li class="sidebar-item">
						<a class="sidebar-link" href="index.php">
							<i class="align-middle" data-feather="sliders"></i> <span
								class="align-middle">Dashboard</span>
						</a>
					</li>

					<li class="sidebar-item active">
						<a class="sidebar-link" href="index.php?web=profile">
							<i class="align-middle" data-feather="user"></i> <span class="align-middle">Profile</span>
						</a>
					</li>

					<li class="sidebar-item">
						<a class="sidebar-link" href="index.php?web=out">
							<i class="align-middle" data-feather="log-in"></i> <span class="align-middle">Sign In</span>
						</a>
					</li>

					<li class="sidebar-item">
						<a class="sidebar-link" href="index.php?web=addUser">
							<i class="align-middle" data-feather="user-plus"></i> <span class="align-middle">Sign
								Up</span>
						</a>
					</li>

					<li class="sidebar-item">
						<a class="sidebar-link" href="index.php?web=login_blank">
							<i class="align-middle" data-feather="book"></i> <span class="align-middle">Blank</span>
						</a>
					</li>

					<li class="sidebar-header">
						Gestion Empresa
					</li>

					<li class="sidebar-item">
						<a class="sidebar-link" href="index.php?web=fact">
							<i class="align-middle" data-feather="edit"></i>
							<span class="align-middle">Facturas</span>
						</a>
					</li>
					<li class="sidebar-item">
						<a class="sidebar-link" href="index.php?web=pre">
							<i class="align-middle" data-feather="edit"></i>
							<span class="align-middle">Presupuestos</span>
						</a>
					</li>
					<li class="sidebar-item">
						<a class="sidebar-link" href="index.php?web=con">
							<i class="align-middle" data-feather="edit-3"></i>
							<span class="align-middle">Contratos</span>
						</a>
					</li>

					<li class="sidebar-item">
						<a class="sidebar-link" href="ui-buttons.html">
							<i class="align-middle" data-feather="square"></i> <span class="align-middle">Buttons</span>
						</a>
					</li>

					<li class="sidebar-item">
						<a class="sidebar-link" href="ui-forms.html">
							<i class="align-middle" data-feather="check-square"></i> <span
								class="align-middle">Forms</span>
						</a>
					</li>

					<li class="sidebar-item">
						<a class="sidebar-link" href="ui-cards.html">
							<i class="align-middle" data-feather="grid"></i> <span class="align-middle">Cards</span>
						</a>
					</li>

					<li class="sidebar-item">
						<a class="sidebar-link" href="ui-typography.html">
							<i class="align-middle" data-feather="align-left"></i> <span
								class="align-middle">Typography</span>
						</a>
					</li>

					<li class="sidebar-item">
						<a class="sidebar-link" href="icons-feather.html">
							<i class="align-middle" data-feather="coffee"></i> <span class="align-middle">Icons</span>
						</a>
					</li>

					<li class="sidebar-header">
						Plugins & Addons
					</li>

					<li class="sidebar-item">
						<a class="sidebar-link" href="charts-chartjs.html">
							<i class="align-middle" data-feather="bar-chart-2"></i> <span
								class="align-middle">Charts</span>
						</a>
					</li>

					<li class="sidebar-item">
						<a class="sidebar-link" href="maps-google.html">
							<i class="align-middle" data-feather="map"></i> <span class="align-middle">Maps</span>
						</a>
					</li>
				</ul>

				<div class="sidebar-cta">
					<div class="sidebar-cta-content">
						<strong class="d-inline-block mb-2">Upgrade to Pro</strong>
						<div class="mb-3 text-sm">
							Are you looking for more components? Check out our premium version.
						</div>
						<div class="d-grid">
							<a href="upgrade-to-pro.html" class="btn btn-primary">Upgrade to Pro</a>
						</div>
					</div>
				</div>
			</div>
		</nav>

		<div class="main">
			<nav class="navbar navbar-expand navbar-light navbar-bg">
				<a class="sidebar-toggle js-sidebar-toggle">
					<i class="hamburger align-self-center"></i>
				</a>

				<div class="navbar-collapse collapse">
					<ul class="navbar-nav navbar-align">
						<li class="nav-item dropdown">
							<a class="nav-icon dropdown-toggle" href="#" id="alertsDropdown" data-bs-toggle="dropdown">
								<div class="position-relative">
									<i class="align-middle" data-feather="bell"></i>
									<span class="indicator">4</span>
								</div>
							</a>
							<div class="dropdown-menu dropdown-menu-lg dropdown-menu-end py-0"
								aria-labelledby="alertsDropdown">
								<div class="dropdown-menu-header">
									4 New Notifications
								</div>
								<div class="list-group">
									<a href="#" class="list-group-item">
										<div class="row g-0 align-items-center">
											<div class="col-2">
												<i class="text-danger" data-feather="alert-circle"></i>
											</div>
											<div class="col-10">
												<div class="text-dark">Update completed</div>
												<div class="text-muted small mt-1">Restart server 12 to complete the
													update.</div>
												<div class="text-muted small mt-1">30m ago</div>
											</div>
										</div>
									</a>
									<a href="#" class="list-group-item">
										<div class="row g-0 align-items-center">
											<div class="col-2">
												<i class="text-warning" data-feather="bell"></i>
											</div>
											<div class="col-10">
												<div class="text-dark">Lorem ipsum</div>
												<div class="text-muted small mt-1">Aliquam ex eros, imperdiet vulputate
													hendrerit et.</div>
												<div class="text-muted small mt-1">2h ago</div>
											</div>
										</div>
									</a>
									<a href="#" class="list-group-item">
										<div class="row g-0 align-items-center">
											<div class="col-2">
												<i class="text-primary" data-feather="home"></i>
											</div>
											<div class="col-10">
												<div class="text-dark">Login from 192.186.1.8</div>
												<div class="text-muted small mt-1">5h ago</div>
											</div>
										</div>
									</a>
									<a href="#" class="list-group-item">
										<div class="row g-0 align-items-center">
											<div class="col-2">
												<i class="text-success" data-feather="user-plus"></i>
											</div>
											<div class="col-10">
												<div class="text-dark">New connection</div>
												<div class="text-muted small mt-1">Christina accepted your request.
												</div>
												<div class="text-muted small mt-1">14h ago</div>
											</div>
										</div>
									</a>
								</div>
								<div class="dropdown-menu-footer">
									<a href="#" class="text-muted">Show all notifications</a>
								</div>
							</div>
						</li>
						<li class="nav-item dropdown">
							<a class="nav-icon dropdown-toggle" href="#" id="messagesDropdown"
								data-bs-toggle="dropdown">
								<div class="position-relative">
									<i class="align-middle" data-feather="message-square"></i>
								</div>
							</a>
							<div class="dropdown-menu dropdown-menu-lg dropdown-menu-end py-0"
								aria-labelledby="messagesDropdown">
								<div class="dropdown-menu-header">
									<div class="position-relative">
										4 New Messages
									</div>
								</div>
								<div class="list-group">
									<a href="#" class="list-group-item">
										<div class="row g-0 align-items-center">
											<div class="col-2">
												<img src="<?php echo $_SESSION['user']['perfil']?>"
													class="avatar img-fluid rounded-circle" alt="Vanessa Tucker">
											</div>
											<div class="col-10 ps-2">
												<div class="text-dark">Vanessa Tucker</div>
												<div class="text-muted small mt-1">Nam pretium turpis et arcu. Duis arcu
													tortor.</div>
												<div class="text-muted small mt-1">15m ago</div>
											</div>
										</div>
									</a>
									<a href="#" class="list-group-item">
										<div class="row g-0 align-items-center">
											<div class="col-2">
												<img src="<?php echo $_SESSION['user']['perfil']?>"
													class="avatar img-fluid rounded-circle" alt="William Harris">
											</div>
											<div class="col-10 ps-2">
												<div class="text-dark">William Harris</div>
												<div class="text-muted small mt-1">Curabitur ligula sapien euismod
													vitae.</div>
												<div class="text-muted small mt-1">2h ago</div>
											</div>
										</div>
									</a>
									<a href="#" class="list-group-item">
										<div class="row g-0 align-items-center">
											<div class="col-2">
												<img src="<?php echo $_SESSION['user']['perfil']?>"
													class="avatar img-fluid rounded-circle" alt="Christina Mason">
											</div>
											<div class="col-10 ps-2">
												<div class="text-dark">Christina Mason</div>
												<div class="text-muted small mt-1">Pellentesque auctor neque nec urna.
												</div>
												<div class="text-muted small mt-1">4h ago</div>
											</div>
										</div>
									</a>
									<a href="#" class="list-group-item">
										<div class="row g-0 align-items-center">
											<div class="col-2">
												<img src="public/static/img/avatars/avatar-3.jpg"
													class="avatar img-fluid rounded-circle" alt="Sharon Lessman">
											</div>
											<div class="col-10 ps-2">
												<div class="text-dark">Sharon Lessman</div>
												<div class="text-muted small mt-1">Aenean tellus metus, bibendum sed,
													posuere ac, mattis non.</div>
												<div class="text-muted small mt-1">5h ago</div>
											</div>
										</div>
									</a>
								</div>
								<div class="dropdown-menu-footer">
									<a href="#" class="text-muted">Show all messages</a>
								</div>
							</div>
						</li>
						<li class="nav-item dropdown">
							<a class="nav-icon dropdown-toggle d-inline-block d-sm-none" href="#"
								data-bs-toggle="dropdown">
								<i class="align-middle" data-feather="settings"></i>
							</a>

							<a class="nav-link dropdown-toggle d-none d-sm-inline-block" href="#"
								data-bs-toggle="dropdown">
								<img src="<?php echo $_SESSION['user']['perfil']?>"
									class="avatar img-fluid rounded me-1" alt="Charles Hall" /> <span class="text-dark">
									<?php echo $_SESSION['user']['username']?>

								</span>
							</a>
							<div class="dropdown-menu dropdown-menu-end">
								<a class="dropdown-item" href="index.php?web=profile"><i class="align-middle me-1"
										data-feather="user"></i> Profile</a>
								<a class="dropdown-item" href="#"><i class="align-middle me-1"
										data-feather="pie-chart"></i> Analytics</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item" href="index.php"><i class="align-middle me-1"
										data-feather="settings"></i> Settings & Privacy</a>
								<a class="dropdown-item" href="#"><i class="align-middle me-1"
										data-feather="help-circle"></i> Help Center</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item" href="index.php?web=out">Log out</a>
							</div>
						</li>
					</ul>
				</div>
			</nav>

			<main class="content">
				<div class="container-fluid p-0">
					<b>
						<h1 class="h1 mb-3">Manager Profile</h1>
					</b>
					<div class="row">
						<div class="col-12">
							<div class=" col-12 card row">
								<div class="container">
									<div class="row">
										<div class="col-lg-6">
											<div class="card col-lg-12">
												<img class="card-img-top" src="<?php echo $_SESSION['user']['perfil']?>"
													alt="Card image" style="width:300px">
												<div class="card-body">
													<h4 class="card-title" id="titulo"></h4>
													<p class="card-text" id="texto">Some example text some example text.
														John Doe is an architect and engineer</p>
													<button type="button" class="btn btn-primary" data-bs-toggle="modal"
														data-bs-target="#exampleModal">
														Editar Perfil
													</button>
													<button type="button" class="btn btn-primary" data-bs-toggle="modal"
														data-bs-target="#miModal">
														Cambio de Password
													</button>
													<button type="button" class="btn btn-primary" data-bs-toggle="modal"
														data-bs-target="#miModal2">
														Cambio de Imagen
													</button>
												</div>
											</div>
										</div>
										<div class="col-lg-6">
											<div class="card col-lg-12"  id="tEmp1">
												<div class="container mt-5">
													<h2 class="mb-4">Lista de Empresas</h2>
													<div id="tEmp"></div> <!-- Cambiado a tEmp -->
													<div id="imgEmp" class="img-thumbnail" width="304" height="236"></div>
													<div id="detallesEmpresa" style="display:none; border: 1px solid #ccc; padding: 10px; margin-top: 20px; background-color: #f9f9f9;"></div>
												</div>
												<div class="card" style="width:400px" id="tEmp">										
												</div>									
											</div>
									</div>
								</div>
							</div>
						</div>

					</div>
				</div>
			</main>


			<!-- Modal -->
			<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel"	aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="exampleModalLabel">Modificar Perfil</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="modal-body">
							<form action="index.php?web=add_cliente" method="POST" class="row" id="editProfile">
								<!-- Nombre -->
								<div class="mb-3">
									<label for="nombre" class="form-label">Nombre</label>
									<input type="text" class="form-control" id="nombre" name="nombre" maxlength="100"
										required>
								</div>

								<!-- Apellidos -->
								<div class="mb-3">
									<label for="apellidos" class="form-label">Apellidos</label>
									<input type="text" class="form-control" id="apellidos" name="apellidos"
										maxlength="100" required>
								</div>

								<!-- DNI -->
								<div class="mb-3 col-6">
									<label for="dni" class="form-label">DNI</label>
									<input type="text" class="form-control" id="dni" name="dni" maxlength="20" required>
								</div>

								<!-- Correo Electrónico -->
								<div class="mb-3 col-6">
									<label for="email" class="form-label">Correo Electrónico</label>
									<input type="email" class="form-control" id="email" name="email" maxlength="100"
										required>
								</div>

								<div class="mb-3 col-6">
									<label for="fecha_nacimiento" class="form-label">Fecha de Nacimiento</label>
									<input type="date" class="form-control" id="fecha_nacimiento"
										name="fecha_nacimiento" required>
								</div>

								<!-- Teléfono -->
								<div class="mb-3 col-6">
									<label for="telefono" class="form-label">Teléfono</label>
									<input type="text" class="form-control" id="telefono" name="telefono" maxlength="15"
										required>
								</div>

								<!-- Dirección -->
								<div class="mb-3">
									<label for="direccion" class="form-label">Dirección</label>
									<input type="text" class="form-control" id="direccion" name="direccion"
										maxlength="255" required>
								</div>

								<div class="mb-1 col-6">
									<label for="pais" class="form-label">País</label>
									<input type="text" class="form-control" id="pais" name="pais" maxlength="255"
										required>
								</div>

								<div class="mb-1 col-6">
									<label for="localidad" class="form-label">Localidad</label>
									<input type="text" class="form-control" id="localidad" name="localidad"
										maxlength="255" required>
								</div>

								<div class="mb-1 col-6">
									<label for="cp" class="form-label">Codigo Postal</label>
									<input type="text" class="form-control" id="cp" name="cp" maxlength="255" required>
								</div>

								<div class="mb-1 col-6">
									<label for="provincia" class="form-label">Provincia</label>
									<input type="text" class="form-control" id="provincia" name="provincia"
										maxlength="255" required>
								</div>

								<!-- Fecha de Nacimiento -->


								<button type="submit" class="btn mt-3 btn-primary mb-3">Guardar Cambios</button>
								<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>

							</form>
						</div>
					</div>
				</div>
			</div>

			 <!-- Modal -->
			<div class="modal fade" id="miModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Cambio de Contraseña</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
					<form id="passwordForm"  action="" method="POST">
						<div class="mb-3">
						<label for="oldPassword" class="form-label">Contraseña Antigua:</label>
						<input type="password" class="form-control" id="oldPassword" name="oldPassword" required>
						<div id="oldPasswordError" class="error"></div>
						</div>

						<div class="mb-3">
						<label for="newPassword" class="form-label">Nueva Contraseña:</label>
						<input type="password" class="form-control" id="newPassword" name="newPassword" required>
						<div id="passwordError" class="error"></div>
						</div>

						<div class="mb-3">
						<label for="confirmPassword" class="form-label">Confirmar Contraseña:</label>
						<input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
						<div id="confirmError" class="error"></div>
						</div>

						<button type="submit" class="btn btn-primary" id="submitBtn" disabled>Cambiar Contraseña</button>
					</form>
					</div>
				</div>
				</div>
			</div>
			 <!-- Modal -->
			<div class="modal fade" id="miModal2" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Cambio de Imagen</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
					<form action="index.php?web=CImg&&id=<?php echo $_SESSION['user']['persona_id'];?>" method="post" enctype="multipart/form-data">
						<label for="file">Selecciona una imagen:</label>
						<input type="file" name="file" id="file" accept="image/*" onchange="previewImage(event)">
						<br><br>

						<!-- Contenedor donde se mostrará la previsualización -->
						<img id="preview" src="#" alt="Vista previa" style="display: none; max-width: 300px; max-height: 300px;">
						<br><br>

						<input type="submit" value="Subir imagen" name="submit">
					</form>
					</div>
				</div>
				</div>
			</div>

			<footer class="footer">
				<div class="container-fluid">
					<div class="row text-muted">
						<div class="col-6 text-start">
							<p class="mb-0">
								<a class="text-muted" href="https://Fact-Gus.io/"
									target="_blank"><strong>Fact-Gus</strong></a> - <a class="text-muted"
									href="https://Fact-Gus.io/" target="_blank"><strong>Bootstrap Admin
										Template</strong></a> &copy;
							</p>
						</div>
						<div class="col-6 text-end">
							<ul class="list-inline">
								<li class="list-inline-item">
									<a class="text-muted" href="https://Fact-Gus.io/" target="_blank">Support</a>
								</li>
								<li class="list-inline-item">
									<a class="text-muted" href="https://Fact-Gus.io/" target="_blank">Help Center</a>
								</li>
								<li class="list-inline-item">
									<a class="text-muted" href="https://Fact-Gus.io/" target="_blank">Privacy</a>
								</li>
								<li class="list-inline-item">
									<a class="text-muted" href="https://Fact-Gus.io/" target="_blank">Terms</a>
								</li>
							</ul>
						</div>
					</div>
				</div>
			</footer>
		</div>
	</div>

	<script src="public/static/js/app.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>


</body>

</html>

<script>
    const passwordInput = document.getElementById('newPassword');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const submitBtn = document.getElementById('submitBtn');
    const passwordError = document.getElementById('passwordError');
    const confirmError = document.getElementById('confirmError');

    function validatePassword() {
      const password = passwordInput.value;
      const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;

      if (!passwordRegex.test(password)) {
        passwordError.textContent = 'La contraseña debe tener al menos 8 caracteres, incluir mayúsculas, minúsculas, números y caracteres especiales.';
        return false;
      } else {
        passwordError.textContent = '';
        return true;
      }
    }

    function validateConfirmPassword() {
      const password = passwordInput.value;
      const confirmPassword = confirmPasswordInput.value;

      if (password !== confirmPassword) {
        confirmError.textContent = 'Las contraseñas no coinciden.';
        return false;
      } else {
        confirmError.textContent = '';
        return true;
      }
    }

    function toggleSubmitButton() {
      const isValid = validatePassword() && validateConfirmPassword();
      submitBtn.disabled = !isValid;
    }

    passwordInput.addEventListener('input', toggleSubmitButton);
    confirmPasswordInput.addEventListener('input', toggleSubmitButton);

    document.getElementById('passwordForm').addEventListener('submit', function(event) {
      if (!validatePassword() || !validateConfirmPassword()) {
        event.preventDefault(); // Evita el envío si hay errores
      }
    });

	function previewImage(event) {
            var reader = new FileReader();
            reader.onload = function(){
                var output = document.getElementById('preview');
                output.src = reader.result;
                output.style.display = 'block'; // Mostrar la imagen
            };
            reader.readAsDataURL(event.target.files[0]);
        }
  </script>
  

   

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


<style>
    .error {
      color: red;
      font-size: 0.9em;
    }
  </style>