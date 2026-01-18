<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css" />
<style>
:root {
	--bg: #f5f7fb;
	--card-bg: #ffffff;
	--primary: #2d6cdf;
	--primary-grad: linear-gradient(135deg, #2d6cdf, #6b9dff);
	--text: #1f2a37;
	--text-sub: #5b6675;
	--border: #e2e8f0;
	--radius: 16px;
	--shadow: 0 4px 12px -2px rgba(0, 0, 0, 0.08), 0 2px 4px -1px
		rgba(0, 0, 0, 0.06);
	--transition: 0.25s cubic-bezier(0.4, 0, 0.2, 1);
	font-size: 16px;
}

.container {
	max-width: 960px;
	margin: 48px auto;
	padding: 0 32px 64px;
}

header {
	display: flex;
	flex-wrap: wrap;
	gap: 24px;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 12px;
}

header h1 {
	font-size: clamp(1.5rem, 2.4vw, 2.2rem);
	letter-spacing: 0.5px;
	margin: 0;
	background: var(--primary-grad);
	-webkit-background-clip: text;
	font-weight: 700;
}

.search .input {
	position: relative;
	width: 280px;
	display: flex;
}

.search .input input {
	width: 100%;
	padding: 12px 16px 12px 44px;
	border: 1.5px solid var(--border);
	border-radius: 12px;
	background: #fff;
	font-size: 0.95rem;
	outline: none;
	transition: var(--transition);
}

.search .input input::placeholder {
	color: #98a3b3;
}

.search .input input:focus {
	border-color: var(--primary);
	box-shadow: 0 0 0 3px rgba(45, 108, 223, 0.15);
}

.search .input .icon {
	position: absolute;
	top: 50%;
	left: 14px;
	width: 20px;
	height: 20px;
	transform: translateY(-50%);
	stroke: var(--text-sub);
	pointer-events: none;
}

.subtitle {
	font-size: 0.9rem;
	color: var(--text-sub);
	margin-bottom: 20px;
	padding-left: 4px;
}

.card {
	background: var(--card-bg);
	border: 1px solid var(--border);
	border-radius: var(--radius);
	padding: 28px 28px 26px;
	box-shadow: var(--shadow);
	display: flex;
	flex-direction: column;
	gap: 28px;
}

.sharer {
	display: flex;
	align-items: center;
	gap: 18px;
	padding-bottom: 18px;
	border-bottom: 1px dashed var(--border);
}

.avatar {
	width: 70px;
	height: 70px;
	border-radius: 50%;
	background: var(--primary-grad);
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: 600;
	font-size: 1.05rem;
	color: #fff;
	letter-spacing: 0.5px;
	box-shadow: 0 4px 10px -2px rgba(45, 108, 223, 0.45);
}

.meta .name {
	font-weight: 600;
	font-size: 1.05rem;
	margin-bottom: 4px;
}

.meta .email {
	font-size: 0.85rem;
	color: var(--text-sub);
}

.recipients .title {
	font-weight: 600;
	font-size: 0.95rem;
	margin-bottom: 14px;
	letter-spacing: 0.4px;
	color: var(--text);
	position: relative;
}

.recipients .title:after {
	content: "";
	position: absolute;
	left: 0;
	bottom: -6px;
	width: 48px;
	height: 3px;
	border-radius: 2px;
	background: var(--primary-grad);
}

.recipient-list {
	display: grid;
	gap: 14px;
	grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
}

.recipient {
	display: flex;
	gap: 14px;
	padding: 14px 16px;
	background: #f9fbfe;
	border: 1px solid #edf1f7;
	border-radius: 14px;
	align-items: center;
	position: relative;
	transition: var(--transition);
	overflow: hidden;
}

.recipient:hover {
	border-color: var(--primary);
	background: #ffffff;
	box-shadow: 0 4px 16px -4px rgba(0, 0, 0, 0.12);
	transform: translateY(-2px);
}

.avatar-sm {
	width: 46px;
	height: 46px;
	border-radius: 50%;
	background: linear-gradient(135deg, #e3e8ef, #f5f7fa);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 0.8rem;
	font-weight: 600;
	color: #334155;
	border: 1px solid #d9e2ec;
}

.recipient:hover .avatar-sm {
	background: var(--primary-grad);
	color: #fff;
	border-color: transparent;
	box-shadow: 0 3px 8px -2px rgba(45, 108, 223, 0.5);
}

.rmeta .rname {
	font-size: 0.9rem;
	font-weight: 600;
	margin-bottom: 3px;
	color: var(--text);
}

.rmeta .remail {
	font-size: 0.75rem;
	color: var(--text-sub);
	word-break: break-all;
}

@media ( max-width : 640px) {
	.container {
		padding: 0 20px 52px;
		margin-top: 32px;
	}
	header {
		flex-direction: column;
		align-items: flex-start;
	}
	.search .input {
		width: 100%;
	}
	.sharer {
		flex-direction: row;
	}
	.avatar {
		width: 60px;
		height: 60px;
		font-size: 0.95rem;
	}
}
</style>
<div class="container">
	<header>
		<h1>Lọc Bài Viết</h1>
		<div class="search">
			<div class="input">
				<svg class="icon" viewBox="0 0 24 24" fill="none"
					xmlns="http://www.w3.org/2000/svg">
          <path d="M21 21l-4.35-4.35" stroke="currentColor"
						stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"
						opacity="0.8" />
          <circle cx="11" cy="11" r="6" stroke="currentColor"
						stroke-width="1.6" opacity="0.8" />
        </svg>
				<input placeholder="Hướng dẫn thiết kế UI/UX hiện đại"
					aria-label="Tìm kiếm" />
			</div>
		</div>
	</header>

	<div class="subtitle">Kết quả tìm kiếm cho: "Hướng dẫn thiết kế
		UI/UX hiện đại"</div>

	<div class="card">
		<div class="sharer">
			<div class="avatar">VA</div>
			<div class="meta">
				<div class="name">Nguyễn Văn An</div>
				<div class="email">nguyen.van.an@email.com</div>
			</div>
		</div>

		<div class="recipients">
			<div class="title">Danh sách người nhận</div>
			<div class="recipient-list">
				<div class="recipient">
					<div class="avatar-sm">TB</div>
					<div class="rmeta">
						<div class="rname">Trần Thị Bích</div>
						<div class="remail">tran.thi.bich@email.com</div>
					</div>
				</div>

				<div class="recipient">
					<div class="avatar-sm">LC</div>
					<div class="rmeta">
						<div class="rname">Lê Minh Cường</div>
						<div class="remail">le.minh.cuong@email.com</div>
					</div>
				</div>

				<div class="recipient">
					<div class="avatar-sm">PD</div>
					<div class="rmeta">
						<div class="rname">Phạm Thị Dung</div>
						<div class="remail">pham.thi.dung@email.com</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
