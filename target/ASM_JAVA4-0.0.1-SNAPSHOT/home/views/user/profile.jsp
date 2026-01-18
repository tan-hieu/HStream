<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css" />
<style>
.profile-container {
    max-width: 700px;
    margin: 40px auto;
    background: linear-gradient(145deg, #1e2a3a 0%, #0f1419 100%);
    padding: 30px;
    border-radius: 16px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
    color: #fff;
}

.profile-title {
    font-size: 26px;
    font-weight: bold;
    margin-bottom: 30px;
    text-align: center;
    color: #fff;
}

.profile-avatar-section {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-bottom: 30px;
}

.profile-avatar-large {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    object-fit: cover;
    border: 4px solid #065fd4;
    margin-bottom: 15px;
}

.form-label {
    font-weight: 600;
    color: #b0b8c1;
    margin-bottom: 8px;
}

.form-control, .form-select {
    background-color: #1a2332;
    border: 1px solid #2d3a4d;
    color: #fff;
    padding: 12px 15px;
    border-radius: 10px;
}

.form-control:focus, .form-select:focus {
    background-color: #1a2332;
    border-color: #065fd4;
    color: #fff;
    box-shadow: 0 0 0 3px rgba(6, 95, 212, 0.2);
}

.form-control[readonly] {
    background-color: #0f1419;
    cursor: not-allowed;
    opacity: 0.7;
}

.btn-edit {
    background-color: #065fd4;
    color: white;
    padding: 12px 30px;
    border-radius: 10px;
    font-size: 16px;
    font-weight: 600;
    border: none;
    cursor: pointer;
    transition: all 0.3s ease;
}

.btn-edit:hover {
    background-color: #054bb0;
    transform: translateY(-2px);
}

/* Modal styles */
.modal-overlay {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.7);
    z-index: 9999;
    justify-content: center;
    align-items: center;
    backdrop-filter: blur(5px);
}

.modal-overlay.show {
    display: flex;
}

