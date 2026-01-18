<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/theme.css" />
<style>
/* Card & theme aligned with login.jsp */
.auth-card {
	max-width: 420px;
	width: 92vw;
	background: var(--bg-soft);
	border: 1px solid var(--border-soft);
	border-radius: 1.5rem;
	padding: 2.25rem;
	color: var(--gray-light);
	box-shadow: var(--shadow-accent);
}

.form-label {
	color: var(--gray-subtle);
}

/* Input group styled like login.jsp */
.input-group-icon {
	border: 1px solid var(--border-soft);
	border-radius: 0.75rem;
	background: var(--bg-panel);
	overflow: hidden;
	transition: border-color 0.2s ease, box-shadow 0.2s ease, background
		0.2s ease;
}

.input-group-icon:focus-within {
	border-color: var(--accent);
	box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.28);
	background: var(--bg-soft);
}

.input-group-icon .input-group-text {
	border: 0;
	background: transparent;
	color: var(--accent);
	font-size: 1.1rem;
	display: flex;
	align-items: center;
	justify-content: center;
	padding-inline: 0.95rem;
}

.input-group-icon .form-control, .input-group-icon .form-select {
	border: 0;
	background: transparent;
	box-shadow: none;
	padding-left: 0;
	color: var(--gray-light);
}

.input-group-icon .form-control:focus, .input-group-icon .form-select:focus
	{
	box-shadow: none;
}

.input-group-icon .toggle-password {
	border: 0;
	border-left: 1px solid var(--border-soft);
	background: transparent;
	padding: 0 0.9rem;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	font-size: 1.05rem;
	color: var(--gray-icon);
	transition: color 0.2s ease, background 0.2s ease;
}

.input-group-icon .toggle-password:hover {
	background: var(--layer-soft);
	color: var(--accent);
}

.input-group-icon .toggle-password:focus-visible {
	outline: 2px solid var(--accent);
	outline-offset: 2px;
	border-radius: 0.4rem;
}

.form-control {
	border-left: none;
}

.form-control:focus {
	border-color: var(--accent);
	box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.35);
}

/* Primary button scoped like login.jsp */
.auth-card .btn-primary {
	background: var(--accent-grad) !important;
	border-color: var(--accent) !important;
	color: #fff !important;
	box-shadow: 0 10px 24px -8px rgba(99, 102, 241, 0.7);
	transition: transform 0.12s ease, box-shadow 0.2s ease, filter 0.2s ease;
}

.auth-card .btn-primary:hover {
	filter: brightness(1.05);
	box-shadow: 0 16px 32px -10px rgba(99, 102, 241, 0.85);
	transform: translateY(-1px);
}

.auth-card .btn-primary:active {
	transform: translateY(0);
	box-shadow: 0 8px 18px -6px rgba(99, 102, 241, 0.65);
}

.text-primary {
	color: var(--accent) !important;
}

.link-primary {
	color: var(--accent) !important;
}

.link-primary:hover {
	color: var(--accent-light) !important;
}

.text-muted {
	color: var(--gray-muted) !important;
}

/* Grid spacing keeps original layout */
.form-grid {
	display: grid;
	gap: 1.25rem;
}

.form-grid-double {
	gap: 1.25rem;
}

@media ( min-width : 768px) {
	.form-grid-double {
		grid-template-columns: repeat(2, minmax(0, 1fr));
	}
}

.form-section-title {
	font-size: 0.95rem;
	font-weight: 600;
	color: var(--accent);
	margin-bottom: 0.25rem;
}
</style>

