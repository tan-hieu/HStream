<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ page
language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<title>Báo cáo thống kê</title>
<link
  rel="stylesheet"
  href="${pageContext.request.contextPath}/assets/css/theme.css"
/>
<style>
  .stats-row {
    display: flex;
    gap: 28px;
    margin-bottom: 38px;
    flex-wrap: wrap;
  }
  .stat-card {
    flex: 1 1 0;
    background: var(--bg-panel);
    border: 1.5px solid var(--border-soft);
    border-radius: 22px;
    padding: 28px 28px 18px 28px;
    box-shadow: 0 8px 32px 0 rgba(99, 102, 241, 0.1), var(--shadow-soft);
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    min-width: 320px;
    margin-bottom: 0;
    color: var(--gray-light);
    transition: border-color 0.2s, box-shadow 0.2s, transform 0.18s;
    position: relative;
  }
  .stat-card:hover {
    border-color: var(--accent);
    box-shadow: 0 12px 36px 0 rgba(99, 102, 241, 0.18), var(--shadow-accent);
    transform: translateY(-2px) scale(1.012);
    z-index: 2;
  }
  .stat-title {
    font-size: 1.08rem;
    color: var(--gray-subtle);
    margin-bottom: 16px;
    font-weight: 700;
    letter-spacing: 0.01em;
  }
  .stat-chart {
    display: block;
    width: 100% !important;
    height: 220px !important;
    max-width: 100%;
    background: transparent;
    border-radius: 12px;
  }
  @media (max-width: 1100px) {
    .stat-card {
      min-width: 320px;
      width: 100%;
    }
  }
  @media (max-width: 900px) {
    .stats-row {
      flex-direction: column;
      gap: 18px;
    }
    .stat-card {
      min-width: 0;
      width: 100%;
      margin-bottom: 18px;
    }
  }
  .section {
    margin-top: 38px;
    background: var(--bg-panel);
    border: 1.5px solid var(--border-soft);
    border-radius: 18px;
    padding: 24px 24px 18px 24px;
    box-shadow: 0 4px 18px 0 rgba(99, 102, 241, 0.08), var(--shadow-soft);
    color: var(--gray-light);
    transition: border-color 0.2s, box-shadow 0.2s;
  }
  .section-title {
    font-size: 1.08rem;
    font-weight: 700;
    margin-bottom: 14px;
    color: var(--gray-light);
    letter-spacing: 0.01em;
  }
  /* Bảng đẹp, hiện đại, phù hợp theme tối */
  .table-responsive {
    overflow-x: auto;
    border-radius: 14px;
    background: transparent;
    margin-top: 10px;
  }
  table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    background: var(--bg-panel);
    border-radius: 14px;
    overflow: hidden;
    box-shadow: 0 2px 12px 0 rgba(99, 102, 241, 0.06);
  }
  th,
  td {
    padding: 14px 18px;
    text-align: left;
    font-size: 1rem;
    border-bottom: 1px solid var(--border-subtle);
    transition: background 0.18s;
  }
  th {
    background: var(--bg-soft);
    color: var(--accent);
    font-weight: 700;
    border-bottom: 2px solid var(--accent);
    letter-spacing: 0.01em;
    font-size: 1.05rem;
  }
  tr:last-child td {
    border-bottom: none;
  }
  tbody tr {
    background: transparent;
    transition: background 0.18s;
  }
  tbody tr:hover td {
    background: var(--layer-soft);
  }
  td {
    color: var(--gray-light);
  }
  /* Ensure table body text is visible on dark theme */
  .table-responsive tbody td {
    color: var(--gray-light) !important;
  }
  .table-empty-row td {
    text-align: center;
    color: var(--gray-muted);
    font-style: italic;
    background: transparent;
  }
  .badge {
    display: inline-block;
    padding: 2px 10px;
    border-radius: 8px;
    font-size: 0.92em;
    color: #fff;
    background: var(--accent);
    margin-right: 4px;
    font-weight: 600;
  }
  .btn {
    background: var(--accent);
    color: #fff;
    border: none;
    border-radius: 8px;
    padding: 7px 20px;
    font-size: 1rem;
    cursor: pointer;
    transition: background 0.2s, box-shadow 0.2s;
    box-shadow: 0 2px 8px 0 rgba(99, 102, 241, 0.1);
  }
  .btn:hover {
    background: var(--accent-dark);
    box-shadow: 0 4px 16px 0 rgba(99, 102, 241, 0.18);
  }
  .table-footer {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    gap: 8px;
  }
  .pagination {
    display: flex;
    gap: 4px;
  }
  .pagination button {
    background: var(--bg-soft);
    border: 1px solid var(--border-subtle);
    border-radius: 6px;
    padding: 5px 14px;
    cursor: pointer;
    font-size: 1rem;
    color: var(--gray-subtle);
    transition: background 0.2s, color 0.2s, border-color 0.2s;
  }
  .pagination button.active {
    background: var(--accent);
    color: #fff;
    border-color: var(--accent);
    box-shadow: var(--shadow-accent);
  }
  .pagination button:hover:not(.active) {
    background: var(--layer-soft);
    color: var(--accent-light);
    border-color: var(--accent-light);
  }
  .form-select,
  .form-control {
    background: var(--bg-soft) !important;
    color: var(--gray-light) !important;
    border: 1.5px solid var(--border-soft) !important;
    border-radius: 8px !important;
    font-size: 1rem;
    padding: 8px 14px;
    transition: border-color 0.2s, box-shadow 0.2s;
  }
  .form-select:focus,
  .form-control:focus {
    border-color: var(--accent) !important;
    box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.22) !important;
  }
  /* Modern underline tab style */
  .nav-tabs {
    border-bottom: none;
    display: flex;
    gap: 18px;
    background: transparent;
    margin-bottom: 32px !important;
    padding-left: 0;
    position: relative;
  }
  .nav-tabs .nav-link {
    border: none;
    border-radius: 16px 16px 0 0;
    background: rgba(40, 50, 90, 0.45);
    color: var(--gray-subtle);
    font-weight: 600;
    font-size: 1.12rem;
    padding: 14px 38px 12px 38px;
    margin-right: 0;
    position: relative;
    transition: background 0.22s cubic-bezier(0.4, 1.4, 0.6, 1), color 0.18s,
      box-shadow 0.22s, transform 0.18s;
    box-shadow: 0 2px 12px 0 rgba(99, 102, 241, 0.1);
    outline: none;
    z-index: 1;
    backdrop-filter: blur(6px);
  }
  .nav-tabs .nav-link.active,
  .nav-tabs .nav-link:focus {
    background: linear-gradient(90deg, var(--accent) 0%, #6a82fb 100%);
    color: #fff !important;
    box-shadow: 0 6px 24px 0 rgba(99, 102, 241, 0.18),
      0 2px 8px 0 rgba(106, 130, 251, 0.1);
    transform: translateY(-2px) scale(1.04);
    z-index: 2;
  }
  .nav-tabs .nav-link:not(.active):hover {
    background: rgba(99, 102, 241, 0.13);
    color: var(--accent-light) !important;
    box-shadow: 0 2px 12px 0 rgba(99, 102, 241, 0.13);
    transform: translateY(-1px) scale(1.01);
  }
  .tab-indicator {
    display: none;
  }

  /* Flex row for label + select */
  .inline-form-row {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 18px;
    flex-wrap: wrap;
  }
  .inline-form-row label {
    margin-bottom: 0;
    font-weight: 500;
    color: var(--gray-light);
    min-width: 90px;
  }
  .inline-form-row .form-select {
    min-width: 1058px;
    margin-bottom: 0;
  }
  @media (max-width: 600px) {
    .inline-form-row {
      flex-direction: column;
      align-items: stretch;
      gap: 8px;
    }
    .inline-form-row label {
      min-width: 0;
    }
  }
  .form-select option {
    color: #fff !important;
    background: #222 !important;
    min-height: 30px;
  }
  .form-select {
    min-width: 1058px !important; /* hoặc giá trị nhỏ hơn 1058px */
  }

  /* Khi đặt attribute size trên <select>, giới hạn chiều cao và bật scrollbar */
  .form-select[size] {
    height: auto;
    max-height: 220px; /* điều chỉnh theo cần thiết (px) */
    overflow-y: auto;
    -webkit-appearance: none;
    appearance: none;
    padding-right: 6px; /* đảm bảo không bị cắt nội dung */
  }

  /* Keep favorite select inline with its label, only for this row */
  .inline-form-row.favorite-row {
    align-items: center;
    gap: 12px;
  }

  .inline-form-row.favorite-row .form-select {
    min-width: 300px;
    max-width: calc(100% - 120px);
    flex: 1 1 auto;
    margin-bottom: 0;
  }

  /* Make the multi-row select (size=5) look tidy */
  #shareVideoSelect[size] {
    height: auto; /* let browser show `size` rows */
    padding: 8px 12px;
    overflow-y: auto;
    -webkit-appearance: none;
    appearance: none;
  }

  /* Custom dropdown (shared style for both selects) */
  .custom-select-container {
    position: relative;
    display: inline-block;
    width: 100%;
    max-width: 1058px; /* cùng kích thước với các .form-select khác */
    vertical-align: middle;
  }

  .custom-select-container.small {
    max-width: 1058px; /* giữ cùng kích thước để giống nhau */
  }

  .select-display {
    cursor: pointer;
    user-select: none;
    padding: 10px 14px;
    border-radius: 8px;
    background: var(--bg-soft);
    color: var(--gray-light);
    border: 1.5px solid var(--border-soft);
    min-height: 44px;
    display: flex;
    align-items: center;
    gap: 12px;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis; /* rút ngắn văn bản dài */
  }

  /* nhỏ icon mũi tên phải, không che text */
  .select-display::after {
    content: "";
    display: inline-block;
    flex: 0 0 18px;
    width: 18px;
    height: 18px;
    margin-left: 8px;
    background-image: linear-gradient(45deg, transparent 50%, currentColor 50%),
      linear-gradient(-45deg, transparent 50%, currentColor 50%);
    background-size: 7px 7px;
    background-position: center;
    opacity: 0.85;
  }

  /* dropdown popup */
  .select-dropdown {
    position: absolute;
    left: 0;
    right: 0;
    margin-top: 8px;
    background: var(--bg-panel);
    border: 1.5px solid var(--border-soft);
    border-radius: 8px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.45);
    z-index: 1200;
    display: none;
    max-height: 320px;
    overflow: hidden;
    padding: 6px;
  }

  .select-dropdown.open {
    display: block;
  }

  .select-dropdown ul {
    list-style: none;
    margin: 0;
    padding: 0;
    max-height: 220px;
    overflow-y: auto;
    scrollbar-width: thin;
    -webkit-overflow-scrolling: touch;
  }

  .select-dropdown li {
    padding: 10px 12px;
    color: var(--gray-light);
    border-radius: 6px;
    cursor: pointer;
    font-size: 0.98rem;
    line-height: 1.2;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }

  .select-dropdown li:hover,
  .select-dropdown li.active {
    background: var(--layer-soft);
    color: var(--accent);
  }
  /* Flex row for label + select */
  .inline-form-row {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 18px;
    flex-wrap: wrap;
  }
  .inline-form-row label {
    margin-bottom: 0;
    font-weight: 500;
    color: var(--gray-light);
    min-width: 90px;
  }
  .inline-form-row .form-select {
    min-width: 1058px;
    margin-bottom: 0;
  }
  @media (max-width: 600px) {
    .inline-form-row {
      flex-direction: column;
      align-items: stretch;
      gap: 8px;
    }
    .inline-form-row label {
      min-width: 0;
    }
  }
  .form-select option {
    color: #fff !important;
    background: #222 !important;
    min-height: 30px;
  }
  .form-select {
    min-width: 1058px !important; /* hoặc giá trị nhỏ hơn 1058px */
  }

  /* Khi đặt attribute size trên <select>, giới hạn chiều cao và bật scrollbar */
  .form-select[size] {
    height: auto;
    max-height: 220px; /* điều chỉnh theo cần thiết (px) */
    overflow-y: auto;
    -webkit-appearance: none;
    appearance: none;
    padding-right: 6px; /* đảm bảo không bị cắt nội dung */
  }

  /* Keep favorite select inline with its label, only for this row */
  .inline-form-row.favorite-row {
    align-items: center;
    gap: 12px;
  }

  .inline-form-row.favorite-row .form-select {
    min-width: 300px;
    max-width: calc(100% - 120px);
    flex: 1 1 auto;
    margin-bottom: 0;
  }

  /* Make the multi-row select (size=5) look tidy */
  #shareVideoSelect[size] {
    height: auto; /* let browser show `size` rows */
    padding: 8px 12px;
    overflow-y: auto;
    -webkit-appearance: none;
    appearance: none;
  }

  /* Custom dropdown (shared style for both selects) */
  .custom-select-container {
    position: relative;
    display: inline-block;
    width: 100%;
    max-width: 1058px; /* cùng kích thước với các .form-select khác */
    vertical-align: middle;
  }

  .custom-select-container.small {
    max-width: 1058px; /* giữ cùng kích thước để giống nhau */
  }

  .select-display {
    cursor: pointer;
    user-select: none;
    padding: 10px 14px;
    border-radius: 8px;
    background: var(--bg-soft);
    color: var(--gray-light);
    border: 1.5px solid var(--border-soft);
    min-height: 44px;
    display: flex;
    align-items: center;
    gap: 12px;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis; /* rút ngắn văn bản dài */
  }

  /* nhỏ icon mũi tên phải, không che text */
  .select-display::after {
    content: "";
    display: inline-block;
    flex: 0 0 18px;
    width: 18px;
    height: 18px;
    margin-left: 8px;
    background-image: linear-gradient(45deg, transparent 50%, currentColor 50%),
      linear-gradient(-45deg, transparent 50%, currentColor 50%);
    background-size: 7px 7px;
    background-position: center;
    opacity: 0.85;
  }

  /* dropdown popup */
  .select-dropdown {
    position: absolute;
    left: 0;
    right: 0;
    margin-top: 8px;
    background: var(--bg-panel);
    border: 1.5px solid var(--border-soft);
    border-radius: 8px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.45);
    z-index: 1200;
    display: none;
    max-height: 320px;
    overflow: hidden;
    padding: 6px;
  }

  .select-dropdown.open {
    display: block;
  }

  .select-dropdown ul {
    list-style: none;
    margin: 0;
    padding: 0;
    max-height: 220px;
    overflow-y: auto;
    scrollbar-width: thin;
    -webkit-overflow-scrolling: touch;
  }

  .select-dropdown li {
    padding: 10px 12px;
    color: var(--gray-light);
    border-radius: 6px;
    cursor: pointer;
    font-size: 0.98rem;
    line-height: 1.2;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }

  .select-dropdown li:hover,
  .select-dropdown li.active {
    background: var(--layer-soft);
    color: var(--accent);
  }
  /* Flex row for label + select */
  .inline-form-row {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 18px;
    flex-wrap: wrap;
  }
  .inline-form-row label {
    margin-bottom: 0;
    font-weight: 500;
    color: var(--gray-light);
    min-width: 90px;
  }
  .inline-form-row .form-select {
    min-width: 1058px;
    margin-bottom: 0;
  }
  @media (max-width: 600px) {
    .inline-form-row {
      flex-direction: column;
      align-items: stretch;
      gap: 8px;
    }
    .inline-form-row label {
      min-width: 0;
    }
  }
  .form-select option {
    color: #fff !important;
    background: #222 !important;
    min-height: 30px;
  }
  .form-select {
    min-width: 1058px !important; /* hoặc giá trị nhỏ hơn 1058px */
  }

  /* Khi đặt attribute size trên <select>, giới hạn chiều cao và bật scrollbar */
  .form-select[size] {
    height: auto;
    max-height: 220px; /* điều chỉnh theo cần thiết (px) */
    overflow-y: auto;
    -webkit-appearance: none;
    appearance: none;
    padding-right: 6px; /* đảm bảo không bị cắt nội dung */
  }

  /* Keep favorite select inline with its label, only for this row */
  .inline-form-row.favorite-row {
    align-items: center;
    gap: 12px;
  }

  .inline-form-row.favorite-row .form-select {
    min-width: 300px;
    max-width: calc(100% - 120px);
    flex: 1 1 auto;
    margin-bottom: 0;
  }

  /* Make the multi-row select (size=5) look tidy */
  #shareVideoSelect[size] {
    height: auto; /* let browser show `size` rows */
    padding: 8px 12px;
    overflow-y: auto;
    -webkit-appearance: none;
    appearance: none;
  }

  /* Custom dropdown (shared style for both selects) */
  .custom-select-container {
    position: relative;
    display: inline-block;
    width: 100%;
    max-width: 1058px; /* cùng kích thước với các .form-select khác */
    vertical-align: middle;
  }

  .custom-select-container.small {
    max-width: 1058px; /* giữ cùng kích thước để giống nhau */
  }

  .select-display {
    cursor: pointer;
    user-select: none;
    padding: 10px 14px;
    border-radius: 8px;
    background: var(--bg-soft);
    color: var(--gray-light);
    border: 1.5px solid var(--border-soft);
    min-height: 44px;
    display: flex;
    align-items: center;
    gap: 12px;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis; /* rút ngắn văn bản dài */
  }

  /* nhỏ icon mũi tên phải, không che text */
  .select-display::after {
    content: "";
    display: inline-block;
    flex: 0 0 18px;
    width: 18px;
    height: 18px;
    margin-left: 8px;
    background-image: linear-gradient(45deg, transparent 50%, currentColor 50%),
      linear-gradient(-45deg, transparent 50%, currentColor 50%);
    background-size: 7px 7px;
    background-position: center;
    opacity: 0.85;
  }

  /* dropdown popup */
  .select-dropdown {
    position: absolute;
    left: 0;
    right: 0;
    margin-top: 8px;
    background: var(--bg-panel);
    border: 1.5px solid var(--border-soft);
    border-radius: 8px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.45);
    z-index: 1200;
    display: none;
    max-height: 320px;
    overflow: hidden;
    padding: 6px;
  }

  .select-dropdown.open {
    display: block;
  }

  .select-dropdown ul {
    list-style: none;
    margin: 0;
    padding: 0;
    max-height: 220px;
    overflow-y: auto;
    scrollbar-width: thin;
    -webkit-overflow-scrolling: touch;
  }

  .select-dropdown li {
    padding: 10px 12px;
    color: var(--gray-light);
    border-radius: 6px;
    cursor: pointer;
    font-size: 0.98rem;
    line-height: 1.2;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }

  .select-dropdown li:hover,
  .select-dropdown li.active {
    background: var(--layer-soft);
    color: var(--accent);
  }
  /* Flex row for label + select */
  .inline-form-row {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 18px;
    flex-wrap: wrap;
  }
  .inline-form-row label {
    margin-bottom: 0;
    font-weight: 500;
    color: var(--gray-light);
    min-width: 90px;
  }
  .inline-form-row .form-select {
    min-width: 1058px;
    margin-bottom: 0;
  }
  @media (max-width: 600px) {
    .inline-form-row {
      flex-direction: column;
      align-items: stretch;
      gap: 8px;
    }
    .inline-form-row label {
      min-width: 0;
    }
  }
  .form-select option {
    color: #fff !important;
    background: #222 !important;
    min-height: 30px;
  }
  .form-select {
    min-width: 1058px !important; /* hoặc giá trị nhỏ hơn 1058px */
  }

  /* Khi đặt attribute size trên <select>, giới hạn chiều cao và bật scrollbar */
  .form-select[size] {
    height: auto;
    max-height: 220px; /* điều chỉnh theo cần thiết (px) */
    overflow-y: auto;
    -webkit-appearance: none;
    appearance: none;
    padding-right: 6px; /* đảm bảo không bị cắt nội dung */
  }

  /* Keep favorite select inline with its label, only for this row */
  .inline-form-row.favorite-row {
    align-items: center;
    gap: 12px;
  }

  .inline-form-row.favorite-row .form-select {
    min-width: 300px;
    max-width: calc(100% - 120px);
    flex: 1 1 auto;
    margin-bottom: 0;
  }

  /* Make the multi-row select (size=5) look tidy */
  #shareVideoSelect[size] {
    height: auto; /* let browser show `size` rows */
    padding: 8px 12px;
    overflow-y: auto;
    -webkit-appearance: none;
    appearance: none;
  }

  /* Custom dropdown (shared style for both selects) */
  .custom-select-container {
    position: relative;
    display: inline-block;
    width: 100%;
    max-width: 1058px; /* cùng kích thước với các .form-select khác */
    vertical-align: middle;
  }

  .custom-select-container.small {
    max-width: 1058px; /* giữ cùng kích thước để giống nhau */
  }

  .select-display {
    cursor: pointer;
    user-select: none;
    padding: 10px 14px;
    border-radius: 8px;
    background: var(--bg-soft);
    color: var(--gray-light);
    border: 1.5px solid var(--border-soft);
    min-height: 44px;
    display: flex;
    align-items: center;
    gap: 12px;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis; /* rút ngắn văn bản dài */
  }

  /* nhỏ icon mũi tên phải, không che text */
  .select-display::after {
    content: "";
    display: inline-block;
    flex: 0 0 18px;
    width: 18px;
    height: 18px;
    margin-left: 8px;
    background-image: linear-gradient(45deg, transparent 50%, currentColor 50%),
      linear-gradient(-45deg, transparent 50%, currentColor 50%);
    background-size: 7px 7px;
    background-position: center;
    opacity: 0.85;
  }

  /* dropdown popup */
  .select-dropdown {
    position: absolute;
    left: 0;
    right: 0;
    margin-top: 8px;
    background: var(--bg-panel);
    border: 1.5px solid var(--border-soft);
    border-radius: 8px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.45);
    z-index: 1200;
    display: none;
    max-height: 320px;
    overflow: hidden;
    padding: 6px;
  }

  .select-dropdown.open {
    display: block;
  }

  .select-dropdown ul {
    list-style: none;
    margin: 0;
    padding: 0;
    max-height: 220px;
    overflow-y: auto;
    scrollbar-width: thin;
    -webkit-overflow-scrolling: touch;
  }

  .select-dropdown li {
    padding: 10px 12px;
    color: var(--gray-light);
    border-radius: 6px;
    cursor: pointer;
    font-size: 0.98rem;
    line-height: 1.2;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }

  .select-dropdown li:hover,
  .select-dropdown li.active {
    background: var(--layer-soft);
    color: var(--accent);
  }
  /* Flex row for label + select */
  .inline-form-row {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 18px;
    flex-wrap: wrap;
  }
  .inline-form-row label {
    margin-bottom: 0;
    font-weight: 500;
    color: var(--gray-light);
    min-width: 90px;
  }
  .inline-form-row .form-select {
    min-width: 1058px;
    margin-bottom: 0;
  }
  @media (max-width: 600px) {
    .inline-form-row {
      flex-direction: column;
      align-items: stretch;
      gap: 8px;
    }
    .inline-form-row label {
      min-width: 0;
    }
  }
  .form-select option {
    color: #fff !important;
    background: #222 !important;
    min-height: 30px;
  }
  .form-select {
    min-width: 1058px !important; /* hoặc giá trị nhỏ hơn 1058px */
  }

  /* Khi đặt attribute size trên <select>, giới hạn chiều cao và bật scrollbar */
  .form-select[size] {
    height: auto;
    max-height: 220px; /* điều chỉnh theo cần thiết (px) */
    overflow-y: auto;
    -webkit-appearance: none;
    appearance: none;
    padding-right: 6px; /* đảm bảo không bị cắt nội dung */
  }

  /* Keep favorite select inline with its label, only for this row */
  .inline-form-row.favorite-row {
    align-items: center;
    gap: 12px;
  }

  .inline-form-row.favorite-row .form-select {
    min-width: 300px;
    max-width: calc(100% - 120px);
    flex: 1 1 auto;
    margin-bottom: 0;
  }

  /* Make the multi-row select (size=5) look tidy */
  #shareVideoSelect[size] {
    height: auto; /* let browser show `size` rows */
    padding: 8px 12px;
    overflow-y: auto;
    -webkit-appearance: none;
    appearance: none;
  }
  /* Custom dropdown that opens as a popup with scrollbar */
  .custom-select-container {
    position: relative;
    display: inline-block;
    width: 100%;
    max-width: 100%;
  }
  .select-display {
    cursor: pointer;
    user-select: none;
    padding: 8px 12px;
    border-radius: 8px;
    background: var(--bg-soft);
    color: var(--gray-light);
    border: 1.5px solid var(--border-soft);
    min-height: 42px;
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .select-display:after {
    content: "";
    margin-left: auto;
    width: 12px;
    height: 12px;
    background-image: linear-gradient(45deg, transparent 50%, currentColor 50%),
      linear-gradient(-45deg, transparent 50%, currentColor 50%);
    background-size: 6px 6px;
    background-position: center;
    transform: translateY(1px);
    opacity: 0.85;
  }
  .select-dropdown {
    position: absolute;
    left: 0;
    right: 0;
    margin-top: 8px;
    background: var(--bg-panel);
    border: 1.5px solid var(--border-soft);
    border-radius: 8px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.45);
    z-index: 1200;
    display: none;
    max-height: 320px; /* tổng khung dropdown */
    overflow: hidden;
    padding: 6px;
  }
  .select-dropdown.open {
    display: block;
  }
  .select-dropdown ul {
    list-style: none;
    margin: 0;
    padding: 0;
    max-height: 220px; /* chiều cao cuộn bên trong */
    overflow-y: auto;
    scrollbar-width: thin;
    -webkit-overflow-scrolling: touch;
  }
  .select-dropdown li {
    padding: 10px 12px;
    color: var(--gray-light);
    border-radius: 6px;
    cursor: pointer;
    font-size: 0.98rem;
    line-height: 1.2;
  }
  .select-dropdown li:hover,
  .select-dropdown li.active {
    background: var(--layer-soft);
    color: var(--accent);
  }