.modal-content {
    background: linear-gradient(145deg, #1e2a3a 0%, #0f1419 100%);
    padding: 30px;
    border-radius: 16px;
    width: 90%;
    max-width: 550px;
    max-height: 90vh;
    overflow-y: auto;
    position: relative;
    animation: modalSlideIn 0.3s ease;
}

@keyframes modalSlideIn {
    from {
        opacity: 0;
        transform: translateY(-30px) scale(0.95);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

.modal-close {
    position: absolute;
    top: 15px;
    right: 20px;
    font-size: 28px;
    color: #888;
    cursor: pointer;
    transition: color 0.2s;
}

.modal-close:hover {
    color: #fff;
}

.modal-title {
    font-size: 22px;
    font-weight: bold;
    margin-bottom: 25px;
    text-align: center;
    color: #fff;
}

/* Avatar upload */
.avatar-upload-section {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-bottom: 25px;
}

.avatar-preview {
    width: 130px;
    height: 130px;
    border-radius: 50%;
    object-fit: cover;
    border: 4px solid #065fd4;
    margin-bottom: 15px;
    cursor: pointer;
    transition: all 0.3s ease;
}

.avatar-preview:hover {
    opacity: 0.8;
    border-color: #4a9eff;
}

.avatar-upload-label {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: linear-gradient(135deg, #065fd4, #4a9eff);
    color: white;
    padding: 10px 20px;
    border-radius: 25px;
    cursor: pointer;
    font-weight: 500;
    transition: all 0.3s ease;
}

.avatar-upload-label:hover {
    transform: scale(1.05);
    box-shadow: 0 4px 15px rgba(6, 95, 212, 0.4);
}

.avatar-upload-label input {
    display: none;
}

.btn-save {
    background: linear-gradient(135deg, #065fd4, #4a9eff);
    color: white;
    padding: 12px 35px;
    border-radius: 10px;
    font-size: 16px;
    font-weight: 600;
    border: none;
    cursor: pointer;
    transition: all 0.3s ease;
}

.btn-save:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 20px rgba(6, 95, 212, 0.4);
}

.btn-cancel {
    background: transparent;
    color: #888;
    padding: 12px 25px;
    border-radius: 10px;
    font-size: 16px;
    border: 1px solid #444;
    cursor: pointer;
    transition: all 0.2s;
    margin-right: 10px;
}

.btn-cancel:hover {
    background: #333;
    color: #fff;
}

.modal-buttons {
    display: flex;
    justify-content: center;
    gap: 15px;
    margin-top: 25px;
}

.info-row {
    display: flex;
    align-items: center;
    padding: 15px 0;
    border-bottom: 1px solid #2d3a4d;
}

.info-label {
    width: 130px;
    font-weight: 600;
    color: #b0b8c1;
}

.info-value {
    flex: 1;
    color: #fff;
}

/* Error message style */
.error-message {
    color: #ff6b6b;
    font-size: 13px;
    margin-top: 5px;
    display: none;
}

.form-control.error {
    border-color: #ff6b6b !important;
}

.email-note {
    font-size: 12px;
    color: #888;
    margin-top: 5px;
    font-style: italic;
}

/* ============ TOAST NOTIFICATION (giống video_management) ============ */
.toast-container {
    position: fixed;
    top: 20px;
    right: 20px;
    z-index: 99999;
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.toast-notification {
    min-width: 300px;
    max-width: 400px;
    padding: 16px 20px;
    border-radius: 10px;
    color: #fff;
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 12px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
    animation: slideIn 0.3s ease-out;
    cursor: pointer;
}

.toast-notification.success {
    background: linear-gradient(135deg, #28a745, #20c997);
}

.toast-notification.error {
    background: linear-gradient(135deg, #dc3545, #c82333);
}

.toast-notification.warning {
    background: linear-gradient(135deg, #ffc107, #e0a800);
    color: #212529;
}

.toast-notification.info {
    background: linear-gradient(135deg, #17a2b8, #138496);
}

.toast-notification i {
    font-size: 20px;
}

.toast-notification .toast-text {
    flex: 1;
    font-weight: 500;
}

@keyframes slideIn {
    from {
        transform: translateX(100%);
        opacity: 0;
    }
    to {
        transform: translateX(0);
        opacity: 1;
    }
}

@keyframes slideOut {
    from {
        transform: translateX(0);
        opacity: 1;
    }
    to {
        transform: translateX(100%);
        opacity: 0;
    }
}
</style>

<!-- Toast Container -->
<div class="toast-container" id="toastContainer"></div>

<div class="profile-container">
    <div class="profile-title">
        <i class="fa-solid fa-user"></i> Hồ sơ cá nhân
    </div>
    
    <!-- Avatar hiển thị -->
    <div class="profile-avatar-section">
        <img class="profile-avatar-large"
             src="<c:out value='${empty sessionScope.currentUser.avatar ? pageContext.request.contextPath.concat("/img/") : pageContext.request.contextPath.concat(sessionScope.currentUser.avatar)}'/>"
             alt="avatar" />
    </div>

    <!-- Thông tin hiển thị (chỉ đọc) -->
    <div class="info-row">
        <span class="info-label">Họ và tên</span>
        <span class="info-value">${sessionScope.currentUser.fullname}</span>
    </div>
    
    <div class="info-row">
        <span class="info-label">Giới tính</span>
        <span class="info-value">${sessionScope.currentUser.gender == true ? 'Nam' : 'Nữ'}</span>
    </div>
    
    <div class="info-row">
        <span class="info-label">Số điện thoại</span>
        <span class="info-value">${sessionScope.currentUser.mobile}</span>
    </div>
    
    <div class="info-row">
        <span class="info-label">Ngày sinh</span>
        <span class="info-value">${sessionScope.currentUser.birthdate}</span>
    </div>
    
    <div class="info-row">
        <span class="info-label">Email</span>
        <span class="info-value">${sessionScope.currentUser.email}</span>
    </div>

    <div class="text-center mt-4">
        <button class="btn-edit" type="button" onclick="openEditModal()">
            <i class="fa-solid fa-pen-to-square"></i> Chỉnh sửa hồ sơ
        </button>
    </div>
</div>

<!-- Modal chỉnh sửa hồ sơ -->
<div class="modal-overlay" id="editProfileModal">
    <div class="modal-content">
        <span class="modal-close" onclick="closeEditModal()">&times;</span>
        <div class="modal-title">
            <i class="fa-solid fa-user-pen"></i> Chỉnh sửa hồ sơ
        </div>
        
        <!-- Trong modal chỉnh sửa hồ sơ -->
        <form id="editProfileForm" method="post" action="${pageContext.request.contextPath}/user/profile/update" enctype="multipart/form-data">
            <!-- Upload Avatar -->
            <div class="avatar-upload-section">
                <img id="avatarPreview" class="avatar-preview"
                     src="<c:out value='${empty user.avatar ? pageContext.request.contextPath.concat("/img") : user.avatar}'/>"
                     alt="avatar" />
                <label class="avatar-upload-label">
                    <i class="fa-solid fa-upload"></i> Chọn ảnh đại diện
                    <input type="file" name="avatar" id="editAvatar" accept="image/*" onchange="previewAvatar(this)" />
                </label>
            </div>

            <!-- Họ tên -->
            <div class="mb-3">
                <label class="form-label">Họ và tên</label>
                <input type="text" name="fullname" id="editFullname" class="form-control"
                    value="${sessionScope.currentUser.fullname}" required>
            </div>

            <!-- Giới tính -->
            <div class="mb-3">
                <label class="form-label">Giới tính</label>
                <select name="gender" id="editGender" class="form-select">
                    <option value="true" ${sessionScope.currentUser.gender == true ? 'selected' : ''}>Nam</option>
                    <option value="false" ${sessionScope.currentUser.gender == false ? 'selected' : ''}>Nữ</option>
                </select>
            </div>

            <!-- Số điện thoại -->
            <div class="mb-3">
                <label class="form-label">Số điện thoại</label>
                <input type="text" name="mobile" id="editMobile" class="form-control"
                    value="${sessionScope.currentUser.mobile}" 
                    maxlength="10" 
                    pattern="0[0-9]{9}"
                    inputmode="numeric"
                    required>
                <div class="error-message" id="mobileError">Số điện thoại phải bắt đầu bằng 0 và có đúng 10 chữ số!</div>
            </div>

            <!-- Ngày sinh -->
            <div class="mb-3">
                <label class="form-label">Ngày sinh</label>
                <input type="date" name="birthdate" id="editBirthdate" class="form-control"
                    value="${sessionScope.currentUser.birthdate}" required>
                <div class="error-message" id="birthdateError">Ngày sinh không được vượt quá ngày hiện tại!</div>
            </div>

            <!-- Email (không cho sửa) -->
            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" id="editEmail" class="form-control" 
                    value="${sessionScope.currentUser.email}" readonly>
                <div class="email-note"><i class="fa-solid fa-lock"></i> Email không thể thay đổi</div>
            </div>

            <div class="modal-buttons">
                <button type="button" class="btn-cancel" onclick="closeEditModal()">Hủy</button>
                <button type="submit" class="btn-save">
                    <i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi
                </button>
            </div>
        </form>
    </div>
</div>

<script>
// ===== TOAST NOTIFICATION (giống video_management) =====
function showToast(type, message) {
    const container = document.getElementById('toastContainer');
    
    // Icon theo loại toast
    const icons = {
        success: 'fa-solid fa-circle-check',
        error: 'fa-solid fa-circle-exclamation',
        warning: 'fa-solid fa-triangle-exclamation',
        info: 'fa-solid fa-circle-info'
    };
    
    // Tạo toast element
    const toast = document.createElement('div');
    toast.className = 'toast-notification ' + type;
    
    toast.innerHTML = '<i class="' + icons[type] + '"></i><span class="toast-text">' + message + '</span>';
    
    container.appendChild(toast);
    
    // Click để đóng
    toast.addEventListener('click', function() {
        toast.style.animation = 'slideOut 0.3s ease-out forwards';
        setTimeout(() => toast.remove(), 300);
    });
    
    // Tự động đóng sau 3s
    setTimeout(() => {
        if (toast.parentElement) {
            toast.style.animation = 'slideOut 0.3s ease-out forwards';
            setTimeout(() => toast.remove(), 300);
        }
    }, 3000);
}

// Mở modal
function openEditModal() {
    document.getElementById('editProfileModal').classList.add('show');
    document.body.style.overflow = 'hidden';
    
    // Set max date cho ngày sinh là hôm nay
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('editBirthdate').setAttribute('max', today);

    // Thiết lập avatar preview dựa trên avatar hiện tại của session
    const avatarPreview = document.getElementById('avatarPreview');
    const ctx = '${pageContext.request.contextPath}';
    const currentAvatar = '${sessionScope.currentUser.avatar}';
    if (avatarPreview) {
        if (currentAvatar && currentAvatar.trim() !== '') {
            let url = currentAvatar;
            if (url.startsWith('/')) url = ctx + url;
            else if (!url.startsWith('http')) url = ctx + '/' + url;
            avatarPreview.src = url;
            avatarPreview.style.display = '';
        } else {
            avatarPreview.src = '';
            avatarPreview.style.display = 'none';
        }
    }
}

// Đóng modal
function closeEditModal() {
    document.getElementById('editProfileModal').classList.remove('show');
    document.body.style.overflow = 'auto';
    // Reset error messages
    document.querySelectorAll('.error-message').forEach(el => el.style.display = 'none');
    document.querySelectorAll('.form-control.error').forEach(el => el.classList.remove('error'));
}

// Đóng modal khi click ngoài
document.getElementById('editProfileModal').addEventListener('click', function(e) {
    if (e.target === this) {
        closeEditModal();
    }
});

// Đóng modal khi nhấn ESC
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeEditModal();
    }
});

// Preview ảnh đại diện
function previewAvatar(input) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById('avatarPreview').src = e.target.result;
        };
        reader.readAsDataURL(input.files[0]);
    }
}

// Chỉ cho phép nhập số vào ô điện thoại
document.getElementById('editMobile').addEventListener('input', function(e) {
    // Loại bỏ tất cả ký tự không phải số
    this.value = this.value.replace(/[^0-9]/g, '');
    
    // Giới hạn 10 số
    if (this.value.length > 10) {
        this.value = this.value.slice(0, 10);
    }
    
    // Validate real-time
    validateMobile();
});

// Chặn paste ký tự không phải số
document.getElementById('editMobile').addEventListener('paste', function(e) {
    e.preventDefault();
    const pastedText = (e.clipboardData || window.clipboardData).getData('text');
    const numbersOnly = pastedText.replace(/[^0-9]/g, '').slice(0, 10);
    this.value = numbersOnly;
    validateMobile();
});

// Chặn nhập ký tự không phải số (keypress)
document.getElementById('editMobile').addEventListener('keypress', function(e) {
    if (!/[0-9]/.test(e.key)) {
        e.preventDefault();
    }
});

// Validate số điện thoại
function validateMobile() {
    const mobile = document.getElementById('editMobile');
    const error = document.getElementById('mobileError');
    const value = mobile.value;
    
    // Phải bắt đầu bằng 0 và có đúng 10 số
    const isValid = /^0[0-9]{9}$/.test(value);
    
    if (value.length > 0 && !isValid) {
        mobile.classList.add('error');
        error.style.display = 'block';
        return false;
    } else {
        mobile.classList.remove('error');
        error.style.display = 'none';
        return true;
    }
}

// Validate ngày sinh
function validateBirthdate() {
    const birthdate = document.getElementById('editBirthdate');
    const error = document.getElementById('birthdateError');
    const value = birthdate.value;
    
    if (!value) return false;
    
    const selectedDate = new Date(value);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    if (selectedDate > today) {
        birthdate.classList.add('error');
        error.style.display = 'block';
        return false;
    } else {
        birthdate.classList.remove('error');
        error.style.display = 'none';
        return true;
    }
}

// Validate khi thay đổi ngày sinh
document.getElementById('editBirthdate').addEventListener('change', validateBirthdate);

// Submit form
document.getElementById('editProfileForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    // Validate trước khi submit
    const isMobileValid = validateMobile();
    const isBirthdateValid = validateBirthdate();
    
    if (!isMobileValid) {
        showToast('error', 'Số điện thoại phải bắt đầu bằng số 0 và có đúng 10 chữ số!');
        return;
    }
    
    if (!isBirthdateValid) {
        showToast('error', 'Ngày sinh không được vượt quá ngày hiện tại!');
        return;
    }
    
    const formData = new FormData(this);
    
    fetch('${pageContext.request.contextPath}/user/profile/update', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast('success', data.message);

            if (data.avatar) {
                const ctx = '${pageContext.request.contextPath}';
                let avatarUrl = data.avatar;
                if (avatarUrl.startsWith('/')) {
                    avatarUrl = ctx + avatarUrl;
                } else if (!avatarUrl.startsWith('http')) {
                    avatarUrl = ctx + '/' + avatarUrl;
                }
                // Cập nhật avatar ở modal
                const avatarPreview = document.getElementById('avatarPreview');
                if (avatarPreview) avatarPreview.src = avatarUrl;
                // Cập nhật avatar ở header
                const headerAvatar = document.querySelector('.profile-dropdown .profile-avatar');
                if (headerAvatar) headerAvatar.src = avatarUrl;
                // Cập nhật avatar lớn ngoài trang chính
                const profileAvatarLarge = document.querySelector('.profile-avatar-large');
                if (profileAvatarLarge) profileAvatarLarge.src = avatarUrl + '?t=' + new Date().getTime(); // Thêm query tránh cache
            }
            closeEditModal();
        } else {
            showToast('error', data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('error', 'Có lỗi xảy ra. Vui lòng thử lại!');
    });
});
</script>

