# --- Archivo: ui.R  ---
library(shinydashboard)

ui <- dashboardPage(
  skin = "purple",
  
  # 1. Cabecera del Dashboard
  dashboardHeader(
    title = tagList(
      tags$img(src = 'credit-card-shield-svgrepo-com.svg', height = '25', style = "padding-right:10px;"),
      "Deteccion de Fraude en Transacciones de Pago de la Union Europea"
    ),
    titleWidth = 450,
    dropdownMenu(type = "messages",
                 icon = icon("github"),
                 
                 tags$li(
                   tags$a(
                     href = "https://github.com/s3rgiorafael2018-create",
                     target = "_blank",  
                     icon("github"),
                     " Github Sergio Rada"
                   )
                 ),
                 
                 tags$li(
                   tags$a(
                     href = "https://github.com/T1fff/",
                     target = "_blank",
                     icon("github"),
                     " Github Tiffany Mendoza"
                   )
                 )
    ),
    dropdownMenu(type = "messages",
                 icon = icon("linkedin"),
                 
                 tags$li(
                   tags$a(
                     href = "https://www.linkedin.com/in/sergio-rafael-rada-de-la-cruz-9463953a9",
                     target = "_blank",
                     icon("linkedin"),
                     " LinkedIn Sergio Rada"
                   )
                 ),
                 
                 tags$li(
                   tags$a(
                     href = "https://www.linkedin.com/in/tiffany-m-a595a8270",
                     target = "_blank",
                     icon("linkedin"),
                     " LinkedIn Tiffany Mendoza"
                   )
                 )
    )
  ),
  
  # 2. Barra lateral
  dashboardSidebar(
    width = 250,
    tags$head(tags$style(HTML("
      /* =============================================
         ESTILOS GLOBALES - ESTILO PYTHON DASHBOARD
         ============================================= */

      /* Fondo general */
      body, .wrapper, .content-wrapper, .tab-content {
        background: #f4f3fb !important;
        font-family: 'Segoe UI', 'Inter', Arial, sans-serif !important;
      }
      .content-wrapper {
        color: #1a1a2e !important;
      }

      /* Sidebar */
      .main-sidebar, .left-side {
        background: #1a1a2e !important;
      }
      .sidebar-menu > li > a {
        color: rgba(255,255,255,0.75) !important;
        font-size: 13px !important;
        font-weight: 400 !important;
      }
      .sidebar-menu > li.active > a,
      .sidebar-menu > li > a:hover {
        color: #ffffff !important;
        background: rgba(108,99,255,0.25) !important;
        border-left: 3px solid #6c63ff !important;
      }

      /* Header */
      .main-header .navbar,
      .main-header .logo {
        background: #1a1a2e !important;
        border-bottom: 2px solid #6c63ff !important;
      }
      .main-header .logo {
        color: #ffffff !important;
        font-size: 13px !important;
      }

      /* Tarjetas base */
      .py-card {
        background: #ffffff;
        border-radius: 14px;
        border: 1px solid #e8e5f8;
        padding: 1.4rem 1.6rem;
        margin-bottom: 20px;
        box-shadow: 0 1px 6px rgba(108,99,255,0.07);
      }
      .py-card-title {
        font-size: 15px;
        font-weight: 600;
        color: #1a1a2e;
        margin-bottom: 4px;
      }
      .py-card-sub {
        font-size: 11px;
        color: #8888aa;
        margin-bottom: 1rem;
      }

      /* Titulos principales */
      .py-title {
        font-size: 28px;
        font-weight: 700;
        color: #1a1a2e;
        margin-bottom: 4px;
      }
      .py-sub {
        font-size: 13px;
        color: #8888aa;
        margin-bottom: 1.5rem;
      }

      /* KPIs */
      .py-kpis {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 14px;
        margin-bottom: 1.5rem;
      }
      .py-kpi {
        background: #ffffff;
        border: 1px solid #e8e5f8;
        border-radius: 14px;
        padding: 1.1rem 1.2rem;
        box-shadow: 0 1px 6px rgba(108,99,255,0.07);
      }
      .py-kpi-tag {
        font-size: 9px;
        font-weight: 600;
        padding: 3px 9px;
        border-radius: 10px;
        margin-bottom: .5rem;
        display: inline-block;
        text-transform: uppercase;
        letter-spacing: .05em;
      }
      .tag-b { background: rgba(108,99,255,0.12); color: #6c63ff; }
      .tag-r { background: rgba(220,53,69,0.10);  color: #c0392b; }
      .tag-g { background: rgba(29,158,117,0.12); color: #1d9e75; }
      .tag-y { background: rgba(186,117,23,0.12); color: #ba7517; }
      .py-kpi-val   { font-size: 1.6rem; font-weight: 700; color: #1a1a2e; line-height: 1.1; }
      .py-kpi-label { font-size: 11px; color: #8888aa; margin-top: 4px; }
      .py-kpi-hint  { font-size: 10px; color: #aaaacc; margin-top: 3px; }

      /* Divisor */
      .py-divider { height: 1px; background: #e8e5f8; margin: 1.5rem 0; }

      /* Texto cuerpo */
      .py-texto { font-size: 13px; line-height: 1.85; color: #444466; margin-bottom: 1.5rem; }
      .py-texto p { margin-bottom: 1rem; }
      .py-texto p:last-child { margin-bottom: 0; }

      /* Tarjeta info (acento izquierdo) */
      .py-info-card {
        background: #f8f7ff;
        border-left: 4px solid #6c63ff;
        border-radius: 0 10px 10px 0;
        padding: 1rem 1.2rem;
        margin-bottom: 14px;
      }
      .py-info-card-title {
        font-size: 13px;
        font-weight: 600;
        color: #6c63ff;
        margin-bottom: 5px;
      }
      .py-info-card-text {
        font-size: 12.5px;
        color: #555577;
        line-height: 1.65;
        margin: 0;
      }

      /* Alerta amarilla */
      .py-alerta {
        background: #fffbea;
        border: 1px solid #f5d87a;
        border-radius: 10px;
        padding: 1rem 1.2rem;
        margin-top: 1rem;
      }
      .py-alerta-title {
        font-size: 12px;
        font-weight: 600;
        color: #b8860b;
        margin-bottom: 4px;
      }
      .py-alerta-text {
        font-size: 12px;
        color: #7a6000;
        line-height: 1.6;
        margin: 0;
      }

      /* Tabs de pestanas */
      .nav-tabs > li > a {
        color: #6c63ff !important;
        font-size: 13px !important;
        font-weight: 500 !important;
        border-radius: 8px 8px 0 0 !important;
        border: 1px solid transparent !important;
      }
      .nav-tabs > li.active > a,
      .nav-tabs > li.active > a:focus,
      .nav-tabs > li.active > a:hover {
        background: #ffffff !important;
        color: #1a1a2e !important;
        border: 1px solid #e8e5f8 !important;
        border-bottom-color: #ffffff !important;
        font-weight: 600 !important;
      }
      .nav-tabs {
        border-bottom: 1px solid #e8e5f8 !important;
      }

      /* Tabla DT */
      .dataTables_wrapper .dataTables_filter input,
      .dataTables_wrapper .dataTables_length select {
        border: 1px solid #e8e5f8;
        border-radius: 8px;
        padding: 4px 10px;
        font-size: 12px;
        color: #1a1a2e;
        background: #ffffff;
      }
      table.dataTable thead th {
        background: #f4f3fb !important;
        color: #6c63ff !important;
        font-size: 12px !important;
        font-weight: 600 !important;
        border-bottom: 2px solid #e8e5f8 !important;
      }
      table.dataTable tbody tr {
        background: #ffffff !important;
        color: #333355 !important;
        font-size: 12.5px !important;
      }
      table.dataTable tbody tr:nth-child(even) {
        background: #f8f7ff !important;
      }
      table.dataTable tbody tr:hover {
        background: #eeedfe !important;
      }

      /* Mini-cards problema */
      .py-mini-grid  { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-top: 1.2rem; }
      .py-mini-card  { border-radius: 12px; padding: 1rem; text-align: center; }
      .py-mini-card.fraud    { background: #fff0f0; border: 1px solid #ffd0d0; }
      .py-mini-card.nofraude { background: #f0fff6; border: 1px solid #b6f0cc; }
      .py-mini-dot  { width: 12px; height: 12px; border-radius: 50%; margin: 0 auto 6px; }
      .py-mini-dot.r { background: #e53935; }
      .py-mini-dot.g { background: #1d9e75; }
      .py-mini-n    { font-size: 1.5rem; font-weight: 700; line-height: 1; margin-bottom: 4px; }
      .py-mini-n.r  { color: #e53935; }
      .py-mini-n.g  { color: #1d9e75; }
      .py-mini-label { font-size: 11px; color: #888899; }
      .py-mini-pct   { font-size: 11px; font-weight: 600; margin-top: 2px; }
      .py-mini-pct.r { color: #e53935; }
      .py-mini-pct.g { color: #1d9e75; }

      /* Objetivos - tarjetas etapas */
      .py-etapa {
        background: #f8f7ff;
        border-left: 4px solid #6c63ff;
        border-radius: 0 10px 10px 0;
        padding: 14px 16px;
        margin-bottom: 12px;
      }
      .py-etapa-num {
        font-size: 22px;
        font-weight: 700;
        color: #6c63ff;
        opacity: 0.25;
        float: right;
        line-height: 1;
        margin-top: -2px;
      }
      .py-etapa-title { font-size: 14px; font-weight: 600; color: #1a1a2e; margin: 0 0 4px 0; }
      .py-etapa-text  { font-size: 12px; color: #7777aa; margin: 0; }

      /* Conclusiones - tarjetas */
      .py-concl-card {
        background: #6c63ff;
        border-radius: 14px;
        padding: 1.2rem 1.3rem;
        color: #ffffff;
        height: 100%;
      }
      .py-concl-card-title {
        font-size: 14px;
        font-weight: 600;
        color: #ffffff;
        margin-bottom: 8px;
      }
      .py-concl-card p {
        font-size: 12.5px;
        color: rgba(255,255,255,0.85);
        line-height: 1.65;
        margin: 0;
      }

      /* Badges tabla diccionario */
      .badge-sel  { background: rgba(29,158,117,0.12); color: #1d9e75; padding: 2px 9px; border-radius: 10px; font-size: 11px; font-weight: 500; }
      .badge-desc { background: rgba(220,53,69,0.10);  color: #c0392b; padding: 2px 9px; border-radius: 10px; font-size: 11px; font-weight: 500; }
      .badge-dup  { background: rgba(186,117,23,0.12); color: #ba7517; padding: 2px 9px; border-radius: 10px; font-size: 11px; font-weight: 500; }

      /* KPI faltantes */
      .kpi-na-red  { background: #fff0f0; border: 1px solid #ffd0d0; border-radius: 14px; padding: 20px; text-align: center; margin-bottom: 20px; }
      .kpi-na-grn  { background: #f0fff6; border: 1px solid #b6f0cc; border-radius: 14px; padding: 20px; text-align: center; margin-bottom: 20px; }
      .kpi-na-blu  { background: #f0f4ff; border: 1px solid #c5ceff; border-radius: 14px; padding: 20px; text-align: center; margin-bottom: 20px; }

      /* Links */
      a { color: #6c63ff !important; }
      a:hover { color: #4a3fcc !important; }

      /* Selectize / selectInput */
      .selectize-input {
        border: 1px solid #e8e5f8 !important;
        border-radius: 8px !important;
        font-size: 13px !important;
        color: #1a1a2e !important;
        background: #ffffff !important;
      }
      .selectize-dropdown {
        border: 1px solid #e8e5f8 !important;
        border-radius: 8px !important;
        font-size: 13px !important;
      }
      .selectize-dropdown .option.selected,
      .selectize-dropdown .option:hover {
        background: #eeedfe !important;
        color: #6c63ff !important;
      }
    "))),
    sidebarMenu(
      menuItem("Introduccion",    tabName = "introduccion",    icon = icon("house")),
      menuItem("Objetivos",       tabName = "objetivos",       icon = icon("bullseye")),
      menuItem("Problema",        tabName = "problema",        icon = icon("triangle-exclamation")),
      menuItem("Eda Univariado",  tabName = "Eda_Univariado",  icon = icon("chart-bar")),
      menuItem("Eda Multivariado",tabName = "Eda_Multivariado",icon = icon("chart-bar")),
      menuItem("Conclusiones",    tabName = "conclusiones",    icon = icon("flag-checkered"))
    )
  ),
  
  # 3. Cuerpo del Dashboard
  dashboardBody(
    
    tabItems(
      
      # --------------------------------------------------
      # INTRODUCCION
      # --------------------------------------------------
      tabItem(tabName = "introduccion",
              
              div(
                div(class = "py-title", "Deteccion de Fraude en Transacciones de Pago de la Union Europea"),
                div(class = "py-sub", "Informacion basica del Dataset"),
                
                # KPIs
                div(class = "py-kpis",
                    div(class = "py-kpi",
                        div(class = "py-kpi-tag tag-b", "Dataset"),
                        div(class = "py-kpi-val", textOutput("kpi_registros", inline = TRUE)),
                        div(class = "py-kpi-label", "Total observaciones y columnas originales"),
                        div(class = "py-kpi-hint", textOutput("kpi_columnas", inline = TRUE))
                    ),
                    div(class = "py-kpi",
                        div(class = "py-kpi-tag tag-r", "Fraude 2000-2024"),
                        div(class = "py-kpi-val", textOutput("kpi_fraude", inline = TRUE)),
                        div(class = "py-kpi-label", "Casos estimados de fraude")
                    ),
                    div(class = "py-kpi",
                        div(class = "py-kpi-tag tag-g", "Paises y zonas analizadas"),
                        div(class = "py-kpi-val", textOutput("kpi_paises", inline = TRUE)),
                        div(class = "py-kpi-hint", "Paises y zonas")
                    ),
                    div(class = "py-kpi",
                        div(class = "py-kpi-tag tag-y", "Datos Faltantes"),
                        div(class = "py-kpi-val", textOutput("kpi_nan", inline = TRUE)),
                        div(class = "py-kpi-label", "NaN en monto"),
                        div(class = "py-kpi-hint", textOutput("kpi_nan_n", inline = TRUE))
                    )
                ),
                
                # Texto introductorio
                div(class = "py-divider"),
                div(class = "py-card",
                    div(class = "py-card-title", "Contexto inicial"),
                    div(class = "py-texto",
                        tags$p("La creciente digitalizacion de las transacciones financieras ha traido consigo un aumento sostenido de las actividades fraudulentas. El valor total de transacciones fraudulentas en el Espacio Economico Europeo ascendio a 4,2 billones en 2024, frente a 3,5 billones en 2023 y 3,4 billones en 2022, de acuerdo con datos de proveedores de servicios de pago recopilados por el BCE y la EBA. Los nuevos tipos de fraude, especialmente aquellos que implican la manipulacion de los pagadores para que inicien transacciones no autorizadas, registran una tendencia creciente que exige el desarrollo de enfoques de mitigacion mas sofisticados y adaptativos."),
                        
                        tags$p("El presente proyecto aborda esta problematica a partir del conjunto de datos publico del Banco Central Europeo, que registra estadisticas semestrales de transacciones financieras legales y fraudulentas realizadas en la Union Europea. El analisis se estructura en tres componentes principales: un analisis exploratorio de datos univariado y bivariado orientado a caracterizar la estructura, distribucion y calidad del dataset; un dashboard interactivo que permite visualizar el comportamiento de las transacciones segun dimensiones temporales, geograficas y tipologicas; y un modelo predictivo de machine learning enfocado en la clasificacion de transacciones fraudulentas.")
                    )
                ),
                div(class = "py-divider"),
                
                fluidRow(
                  column(6,
                         div(class = "py-card",
                             div(class = "py-card-title", "Estructura del Dash"),
                             div(class = "py-card-sub", "Organizacion general del desarrollo"),
                             tags$ul(style = "color: #444466; font-size: 13px; line-height: 2;",
                                     tags$li("Introduccion"),
                                     tags$li("Problema"),
                                     tags$li("Objetivos"),
                                     tags$li("EDA (Analisis Univariado, tratamientos de datos nulos y Bivariado)"),
                                     tags$li("Conclusiones")
                             )
                         )
                  ),
                  column(6,
                         div(class = "py-card",
                             div(class = "py-card-title", "Origen de los Datos"),
                             div(class = "py-card-sub", "Fuente oficial del dataset"),
                             tags$p(style = "font-size: 13px; color: #444466; line-height: 1.75;",
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
              )
      ),
      
      # --------------------------------------------------
      # PROBLEMA
      # --------------------------------------------------
      tabItem(tabName = "problema",
              
              div(
                div(class = "py-title", "El Problema"),
                div(class = "py-sub", "Crecimiento del fraude financiero digital en la Union Europea"),
                
                fluidRow(
                  
                  column(6,
                         div(class = "py-card",
                             div(class = "py-card-title", "Descripcion del Problema"),
                             div(class = "py-texto",
                                 tags$p("La digitalizacion acelerada del sistema financiero europeo ha generado un incremento sostenido en las actividades fraudulentas. El valor total de transacciones fraudulentas en el Espacio Economico Europeo ascendio a 4,2 billones en 2024, frente a 3,5 billones en 2023 y 3,4 billones en 2022."),
                                 tags$p("Los nuevos tipos de fraude, especialmente aquellos que implican la manipulacion de los pagadores para que inicien transacciones no autorizadas, registran una tendencia creciente que exige el desarrollo de enfoques de mitigacion mas sofisticados y adaptativos."),
                                 tags$p("Uno de los principales desafios metodologicos en este campo radica en la naturaleza profundamente desbalanceada de los conjuntos de datos disponibles, en los que las transacciones fraudulentas representan una minoria estadistica frente al volumen total de operaciones legitimas.")
                             ),
                             div(class = "py-mini-grid",
                                 div(class = "py-mini-card fraud",
                                     div(class = "py-mini-dot r"),
                                     div(class = "py-mini-n r", textOutput("kpi_fraude",    inline = TRUE)),
                                     div(class = "py-mini-label", "con fraude"),
                                     div(class = "py-mini-pct r", textOutput("kpi_fraude_pct", inline = TRUE))
                                 ),
                                 div(class = "py-mini-card nofraude",
                                     div(class = "py-mini-dot g"),
                                     div(class = "py-mini-n g", textOutput("kpi_sinfraude",     inline = TRUE)),
                                     div(class = "py-mini-label", "sin fraude"),
                                     div(class = "py-mini-pct g", textOutput("kpi_sinfraude_pct", inline = TRUE))
                                 )
                             )
                         )
                  ),
                  
                  column(6,
                         div(class = "py-card",
                             div(class = "py-card-title", "Distribucion del tipo de fraude (Variable Objetivo)"),
                             div(class = "py-card-sub", "Alto desbalance de clases · 99.7% sin fraude vs 0.3% con fraude"),
                             plotlyOutput("plot_tipo_fraude", height = "300px"),
                             div(class = "py-alerta",
                                 div(class = "py-alerta-title", "Desbalance de clases"),
                                 div(class = "py-alerta-text",
                                     "Este notable desequilibrio es importante destacarlo al momento de construir modelos predictivos.
                     Se deberan aplicar tecnicas de balanceo como SMOTE, submuestreo o ajuste de pesos en el clasificador.")
                             )
                         )
                  )
                )
              )
      ),
      
      # --------------------------------------------------
      # OBJETIVOS
      # --------------------------------------------------
      tabItem(tabName = "objetivos",
              
              div(
                div(class = "py-title", "Objetivo del Analisis"),
                div(class = "py-sub", "Metas generales y especificas del proyecto"),
                
                # Objetivo General
                div(class = "py-card",
                    div(class = "py-card-title", "Objetivo General"),
                    tags$p(style = "font-size: 14px; color: #444466; line-height: 1.75; margin: 0;",
                           "Desarrollar un dashboard analitico interactivo orientado a la visualizacion y exploracion
             de los patrones de transacciones financieras en la Union Europea, con enfasis en la
             identificacion de variables asociadas a comportamientos fraudulentos.")
                ),
                
                fluidRow(
                  
                  column(6,
                         div(class = "py-card", style = "height: 100%;",
                             div(class = "py-card-title", "Objetivos Especificos"),
                             
                             div(class = "py-info-card",
                                 div(class = "py-info-card-title", "1. Calidad del Dato"),
                                 tags$p(class = "py-info-card-text",
                                        "Evaluar la calidad, cobertura y estructura del conjunto de datos mediante
                    tecnicas de analisis descriptivo y deteccion de valores faltantes.")
                             ),
                             
                             div(class = "py-info-card",
                                 div(class = "py-info-card-title", "2. Variables Explicativas"),
                                 tags$p(class = "py-info-card-text",
                                        "Identificar y caracterizar las variables con mayor capacidad explicativa
                    para la clasificacion de transacciones fraudulentas.")
                             ),
                             
                             div(class = "py-info-card", style = "margin-bottom: 0;",
                                 div(class = "py-info-card-title", "3. Dashboard de Visualizacion"),
                                 tags$p(class = "py-info-card-text",
                                        "Disenar e implementar un dashboard de visualizacion de datos que permita
                    explorar de manera dinamica el comportamiento de las transacciones segun
                    dimensiones temporales, geograficas y tipologicas.")
                             )
                         )
                  ),
                  
                  column(6,
                         div(class = "py-card", style = "height: 100%;",
                             div(class = "py-card-title", "Etapas del Proyecto"),
                             
                             div(class = "py-etapa",
                                 div(class = "py-etapa-num", "01"),
                                 div(class = "py-etapa-title", "EDA"),
                                 tags$p(class = "py-etapa-text",
                                        "Analisis exploratorio univariado y bivariado, distribuciones, valores faltantes, correlaciones")
                             ),
                             
                             div(class = "py-etapa",
                                 div(class = "py-etapa-num", "02"),
                                 div(class = "py-etapa-title", "Dashboard"),
                                 tags$p(class = "py-etapa-text",
                                        "Visualizacion interactiva, filtros dinamicos, mapas, graficas comparativas")
                             ),
                             
                             div(class = "py-etapa", style = "margin-bottom: 0;",
                                 div(class = "py-etapa-num", "03"),
                                 div(class = "py-etapa-title", "Modelo ML"),
                                 tags$p(class = "py-etapa-text",
                                        "Random Forest, Naive Bayes, clasificacion de fraude, metricas de evaluacion")
                             )
                         )
                  )
                )
              )
      ),
      
      # --------------------------------------------------
      # EDA UNIVARIADO
      # --------------------------------------------------
      tabItem(tabName = "Eda_Univariado",
              
              div(
                div(class = "py-title", "Analisis Exploratorio Univariado"),
                div(class = "py-sub", "Exploracion detallada de variables individuales"),
                
                tabsetPanel(
                  type = "tabs",
                  
                  # ---- PREPARACION DE COLUMNAS ----
                  tabPanel("Preparacion de Columnas",
                           br(),
                           
                           div(class = "py-card",
                               div(class = "py-card-title", "Diccionario de Columnas"),
                               tags$p(style = "font-size: 13px; color: #666688; margin: 0;",
                                      "El dataset original cuenta con 29 columnas. A continuacion se describen todas las variables disponibles,
              identificando columnas duplicadas y las que se conservaron para el analisis.")
                           ),
                           
                           div(class = "py-card",
                               div(class = "py-card-title", "Columnas originales del dataset"),
                               br(),
                               tags$div(
                                 style = "overflow-x: auto;",
                                 tags$table(
                                   style = "width: 100%; border-collapse: collapse; font-size: 13px;",
                                   tags$thead(
                                     tags$tr(style = "background: #f8f7ff;",
                                             tags$th("#",           style = "color: #6c63ff; padding: 9px 14px; text-align: left; border-bottom: 2px solid #e8e5f8; font-weight: 600;"),
                                             tags$th("Columna",     style = "color: #6c63ff; padding: 9px 14px; text-align: left; border-bottom: 2px solid #e8e5f8; font-weight: 600;"),
                                             tags$th("Descripcion", style = "color: #6c63ff; padding: 9px 14px; text-align: left; border-bottom: 2px solid #e8e5f8; font-weight: 600;"),
                                             tags$th("Estado",      style = "color: #6c63ff; padding: 9px 14px; text-align: left; border-bottom: 2px solid #e8e5f8; font-weight: 600;")
                                     )
                                   ),
                                   tags$tbody(
                                     tags$tr(style = "background: #f8f7ff;",
                                             tags$td("1",  style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$code("KEY", style = "color: #1d9e75; background: rgba(29,158,117,0.10); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td("Clave compuesta de transaccion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$span("clave", class = "badge-sel"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(
                                       tags$td("2",  style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$code("FREQ", style = "color: #1d9e75; background: rgba(29,158,117,0.10); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td("Frecuencia del pago (Anual, trimestral, semestral, etc.)", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$span("frecuencia", class = "badge-sel"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(style = "background: #f8f7ff;",
                                             tags$td("3",  style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$code("REF_AREA", style = "color: #1d9e75; background: rgba(29,158,117,0.10); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td("Pais origen de la transaccion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$span("pais_origen", class = "badge-sel"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(
                                       tags$td("4",  style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$code("COUNT_AREA", style = "color: #1d9e75; background: rgba(29,158,117,0.10); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td("Institucion origen de la transaccion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$span("pais_destino", class = "badge-sel"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(style = "background: #f8f7ff;",
                                             tags$td("5",  style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$code("TYP_TRNSCTN", style = "color: #1d9e75; background: rgba(29,158,117,0.10); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td("Clasificacion de la transaccion (Deposito, retiro, cheques, transferencias, etc.)", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$span("tipo_trx", class = "badge-sel"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(
                                       tags$td("6",  style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$code("RL_TRNSCTN", style = "color: #1d9e75; background: rgba(29,158,117,0.10); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td("Clasificacion de la entidad que procesa la transaccion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$span("tipo_psp", class = "badge-sel"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(style = "background: #f8f7ff;",
                                             tags$td("7",  style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$code("FRD_TYP", style = "color: #1d9e75; background: rgba(29,158,117,0.10); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td("Clasificacion del fraude (No autorizado, tarjeta robada, sin fraude, etc.)", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$span("tipo_fraude", class = "badge-sel"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(
                                       tags$td("8",  style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$code("TRANSFORMATION", style = "color: #c0392b; background: rgba(220,53,69,0.08); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td("Transformacion realizada a la transaccion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$span("descartada", class = "badge-desc"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(style = "background: #f8f7ff;",
                                             tags$td("9",  style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$code("UNIT_MEASURE", style = "color: #1d9e75; background: rgba(29,158,117,0.10); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td("Unidad o divisa involucrada en la transaccion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$span("unidad", class = "badge-sel"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(
                                       tags$td("10", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$code("TIME_PERIOD", style = "color: #1d9e75; background: rgba(29,158,117,0.10); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td("Ano en el que se proceso la transaccion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$span("anio", class = "badge-sel"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(style = "background: #f8f7ff;",
                                             tags$td("11", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$code("OBS_VALUE", style = "color: #1d9e75; background: rgba(29,158,117,0.10); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td("Monto de la transaccion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$span("monto", class = "badge-sel"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(
                                       tags$td("12", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$code("OBS_STATUS", style = "color: #1d9e75; background: rgba(29,158,117,0.10); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td("Clasificacion del monto (revisado, no validado, valor provisional, etc.)", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$span("tipo_monto", class = "badge-sel"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(style = "background: #f8f7ff;",
                                             tags$td("13", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$code("CONF_STATUS", style = "color: #c0392b; background: rgba(220,53,69,0.08); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td("Clasificacion de confidencialidad", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$span("descartada", class = "badge-desc"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(
                                       tags$td("14", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$code("PRE_BREAK_VALUE", style = "color: #c0392b; background: rgba(220,53,69,0.08); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td("No especificada en la documentacion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$span("descartada", class = "badge-desc"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(style = "background: #f8f7ff;",
                                             tags$td("15", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$code("COMMENT_OBS", style = "color: #c0392b; background: rgba(220,53,69,0.08); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td("Observaciones", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$span("descartada", class = "badge-desc"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(
                                       tags$td("16", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$code("TIME_FORMAT", style = "color: #c0392b; background: rgba(220,53,69,0.08); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td("No especificada en la documentacion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$span("descartada", class = "badge-desc"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(style = "background: #f8f7ff;",
                                             tags$td("17", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$code("BREAKS", style = "color: #c0392b; background: rgba(220,53,69,0.08); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td("No especificada en la documentacion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$span("descartada", class = "badge-desc"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(
                                       tags$td("18", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$code("COMMENT_TS", style = "color: #c0392b; background: rgba(220,53,69,0.08); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td("No especificada en la documentacion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$span("descartada", class = "badge-desc"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(style = "background: #f8f7ff;",
                                             tags$td("19", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$code("COMPILING_ORG", style = "color: #c0392b; background: rgba(220,53,69,0.08); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td("No especificada en la documentacion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$span("descartada", class = "badge-desc"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(
                                       tags$td("20", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$code("DISS_ORG", style = "color: #c0392b; background: rgba(220,53,69,0.08); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td("No especificada en la documentacion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$span("descartada", class = "badge-desc"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(style = "background: #f8f7ff;",
                                             tags$td("21", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$code("TIME_PER_COLLECT", style = "color: #c0392b; background: rgba(220,53,69,0.08); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td("No especificada en la documentacion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$span("descartada", class = "badge-desc"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(
                                       tags$td("22", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$code("COVERAGE", style = "color: #c0392b; background: rgba(220,53,69,0.08); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td("No especificada en la documentacion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$span("descartada", class = "badge-desc"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(style = "background: #f8f7ff;",
                                             tags$td("23", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$code("DATA_COMP", style = "color: #c0392b; background: rgba(220,53,69,0.08); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td("No especificada en la documentacion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$span("descartada", class = "badge-desc"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(
                                       tags$td("24", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$code("DECIMALS", style = "color: #1d9e75; background: rgba(29,158,117,0.10); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td("Cantidad de decimales presentes en el monto", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$span("decimales", class = "badge-sel"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(style = "background: #f8f7ff;",
                                             tags$td("25", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$code("METHOD_REF", style = "color: #c0392b; background: rgba(220,53,69,0.08); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td("Metodologia utilizada para la recoleccion del dato", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$span("descartada", class = "badge-desc"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(
                                       tags$td("26", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$code("TITLE", style = "color: #1d9e75; background: rgba(29,158,117,0.10); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td("Descripcion de la transaccion", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$span("descripcion", class = "badge-sel"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(style = "background: #f8f7ff;",
                                             tags$td("27", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$code("TITLE_COMPL", style = "color: #ba7517; background: rgba(186,117,23,0.10); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td("Columna copia de TITLE", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                             tags$td(tags$span("duplicada", class = "badge-dup"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(
                                       tags$td("28", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$code("UNIT", style = "color: #ba7517; background: rgba(186,117,23,0.10); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td("Columna copia de UNIT_MEASURE", style = "color: #555577; padding: 8px 14px; border-bottom: 1px solid #f0eeff;"),
                                       tags$td(tags$span("duplicada", class = "badge-dup"), style = "padding: 8px 14px; border-bottom: 1px solid #f0eeff;")
                                     ),
                                     tags$tr(style = "background: #f8f7ff;",
                                             tags$td("29", style = "color: #555577; padding: 8px 14px;"),
                                             tags$td(tags$code("UNIT_MULT", style = "color: #1d9e75; background: rgba(29,158,117,0.10); padding: 2px 7px; border-radius: 5px;"), style = "padding: 8px 14px;"),
                                             tags$td("Multiplicador del monto de la transaccion", style = "color: #555577; padding: 8px 14px;"),
                                             tags$td(tags$span("multiplicador_unidad", class = "badge-sel"), style = "padding: 8px 14px;")
                                     )
                                   )
                                 )
                               )
                           ),
                           
                           fluidRow(
                             column(4,
                                    div(class = "py-card",
                                        div(class = "py-card-title", "Leyenda"),
                                        tags$div(style = "display: flex; flex-direction: column; gap: 10px; margin-top: 8px;",
                                                 tags$div(style = "display: flex; align-items: center; gap: 8px;",
                                                          tags$span(class = "badge-sel", "seleccionada"),
                                                          tags$span("Columna seleccionada para el analisis", style = "color: #666688; font-size: 12px;")
                                                 ),
                                                 tags$div(style = "display: flex; align-items: center; gap: 8px;",
                                                          tags$span(class = "badge-desc", "descartada"),
                                                          tags$span("Columna descartada", style = "color: #666688; font-size: 12px;")
                                                 ),
                                                 tags$div(style = "display: flex; align-items: center; gap: 8px;",
                                                          tags$span(class = "badge-dup", "duplicada"),
                                                          tags$span("Columna duplicada (eliminada)", style = "color: #666688; font-size: 12px;")
                                                 )
                                        )
                                    )
                             ),
                             column(8,
                                    div(class = "py-card",
                                        div(class = "py-card-title", "Resumen de la seleccion"),
                                        tags$div(
                                          style = "display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin-top: 8px;",
                                          tags$div(
                                            style = "background: rgba(29,158,117,0.08); border: 1px solid rgba(29,158,117,0.2); border-radius: 10px; padding: 14px; text-align: center;",
                                            tags$div("14", style = "color: #1d9e75; font-size: 1.6rem; font-weight: 700;"),
                                            tags$div("Columnas seleccionadas", style = "color: #666688; font-size: 11px; margin-top: 2px;")
                                          ),
                                          tags$div(
                                            style = "background: rgba(220,53,69,0.07); border: 1px solid rgba(220,53,69,0.18); border-radius: 10px; padding: 14px; text-align: center;",
                                            tags$div("13", style = "color: #c0392b; font-size: 1.6rem; font-weight: 700;"),
                                            tags$div("Columnas descartadas", style = "color: #666688; font-size: 11px; margin-top: 2px;")
                                          ),
                                          tags$div(
                                            style = "background: rgba(186,117,23,0.08); border: 1px solid rgba(186,117,23,0.2); border-radius: 10px; padding: 14px; text-align: center;",
                                            tags$div("2", style = "color: #ba7517; font-size: 1.6rem; font-weight: 700;"),
                                            tags$div("Columnas duplicadas", style = "color: #666688; font-size: 11px; margin-top: 2px;")
                                          )
                                        )
                                    )
                             )
                           ),
                           
                           div(class = "py-card",
                               div(class = "py-card-title", "Vista previa del dataframe limpio (df)"),
                               tags$p(style = "font-size: 12px; color: #8888aa; margin-bottom: 14px;",
                                      "Primeras filas del dataset tras la seleccion y renombramiento de columnas."),
                               DT::dataTableOutput("tabla_df_preview")
                           ),
                           
                           div(class = "py-card",
                               div(class = "py-card-title", "Comprobacion de columnas duplicadas"),
                               fluidRow(
                                 column(6,
                                        tags$div(
                                          style = "background: rgba(186,117,23,0.07); border: 1px solid rgba(186,117,23,0.2); border-radius: 10px; padding: 16px;",
                                          tags$p(tags$code("UNIT_MEASURE == UNIT", style = "color: #ba7517; background: rgba(186,117,23,0.1); padding: 3px 8px; border-radius: 5px;"), style = "margin-bottom: 8px;"),
                                          tags$p("Son identicas?", style = "color: #888899; font-size: 12px; margin-bottom: 6px;"),
                                          textOutput("check_unit")
                                        )
                                 ),
                                 column(6,
                                        tags$div(
                                          style = "background: rgba(186,117,23,0.07); border: 1px solid rgba(186,117,23,0.2); border-radius: 10px; padding: 16px;",
                                          tags$p(tags$code("TITLE == TITLE_COMPL", style = "color: #ba7517; background: rgba(186,117,23,0.1); padding: 3px 8px; border-radius: 5px;"), style = "margin-bottom: 8px;"),
                                          tags$p("Son identicas?", style = "color: #888899; font-size: 12px; margin-bottom: 6px;"),
                                          textOutput("check_title")
                                        )
                                 )
                               )
                           )
                  ),
                  
                  # ---- IDENTIFICACION DE FALTANTES ----
                  tabPanel("Identificacion de Faltantes",
                           br(),
                           
                           div(class = "py-card",
                               div(class = "py-card-title", "Identificacion de Valores Faltantes"),
                               tags$p(style = "font-size: 13px; color: #666688; margin: 0;",
                                      "Se analiza la presencia de NAs en cada columna del dataset limpio. La mayoria de columnas no presentan valores faltantes. Sin embargo, la columna monto concentra la totalidad de los missing values.")
                           ),
                           
                           fluidRow(
                             column(4,
                                    tags$div(class = "kpi-na-red",
                                             tags$div("143.875", style = "color: #c0392b; font-size: 2.2rem; font-weight: 700; line-height: 1;"),
                                             tags$div("NAs en columna monto", style = "color: #888899; font-size: 12px; margin-top: 8px;"),
                                             tags$div("Unica columna con valores faltantes", style = "color: rgba(192,57,43,0.6); font-size: 11px; margin-top: 4px;")
                                    )
                             ),
                             column(4,
                                    tags$div(class = "kpi-na-grn",
                                             tags$div("13", style = "color: #1d9e75; font-size: 2.2rem; font-weight: 700; line-height: 1;"),
                                             tags$div("Columnas sin NAs", style = "color: #888899; font-size: 12px; margin-top: 8px;"),
                                             tags$div("Completitud total en el resto de variables", style = "color: rgba(29,158,117,0.6); font-size: 11px; margin-top: 4px;")
                                    )
                             ),
                             column(4,
                                    tags$div(class = "kpi-na-blu",
                                             tags$div(textOutput("pct_na_monto", inline = TRUE),
                                                      style = "color: #6c63ff; font-size: 2.2rem; font-weight: 700; line-height: 1;"),
                                             tags$div("% de NAs sobre el total", style = "color: #888899; font-size: 12px; margin-top: 8px;"),
                                             tags$div("Calculado sobre el total de filas del df", style = "color: rgba(108,99,255,0.6); font-size: 11px; margin-top: 4px;")
                                    )
                             )
                           ),
                           
                           div(class = "py-card",
                               div(class = "py-card-title", "NAs por columna"),
                               tags$p(style = "font-size: 11px; color: #8888aa; font-family: monospace; margin-bottom: 14px;",
                                      "Resultado de aplicar summarise(across(everything(), ~ sum(is.na(.))))"),
                               DT::dataTableOutput("tabla_nas")
                           ),
                           
                           div(class = "py-card",
                               div(class = "py-card-title", "Detalle - Columna monto"),
                               fluidRow(
                                 column(6,
                                        plotlyOutput("plot_na_barras", height = "280px")
                                 ),
                                 column(6,
                                        tags$div(
                                          style = "background: #fff5f5; border-left: 4px solid #c0392b; border-radius: 0 10px 10px 0; padding: 16px; height: 100%;",
                                          tags$p("Hallazgo clave", style = "color: #c0392b; font-weight: 600; font-size: 13px; margin-bottom: 10px;"),
                                          tags$p("La columna monto es la unica variable del dataset que presenta valores faltantes,
                  concentrando el 100% de los NAs del conjunto de datos.",
                                                 style = "color: #555577; font-size: 13px; line-height: 1.65; margin-bottom: 10px;"),
                                          tags$p("Dado que esta es la variable cuantitativa central del analisis, el tratamiento
                  de estos valores faltantes tendra un impacto directo en la calidad de los modelos
                  y visualizaciones posteriores.",
                                                 style = "color: #555577; font-size: 13px; line-height: 1.65; margin-bottom: 10px;"),
                                          div(class = "py-alerta",
                                              div(class = "py-alerta-title", "Accion requerida"),
                                              div(class = "py-alerta-text",
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
                           
                           div(class = "py-card",
                               div(class = "py-card-title", "Analisis Univariado"),
                               tags$p(style = "font-size: 13px; color: #666688; margin: 0;",
                                      "A continuacion se examina cada variable de forma individual con el objetivo de entender su distribucion, medidas centrales y de dispersion.")
                           ),
                           
                           div(class = "py-card",
                               tags$p("Variable a analizar", style = "color: #1a1a2e; font-weight: 600; font-size: 15px; margin-bottom: 4px;"),
                               tags$p("Selecciona una variable para visualizar su distribucion e informacion estadistica",
                                      style = "color: #8888aa; font-size: 12px; margin-bottom: 16px;"),
                               
                               fluidRow(
                                 column(6,
                                        selectInput("eda_variable", label = NULL,
                                                    choices = list(
                                                      "Solo tabla resumen" = list(
                                                        "clave"       = "clave",
                                                        "pais_origen" = "pais_origen",
                                                        "pais_destino"= "pais_destino",
                                                        "anio"        = "anio"
                                                      ),
                                                      "Con graficos" = list(
                                                        "frecuencia"  = "frecuencia",
                                                        "tipo_trx"    = "tipo_trx",
                                                        "tipo_psp"    = "tipo_psp",
                                                        "unidad"      = "unidad",
                                                        "tipo_monto"  = "tipo_monto",
                                                        "tipo_fraude (Variable objetivo)" = "tipo_fraude",
                                                        "monto"       = "monto"
                                                      ),
                                                      "Solo indicativas" = list(
                                                        "clave (indicativa)"                  = "clave_ind",
                                                        "decimales (indicativa)"              = "decimales",
                                                        "descripcion (indicativa)"            = "descripcion",
                                                        "multiplicador_unidad (indicativa)"   = "multiplicador_unidad"
                                                      )
                                                    ),
                                                    width = "100%"
                                        )
                                 ),
                                 column(6,
                                        uiOutput("selector_tipo_grafico")
                                 )
                               )
                           ),
                           
                           fluidRow(
                             column(8,
                                    div(class = "py-card",
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
                                    div(class = "py-card",
                                        div(class = "py-card-title", "Estadisticas"),
                                        uiOutput("eda_stats")
                                    )
                             )
                           )
                  ),
                  
                  # ---- TRATAMIENTO DE FALTANTES ----
                  tabPanel("Tratamiento de Faltantes",
                           br(),
                           
                           div(class = "py-card",
                               div(class = "py-card-title", "Tratamiento de Valores Faltantes"),
                               tags$p(style = "font-size: 13px; color: #666688; line-height: 1.75;",
                                      "En la variable monto, el 21.71% de las observaciones corresponden a valores faltantes. En este caso, no se imputará con las medidas de tendencia central porque generaría un cambio en la distribución de la variable monto, por tanto, la imputación se realizará con haciendo uso de un modelo de Machine Learning, en este caso, será buscará el mejor modelo entre: KNN, Ridge, BayesianRidge, Random Forest, XGBoost y regresión de vectores de soporte.")
                           ),
                           
                           div(class = "py-card",
                               div(class = "py-card-title", "Metricas de los Modelos entrenados"),
                               
                               tableOutput("tabla_metricas")
                           ),
                           
                           div(class = "py-card",
                               div(class = "py-card-title", "Predicciones vs Valores Reales"),
                               plotOutput("plot_predicciones")
                           ),
                           
                        
                           
                           div(class = "py-card",
                               div(class = "py-card-title", "Distribucion: Original vs Imputado"),
                               plotOutput("plot_distribucion")
                           ),
                           
                           div(class = "py-card",
                               div(class = "py-card-title", "Prueba de Kolmogorov-Smirnov"),
                               verbatimTextOutput("resultado_ks"),
                               tags$p(style = "font-size: 13px; color: #666688; line-height: 1.75; margin-top: 12px;",
                                      "Para tratar el 21.71% de valores faltantes en la variable monto, se utilizó un modelo de Random Forest tras una normalización previa para asegurar coherencia escalar. La robustez de esta imputación se confirma mediante un alto poder predictivo ($R^2 = 0.862$), una mínima distorsión de la distribución original (KS $D=0.054$) y la preservación de la estructura de cuantiles y estadísticos robustos. Aunque se observa una leve compresión en la variabilidad típica de los modelos de ensamble al promediar predicciones, el método garantiza una base de datos íntegra y sin sesgos significativos para análisis posteriores.")
                           )
                  )
                )
              )
      ),
      
      # --------------------------------------------------
      # EDA MULTIVARIADO
      # --------------------------------------------------
      tabItem(tabName = "Eda_Multivariado",
              
              div(
                div(class = "py-title", "Analisis Bivariado"),
                div(class = "py-sub", "Analisis de la variable de respuesta (tipo_fraude) frente a las variables independientes"),
                
                div(class = "py-card",
                    div(class = "py-card-title", "Tipo de analisis"),
                    tabsetPanel(id = "tab_bivariado", type = "tabs",
                                
                                tabPanel("Variables categoricas vs tipo_fraude",
                                         br(),
                                         
                                         fluidRow(
                                           column(6,
                                                  div(class = "py-card",
                                                      div(class = "py-card-title", "Variable categorica"),
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
                                                  div(class = "py-card",
                                                      div(class = "py-card-title", "Distribucion del monto por tipo de fraude"),
                                                      div(class = "py-card-sub", "Los puntos indican la media de cada grupo"),
                                                      plotlyOutput("plot_boxplot_monto", height = "380px")
                                                  )
                                           ),
                                           column(4,
                                                  div(class = "py-card",
                                                      div(class = "py-card-title", "Estadisticas descriptivas"),
                                                      div(style = "overflow-x:auto; max-height:380px;",
                                                          tableOutput("tabla_desc_monto"))
                                                  )
                                           )
                                         ),
                                         
                                         fluidRow(
                                           column(6,
                                                  div(class = "py-card",
                                                      div(class = "py-card-title", "Prueba de normalidad (Anderson-Darling)"),
                                                      verbatimTextOutput("ad_test_resultado"),
                                                      uiOutput("ad_test_resultado_texto")
                                                  )
                                           ),
                                           column(6,
                                                  div(class = "py-card",
                                                      div(class = "py-card-title", "Prueba de Wilcoxon (no parametrica)"),
                                                      verbatimTextOutput("wilcox_resultado"),
                                                      uiOutput("wilcox_interpretacion")
                                                  )
                                           )
                                         ),
                                         
                                         fluidRow(
                                           column(12,
                                                  div(class = "py-card",
                                                      div(class = "py-card-title", "Interpretacion"),
                                                      tags$p(style = "font-size: 13px; color: #555577; line-height: 1.75;",
                                                             "El grafico muestra la distribucion del valor de las transacciones segun si hubo o no fraude.
                  Las operaciones no fraudulentas presentan alta dispersion con numerosos valores extremos,
                  mientras que las transacciones fraudulentas se concentran en valores bajos con escasa variabilidad.
                  Este patron sugiere que el fraude se asocia principalmente a importes reducidos."),
                                                      tags$p(style = "font-size: 13px; color: #555577; line-height: 1.75; margin-bottom: 0;",
                                                             "La prueba de Wilcoxon confirma que existe diferencia estadisticamente significativa
                  (p-valor < 0.05) en los montos entre ambos grupos, lo que constituye un indicio de
                  dependencia entre el valor de la transaccion y el tipo de fraude.")
                                                  )
                                           )
                                         )
                                )
                    )
                )
              )
      ),
      
      # --------------------------------------------------
      # CONCLUSIONES
      # --------------------------------------------------
      tabItem(tabName = "conclusiones",
              
              div(
                div(class = "py-title", "Conclusion"),
                div(class = "py-sub", "Hallazgos del analisis exploratorio y referencias bibliograficas"),
                
                div(class = "py-card",
                    div(class = "py-card-title", "Hallazgos Principales"),
                    div(class = "py-texto",
                        tags$p("El anterior analisis permitio conocer a profundidad caracteristicas generales del dataset escogido tales como numero de observaciones y variables estudiadas. De la misma manera, permitio estudiar el posible impacto en este proyecto de cada una de las columnas listadas, pues, fuera por falta de documentacion en la fuente original o duplicacion de informacion, no todas eran aptas de ser incluidas. En un reconocimiento inicial se vio que la variable objetivo tipo_fraude, se encuentra desbalanceada a favor de observaciones que no presentaron fraude, de la misma forma, se pudo conocer a grandes rasgos, la distribucion particular de las variables presentes en los datos como los paises origen, destino, ano de origen, monto o conteo, tipo de unidad, tipo de multiplicador, tipo de psp, descripcion, por mencionar algunas."),
                        tags$p("Al comparar los tipos de fraude con las diferentes variables se encontro que existe dependencia en la mayoria de casos. Aun asi, es importante resaltar que los fraudes se concentran en categorias muy particulares, por ejemplo, en solo una de las categorias de la variable frecuencia se encontraron casos de fraude. Por otro lado, en la variable monto se encontro diferencias significativas entre el grupo en el que se identifica fraude y el grupo en el que no. Los montos suelen ser menores en las transacciones fraudulentas que en las que no lo son.")
                    )
                ),
                
                div(class = "py-divider"),
                
                fluidRow(
                  column(4,
                         div(class = "py-concl-card",
                             div(class = "py-concl-card-title", "Desbalance de clases"),
                             tags$p("El 99.7% de las transacciones son legitimas vs 0.3% fraudulentas. Esto requiere tecnicas de balanceo especiales como SMOTE o ajuste de pesos en el clasificador para construir un modelo robusto.")
                         )
                  ),
                  column(4,
                         div(class = "py-concl-card", style = "background: #7c6af7;",
                             div(class = "py-concl-card-title", "Dependencia estadistica"),
                             tags$p("Existe dependencia entre tipo_fraude y la mayoria de variables categoricas analizadas. Los fraudes se concentran en categorias muy particulares, especialmente en transacciones anuales (frecuencia A).")
                         )
                  ),
                  column(4,
                         div(class = "py-concl-card", style = "background: #534ab7;",
                             div(class = "py-concl-card-title", "Monto como variable clave"),
                             tags$p("Se encontraron diferencias significativas en la variable monto entre transacciones fraudulentas y no fraudulentas. Los montos son menores en transacciones fraudulentas, lo cual es un patron relevante para el modelo ML.")
                         )
                  )
                ),
                
                div(class = "py-divider"),
                
                div(class = "py-card",
                    div(class = "py-card-title", "Referencias"),
                    tags$ol(style = "font-size: 13px; color: #444466; line-height: 2.2;",
                            tags$li(tags$a(href = "https://www.ecb.europa.eu/ecb-and-you/explainers/tell-me/html/what-is-t2.en.html", target = "_blank", "Banco Central Europeo. (2025). What is T2?")),
                            tags$li(tags$a(href = "https://www.ecb.europa.eu/press/pr/date/2025/html/ecb.pr251215~e133d9d683.en.html", target = "_blank", "European Banking Authority & European Central Bank. (2025). 2025 Report on Payment Fraud.")),
                            tags$li(tags$a(href = "https://www.bde.es/wbe/en/punto-informacion/contenidos/sistemas-pago-infraestructuras/target-banco-espana/", target = "_blank", "Banco de Espana. (2023). TARGET. Sistema de liquidacion bruta en tiempo real.")),
                            tags$li(tags$a(href = "https://www.nature.com/articles/s41599-024-03606-0", target = "_blank", "Sanchez-Aguayo, M., Urda, D., & Jerez, J. M. (2024). Financial fraud detection through ML techniques: a literature review.")),
                            tags$li(tags$a(href = "https://www.tandfonline.com/doi/full/10.1080/23311975.2025.2474209", target = "_blank", "Albert, J. F., et al. (2025). Comparative analysis of ML models for fraud detection.")),
                            tags$li(tags$a(href = "https://www.sciencedirect.com/science/article/pii/S2666764925000372", target = "_blank", "Chen, Y., et al. (2025). Deep learning in financial fraud detection: innovations and challenges."))
                    )
                )
              )
      )
      
    )
  )
)