<div class="d-flex align-items-center justify-content-center min-vh-500">
	<main class="card shadow-lg auth-card">
		<header class="text-center mb-4">
			<h1 class="h3 fw-bold text-primary mb-2">Tạo tài khoản</h1>
			<p class="text-muted mb-0">Hoàn tất vài bước để bắt đầu</p>
		</header>

		<c:if test="${not empty error}">
			<div class="alert alert-danger py-2 mb-3">${error}</div>
		</c:if>

		<form action="${pageContext.request.contextPath}/register" method="post">
			<div class="form-grid">
				<section>
					<div>
						<label class="form-label fw-semibold" for="fullName">Họ
							và tên</label>
						<div class="input-group input-group-icon">
							<span class="input-group-text"> <i
								class="fa-solid fa-user"></i>
							</span> <input class="form-control" type="text" id="fullname"
								name="fullname" placeholder="Mời nhập vào họ và tên" required
								minlength="3" title="Họ và tên cần ít nhất 3 ký tự." value="${param.fullname}"/>
						</div>
					</div>

					<div>
						<label class="form-label fw-semibold" for="phone">Số
							điện thoại</label>
						<div class="input-group input-group-icon">
							<span class="input-group-text"> <i
								class="fa-solid fa-phone"></i>
							</span> <input class="form-control" type="tel" id="phone" name="phone"
								placeholder="0xxxxxxxxx" required pattern="^0\d{9}$"
								title="Số điện thoại gồm 10 chữ số và bắt đầu bằng 0." value="${param.phone}"/>
						</div>
					</div>

					<div class="form-grid form-grid-double mt-3">
						<div>
							<label class="form-label fw-semibold" for="gender">Giới
								tính</label>
							<div class="input-group input-group-icon">
								<span class="input-group-text"> <i
									class="fa-solid fa-venus-mars"></i>
								</span> <select class="form-select border-0" id="gender" name="gender"
									required>
								<option value="male" ${param.gender != 'female' ? 'selected' : ''}>Nam</option>
								<option value="female" ${param.gender == 'female' ? 'selected' : ''}>Nữ</option>
								</select>
							</div>
						</div>

						<div>
							<label class="form-label fw-semibold" for="birthdate">Ngày
								sinh</label>
							<div class="input-group input-group-icon">
								<span class="input-group-text"> <i
									class="fa-solid fa-calendar-day"></i>
								</span> <input class="form-control" type="date" id="birthdate"
									name="birthdate" required value="${param.birthdate}"/>
							</div>
						</div>
					</div>
				</section>

				<section>
					<div class="form-grid">
						<div>
							<label class="form-label fw-semibold" for="email">Email</label>
							<div class="input-group input-group-icon">
								<span class="input-group-text"> <i
									class="fa-solid fa-envelope"></i>
								</span> <input class="form-control" type="email" id="email"
									name="email" placeholder="name@gmail.com" required
									pattern="^[a-zA-Z0-9._%+-]+@gmail\.com$"
									title="Vui lòng nhập địa chỉ Gmail kết thúc bằng @gmail.com" value="${param.email}"/>
							</div>
						</div>

						<div>
							<label class="form-label fw-semibold" for="password">Mật khẩu</label>
							<div class="input-group input-group-icon">
								<span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
								<input class="form-control" type="password" id="password" name="password"
                                       placeholder="Nhập mật khẩu" required pattern="^\d{6,}$" />
                                <button class="toggle-password" type="button"
                                    id="togglePassword" aria-label="Ẩn hoặc hiện mật khẩu">
                                    <i class="fa-solid fa-eye-slash" id="togglePasswordIcon"></i>
                                </button>
							</div>
						</div>

						<div>
							<label class="form-label fw-semibold" for="confirmPassword">Xác nhận mật khẩu</label>
							<div class="input-group input-group-icon">
								<span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
								<input class="form-control" type="password" id="confirmPassword" name="confirmPassword"
                                       placeholder="Nhập lại mật khẩu" required />
                                <button class="toggle-password" type="button"
                                    id="toggleConfirmPassword"
                                    aria-label="Ẩn hoặc hiện mật khẩu xác nhận">
                                    <i class="fa-solid fa-eye-slash" id="toggleConfirmPasswordIcon"></i>
                                </button>
							</div>
						</div>
					</div>
				</section>
			</div>

			<button
				class="btn btn-primary w-100 d-flex justify-content-center align-items-center gap-2 mt-4"
				type="submit">
				<i class="fa-solid fa-user-plus"></i> Đăng ký
			</button>
		</form>

		<div class="text-center mt-4 text-muted">
			Đã có tài khoản? <a class="fw-semibold text-decoration-none"
				href="${pageContext.request.contextPath}/home?page=login">
				<i class="fa-solid fa-arrow-right-to-bracket me-1"></i>Đăng nhập
				ngay
			</a>
		</div>
	</main>

	<%--<script>
    const fullNameInput = document.getElementById("fullName");
    const emailInput = document.getElementById("email");
    const passwordInput = document.getElementById("password");
    const confirmPasswordInput = document.getElementById("confirmPassword");
    const togglePassword = document.getElementById("togglePassword");
    const toggleConfirmPassword = document.getElementById(
      "toggleConfirmPassword"
    );
    const togglePasswordIcon = document.getElementById("togglePasswordIcon");
    const toggleConfirmPasswordIcon = document.getElementById(
      "toggleConfirmPasswordIcon"
    );
    const phoneInput = document.getElementById("phone");
    const genderSelect = document.getElementById("gender");
    const birthdateInput = document.getElementById("birthdate");

    // Enhance toggle buttons to mirror login's aria and state feedback
    const setToggleState = (btn, icon, show) => {
      icon.classList.remove("fa-eye", "fa-eye-slash");
      icon.classList.add(show ? "fa-eye" : "fa-eye-slash");
      btn.classList.toggle("is-show", show);
      btn.setAttribute("aria-pressed", show ? "true" : "false");
      btn.setAttribute("title", show ? "Ẩn mật khẩu" : "Hiện mật khẩu");
    };
    togglePassword.addEventListener("click", () => {
      const show = passwordInput.type == "password";
      passwordInput.type = show ? "text" : "password";
      setToggleState(togglePassword, togglePasswordIcon, show);
    });
    toggleConfirmPassword.addEventListener("click", () => {
      const show = confirmPasswordInput.type == "password";
      confirmPasswordInput.type = show ? "text" : "password";
      setToggleState(toggleConfirmPassword, toggleConfirmPasswordIcon, show);
    });

    fullNameInput.addEventListener("input", () => {
      const value = fullNameInput.value.trim();
      fullNameInput.setCustomValidity(
        value.length >= 3 ? "" : "Họ và tên cần ít nhất 3 ký tự."
      );
    });

    emailInput.addEventListener("input", () => {
      const valid = /^[a-zA-Z0-9._%+-]+@gmail\.com$/.test(emailInput.value);
      emailInput.setCustomValidity(
        valid ? "" : "Chỉ chấp nhận địa chỉ Gmail (@gmail.com)."
      );
    });

    const validatePasswordStrength = () => {
      const valid = /^\d{6,}$/.test(passwordInput.value);
      passwordInput.setCustomValidity(
        valid ? "" : "Mật khẩu phải gồm ít nhất 6 chữ số."
      );
    };

    const validatePasswordMatch = () => {
      const match = confirmPasswordInput.value == passwordInput.value;
      confirmPasswordInput.setCustomValidity(
        match ? "" : "Mật khẩu xác nhận chưa đúng."
      );
    };

    passwordInput.addEventListener("input", () => {
      validatePasswordStrength();
      validatePasswordMatch();
    });

    confirmPasswordInput.addEventListener("input", validatePasswordMatch);

    const todayISO = new Date().toISOString().split("T")[0];
    birthdateInput.setAttribute("max", todayISO);

    phoneInput.addEventListener("input", () => {
      const valid = /^0\d{9}$/.test(phoneInput.value);
      phoneInput.setCustomValidity(
        valid ? "" : "Số điện thoại gồm 10 chữ số và bắt đầu bằng 0."
      );
    });

    genderSelect.addEventListener("change", () => {
      genderSelect.setCustomValidity(
        genderSelect.value ? "" : "Vui lòng chọn giới tính."
      );
    });

    birthdateInput.addEventListener("input", () => {
      const value = birthdateInput.value;
      const valid = value && value <= todayISO;
      birthdateInput.setCustomValidity(
        valid ? "" : "Ngày sinh không được ở tương lai."
      );
    });
  </script>--%>
	<script>
  const passwordInput = document.getElementById("password");
  const confirmPasswordInput = document.getElementById("confirmPassword");
  const togglePassword = document.getElementById("togglePassword");
  const toggleConfirmPassword = document.getElementById("toggleConfirmPassword");
  const togglePasswordIcon = document.getElementById("togglePasswordIcon");
  const toggleConfirmPasswordIcon = document.getElementById("toggleConfirmPasswordIcon");

  function setToggleState(btn, icon, show) {
    icon.classList.remove("fa-eye", "fa-eye-slash");
    icon.classList.add(show ? "fa-eye" : "fa-eye-slash");
    btn.classList.toggle("is-show", show);
    btn.setAttribute("aria-pressed", show ? "true" : "false");
    btn.setAttribute("title", show ? "Ẩn mật khẩu" : "Hiện mật khẩu");
  }

  togglePassword.addEventListener("click", () => {
    const show = passwordInput.type === "password";
    passwordInput.type = show ? "text" : "password";
    setToggleState(togglePassword, togglePasswordIcon, show);
  });

  toggleConfirmPassword.addEventListener("click", () => {
    const show = confirmPasswordInput.type === "password";
    confirmPasswordInput.type = show ? "text" : "password";
    setToggleState(toggleConfirmPassword, toggleConfirmPasswordIcon, show);
  });
</script>
</div>
