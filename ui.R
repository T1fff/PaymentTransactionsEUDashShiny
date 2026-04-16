library(shiny)
library(shinydashboard)

ui <- fluidPage(
  tags$head(
    tags$meta(charset = "UTF-8"),
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1.0"),
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=DM+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,400&family=DM+Mono:wght@400;500&display=swap"),
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"),
    tags$style(HTML("

      /* ============================================================
         RESET & BASE
         ============================================================ */
      *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

      :root {
        --navy:       #f8fafc;      /* fondo general */
        --navy-mid:   #f1f5f9;
        --navy-soft:  #ffffff;
      
        --border:     rgba(0,0,0,0.08);
        --border-light: #e2e8f0;
      
        --accent:     #2563eb;
        --accent-2:   #4f46e5;
        --accent-glow: rgba(37,99,235,0.15);
      
        --red:        #dc2626;
        --green:      #059669;
        --amber:      #d97706;
      
        --text-pri:   #0f172a;   /* 🔥 texto principal oscuro */
        --text-sec:   #334155;
        --text-muted: #64748b;
      
        --card-bg:    #ffffff;
        --card-border: rgba(0,0,0,0.08);
      
        --radius:     12px;
        --radius-lg:  18px;
        --shadow:     0 6px 20px rgba(0,0,0,0.06);
      
        --font:       'DM Sans', sans-serif;
        --mono:       'DM Mono', monospace;
      }

      html, body {
        font-family: var(--font);
        background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
        color: var(--text-pri);
        min-height: 100vh;
      }

      /* Shiny container resets */
      .container-fluid { padding: 0 !important; }
      body > .container-fluid { max-width: 100%; }

      /* ============================================================
         TOP NAVIGATION BAR
         ============================================================ */
      .corp-topbar {
        position: sticky;
        top: 0;
        z-index: 1000;
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 32px;
        height: 60px;
        background: rgba(255,255,255,0.9);
        border-bottom: 1px solid rgba(0,0,0,0.08);
        
      }
      

      .corp-topbar-brand {
        display: flex;
        align-items: center;
        gap: 12px;
        flex-shrink: 0;
      }

      .corp-topbar-brand img {
        height: 28px;
        width: auto;
        filter: brightness(1.1);
      }

      .corp-topbar-brand-text {
        font-size: 13px;
        font-weight: 600;
        color: var(--text-pri);
        letter-spacing: 0.01em;
        white-space: nowrap;
        max-width: 320px;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      .corp-topbar-brand-text span {
        color: var(--accent);
      }

      .corp-topbar-divider {
        width: 1px;
        height: 24px;
        background: var(--border);
        margin: 0 20px;
        flex-shrink: 0;
      }

      /* NAV TABS */
      .corp-nav {
        display: flex;
        align-items: center;
        gap: 2px;
        flex: 1;
      }

      .corp-nav-item {
        padding: 6px 14px;
        border-radius: 8px;
        font-size: 12.5px;
        font-weight: 500;
        color: var(--text-sec);
        cursor: pointer;
        transition: all 0.18s ease;
        white-space: nowrap;
        display: flex;
        align-items: center;
        gap: 6px;
        border: none;
        background: transparent;
        letter-spacing: 0.01em;
      }

      .corp-nav-item i {
        font-size: 11px;
        opacity: 0.7;
      }

      .corp-nav-item:hover {
        color: var(--text-pri);
        background: rgba(0,0,0,0.05);
      }

      .corp-nav-item.active {
        color: var(--accent);
        background: var(--accent-glow);
        font-weight: 600;
      }

      .corp-nav-item.active i {
        color: var(--accent);
        background: var(--accent-glow);
      }

      /* TOPBAR RIGHT: SOCIAL LINKS */
      .corp-topbar-right {
        display: flex;
        align-items: center;
        gap: 8px;
        flex-shrink: 0;
        margin-left: 16px;
      }

      .corp-social-btn {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 5px 11px;
        border-radius: 8px;
        background: rgba(255,255,255,0.05);
        border: 1px solid var(--border);
        color: var(--text-sec) !important;
        font-size: 12px;
        font-weight: 500;
        text-decoration: none !important;
        transition: all 0.18s ease;
      }

      .corp-social-btn:hover {
        background: rgba(255,255,255,0.1);
        color: var(--text-pri) !important;
        border-color: rgba(255,255,255,0.15);
      }

      .corp-social-btn i { font-size: 13px; }

      .corp-social-dropdown {
        position: relative;
        display: inline-block;
      }

      .corp-social-dropdown-menu {
        display: none;
        position: absolute;
        right: 0;
        background: var(--navy-soft);
        border: 1px solid var(--border);
        border-radius: var(--radius);
        overflow: hidden;
        min-width: 200px;
        box-shadow: var(--shadow);
        z-index: 2000;
        top: calc(100% + 8px);  /* cambia a: */
        top: 100%;
        padding-top: 8px; 
      }

      .corp-social-dropdown:hover .corp-social-dropdown-menu {
        display: block;
      }

      .corp-social-dropdown-item {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 16px;
        color: var(--text-sec) !important;
        font-size: 13px;
        text-decoration: none !important;
        transition: background 0.15s;
        border-bottom: 1px solid var(--border);
      }

      .corp-social-dropdown-item:last-child { border-bottom: none; }

      .corp-social-dropdown-item:hover {
        background: rgba(255,255,255,0.06);
        color: var(--text-pri) !important;
      }

      /* ============================================================
         PAGE WRAPPER
         ============================================================ */
      .corp-page-wrapper {
        min-height: calc(100vh - 60px);
      }

      /* TAB PANELS */
      .corp-tab-panel {
        display: none;
        padding: 36px 40px;
        animation: fadeSlideIn 0.22s ease;
      }

      .corp-tab-panel.active { display: block; }

      @keyframes fadeSlideIn {
        from { opacity: 0; transform: translateY(8px); }
        to   { opacity: 1; transform: translateY(0); }
      }

      /* ============================================================
         TYPOGRAPHY
         ============================================================ */
      .corp-page-title {
        font-size: 26px;
        font-weight: 700;
        color: var(--text-pri);
        letter-spacing: -0.02em;
        line-height: 1.2;
        margin-bottom: 6px;
      }

      .corp-page-sub {
        font-size: 15px;
        color: var(--text-muted);
        font-weight: 400;
        margin-bottom: 28px;
        letter-spacing: 0.01em;
      }

      .corp-section-title {
        font-size: 14px;
        font-weight: 600;
        color: var(--text-pri);
        margin-bottom: 4px;
        letter-spacing: 0.01em;
      }

      .corp-section-sub {
        font-size: 13px;
        color: var(--text-muted);
        margin-bottom: 16px;
        font-weight: 400;
      }

      /* ============================================================
         CARDS
         ============================================================ */
      .corp-card {
        border: 1px solid var(--card-border);
        border-radius: var(--radius-lg);
        padding: 24px 28px;
        margin-bottom: 20px;
        /* backdrop-filter: blur(4px);  <-- ELIMINA esta línea */
        background: #ffffff;
        box-shadow: var(--shadow);
      }

      .corp-card-sm {
        padding: 18px 22px;
      }

      /* ============================================================
         KPI GRID
         ============================================================ */
      .corp-kpi-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 14px;
        margin-bottom: 24px;
      }

      @media (max-width: 1100px) {
        .corp-kpi-grid { grid-template-columns: repeat(2, 1fr); }
      }

      .corp-kpi {
        border: 1px solid var(--card-border);
        border-radius: var(--radius-lg);
        padding: 20px 22px;
        position: relative;
        overflow: hidden;
        transition: border-color 0.2s;
        background: #ffffff;
      }

      .corp-kpi::before {
        content: '';
        position: absolute;
        top: 0; left: 0;
        width: 3px; height: 100%;
        border-radius: 3px 0 0 3px;
      }

      .corp-kpi.kpi-blue::before   { background: var(--accent); }
      .corp-kpi.kpi-red::before    { background: var(--red); }
      .corp-kpi.kpi-green::before  { background: var(--green); }
      .corp-kpi.kpi-amber::before  { background: var(--amber); }

      .corp-kpi-badge {
        font-size: 9.5px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        padding: 3px 9px;
        border-radius: 20px;
        display: inline-block;
        margin-bottom: 12px;
      }

      .badge-blue  { background: rgba(59,130,246,0.15);  color: #60a5fa; }
      .badge-red   { background: rgba(239,68,68,0.15);   color: #f87171; }
      .badge-green { background: rgba(16,185,129,0.15);  color: #34d399; }
      .badge-amber { background: rgba(245,158,11,0.15);  color: #fbbf24; }
      
      
      .corp-kpi-value {
        font-size: 28px;
        font-weight: 700;
        color: #0f172a !important;
        background: transparent !important;
      }
    

      .corp-kpi-label {
        font-size: 11.5px;
        color: #64748b !important;
        font-weight: 400;
        line-height: 1.4;
      }

      .corp-kpi-hint {
        font-size: 10.5px;
        color: var(--text-muted);
        margin-top: 4px;
        opacity: 0.7;
      }

      /* ============================================================
         HERO IMAGE BLOCK
         ============================================================ */
      .corp-hero-image {
          width: 100%;
          display: flex;
          justify-content: center;
          align-items: center;
          padding: 20px 0 40px 0; /* Más espacio abajo que arriba para que respire */
          background: transparent; 
      }
      
      /* La imagen: el truco es que no sea tan ancha para que respete los márgenes del texto */
      .hero-img {
          width: 100%;
          max-width: 1100px; /* Un poco más estrecha la hace ver más elegante */
          height: auto;
          display: block;
          border-radius: 12px;
          /* Una sombra más suave y extendida (estilo Apple) */
          box-shadow: 0 20px 40px rgba(0,0,0,0.06);
          /* Un borde gris casi invisible para definir los límites en fondos blancos */
          border: 1px solid rgba(0,0,0,0.03); 
          transition: transform 0.3s ease; /* Un toque de interactividad */
      }
      
      .hero-img:hover {
          transform: translateY(-5px); /* Se eleva sutilmente al pasar el mouse */
      }

      /* ============================================================
         DIVIDER
         ============================================================ */
      .corp-divider {
        height: 1px;
        background: var(--card-border);
        margin: 24px 0;
      }

      /* ============================================================
         TEXT BODY
         ============================================================ */
      .corp-body-text {
        font-size: 15.5px; /* Antes 13.5px */
        line-height: 1.75; /* Un poco menos de espacio entre líneas para compensar el tamaño */
        font-weight: 400;
        color: #334155; /* Un tono más oscuro para mejorar contraste */
      }

      .corp-body-text p { margin-bottom: 1rem; }
      .corp-body-text p:last-child { margin-bottom: 0; }

      /* ============================================================
         INFO ACCENT CARDS
         ============================================================ */
      .corp-accent-card {
        background: rgba(59,130,246,0.05);
        border-left: 3px solid var(--accent);
        border-radius: 0 10px 10px 0;
        padding: 14px 18px;
        margin-bottom: 12px;
      }

      .corp-accent-card-title {
        font-size: 12.5px;
        font-weight: 600;
        color: #60a5fa;
        margin-bottom: 6px;
        display: flex;
        align-items: center;
        gap: 6px;
      }

      .corp-accent-card-text {
        font-size: 14px;
        color: var(--text-sec);
        line-height: 1.6;
        margin: 0;
      }

      /* ============================================================
         WARNING / ALERT
         ============================================================ */
      .corp-alert {
        background: rgba(245,158,11,0.08);
        border: 1px solid rgba(245,158,11,0.25);
        border-radius: 10px;
        padding: 14px 16px;
        margin-top: 14px;
      }

      .corp-alert-title {
        font-size: 12px;
        font-weight: 600;
        color: var(--amber);
        margin-bottom: 5px;
        display: flex;
        align-items: center;
        gap: 6px;
      }

      .corp-alert-text {
        font-size: 14px;
        color: #d4a96a;
        line-height: 1.6;
        margin: 0;
      }

      /* ============================================================
         MINI FRAUD CARDS
         ============================================================ */
      .corp-mini-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 12px;
        margin-top: 16px;
      }

      .corp-mini-card {
        border-radius: 12px;
        padding: 16px;
        text-align: center;
      }

      .corp-mini-card.fraud    { background: rgba(239,68,68,0.07); border: 1px solid rgba(239,68,68,0.2); }
      .corp-mini-card.nofraude { background: rgba(16,185,129,0.07); border: 1px solid rgba(16,185,129,0.2); }

      .corp-mini-dot { width: 10px; height: 10px; border-radius: 50%; margin: 0 auto 8px; }
      .corp-mini-dot.r { background: var(--red); }
      .corp-mini-dot.g { background: var(--green); }

      .corp-mini-n { font-size: 22px; font-weight: 700; line-height: 1; margin-bottom: 4px; }
      .corp-mini-n.r { color: #f87171; }
      .corp-mini-n.g { color: #34d399; }

      .corp-mini-label { font-size: 11px; color: var(--text-muted); }
      .corp-mini-pct   { font-size: 11px; font-weight: 600; margin-top: 4px; }
      .corp-mini-pct.r { color: #f87171; }
      .corp-mini-pct.g { color: #34d399; }

      /* ============================================================
         ETAPAS / STEPS
         ============================================================ */
      .corp-step {
        background: rgba(59,130,246,0.04);
        border-left: 3px solid var(--accent-2);
        border-radius: 0 10px 10px 0;
        padding: 14px 18px;
        margin-bottom: 12px;
        position: relative;
      }

      .corp-step-num {
        font-size: 28px;
        font-weight: 700;
        color: var(--accent-2);
        opacity: 0.2;
        position: absolute;
        top: 10px;
        right: 16px;
        line-height: 1;
        font-variant-numeric: tabular-nums;
      }

      .corp-step-title { font-size: 13.5px; font-weight: 600; color: var(--text-pri); margin-bottom: 4px; }
      .corp-step-text  { font-size: 14px; color: var(--text-muted); margin: 0; }

      /* ============================================================
         CONCLUSION CARDS
         ============================================================ */
      .corp-concl-card {
        background: linear-gradient(135deg, var(--accent), var(--accent-2));
        border-radius: var(--radius-lg);
        padding: 22px 24px;
        color: #fff;
        height: 100%;
      }

      .corp-concl-card-2 { background: linear-gradient(135deg, #4f46e5, #6366f1); }
      .corp-concl-card-3 { background: linear-gradient(135deg, #1e3a5f, #1d4ed8); }

      .corp-concl-card-title {
        font-size: 13.5px;
        font-weight: 700;
        color: #fff;
        margin-bottom: 10px;
        letter-spacing: 0.01em;
      }

      .corp-concl-card p {
        font-size: 12.5px;
        color: rgba(255,255,255,0.82);
        line-height: 1.7;
        margin: 0;
      }

      /* ============================================================
         DICTIONARY TABLE
         ============================================================ */
      .corp-dict-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 12.5px;
      }

      .corp-dict-table thead th {
        background: rgba(255,255,255,0.04);
        color: var(--accent);
        padding: 10px 14px;
        text-align: left;
        border-bottom: 1px solid var(--card-border);
        font-weight: 600;
        font-size: 11.5px;
        text-transform: uppercase;
        letter-spacing: 0.05em;
      }

      .corp-dict-table tbody tr {
        border-bottom: 1px solid rgba(255,255,255,0.03);
        transition: background 0.12s;
      }

      .corp-dict-table tbody tr:hover {
        background: rgba(255,255,255,0.03);
      }

      .corp-dict-table tbody td {
        padding: 9px 14px;
        color: var(--text-sec);
        vertical-align: middle;
      }

      .corp-code {
        font-family: var(--mono);
        font-size: 11.5px;
        padding: 2px 8px;
        border-radius: 5px;
        font-weight: 500;
      }

      .code-sel  { background: rgba(16,185,129,0.12);  color: #34d399; }
      .code-drop { background: rgba(239,68,68,0.10);   color: #f87171; }
      .code-dup  { background: rgba(245,158,11,0.12);  color: #fbbf24; }

      .corp-badge { font-size: 10.5px; font-weight: 600; padding: 2px 9px; border-radius: 20px; }
      .badge-sel  { background: rgba(16,185,129,0.12);  color: #34d399; }
      .badge-desc { background: rgba(239,68,68,0.10);   color: #f87171; }
      .badge-dup  { background: rgba(245,158,11,0.12);  color: #fbbf24; }

      /* ============================================================
         KPI NA BOXES
         ============================================================ */
      .kpi-na-red {
        background: rgba(239,68,68,0.06);
        border: 1px solid rgba(239,68,68,0.2);
        border-radius: var(--radius-lg);
        padding: 22px;
        text-align: center;
        margin-bottom: 20px;
      }

      .kpi-na-grn {
        background: rgba(16,185,129,0.06);
        border: 1px solid rgba(16,185,129,0.2);
        border-radius: var(--radius-lg);
        padding: 22px;
        text-align: center;
        margin-bottom: 20px;
      }

      .kpi-na-blu {
        background: rgba(59,130,246,0.06);
        border: 1px solid rgba(59,130,246,0.2);
        border-radius: var(--radius-lg);
        padding: 22px;
        text-align: center;
        margin-bottom: 20px;
      }

      .kpi-na-num {
        font-size: 32px;
        font-weight: 700;
        line-height: 1;
        font-variant-numeric: tabular-nums;
      }

      .kpi-na-label  { font-size: 12px; color: var(--text-muted); margin-top: 8px; }
      .kpi-na-hint   { font-size: 10.5px; margin-top: 4px; opacity: 0.65; }

      /* ============================================================
         INNER TABS (tabsetPanel)
         ============================================================ */
      .nav-tabs {
        border-bottom: 1px solid var(--card-border) !important;
        margin-bottom: 20px;
        gap: 2px;
        display: flex;
      }

      .nav-tabs > li > a {
        color: var(--text-muted) !important;
        font-size: 12.5px !important;
        font-weight: 500 !important;
        border-radius: 8px 8px 0 0 !important;
        border: 1px solid transparent !important;
        padding: 8px 16px !important;
        transition: all 0.15s !important;
        background: transparent !important;
        font-family: var(--font) !important;
      }

      .nav-tabs > li > a:hover {
        color: var(--text-pri) !important;
        background: rgba(255,255,255,0.04) !important;
      }

      .nav-tabs > li.active > a,
      .nav-tabs > li.active > a:focus,
      .nav-tabs > li.active > a:hover {
        background: var(--card-bg) !important;
        color: var(--accent) !important;
        border: 1px solid var(--card-border) !important;
        border-bottom-color: var(--navy) !important;
        font-weight: 600 !important;
      }

      .tab-content {
        background: transparent !important;
      }

      /* ============================================================
         DATATABLES
         ============================================================ */
      .dataTables_wrapper .dataTables_filter input,
      .dataTables_wrapper .dataTables_length select {
        background: var(--navy-soft) !important;
        border: 1px solid var(--card-border) !important;
        border-radius: 8px !important;
        padding: 5px 12px !important;
        font-size: 12px !important;
        color: var(--text-pri) !important;
        font-family: var(--font) !important;
      }

      .dataTables_wrapper .dataTables_filter label,
      .dataTables_wrapper .dataTables_length label,
      .dataTables_wrapper .dataTables_info {
        color: var(--text-muted) !important;
        font-size: 12px !important;
        font-family: var(--font) !important;
      }

      table.dataTable thead th {
        background: rgba(255,255,255,0.03) !important;
        color: var(--accent) !important;
        font-size: 11.5px !important;
        font-weight: 600 !important;
        border-bottom: 1px solid var(--card-border) !important;
        text-transform: uppercase;
        letter-spacing: 0.04em;
        font-family: var(--font) !important;
      }

      table.dataTable tbody tr {
        background: transparent !important;
        color: var(--text-sec) !important;
        font-size: 12.5px !important;
        font-family: var(--font) !important;
      }

      table.dataTable tbody tr:nth-child(even) {
        background: rgba(255,255,255,0.02) !important;
      }

      table.dataTable tbody tr:hover {
        background: rgba(59,130,246,0.06) !important;
      }

      .dataTables_paginate .paginate_button {
        color: var(--text-muted) !important;
        font-size: 12px !important;
        border-radius: 6px !important;
      }

      .dataTables_paginate .paginate_button.current,
      .dataTables_paginate .paginate_button:hover {
        background: var(--accent-glow) !important;
        color: var(--accent) !important;
        border: 1px solid var(--accent) !important;
      }

      /* ============================================================
         SELECTIZE
         ============================================================ */
      .selectize-input {
        background: var(--navy-soft) !important;
        border: 1px solid var(--card-border) !important;
        border-radius: 8px !important;
        color: var(--text-pri) !important;
        font-size: 13px !important;
        font-family: var(--font) !important;
        box-shadow: none !important;
      }

      .selectize-input.focus {
        border-color: var(--accent) !important;
        box-shadow: 0 0 0 3px var(--accent-glow) !important;
      }

      .selectize-dropdown {
        background: var(--navy-soft) !important;
        border: 1px solid var(--card-border) !important;
        border-radius: 8px !important;
        font-size: 13px !important;
        font-family: var(--font) !important;
        box-shadow: var(--shadow) !important;
        z-index: 9999 !important;
      }

      .selectize-dropdown .option {
        color: var(--text-sec) !important;
        padding: 8px 14px !important;
      }

      .selectize-dropdown .option:hover,
      .selectize-dropdown .option.selected {
        background: rgba(59,130,246,0.1) !important;
        color: var(--accent) !important;
      }

      /* ============================================================
         VERBATIM / PRE
         ============================================================ */
      pre, .shiny-text-output {
        border: 1px solid var(--card-border) !important;
        font-family: var(--mono) !important;
        font-size: 12px !important;
        background: transparent !important;
        border: none !important;
        padding: 0 !important;
        color: #0f172a !important;
      }

      /* ============================================================
         LINKS
         ============================================================ */
      a { color: #60a5fa !important; }
      a:hover { color: var(--accent) !important; }

      /* ============================================================
         PLOTLY CONTAINERS
         ============================================================ */
      .plotly { border-radius: 10px; overflow: hidden; }

      /* ============================================================
         TABLES (renderTable)
         ============================================================ */
      .table {
        color: var(--text-sec) !important;
        font-size: 12.5px !important;
        font-family: var(--font) !important;
      }

      .table thead th {
        background: rgba(255,255,255,0.03) !important;
        color: var(--accent) !important;
        border-bottom: 1px solid var(--card-border) !important;
        font-size: 11.5px !important;
        font-weight: 600 !important;
        text-transform: uppercase;
        letter-spacing: 0.04em;
      }

      .table-striped tbody tr:nth-of-type(odd) {
        background: rgba(255,255,255,0.02) !important;
      }

      .table-hover tbody tr:hover {
        background: rgba(59,130,246,0.06) !important;
      }

      .table-bordered, .table-bordered td, .table-bordered th {
        border-color: var(--card-border) !important;
      }

      /* ============================================================
         GGPLOT OUTPUT
         ============================================================ */
      .shiny-plot-output img {
        border-radius: 10px;
      }

      /* ============================================================
         RESPONSIVE TWEAKS
         ============================================================ */
      @media (max-width: 900px) {
        .corp-topbar { padding: 0 16px; }
        .corp-nav-item span { display: none; }
        .corp-tab-panel { padding: 20px 16px; }
        .corp-topbar-brand-text { max-width: 180px; }
      }

      /* ============================================================
         SUMMARY GRID (seleccion columnas)
         ============================================================ */
      .corp-summary-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 12px;
        margin-top: 10px;
      }

      .corp-summary-cell {
        border-radius: 10px;
        padding: 16px;
        text-align: center;
      }

      .corp-summary-cell.cell-green {
        background: rgba(16,185,129,0.07);
        border: 1px solid rgba(16,185,129,0.2);
      }
      .corp-summary-cell.cell-red {
        background: rgba(239,68,68,0.07);
        border: 1px solid rgba(239,68,68,0.2);
      }
      .corp-summary-cell.cell-amber {
        background: rgba(245,158,11,0.07);
        border: 1px solid rgba(245,158,11,0.2);
      }

      .corp-summary-num  { font-size: 26px; font-weight: 700; line-height: 1; }
      .corp-summary-label { font-size: 11px; color: var(--text-muted); margin-top: 4px; }

      /* ============================================================
         DUP CHECK BOXES
         ============================================================ */
      .corp-dup-box {
        background: rgba(245,158,11,0.06);
        border: 1px solid rgba(245,158,11,0.2);
        border-radius: 10px;
        padding: 16px 18px;
      }

      /* ============================================================
         HALLAZGO BOX
         ============================================================ */
      .corp-finding-box {
        background: rgba(239,68,68,0.05);
        border-left: 4px solid var(--red);
        border-radius: 0 10px 10px 0;
        padding: 18px 20px;
        height: 100%;
      }

      .corp-finding-box .finding-title {
        color: #f87171;
        font-weight: 600;
        font-size: 13px;
        margin-bottom: 10px;
      }

      /* ============================================================
         INTERPRETATION BOX
         ============================================================ */
      .corp-interp-box {
        background: rgba(59,130,246,0.05);
        border-left: 4px solid var(--accent);
        border-radius: 0 10px 10px 0;
        padding: 14px 18px;
        margin-top: 16px;
      }

    "))
  ),
  
  # ===============================================================
  # TOP NAVIGATION BAR
  # ===============================================================
  tags$div(class = "corp-topbar",
           
           # BRAND
           tags$div(class = "corp-topbar-brand",
                    tags$img(src = "credit-card-shield-svgrepo-com.svg", alt = "logo"),
                    tags$div(class = "corp-topbar-brand-text",
                             "Deteccion de Fraude ", tags$span("EU")
                    )
           ),
           
           tags$div(class = "corp-topbar-divider"),
           
           # NAVIGATION ITEMS
           tags$div(class = "corp-nav",
                    tags$button(class = "corp-nav-item active", `data-tab` = "introduccion",
                                tags$i(class = "fa fa-house"), tags$span("Introduccion")
                    ),
                    tags$button(class = "corp-nav-item", `data-tab` = "objetivos",
                                tags$i(class = "fa fa-bullseye"), tags$span("Objetivos")
                    ),
                    tags$button(class = "corp-nav-item", `data-tab` = "problema",
                                tags$i(class = "fa fa-triangle-exclamation"), tags$span("Problema")
                    ),
                    tags$button(class = "corp-nav-item", `data-tab` = "eda_univariado",
                                tags$i(class = "fa fa-chart-bar"), tags$span("EDA Univariado")
                    ),
                    tags$button(class = "corp-nav-item", `data-tab` = "eda_multivariado",
                                tags$i(class = "fa fa-chart-bar"), tags$span("EDA Multivariado")
                    ),
                    tags$button(class = "corp-nav-item", `data-tab` = "conclusiones",
                                tags$i(class = "fa fa-flag-checkered"), tags$span("Conclusiones")
                    )
           ),
           
           # SOCIAL LINKS
           tags$div(class = "corp-topbar-right",
                    
                    tags$div(class = "corp-social-dropdown",
                             tags$button(class = "corp-social-btn",
                                         tags$i(class = "fab fa-github"), "GitHub"
                             ),
                             tags$div(class = "corp-social-dropdown-menu",
                                      tags$a(href = "https://github.com/s3rgiorafael2018-create", target = "_blank",
                                             class = "corp-social-dropdown-item",
                                             tags$i(class = "fab fa-github"), "Sergio Rada"
                                      ),
                                      tags$a(href = "https://github.com/T1fff/", target = "_blank",
                                             class = "corp-social-dropdown-item",
                                             tags$i(class = "fab fa-github"), "Tiffany Mendoza"
                                      )
                             )
                    ),
                    
                    tags$div(class = "corp-social-dropdown",
                             tags$button(class = "corp-social-btn",
                                         tags$i(class = "fab fa-linkedin"), "LinkedIn"
                             ),
                             tags$div(class = "corp-social-dropdown-menu",
                                      tags$a(href = "https://www.linkedin.com/in/sergio-rafael-rada-de-la-cruz-9463953a9",
                                             target = "_blank", class = "corp-social-dropdown-item",
                                             tags$i(class = "fab fa-linkedin"), "Sergio Rada"
                                      ),
                                      tags$a(href = "https://www.linkedin.com/in/tiffany-m-a595a8270",
                                             target = "_blank", class = "corp-social-dropdown-item",
                                             tags$i(class = "fab fa-linkedin"), "Tiffany Mendoza"
                                      )
                             )
                    )
           )
  ),
  
  # ===============================================================
  # PAGE WRAPPER
  # ===============================================================
  tags$div(class = "corp-page-wrapper",
           
           # ============================================================
           # TAB: INTRODUCCION
           # ============================================================
           tags$div(id = "tab-introduccion", class = "corp-tab-panel active",
                    
                    tags$div(class = "corp-page-title", "Deteccion de Fraude en Transacciones de Pago de la Union Europea"),
                    tags$div(class = "corp-page-sub", "Informacion basica del Dataset"),
                    
                    # HERO IMAGE
                    tags$div(
                      class = "corp-hero-image",
                      tags$img(
                        src = "sergio_rada.png",
                        alt = "Deteccion de Fraude en la Union Europea",
                        class = "hero-img"
                      )
                    ),
                    
                    # KPIs
                    tags$div(class = "corp-kpi-grid",
                             tags$div(class = "corp-kpi kpi-blue",
                                      tags$div(class = "corp-kpi-badge badge-blue", "Dataset"),
                                      tags$div(class = "corp-kpi-value", textOutput("kpi_registros", inline = TRUE)),
                                      tags$div(class = "corp-kpi-label", "Total observaciones y columnas originales"),
                                      tags$div(class = "corp-kpi-hint", textOutput("kpi_columnas", inline = TRUE))
                             ),
                             tags$div(class = "corp-kpi kpi-red",
                                      tags$div(class = "corp-kpi-badge badge-red", "Fraude 2000-2024"),
                                      tags$div(class = "corp-kpi-value", textOutput("kpi_fraude", inline = TRUE)),
                                      tags$div(class = "corp-kpi-label", "Casos estimados de fraude")
                             ),
                             tags$div(class = "corp-kpi kpi-green",
                                      tags$div(class = "corp-kpi-badge badge-green", "Paises y zonas"),
                                      tags$div(class = "corp-kpi-value", textOutput("kpi_paises", inline = TRUE)),
                                      tags$div(class = "corp-kpi-hint", "Paises y zonas analizadas")
                             ),
                             tags$div(class = "corp-kpi kpi-amber",
                                      tags$div(class = "corp-kpi-badge badge-amber", "Datos Faltantes"),
                                      tags$div(class = "corp-kpi-value", textOutput("kpi_nan", inline = TRUE)),
                                      tags$div(class = "corp-kpi-label", "NaN en monto"),
                                      tags$div(class = "corp-kpi-hint", textOutput("kpi_nan_n", inline = TRUE))
                             )
                    ),
                    
                    tags$div(class = "corp-divider"),
                    
                    # CONTEXT TEXT
                    tags$div(class = "corp-card",
                             tags$div(class = "corp-section-title", "Contexto inicial"),
                             tags$div(class = "corp-body-text",
                                      tags$p("La creciente digitalizacion de las transacciones financieras ha traido consigo un aumento sostenido de las actividades fraudulentas. El valor total de transacciones fraudulentas en el Espacio Economico Europeo ascendio a 4,2 billones en 2024, frente a 3,5 billones en 2023 y 3,4 billones en 2022, de acuerdo con datos de proveedores de servicios de pago recopilados por el BCE y la EBA. Los nuevos tipos de fraude, especialmente aquellos que implican la manipulacion de los pagadores para que inicien transacciones no autorizadas, registran una tendencia creciente que exige el desarrollo de enfoques de mitigacion mas sofisticados y adaptativos."),
                                      tags$p("El presente proyecto aborda esta problematica a partir del conjunto de datos publico del Banco Central Europeo, que registra estadisticas semestrales de transacciones financieras legales y fraudulentas realizadas en la Union Europea. El analisis se estructura en tres componentes principales: un analisis exploratorio de datos univariado y bivariado orientado a caracterizar la estructura, distribucion y calidad del dataset; un dashboard interactivo que permite visualizar el comportamiento de las transacciones segun dimensiones temporales, geograficas y tipologicas; y un modelo predictivo de machine learning enfocado en la clasificacion de transacciones fraudulentas.")
                             )
                    ),
                    
                    tags$div(class = "corp-divider"),
                    
                    fluidRow(style = "display: flex;",
                      column(6,
                             tags$div(class = "corp-card",style = "height: 100%;",
                                      tags$div(class = "corp-section-title", "Estructura del Dash"),
                                      tags$div(class = "corp-section-sub", "Organizacion general del desarrollo"),
                                      tags$ul(style = "color: #475569; font-size: 13px; line-height: 2.2; padding-left: 20px;",
                                              tags$li("Introduccion"),
                                              tags$li("Problema"),
                                              tags$li("Objetivos"),
                                              tags$li("EDA (Analisis Univariado, tratamientos de datos nulos y Bivariado)"),
                                              tags$li("Conclusiones")
                                      )
                             )
                      ),
                      column(6,
                             tags$div(class = "corp-card",style = "height: 100%;",
                                      tags$div(class = "corp-section-title", "Origen de los Datos"),
                                      tags$div(class = "corp-section-sub", "Fuente oficial del dataset"),
                                      tags$p(style = "font-size: 13px; color: #475569; line-height: 1.75;",
                                             "El presente dataset muestra estadisticas de alto nivel sobre el total de transacciones financieras legales y fraudulentas realizadas en la Union Europea. Esta informacion es recolectada por el Banco Central Europeo (ECB), entidad que valida semestralmente los reportes enviados por los Bancos Centrales Nacionales del continente. La ultima actualizacion fue realizada el 29 de enero del presente ano."),
                                      tags$a(
                                        href = "https://data.ecb.europa.eu/data/datasets/PAY/structure?dataset%5B0%5D=Payments%20transactions%20%28Key%20indicators%29%20%28PAY%29",
                                        target = "_blank",
                                        style = "font-size: 13px;",
                                        "Ver fuente oficial del ECB"
                                      )
                             )
                      )
                    )
           ),
           
           # ============================================================
           # TAB: PROBLEMA
           # ============================================================
           tags$div(id = "tab-problema", class = "corp-tab-panel",
                    
                    tags$div(class = "corp-page-title", "El Problema"),
                    tags$div(class = "corp-page-sub", "Crecimiento del fraude financiero digital en la Union Europea"),
                    
                    fluidRow(style = "display: flex;",
                      column(6,
                             tags$div(class = "corp-card",style = "height: 100%;",
                                      tags$div(class = "corp-section-title", "Descripcion del Problema"),
                                      tags$div(class = "corp-body-text",
                                               tags$p("La digitalizacion acelerada del sistema financiero europeo ha generado un incremento sostenido en las actividades fraudulentas. El valor total de transacciones fraudulentas en el Espacio Economico Europeo ascendio a 4,2 billones en 2024, frente a 3,5 billones en 2023 y 3,4 billones en 2022."),
                                               tags$p("Los nuevos tipos de fraude, especialmente aquellos que implican la manipulacion de los pagadores para que inicien transacciones no autorizadas, registran una tendencia creciente que exige el desarrollo de enfoques de mitigacion mas sofisticados y adaptativos."),
                                               tags$p("Uno de los principales desafios metodologicos en este campo radica en la naturaleza profundamente desbalanceada de los conjuntos de datos disponibles, en los que las transacciones fraudulentas representan una minoria estadistica frente al volumen total de operaciones legitimas.")
                                      ),
                                      tags$div(class = "corp-mini-grid",
                                               tags$div(class = "corp-mini-card fraud",
                                                        tags$div(class = "corp-mini-dot r"),
                                                        tags$div(class = "corp-mini-n r", textOutput("kpi_fraude2", inline = TRUE)),
                                                        tags$div(class = "corp-mini-label", "con fraude"),
                                                        tags$div(class = "corp-mini-pct r", textOutput("kpi_fraude_pct", inline = TRUE))
                                               ),
                                               tags$div(class = "corp-mini-card nofraude",
                                                        tags$div(class = "corp-mini-dot g"),
                                                        tags$div(class = "corp-mini-n g", textOutput("kpi_sinfraude", inline = TRUE)),
                                                        tags$div(class = "corp-mini-label", "sin fraude"),
                                                        tags$div(class = "corp-mini-pct g", textOutput("kpi_sinfraude_pct", inline = TRUE))
                                               )
                                      )
                             )
                      ),
                      column(6,
                             tags$div(class = "corp-card",style = "height: 100%;",
                                      tags$div(class = "corp-section-title", "Distribucion del tipo de fraude (Variable Objetivo)"),
                                      tags$div(class = "corp-section-sub", "Alto desbalance de clases - 99.7% sin fraude vs 0.3% con fraude"),
                                      plotlyOutput("plot_tipo_fraude",height = "300px", width = "100%"),
                                      tags$div(class = "corp-alert",
                                               tags$div(class = "corp-alert-title",
                                                        tags$i(class = "fa fa-triangle-exclamation"), "Desbalance de clases"
                                               ),
                                               tags$div(class = "corp-alert-text",
                                                        "Este notable desequilibrio es importante destacarlo al momento de construir modelos predictivos. Se deberan aplicar tecnicas de balanceo como SMOTE, submuestreo o ajuste de pesos en el clasificador."
                                               )
                                      )
                             )
                      )
                    )
           ),
           
           # ============================================================
           # TAB: OBJETIVOS
           # ============================================================
           tags$div(id = "tab-objetivos", class = "corp-tab-panel",
                    
                    tags$div(class = "corp-page-title", "Objetivo del Analisis"),
                    tags$div(class = "corp-page-sub", "Metas generales y especificas del proyecto"),
                    
                    tags$div(class = "corp-card",
                             tags$div(class = "corp-section-title", "Objetivo General"),
                             tags$p(style = "font-size: 16px; color: #94a3b8; line-height: 1.75; margin: 0;",
                                    "Desarrollar un dashboard analitico interactivo orientado a la visualizacion y exploracion de los patrones de transacciones financieras en la Union Europea, con enfasis en la identificacion de variables asociadas a comportamientos fraudulentos.")
                    ),
                    
                    fluidRow(style = "display: flex;",
                      column(6,
                             tags$div(class = "corp-card", style = "height: 100%;",
                                      tags$div(class = "corp-section-title", "Objetivos Especificos"),
                                      tags$div(class = "corp-accent-card",
                                               tags$div(class = "corp-accent-card-title",
                                                        tags$i(class = "fa fa-database"), "1. Calidad del Dato"
                                               ),
                                               tags$p(class = "corp-accent-card-text",
                                                      "Evaluar la calidad, cobertura y estructura del conjunto de datos mediante tecnicas de analisis descriptivo y deteccion de valores faltantes.")
                                      ),
                                      tags$div(class = "corp-accent-card",
                                               tags$div(class = "corp-accent-card-title",
                                                        tags$i(class = "fa fa-magnifying-glass-chart"), "2. Variables Explicativas"
                                               ),
                                               tags$p(class = "corp-accent-card-text",
                                                      "Identificar y caracterizar las variables con mayor capacidad explicativa para la clasificacion de transacciones fraudulentas.")
                                      ),
                                      tags$div(class = "corp-accent-card", style = "margin-bottom: 0;",
                                               tags$div(class = "corp-accent-card-title",
                                                        tags$i(class = "fa fa-chart-pie"), "3. Dashboard de Visualizacion"
                                               ),
                                               tags$p(class = "corp-accent-card-text",
                                                      "Disenar e implementar un dashboard de visualizacion de datos que permita explorar de manera dinamica el comportamiento de las transacciones segun dimensiones temporales, geograficas y tipologicas.")
                                      )
                             )
                      ),
                      column(6,
                             tags$div(class = "corp-card", style = "height: 100%;",
                                      tags$div(class = "corp-section-title", "Etapas del Proyecto"),
                                      tags$div(class = "corp-step",
                                               tags$div(class = "corp-step-num", "01"),
                                               tags$div(class = "corp-step-title", "EDA"),
                                               tags$p(class = "corp-step-text", "Analisis exploratorio univariado y bivariado, distribuciones, valores faltantes, correlaciones")
                                      ),
                                      tags$div(class = "corp-step",
                                               tags$div(class = "corp-step-num", "02"),
                                               tags$div(class = "corp-step-title", "Dashboard"),
                                               tags$p(class = "corp-step-text", "Visualizacion interactiva, filtros dinamicos, mapas, graficas comparativas")
                                      ),
                                      tags$div(class = "corp-step", style = "margin-bottom: 0;",
                                               tags$div(class = "corp-step-num", "03"),
                                               tags$div(class = "corp-step-title", "Modelo ML"),
                                               tags$p(class = "corp-step-text", "Random Forest, Naive Bayes, clasificacion de fraude, metricas de evaluacion")
                                      )
                             )
                      )
                    )
           ),
           
           # ============================================================
           # TAB: EDA UNIVARIADO
           # ============================================================
           tags$div(id = "tab-eda_univariado", class = "corp-tab-panel",
                    
                    tags$div(class = "corp-page-title", "Analisis Exploratorio Univariado"),
                    tags$div(class = "corp-page-sub", "Exploracion detallada de variables individuales"),
                    
                    tabsetPanel(
                      type = "tabs",
                      
                      # ---- PREPARACION DE COLUMNAS ----
                      tabPanel("Preparacion de Columnas",
                               br(),
                               tags$div(class = "corp-card",
                                        tags$div(class = "corp-section-title", "Diccionario de Columnas"),
                                        tags$p(style = "font-size: 13px; color: #64748b; margin: 0;",
                                               "El dataset original cuenta con 29 columnas. A continuacion se describen todas las variables disponibles, identificando columnas duplicadas y las que se conservaron para el analisis.")
                               ),
                               
                               tags$div(class = "corp-card",
                                        tags$div(class = "corp-section-title", "Columnas originales del dataset"),
                                        br(),
                                        tags$div(style = "overflow-x: auto;",
                                                 tags$table(class = "corp-dict-table",
                                                            tags$thead(tags$tr(
                                                              tags$th("#"), tags$th("Columna"), tags$th("Descripcion"), tags$th("Estado")
                                                            )),
                                                            tags$tbody(
                                                              tags$tr(tags$td("1"),  tags$td(tags$span(class="corp-code code-sel","KEY")),  tags$td("Clave compuesta de transaccion"), tags$td(tags$span(class="corp-badge badge-sel","clave"))),
                                                              tags$tr(tags$td("2"),  tags$td(tags$span(class="corp-code code-sel","FREQ")), tags$td("Frecuencia del pago (Anual, trimestral, semestral, etc.)"), tags$td(tags$span(class="corp-badge badge-sel","frecuencia"))),
                                                              tags$tr(tags$td("3"),  tags$td(tags$span(class="corp-code code-sel","REF_AREA")), tags$td("Pais origen de la transaccion"), tags$td(tags$span(class="corp-badge badge-sel","pais_origen"))),
                                                              tags$tr(tags$td("4"),  tags$td(tags$span(class="corp-code code-sel","COUNT_AREA")), tags$td("Institucion origen de la transaccion"), tags$td(tags$span(class="corp-badge badge-sel","pais_destino"))),
                                                              tags$tr(tags$td("5"),  tags$td(tags$span(class="corp-code code-sel","TYP_TRNSCTN")), tags$td("Clasificacion de la transaccion (Deposito, retiro, cheques, transferencias, etc.)"), tags$td(tags$span(class="corp-badge badge-sel","tipo_trx"))),
                                                              tags$tr(tags$td("6"),  tags$td(tags$span(class="corp-code code-sel","RL_TRNSCTN")), tags$td("Clasificacion de la entidad que procesa la transaccion"), tags$td(tags$span(class="corp-badge badge-sel","tipo_psp"))),
                                                              tags$tr(tags$td("7"),  tags$td(tags$span(class="corp-code code-sel","FRD_TYP")), tags$td("Clasificacion del fraude (No autorizado, tarjeta robada, sin fraude, etc.)"), tags$td(tags$span(class="corp-badge badge-sel","tipo_fraude"))),
                                                              tags$tr(tags$td("8"),  tags$td(tags$span(class="corp-code code-drop","TRANSFORMATION")), tags$td("Transformacion realizada a la transaccion"), tags$td(tags$span(class="corp-badge badge-desc","descartada"))),
                                                              tags$tr(tags$td("9"),  tags$td(tags$span(class="corp-code code-sel","UNIT_MEASURE")), tags$td("Unidad o divisa involucrada en la transaccion"), tags$td(tags$span(class="corp-badge badge-sel","unidad"))),
                                                              tags$tr(tags$td("10"), tags$td(tags$span(class="corp-code code-sel","TIME_PERIOD")), tags$td("Ano en el que se proceso la transaccion"), tags$td(tags$span(class="corp-badge badge-sel","anio"))),
                                                              tags$tr(tags$td("11"), tags$td(tags$span(class="corp-code code-sel","OBS_VALUE")), tags$td("Monto de la transaccion"), tags$td(tags$span(class="corp-badge badge-sel","monto"))),
                                                              tags$tr(tags$td("12"), tags$td(tags$span(class="corp-code code-sel","OBS_STATUS")), tags$td("Clasificacion del monto (revisado, no validado, valor provisional, etc.)"), tags$td(tags$span(class="corp-badge badge-sel","tipo_monto"))),
                                                              tags$tr(tags$td("13"), tags$td(tags$span(class="corp-code code-drop","CONF_STATUS")), tags$td("Clasificacion de confidencialidad"), tags$td(tags$span(class="corp-badge badge-desc","descartada"))),
                                                              tags$tr(tags$td("14"), tags$td(tags$span(class="corp-code code-drop","PRE_BREAK_VALUE")), tags$td("No especificada en la documentacion"), tags$td(tags$span(class="corp-badge badge-desc","descartada"))),
                                                              tags$tr(tags$td("15"), tags$td(tags$span(class="corp-code code-drop","COMMENT_OBS")), tags$td("Observaciones"), tags$td(tags$span(class="corp-badge badge-desc","descartada"))),
                                                              tags$tr(tags$td("16"), tags$td(tags$span(class="corp-code code-drop","TIME_FORMAT")), tags$td("No especificada en la documentacion"), tags$td(tags$span(class="corp-badge badge-desc","descartada"))),
                                                              tags$tr(tags$td("17"), tags$td(tags$span(class="corp-code code-drop","BREAKS")), tags$td("No especificada en la documentacion"), tags$td(tags$span(class="corp-badge badge-desc","descartada"))),
                                                              tags$tr(tags$td("18"), tags$td(tags$span(class="corp-code code-drop","COMMENT_TS")), tags$td("No especificada en la documentacion"), tags$td(tags$span(class="corp-badge badge-desc","descartada"))),
                                                              tags$tr(tags$td("19"), tags$td(tags$span(class="corp-code code-drop","COMPILING_ORG")), tags$td("No especificada en la documentacion"), tags$td(tags$span(class="corp-badge badge-desc","descartada"))),
                                                              tags$tr(tags$td("20"), tags$td(tags$span(class="corp-code code-drop","DISS_ORG")), tags$td("No especificada en la documentacion"), tags$td(tags$span(class="corp-badge badge-desc","descartada"))),
                                                              tags$tr(tags$td("21"), tags$td(tags$span(class="corp-code code-drop","TIME_PER_COLLECT")), tags$td("No especificada en la documentacion"), tags$td(tags$span(class="corp-badge badge-desc","descartada"))),
                                                              tags$tr(tags$td("22"), tags$td(tags$span(class="corp-code code-drop","COVERAGE")), tags$td("No especificada en la documentacion"), tags$td(tags$span(class="corp-badge badge-desc","descartada"))),
                                                              tags$tr(tags$td("23"), tags$td(tags$span(class="corp-code code-drop","DATA_COMP")), tags$td("No especificada en la documentacion"), tags$td(tags$span(class="corp-badge badge-desc","descartada"))),
                                                              tags$tr(tags$td("24"), tags$td(tags$span(class="corp-code code-sel","DECIMALS")), tags$td("Cantidad de decimales presentes en el monto"), tags$td(tags$span(class="corp-badge badge-sel","decimales"))),
                                                              tags$tr(tags$td("25"), tags$td(tags$span(class="corp-code code-drop","METHOD_REF")), tags$td("Metodologia utilizada para la recoleccion del dato"), tags$td(tags$span(class="corp-badge badge-desc","descartada"))),
                                                              tags$tr(tags$td("26"), tags$td(tags$span(class="corp-code code-sel","TITLE")), tags$td("Descripcion de la transaccion"), tags$td(tags$span(class="corp-badge badge-sel","descripcion"))),
                                                              tags$tr(tags$td("27"), tags$td(tags$span(class="corp-code code-dup","TITLE_COMPL")), tags$td("Columna copia de TITLE"), tags$td(tags$span(class="corp-badge badge-dup","duplicada"))),
                                                              tags$tr(tags$td("28"), tags$td(tags$span(class="corp-code code-dup","UNIT")), tags$td("Columna copia de UNIT_MEASURE"), tags$td(tags$span(class="corp-badge badge-dup","duplicada"))),
                                                              tags$tr(tags$td("29"), tags$td(tags$span(class="corp-code code-sel","UNIT_MULT")), tags$td("Multiplicador del monto de la transaccion"), tags$td(tags$span(class="corp-badge badge-sel","multiplicador_unidad")))
                                                            )
                                                 )
                                        )
                               ),
                               
                               fluidRow(
                                 column(4,
                                        tags$div(class = "corp-card",
                                                 tags$div(class = "corp-section-title", "Leyenda"),
                                                 tags$div(style = "display: flex; flex-direction: column; gap: 10px; margin-top: 10px;",
                                                          tags$div(style = "display: flex; align-items: center; gap: 10px;",
                                                                   tags$span(class = "corp-badge badge-sel", "seleccionada"),
                                                                   tags$span("Columna seleccionada para el analisis", style = "color: #64748b; font-size: 12px;")
                                                          ),
                                                          tags$div(style = "display: flex; align-items: center; gap: 10px;",
                                                                   tags$span(class = "corp-badge badge-desc", "descartada"),
                                                                   tags$span("Columna descartada", style = "color: #64748b; font-size: 12px;")
                                                          ),
                                                          tags$div(style = "display: flex; align-items: center; gap: 10px;",
                                                                   tags$span(class = "corp-badge badge-dup", "duplicada"),
                                                                   tags$span("Columna duplicada (eliminada)", style = "color: #64748b; font-size: 12px;")
                                                          )
                                                 )
                                        )
                                 ),
                                 column(8,
                                        tags$div(class = "corp-card",
                                                 tags$div(class = "corp-section-title", "Resumen de la seleccion"),
                                                 tags$div(class = "corp-summary-grid",
                                                          tags$div(class = "corp-summary-cell cell-green",
                                                                   tags$div("14", class = "corp-summary-num", style = "color: #34d399;"),
                                                                   tags$div("Columnas seleccionadas", class = "corp-summary-label")
                                                          ),
                                                          tags$div(class = "corp-summary-cell cell-red",
                                                                   tags$div("13", class = "corp-summary-num", style = "color: #f87171;"),
                                                                   tags$div("Columnas descartadas", class = "corp-summary-label")
                                                          ),
                                                          tags$div(class = "corp-summary-cell cell-amber",
                                                                   tags$div("2", class = "corp-summary-num", style = "color: #fbbf24;"),
                                                                   tags$div("Columnas duplicadas", class = "corp-summary-label")
                                                          )
                                                 )
                                        )
                                 )
                               ),
                               
                               tags$div(class = "corp-card",
                                        tags$div(class = "corp-section-title", "Vista previa del dataframe limpio (df)"),
                                        tags$p(style = "font-size: 12px; color: #64748b; margin-bottom: 16px;",
                                               "Primeras filas del dataset tras la seleccion y renombramiento de columnas."),
                                        DT::dataTableOutput("tabla_df_preview")
                               ),
                               
                               tags$div(class = "corp-card",
                                        tags$div(class = "corp-section-title", "Comprobacion de columnas duplicadas"),
                                        fluidRow(
                                          column(6,
                                                 tags$div(class = "corp-dup-box",
                                                          tags$p(tags$span(class="corp-code code-dup","UNIT_MEASURE == UNIT"),
                                                                 style = "margin-bottom: 8px;"),
                                                          tags$p("Son identicas?", style = "color: #64748b; font-size: 12px; margin-bottom: 6px;"),
                                                          textOutput("check_unit")
                                                 )
                                          ),
                                          column(6,
                                                 tags$div(class = "corp-dup-box",
                                                          tags$p(tags$span(class="corp-code code-dup","TITLE == TITLE_COMPL"),
                                                                 style = "margin-bottom: 8px;"),
                                                          tags$p("Son identicas?", style = "color: #64748b; font-size: 12px; margin-bottom: 6px;"),
                                                          textOutput("check_title")
                                                 )
                                          )
                                        )
                               )
                      ),
                      
                      # ---- IDENTIFICACION DE FALTANTES ----
                      tabPanel("Identificacion de Faltantes",
                               br(),
                               tags$div(class = "corp-card",
                                        tags$div(class = "corp-section-title", "Identificacion de Valores Faltantes"),
                                        tags$p(style = "font-size: 13px; color: #64748b; margin: 0;",
                                               "Se analiza la presencia de NAs en cada columna del dataset limpio. La mayoria de columnas no presentan valores faltantes. Sin embargo, la columna monto concentra la totalidad de los missing values.")
                               ),
                               
                               fluidRow(
                                 column(4,
                                        tags$div(class = "kpi-na-red",
                                                 tags$div("143.875", class = "kpi-na-num", style = "color: #f87171;"),
                                                 tags$div("NAs en columna monto", class = "kpi-na-label"),
                                                 tags$div("Unica columna con valores faltantes", class = "kpi-na-hint", style = "color: rgba(248,113,113,0.6);")
                                        )
                                 ),
                                 column(4,
                                        tags$div(class = "kpi-na-grn",
                                                 tags$div("13", class = "kpi-na-num", style = "color: #34d399;"),
                                                 tags$div("Columnas sin NAs", class = "kpi-na-label"),
                                                 tags$div("Completitud total en el resto de variables", class = "kpi-na-hint", style = "color: rgba(52,211,153,0.6);")
                                        )
                                 ),
                                 column(4,
                                        tags$div(class = "kpi-na-blu",
                                                 tags$div(textOutput("pct_na_monto", inline = TRUE), class = "kpi-na-num", style = "color: #60a5fa;"),
                                                 tags$div("% de NAs sobre el total", class = "kpi-na-label"),
                                                 tags$div("Calculado sobre el total de filas del df", class = "kpi-na-hint", style = "color: rgba(96,165,250,0.6);")
                                        )
                                 )
                               ),
                               
                               tags$div(class = "corp-card",
                                        tags$div(class = "corp-section-title", "NAs por columna"),
                                        tags$p(style = "font-size: 11px; color: #64748b; font-family: 'DM Mono', monospace; margin-bottom: 14px;",
                                               "Resultado de aplicar summarise(across(everything(), ~ sum(is.na(.))))"),
                                        DT::dataTableOutput("tabla_nas")
                               ),
                               
                               tags$div(class = "corp-card",
                                        tags$div(class = "corp-section-title", "Detalle - Columna monto"),
                                        fluidRow(
                                          column(6, plotlyOutput("plot_na_barras", height = "280px")),
                                          column(6,
                                                 tags$div(class = "corp-finding-box",
                                                          tags$p(class = "finding-title",
                                                                 tags$i(class = "fa fa-circle-info"), " Hallazgo clave"),
                                                          tags$p("La columna monto es la unica variable del dataset que presenta valores faltantes, concentrando el 100% de los NAs del conjunto de datos.",
                                                                 style = "color: #94a3b8; font-size: 13px; line-height: 1.65; margin-bottom: 10px;"),
                                                          tags$p("Dado que esta es la variable cuantitativa central del analisis, el tratamiento de estos valores faltantes tendra un impacto directo en la calidad de los modelos y visualizaciones posteriores.",
                                                                 style = "color: #94a3b8; font-size: 13px; line-height: 1.65; margin-bottom: 10px;"),
                                                          tags$div(class = "corp-alert",
                                                                   tags$div(class = "corp-alert-title",
                                                                            tags$i(class = "fa fa-triangle-exclamation"), "Accion requerida"),
                                                                   tags$div(class = "corp-alert-text",
                                                                            "Ver pestana Tratamiento de Faltantes para la estrategia aplicada.")
                                                          )
                                                 )
                                          )
                                        )
                               )
                      ),
                      
                      # ---- EDA UNIVARIADO ----
                      tabPanel("EDA Univariado",
                               br(),
                               tags$div(class = "corp-card",
                                        tags$div(class = "corp-section-title", "Analisis Univariado"),
                                        tags$p(style = "font-size: 13px; color: #64748b; margin: 0;",
                                               "A continuacion se examina cada variable de forma individual con el objetivo de entender su distribucion, medidas centrales y de dispersion.")
                               ),
                               
                               tags$div(class = "corp-card",
                                        tags$p("Variable a analizar",
                                               style = "color: var(--text-pri); font-weight: 600; font-size: 15px; margin-bottom: 4px;"),
                                        tags$p("Selecciona una variable para visualizar su distribucion e informacion estadistica",
                                               style = "color: #64748b; font-size: 12px; margin-bottom: 16px;"),
                                        fluidRow(
                                          column(6,
                                                 selectInput("eda_variable", label = NULL,
                                                             choices = list(
                                                               "Solo tabla resumen" = list(
                                                                 "clave"        = "clave",
                                                                 "pais_origen"  = "pais_origen",
                                                                 "pais_destino" = "pais_destino",
                                                                 "anio"         = "anio"
                                                               ),
                                                               "Con graficos" = list(
                                                                 "frecuencia"                      = "frecuencia",
                                                                 "tipo_trx"                        = "tipo_trx",
                                                                 "tipo_psp"                        = "tipo_psp",
                                                                 "unidad"                          = "unidad",
                                                                 "tipo_monto"                      = "tipo_monto",
                                                                 "tipo_fraude (Variable objetivo)"  = "tipo_fraude",
                                                                 "monto"                           = "monto"
                                                               ),
                                                               "Solo indicativas" = list(
                                                                 "clave (indicativa)"                 = "clave_ind",
                                                                 "decimales (indicativa)"             = "decimales",
                                                                 "descripcion (indicativa)"           = "descripcion",
                                                                 "multiplicador_unidad (indicativa)"  = "multiplicador_unidad"
                                                               )
                                                             ),
                                                             width = "100%"
                                                 )
                                          ),
                                          column(6, uiOutput("selector_tipo_grafico"))
                                        )
                               ),
                               
                               fluidRow(
                                 column(8,
                                        tags$div(class = "corp-card",
                                                 uiOutput("eda_plot_titulo"),
                                                 
                                                 conditionalPanel(
                                                   condition = "['frecuencia','tipo_trx','tipo_psp','unidad','tipo_monto','tipo_fraude','monto'].includes(input.eda_variable)",
                                                   plotlyOutput("eda_plot", height = "350px")
                                                 ),
                                                 conditionalPanel(
                                                   condition = "['clave','pais_origen','pais_destino','anio'].includes(input.eda_variable)",
                                                   DT::dataTableOutput("eda_dt_tabla")
                                                 ),
                                                 conditionalPanel(
                                                   condition = "['decimales','descripcion','multiplicador_unidad','clave_ind'].includes(input.eda_variable)",
                                                   uiOutput("eda_msg_indicativa")
                                                 ),
                                                 uiOutput("eda_interpretacion")
                                        )
                                 ),
                                 column(4,
                                        tags$div(class = "corp-card",
                                                 tags$div(class = "corp-section-title", "Estadisticas"),
                                                 uiOutput("eda_stats")
                                        )
                                 )
                               )
                      ),
                      
                      # ---- TRATAMIENTO DE FALTANTES ----
                      tabPanel("Tratamiento de Faltantes",
                               br(),
                               tags$div(class = "corp-card",
                                        tags$div(class = "corp-section-title", "Tratamiento de Valores Faltantes"),
                                        tags$p(style = "font-size: 13px; color: #94a3b8; line-height: 1.75;",
                                               "En la variable monto, el 21.71% de las observaciones corresponden a valores faltantes. En este caso, no se imputara con las medidas de tendencia central porque generaria un cambio en la distribucion de la variable monto, por tanto, la imputacion se realizara haciendo uso de un modelo de Machine Learning, en este caso, sera buscara el mejor modelo entre: KNN, Ridge, BayesianRidge, Random Forest, XGBoost y regresion de vectores de soporte.")
                               ),
                               
                               tags$div(class = "corp-card",
                                        tags$div(class = "corp-section-title", "Metricas de los Modelos entrenados"),
                                        tableOutput("tabla_metricas")
                               ),
                               
                               tags$div(class = "corp-card",
                                        tags$div(class = "corp-section-title", "Predicciones vs Valores Reales"),
                                        plotOutput("plot_predicciones")
                               ),
                               
                               tags$div(class = "corp-card",
                                        tags$div(class = "corp-section-title", "Distribucion: Original vs Imputado"),
                                        plotOutput("plot_distribucion")
                               ),
                               
                               tags$div(class = "corp-card",
                                        tags$div(class = "corp-section-title", "Prueba de Kolmogorov-Smirnov"),
                                        verbatimTextOutput("resultado_ks"),
                                        tags$p(style = "font-size: 13px; color: #94a3b8; line-height: 1.75; margin-top: 12px;",
                                               "Para tratar el 21.71% de valores faltantes en la variable monto, se utilizo un modelo de Random Forest tras una normalizacion previa para asegurar coherencia escalar. La robustez de esta imputacion se confirma mediante un alto poder predictivo (R2 = 0.862), una minima distorsion de la distribucion original (KS D=0.054) y la preservacion de la estructura de cuantiles y estadisticos robustos. Aunque se observa una leve compresion en la variabilidad tipica de los modelos de ensamble al promediar predicciones, el metodo garantiza una base de datos integra y sin sesgos significativos para analisis posteriores.")
                               )
                      )
                    )
           ),
           
           # ============================================================
           # TAB: EDA MULTIVARIADO
           # ============================================================
           tags$div(id = "tab-eda_multivariado", class = "corp-tab-panel",
                    
                    tags$div(class = "corp-page-title", "Analisis Bivariado"),
                    tags$div(class = "corp-page-sub", "Analisis de la variable de respuesta (tipo_fraude) frente a las variables independientes"),
                    
                    tags$div(class = "corp-card",
                             tags$div(class = "corp-section-title", "Tipo de analisis"),
                             tabsetPanel(id = "tab_bivariado", type = "tabs",
                                         
                                         tabPanel("Variables categoricas vs tipo_fraude",
                                                  br(),
                                                  fluidRow(
                                                    column(6,
                                                           tags$div(class = "corp-card corp-card-sm",
                                                                    tags$div(class = "corp-section-title", "Variable categorica"),
                                                                    selectInput("var_cat", label = NULL,
                                                                                choices = c(
                                                                                  "Grafico de barras" = "",
                                                                                  "frecuencia", "tipo_trx", "tipo_psp", "unidad", "tipo_monto",
                                                                                  "Tabla de contingencia" = "",
                                                                                  "clave", "pais_origen", "pais_destino", "anio",
                                                                                  "Excluidas" = "",
                                                                                  "decimales", "descripcion", "multiplicador_unidad"
                                                                                ),
                                                                                selected = "frecuencia", width = "100%")
                                                           )
                                                    )
                                                  ),
                                                  
                                                  uiOutput("bivariado_cat_contenido"),
                                                  uiOutput("interpretacion_bloque")
                                         ),
                                         
                                         tabPanel("Variable numerica (monto) vs tipo_fraude",
                                                  br(),
                                                  fluidRow(
                                                    column(8,
                                                           tags$div(class = "corp-card",
                                                                    tags$div(class = "corp-section-title", "Distribucion del monto por tipo de fraude"),
                                                                    tags$div(class = "corp-section-sub", "Los puntos indican la media de cada grupo"),
                                                                    plotlyOutput("plot_boxplot_monto", height = "380px")
                                                           )
                                                    ),
                                                    column(4,
                                                           tags$div(class = "corp-card",
                                                                    tags$div(class = "corp-section-title", "Estadisticas descriptivas"),
                                                                    tags$div(style = "overflow-x:auto; max-height:380px;",
                                                                             tableOutput("tabla_desc_monto"))
                                                           )
                                                    )
                                                  ),
                                                  
                                                  fluidRow(style = "display: flex;",
                                                    column(6,
                                                           tags$div(class = "corp-card",style = "height: 100%;",
                                                                    tags$div(class = "corp-section-title", "Prueba de normalidad (Anderson-Darling)"),
                                                                    verbatimTextOutput("ad_test_resultado"),
                                                                    uiOutput("ad_test_resultado_texto")
                                                           )
                                                    ),
                                                    column(6,
                                                           tags$div(class = "corp-card",style = "height: 100%;",
                                                                    tags$div(class = "corp-section-title", "Prueba de Wilcoxon (no parametrica)"),
                                                                    verbatimTextOutput("wilcox_resultado"),
                                                                    uiOutput("wilcox_interpretacion")
                                                           )
                                                    )
                                                  ),
                                                  
                                                  fluidRow(
                                                    column(12,
                                                           tags$div(class = "corp-card",
                                                                    tags$div(class = "corp-section-title", "Interpretacion"),
                                                                    tags$p(style = "font-size: 13px; color: #94a3b8; line-height: 1.75;",
                                                                           "El grafico muestra la distribucion del valor de las transacciones segun si hubo o no fraude. Las operaciones no fraudulentas presentan alta dispersion con numerosos valores extremos, mientras que las transacciones fraudulentas se concentran en valores bajos con escasa variabilidad. Este patron sugiere que el fraude se asocia principalmente a importes reducidos."),
                                                                    tags$p(style = "font-size: 13px; color: #94a3b8; line-height: 1.75; margin-bottom: 0;",
                                                                           "La prueba de Wilcoxon confirma que existe diferencia estadisticamente significativa (p-valor < 0.05) en los montos entre ambos grupos, lo que constituye un indicio de dependencia entre el valor de la transaccion y el tipo de fraude.")
                                                           )
                                                    )
                                                  )
                                         )
                             )
                    )
           ),
           
           # ============================================================
           # TAB: CONCLUSIONES
           # ============================================================
           tags$div(id = "tab-conclusiones", class = "corp-tab-panel",
                    
                    tags$div(class = "corp-page-title", "Conclusion"),
                    tags$div(class = "corp-page-sub", "Hallazgos del analisis exploratorio y referencias bibliograficas"),
                    
                    tags$div(class = "corp-card",
                             tags$div(class = "corp-section-title", "Hallazgos Principales"),
                             tags$div(class = "corp-body-text",
                                      tags$p("El anterior analisis permitio conocer a profundidad caracteristicas generales del dataset escogido tales como numero de observaciones y variables estudiadas. De la misma manera, permitio estudiar el posible impacto en este proyecto de cada una de las columnas listadas, pues, fuera por falta de documentacion en la fuente original o duplicacion de informacion, no todas eran aptas de ser incluidas. En un reconocimiento inicial se vio que la variable objetivo tipo_fraude, se encuentra desbalanceada a favor de observaciones que no presentaron fraude, de la misma forma, se pudo conocer a grandes rasgos, la distribucion particular de las variables presentes en los datos como los paises origen, destino, ano de origen, monto o conteo, tipo de unidad, tipo de multiplicador, tipo de psp, descripcion, por mencionar algunas."),
                                      tags$p("Al comparar los tipos de fraude con las diferentes variables se encontro que existe dependencia en la mayoria de casos. Aun asi, es importante resaltar que los fraudes se concentran en categorias muy particulares, por ejemplo, en solo una de las categorias de la variable frecuencia se encontraron casos de fraude. Por otro lado, en la variable monto se encontro diferencias significativas entre el grupo en el que se identifica fraude y el grupo en el que no. Los montos suelen ser menores en las transacciones fraudulentas que en las que no lo son.")
                             )
                    ),
                    
                    tags$div(class = "corp-divider"),
                    
                    fluidRow(
                      column(4,
                             tags$div(class = "corp-concl-card",
                                      tags$div(class = "corp-concl-card-title", "Desbalance de clases"),
                                      tags$p("El 99.7% de las transacciones son legitimas vs 0.3% fraudulentas. Esto requiere tecnicas de balanceo especiales como SMOTE o ajuste de pesos en el clasificador para construir un modelo robusto.")
                             )
                      ),
                      column(4,
                             tags$div(class = "corp-concl-card corp-concl-card-2",
                                      tags$div(class = "corp-concl-card-title", "Dependencia estadistica"),
                                      tags$p("Existe dependencia entre tipo_fraude y la mayoria de variables categoricas analizadas. Los fraudes se concentran en categorias muy particulares, especialmente en transacciones anuales (frecuencia A).")
                             )
                      ),
                      column(4,
                             tags$div(class = "corp-concl-card corp-concl-card-3",
                                      tags$div(class = "corp-concl-card-title", "Monto como variable clave"),
                                      tags$p("Se encontraron diferencias significativas en la variable monto entre transacciones fraudulentas y no fraudulentas. Los montos son menores en transacciones fraudulentas, lo cual es un patron relevante para el modelo ML.")
                             )
                      )
                    ),
                    
                    tags$div(class = "corp-divider"),
                    
                    tags$div(class = "corp-card",
                             tags$div(class = "corp-section-title", "Referencias"),
                             tags$ol(style = "font-size: 13px; color: #94a3b8; line-height: 2.2; padding-left: 20px;",
                                     tags$li(tags$a(href = "https://www.ecb.europa.eu/ecb-and-you/explainers/tell-me/html/what-is-t2.en.html", target = "_blank", "Banco Central Europeo. (2025). What is T2?")),
                                     tags$li(tags$a(href = "https://www.ecb.europa.eu/press/pr/date/2025/html/ecb.pr251215~e133d9d683.en.html", target = "_blank", "European Banking Authority & European Central Bank. (2025). 2025 Report on Payment Fraud.")),
                                     tags$li(tags$a(href = "https://www.bde.es/wbe/en/punto-informacion/contenidos/sistemas-pago-infraestructuras/target-banco-espana/", target = "_blank", "Banco de Espana. (2023). TARGET. Sistema de liquidacion bruta en tiempo real.")),
                                     tags$li(tags$a(href = "https://www.nature.com/articles/s41599-024-03606-0", target = "_blank", "Sanchez-Aguayo, M., Urda, D., & Jerez, J. M. (2024). Financial fraud detection through ML techniques: a literature review.")),
                                     tags$li(tags$a(href = "https://www.tandfonline.com/doi/full/10.1080/23311975.2025.2474209", target = "_blank", "Albert, J. F., et al. (2025). Comparative analysis of ML models for fraud detection.")),
                                     tags$li(tags$a(href = "https://www.sciencedirect.com/science/article/pii/S2666764925000372", target = "_blank", "Chen, Y., et al. (2025). Deep learning in financial fraud detection: innovations and challenges."))
                             )
                    )
           )
           
  ), # end corp-page-wrapper
  
  # ============================================================
  # NAVIGATION JAVASCRIPT
  # ============================================================
  tags$script(HTML("
    document.addEventListener('DOMContentLoaded', function() {
      var navItems  = document.querySelectorAll('.corp-nav-item');
      var tabPanels = document.querySelectorAll('.corp-tab-panel');

      navItems.forEach(function(btn) {
        btn.addEventListener('click', function() {
          var target = this.getAttribute('data-tab');

          navItems.forEach(function(b) { b.classList.remove('active'); });
          tabPanels.forEach(function(p) { p.classList.remove('active'); });

          this.classList.add('active');
          var panel = document.getElementById('tab-' + target);
          if (panel) panel.classList.add('active');
        });
      });
    });
  "))
  
)