</style>
<div>
  <div class="stats-row">
    <!-- Card 1: Đăng ký theo thời gian -->
    <div class="stat-card">
      <div class="stat-title">
        Thống kê số lượng người dùng đăng ký theo thời gian
      </div>
      <canvas id="userRegisterChart"></canvas>
    </div>
    <!-- Card 2: Top video được xem nhiều nhất -->
    <div class="stat-card">
      <div class="stat-title">Thống kê top video được xem nhiều nhất</div>
      <canvas
        id="topVideoChart"
        style="height: 220px; max-width: 100%"
      ></canvas>
    </div>
    <!-- Card 3: Số lượt bình luận theo từng video -->
    <div class="stat-card">
      <div class="stat-title">Thống kê số lượt bình luận theo từng video</div>
      <canvas id="commentChart"></canvas>
    </div>
  </div>
  <!-- Tabs Bootstrap -->
  <ul class="nav nav-tabs mb-3" id="statTabs" role="tablist">
    <li class="nav-item" role="presentation">
      <button
        class="nav-link active"
        id="yeuthich-tab"
        data-bs-toggle="tab"
        data-bs-target="#yeuthich"
        type="button"
        role="tab"
        aria-controls="yeuthich"
        aria-selected="true"
      >
        Danh Sách Người Dùng Yêu Thích
      </button>
    </li>
    <li class="nav-item" role="presentation">
      <button
        class="nav-link"
        id="chiase-tab"
        data-bs-toggle="tab"
        data-bs-target="#chiase"
        type="button"
        role="tab"
        aria-controls="chiase"
        aria-selected="false"
      >
        Danh Sách Bạn Đã Chia Sẻ
      </button>
    </li>
  </ul>
  <!-- .tab-indicator đã ẩn bằng CSS -->
  <div class="tab-content" id="statTabsContent">
    <!-- Tab 1: Người dùng yêu thích -->
    <div
      class="tab-pane fade show active section"
      id="yeuthich"
      role="tabpanel"
      aria-labelledby="yeuthich-tab"
    >
      <div class="section-title">Danh Sách Người Dùng Yêu Thích</div>
      <div class="inline-form-row favorite-row">
        <label for="videoSelect">Chọn video:</label>
        <div class="custom-select-container">
          <select
            id="videoSelect"
            name="videoId"
            class="form-select"
            style="display: none"
          ></select>
          <div id="videoSelectDisplay" class="select-display">
            -- Chọn video --
          </div>
          <div
            id="videoSelectDropdown"
            class="select-dropdown"
            aria-hidden="true"
          >
            <ul></ul>
          </div>
        </div>
      </div>
      <div class="table-responsive">
        <table id="favoriteUsersTable">
          <thead>
            <tr>
              <th>Tên người dùng</th>
              <th>Email người dùng</th>
              <th>Ngày thích</th>
            </tr>
          </thead>
          <tbody>
            <!-- Dữ liệu sẽ được render bằng JS -->
          </tbody>
        </table>
      </div>
    </div>
    <!-- Tab 2: Bạn đã chia sẻ -->
    <div
      class="tab-pane fade section"
      id="chiase"
      role="tabpanel"
      aria-labelledby="chiase-tab"
    >
      <div class="section-title">Danh Sách Bạn Đã Chia Sẻ</div>
      <div class="inline-form-row">
        <label for="shareVideoSelect" class="form-label">Chọn video:</label>
        <div class="custom-select-container small" style="max-width: 350px">
          <select
            id="shareVideoSelect"
            class="form-select"
            style="display: none"
          ></select>
          <div id="shareVideoSelectDisplay" class="select-display">
            -- Chọn video --
          </div>
          <div
            id="shareVideoSelectDropdown"
            class="select-dropdown"
            aria-hidden="true"
          >
            <ul></ul>
          </div>
        </div>
      </div>
      <div class="table-responsive">
        <table id="shareTable">
          <thead>
            <tr>
              <th>Họ tên và email người gửi</th>
              <th>Email người nhận</th>
              <th>Ngày gửi video</th>
            </tr>
          </thead>
          <tbody>
            <!-- Dữ liệu sẽ được render bằng JS -->
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
  document.addEventListener("DOMContentLoaded", function () {
    const url = "${pageContext.request.contextPath}/admin/api/favorite-report";
    fetch(url)
      .then((res) => res.json())
      .then((data) => {
        // 1. Thống kê số lượng user đăng ký theo thời gian
        const userLabels = data.userStats.map((x) => x.date);
        const userCounts = data.userStats.map((x) => x.count);

        new Chart(document.getElementById("userRegisterChart"), {
          type: "line",
          data: {
            labels: userLabels,
            datasets: [
              {
                label: "Số lượng đăng ký",
                data: userCounts,
                borderColor: "rgba(75,192,192,1)",
                backgroundColor: "rgba(75,192,192,0.2)",
                fill: true,
                tension: 0.3,
                pointRadius: 4,
                pointHoverRadius: 6,
              },
            ],
          },
          options: {
            responsive: true,
            plugins: {
              legend: {
                labels: {
                  color: "#fff",
                },
              },
              tooltip: {
                callbacks: {
                  title: function (context) {
                    return "Ngày: " + context[0].label;
                  },
                  label: function (context) {
                    return "Số lượng: " + context.parsed.y;
                  },
                },
              },
            },
            scales: {
              x: {
                ticks: {
                  color: "#fff",
                  font: { size: 13 },
                  maxRotation: 0,
                  minRotation: 0,
                },
                grid: { display: false },
              },
              y: {
                ticks: {
                  color: "#fff",
                  font: { size: 13 },
                },
                grid: { color: "rgba(255,255,255,0.08)" },
              },
            },
          },
        });

        // 2. Thống kê top video được xem nhiều nhất (bar chart ngang)
        const topN = 7;
        const videoLabels = data.topVideos.slice(0, topN).map((x) => x.title);
        const videoViews = data.topVideos.slice(0, topN).map((x) => x.views);

        new Chart(document.getElementById("topVideoChart"), {
          type: "bar",
          data: {
            labels: videoLabels,
            datasets: [
              {
                label: "Lượt xem",
                data: videoViews,
                backgroundColor: "rgba(255,99,132,0.5)",
                maxBarThickness: 28,
              },
            ],
          },
          options: {
            indexAxis: "y", // <-- chuyển sang bar ngang
            responsive: true,
            plugins: {
              legend: {
                labels: {
                  color: "#fff",
                },
              },
              tooltip: {
                callbacks: {
                  title: function (context) {
                    return context[0].label;
                  },
                  label: function (context) {
                    return "Lượt xem: " + context.parsed.x;
                  },
                },
              },
            },
            scales: {
              x: {
                ticks: {
                  color: "#fff",
                  font: { size: 13 },
                },
                grid: { color: "rgba(255,255,255,0.08)" },
              },
              y: {
                ticks: {
                  color: "#fff",
                  font: { size: 13 },
                  callback: function (value, index, ticks) {
                    let label = this.getLabelForValue(value);
                    return label.length > 15
                      ? label.substring(0, 12) + "..."
                      : label;
                  },
                },
                grid: { display: false },
              },
            },
          },
        });

        // 3. Thống kê số lượt bình luận theo từng video (Bar chart ngang, gọn đẹp)
        const topCommentN = 7; // chỉ lấy top 7 video nhiều bình luận nhất
        const commentLabels = data.commentStats
          .slice(0, topCommentN)
          .map((x) => x.title);
        const commentCounts = data.commentStats
          .slice(0, topCommentN)
          .map((x) => x.count);

        new Chart(document.getElementById("commentChart"), {
          type: "bar",
          data: {
            labels: commentLabels,
            datasets: [
              {
                label: "Bình luận",
                data: commentCounts,
                backgroundColor: "rgba(153,102,255,0.7)",
                maxBarThickness: 28,
              },
            ],
          },
          options: {
            indexAxis: "y", // bar chart nằm ngang
            responsive: true,
            plugins: {
              legend: {
                labels: {
                  color: "#fff",
                },
              },
              tooltip: {
                callbacks: {
                  title: function (context) {
                    return context[0].label;
                  },
                  label: function (context) {
                    return "Bình luận: " + context.parsed.x;
                  },
                },
              },
            },
            scales: {
              x: {
                ticks: {
                  color: "#fff",
                  font: { size: 13 },
                },
                grid: { color: "rgba(255,255,255,0.08)" },
              },
              y: {
                ticks: {
                  color: "#fff",
                  font: { size: 13 },
                  callback: function (value, index, ticks) {
                    let label = this.getLabelForValue(value);
                    return label.length > 15
                      ? label.substring(0, 12) + "..."
                      : label;
                  },
                },
                grid: { display: false },
              },
            },
          },
        });
      });
  });
  document.addEventListener("DOMContentLoaded", function () {
    const apiUrl = "${pageContext.request.contextPath}/admin/api/videos";

    fetch(apiUrl)
      .then((res) => res.json())
      .then((data) => {
        const fillList = (selectEl, displayEl, dropdownEl, items) => {
          selectEl.innerHTML = "";
          const defaultOption = document.createElement("option");
          defaultOption.value = "";
          defaultOption.textContent = "-- Chọn video --";
          selectEl.appendChild(defaultOption);

          const ul = dropdownEl.querySelector("ul");
          ul.innerHTML = "";

          items.forEach((video) => {
            const cleanTitle = (video.title || "")
              .replace(/[\r\n]+/g, " ")
              .trim();

            // add option to hidden select
            const opt = document.createElement("option");
            opt.value = video.id;
            opt.textContent = cleanTitle;
            selectEl.appendChild(opt);

            // add li to custom dropdown
            const li = document.createElement("li");
            li.dataset.value = video.id;
            li.textContent = cleanTitle;
            ul.appendChild(li);

            li.addEventListener("click", function (e) {
              selectEl.value = this.dataset.value;
              displayEl.textContent = this.textContent;
              // mark active style
              Array.from(ul.children).forEach((x) =>
                x.classList.remove("active")
              );
              this.classList.add("active");
              // close dropdown
              dropdownEl.classList.remove("open");
              dropdownEl.setAttribute("aria-hidden", "true");
              // trigger change for existing handlers
              selectEl.dispatchEvent(new Event("change"));
            });
          });
        };

        // video select elements
        const videoSelect = document.getElementById("videoSelect");
        const videoDisplay = document.getElementById("videoSelectDisplay");
        const videoDropdown = document.getElementById("videoSelectDropdown");

        // share select elements
        const shareSelect = document.getElementById("shareVideoSelect");
        const shareDisplay = document.getElementById("shareVideoSelectDisplay");
        const shareDropdown = document.getElementById(
          "shareVideoSelectDropdown"
        );

        if (videoSelect && videoDisplay && videoDropdown) {
          fillList(videoSelect, videoDisplay, videoDropdown, data);

          videoDisplay.addEventListener("click", () => {
            const open = videoDropdown.classList.toggle("open");
            videoDropdown.setAttribute("aria-hidden", open ? "false" : "true");
            if (open) shareDropdown.classList.remove("open");
          });
        }

        if (shareSelect && shareDisplay && shareDropdown) {
          fillList(shareSelect, shareDisplay, shareDropdown, data);

          shareDisplay.addEventListener("click", () => {
            const open = shareDropdown.classList.toggle("open");
            shareDropdown.setAttribute("aria-hidden", open ? "false" : "true");
            if (open) videoDropdown.classList.remove("open");
          });
        }

        // close any open dropdown when clicking outside
        document.addEventListener("click", function (ev) {
          if (
            !(
              (videoDropdown &&
                videoDropdown.parentElement.contains(ev.target)) ||
              (shareDropdown && shareDropdown.parentElement.contains(ev.target))
            )
          ) {
            if (videoDropdown) {
              videoDropdown.classList.remove("open");
              videoDropdown.setAttribute("aria-hidden", "true");
            }
            if (shareDropdown) {
              shareDropdown.classList.remove("open");
              shareDropdown.setAttribute("aria-hidden", "true");
            }
          }
        });

        // close on Escape
        document.addEventListener("keydown", function (ev) {
          if (ev.key === "Escape") {
            if (videoDropdown) {
              videoDropdown.classList.remove("open");
              videoDropdown.setAttribute("aria-hidden", "true");
            }
            if (shareDropdown) {
              shareDropdown.classList.remove("open");
              shareDropdown.setAttribute("aria-hidden", "true");
            }
          }
        });
      })
      .catch((err) => {
        console.error("Lỗi tải danh sách video:", err);
      });
  });
  // Đoạn này để load danh sách video cho select ở tab "Bạn đã chia sẻ"
  document.addEventListener("DOMContentLoaded", function () {
    fetch("${pageContext.request.contextPath}/admin/api/videos")
      .then((res) => res.json())
      .then((data) => {
        const select = document.getElementById("shareVideoSelect");
        if (!select) return;
        select.innerHTML = "";
        const defaultOption = document.createElement("option");
        defaultOption.value = "";
        defaultOption.textContent = "-- Chọn video --";
        select.appendChild(defaultOption);
        data.forEach((video) => {
          const cleanTitle = (video.title || "")
            .replace(/[\r\n]+/g, " ")
            .trim();
          const opt = document.createElement("option");
          opt.value = video.id;
          opt.textContent = cleanTitle;
          select.appendChild(opt);
        });
      })
      .catch((err) => {
        console.error("Lỗi tải danh sách video cho tab 'Bạn đã chia sẻ':", err);
      });
  });
  // Safe handler: wait DOM, check elements, render textContent (no HTML injection)
  document.addEventListener("DOMContentLoaded", function () {
    const videoSelect = document.getElementById("videoSelect");
    const tbody = document.querySelector("#favoriteUsersTable tbody");
    if (!videoSelect || !tbody) return;

    videoSelect.addEventListener("change", loadFavoriteUsers);

    function loadFavoriteUsers() {
      const videoId = videoSelect.value;
      tbody.innerHTML = "";

      if (!videoId) {
        tbody.innerHTML = `<tr class="table-empty-row"><td colspan="3">Vui lòng chọn video.</td></tr>`;
        return;
      }

      const url =
        `${pageContext.request.contextPath}/admin/api/favorite-users?videoId=` +
        encodeURIComponent(videoId);

      fetch(url)
        .then((res) => {
          if (!res.ok) throw new Error(`HTTP error! status: ${res.status}`);
          return res.json();
        })
        .then((data) => {
          if (!Array.isArray(data) || data.length === 0) {
            tbody.innerHTML = `<tr class="table-empty-row"><td colspan="3">Không có dữ liệu.</td></tr>`;
            return;
          }

          const frag = document.createDocumentFragment();
          data.forEach((user) => {
            const tr = document.createElement("tr");

            const tdName = document.createElement("td");
            tdName.textContent = user.fullname || user.name || "";

            const tdEmail = document.createElement("td");
            tdEmail.textContent = user.email || "";

            const tdDate = document.createElement("td");
            tdDate.textContent = user.likeDate || user.date || "";

            tr.appendChild(tdName);
            tr.appendChild(tdEmail);
            tr.appendChild(tdDate);
            frag.appendChild(tr);
          });
          tbody.appendChild(frag);
        })
        .catch((err) => {
          console.error("Lỗi tải danh sách người dùng yêu thích:", err);
          tbody.innerHTML = `<tr class="table-empty-row"><td colspan="3">Lỗi tải dữ liệu.</td></tr>`;
        });
    }
  });
  // Render share list when selecting a video in "Bạn đã chia sẻ" tab
  document.addEventListener("DOMContentLoaded", function () {
    const shareSelect = document.getElementById("shareVideoSelect");
    const shareTbody = document.querySelector("#shareTable tbody");
    if (!shareSelect || !shareTbody) return;

    shareSelect.addEventListener("change", function () {
      const videoId = this.value;
      shareTbody.innerHTML = "";

      if (!videoId) {
        shareTbody.innerHTML = `
          <tr class="table-empty-row">
            <td colspan="3">Vui lòng chọn video.</td>
          </tr>`;
        return;
      }

      const url =
        `${pageContext.request.contextPath}/admin/api/shares?videoId=` +
        encodeURIComponent(videoId);

      fetch(url)
        .then((res) => {
          if (!res.ok) throw new Error("HTTP " + res.status);
          return res.json();
        })
        .then((data) => {
          if (!Array.isArray(data) || data.length === 0) {
            shareTbody.innerHTML = `
              <tr class="table-empty-row">
                <td colspan="3">Không có dữ liệu.</td>
              </tr>`;
            return;
          }

          const frag = document.createDocumentFragment();
          data.forEach((s) => {
            const tr = document.createElement("tr");

            const tdSender = document.createElement("td");
            tdSender.textContent =
              (s.senderFullname || "") +
              (s.senderEmail ? " (" + s.senderEmail + ")" : "");

            const tdRecipient = document.createElement("td");
            tdRecipient.textContent = s.recipientEmail || "";

            const tdDate = document.createElement("td");
            tdDate.textContent = s.shareDate || "";

            tr.appendChild(tdSender);
            tr.appendChild(tdRecipient);
            tr.appendChild(tdDate);
            frag.appendChild(tr);
          });
          shareTbody.appendChild(frag);
        })
        .catch((err) => {
          console.error("Lỗi tải danh sách chia sẻ:", err);
          shareTbody.innerHTML = `
            <tr class="table-empty-row">
              <td colspan="3">Lỗi tải dữ liệu.</td>
            </tr>`;
        });
    });
  });
</script>
