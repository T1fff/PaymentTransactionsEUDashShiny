library(shiny)
library(nortest)
library(plotly)

# Paleta de colores globales
COL_PRIMARY   <- "#3b82f6"
COL_SECONDARY <- "#6366f1"
COL_FRAUD     <- "#ef4444"
COL_OK        <- "#10b981"
COL_TEXT      <- "#94a3b8"
COL_AXIS      <- "#64748b"
COL_GRID      <- "rgba(255,255,255,0.06)"
BG_PLOT       <- "rgba(0,0,0,0)"

function(input, output, session) {
  
  # ================================================================
  #  KPIs - Introduccion
  # ================================================================
  output$kpi_registros <- renderText({ paste0(format(nrow(df), big.mark = ","), ", 29") })
  output$kpi_columnas  <- renderText({ paste0(ncol(df), " columnas tras limpieza y seleccion") })
  
  output$kpi_fraude <- renderText({
    conteo <- df %>% filter(tipo_fraude == "F") %>% nrow()
    format(conteo, big.mark = ",")
  })
  
  # Alias para la tarjeta del problema (evita conflicto de ID duplicado)
  output$kpi_fraude2 <- renderText({
    conteo <- df %>% filter(tipo_fraude == "F") %>% nrow()
    format(conteo, big.mark = ",")
  })
  
  output$kpi_sinfraude <- renderText({
    conteo <- df %>% filter(tipo_fraude == "_Z") %>% nrow()
    format(conteo, big.mark = ",")
  })
  
  output$kpi_fraude_pct <- renderText({
    pct <- df %>% filter(tipo_fraude == "F") %>% nrow() / nrow(df) * 100
    paste0(round(pct, 1), "%")
  })
  
  output$kpi_sinfraude_pct <- renderText({
    pct <- df %>% filter(tipo_fraude == "_Z") %>% nrow() / nrow(df) * 100
    paste0(round(pct, 1), "%")
  })
  
  output$kpi_paises <- renderText({ length(unique(df$pais_destino)) })
  output$kpi_nan    <- renderText({ paste0(round(sum(is.na(df$monto)) / nrow(df) * 100, 1), "%") })
  output$kpi_nan_n  <- renderText({ paste0(format(sum(is.na(df$monto)), big.mark = ","), " valores") })
  
  # ================================================================
  #  Grafico distribucion tipo_fraude - Problema
  # ================================================================
  output$plot_tipo_fraude <- renderPlotly({
    conteos <- df %>%
      count(tipo_fraude) %>%
      mutate(
        label = ifelse(tipo_fraude == "_Z", "sin fraude", "con fraude"),
        pct   = round(n / sum(n) * 100, 1)
      ) %>%
      arrange(label)
    
    print(conteos)  # verificar en consola que tiene datos
    req(nrow(conteos) > 0)
    
    plot_ly(
      data         = conteos,
      x            = ~label,
      y            = ~n,
      type         = "bar",
      marker       = list(color = c(COL_FRAUD, COL_PRIMARY), opacity = 0.85),
      text         = ~paste0(format(n, big.mark = ","), " (", pct, "%)"),
      textposition = "outside",
      textfont     = list(color = COL_TEXT, size = 12)
    ) %>%
      layout(
        xaxis         = list(title = "", tickfont = list(color = COL_AXIS, size = 12)),
        yaxis         = list(title = "Transacciones", range = c(0, max(conteos$n) * 1.18),
                             tickfont = list(color = COL_AXIS)),
        plot_bgcolor  = BG_PLOT,
        paper_bgcolor = BG_PLOT,
        font          = list(color = COL_TEXT)
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  # ================================================================
  #  Tabla df limpio
  # ================================================================
  output$tabla_df_preview <- DT::renderDataTable({
    DT::datatable(head(df, 10),
                  options = list(
                    scrollX    = TRUE,
                    pageLength = 5,
                    dom        = "t"
                  ),
                  class = "display compact"
    )
  })
  
  # ================================================================
  #  Comprobaciones columnas duplicadas
  # ================================================================
  output$check_unit <- renderText({
    resultado <- identical(datos$UNIT_MEASURE, datos$UNIT)
    if (resultado) "TRUE - Son columnas identicas" else "FALSE - No son identicas"
  })
  
  output$check_title <- renderText({
    resultado <- identical(datos$TITLE, datos$TITLE_COMPL)
    if (resultado) "TRUE - Son columnas identicas" else "FALSE - No son identicas"
  })
  
  # ================================================================
  #  NAs
  # ================================================================
  output$pct_na_monto <- renderText({
    pct <- round(sum(is.na(df$monto)) / nrow(df) * 100, 1)
    paste0(pct, "%")
  })
  
  output$tabla_nas <- DT::renderDataTable({
    na_tabla <- df %>%
      summarise(across(everything(), ~ sum(is.na(.)))) %>%
      tidyr::pivot_longer(everything(), names_to = "Variable", values_to = "NaN") %>%
      mutate(
        `Total obs.` = nrow(df),
        `% NaN`      = paste0(round(NaN / nrow(df) * 100, 2), "%")
      ) %>%
      arrange(desc(NaN))
    
    DT::datatable(na_tabla,
                  options = list(scrollX = TRUE, pageLength = 14, dom = "tp"),
                  class   = "display compact"
    ) %>%
      DT::formatStyle("NaN",
                      color      = DT::styleInterval(0, c(COL_OK, COL_FRAUD)),
                      fontWeight = "bold"
      )
  })
  
  output$plot_na_barras <- renderPlotly({
    na_tabla <- df %>%
      summarise(across(everything(), ~ sum(is.na(.)))) %>%
      tidyr::pivot_longer(everything(), names_to = "Columna", values_to = "NAs") %>%
      arrange(desc(NAs))
    
    colores <- ifelse(na_tabla$NAs > 0, COL_FRAUD, COL_OK)
    
    plot_ly(na_tabla,
            x      = ~reorder(Columna, -NAs),
            y      = ~NAs,
            type   = "bar",
            marker = list(color = colores, line = list(color = "transparent"))
    ) %>%
      layout(
        xaxis         = list(title = "", tickangle = -45, tickfont = list(color = COL_AXIS, size = 11),
                             gridcolor = COL_GRID),
        yaxis         = list(title = "Cantidad de NAs", tickfont = list(color = COL_AXIS),
                             gridcolor = COL_GRID),
        paper_bgcolor = BG_PLOT,
        plot_bgcolor  = BG_PLOT,
        font          = list(color = COL_TEXT),
        showlegend    = FALSE
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  # ================================================================
  #  EDA UNIVARIADO
  # ================================================================
  vars_tabla        <- c("clave", "pais_origen", "pais_destino", "anio")
  vars_graficos_cat <- c("frecuencia", "tipo_trx", "tipo_psp", "unidad", "tipo_monto", "tipo_fraude")
  vars_graficos_num <- c("monto")
  vars_graficos     <- c(vars_graficos_cat, vars_graficos_num)
  vars_indicativas  <- c("decimales", "descripcion", "multiplicador_unidad", "clave_ind")
  
  output$selector_tipo_grafico <- renderUI({
    req(input$eda_variable)
    var <- input$eda_variable
    
    if (var %in% vars_graficos_cat) {
      selectInput("eda_tipo_grafico", label = NULL,
                  choices  = c("Barras" = "barras", "Pastel" = "pastel"),
                  selected = "barras", width = "100%")
    } else if (var %in% vars_graficos_num) {
      selectInput("eda_tipo_grafico", label = NULL,
                  choices  = c("Histograma" = "histograma", "Caja y bigotes" = "boxplot"),
                  selected = "histograma", width = "100%")
    } else {
      NULL
    }
  })
  
  output$eda_plot_titulo <- renderUI({
    var <- input$eda_variable
    req(var, var != "")
    
    subtitulo <- if (var %in% vars_tabla)         "Tabla de frecuencias y porcentajes por categoria"
    else if (var %in% vars_graficos_cat) "Top 10 categorias por frecuencia"
    else if (var %in% vars_graficos_num) "Distribucion de valores numericos"
    else                                 "Variable indicativa"
    
    tags$div(
      tags$h5(paste0("Distribucion: ", var),
              style = "color: #000000; font-weight: 600; margin-bottom: 4px; font-size: 15px;"),
      tags$p(subtitulo, style = "color: #64748b; font-size: 11px; margin-bottom: 16px;")
    )
  })
  
  tipo_grafico_efectivo <- reactive({
    var <- req(input$eda_variable)
    if (var %in% vars_graficos_cat) {
      tipo <- input$eda_tipo_grafico
      if (is.null(tipo) || !tipo %in% c("barras", "pastel")) "barras" else tipo
    } else if (var %in% vars_graficos_num) {
      tipo <- input$eda_tipo_grafico
      if (is.null(tipo) || !tipo %in% c("histograma", "boxplot")) "histograma" else tipo
    } else {
      NA_character_
    }
  })
  
  output$eda_plot <- renderPlotly({
    req(input$eda_variable)
    var  <- input$eda_variable
    tipo <- tipo_grafico_efectivo()
    
    validate(need(var %in% vars_graficos, ""))
    validate(need(!is.na(tipo), ""))
    
    if (var %in% vars_graficos_cat) {
      datos_cat <- df %>%
        count(.data[[var]], name = "n") %>%
        arrange(desc(n)) %>%
        slice_head(n = 10) %>%
        mutate(pct = round(n / nrow(df) * 100, 1))
      
      if (tipo == "barras") {
        plot_ly(datos_cat,
                x             = ~n,
                y             = ~reorder(.data[[var]], n),
                type          = "bar",
                orientation   = "h",
                marker        = list(color = COL_PRIMARY, opacity = 0.85),
                text          = ~paste0(format(n, big.mark = ","), " (", pct, "%)"),
                textfont      = list(color = COL_TEXT, size = 11),
                textposition  = "outside",
                hovertemplate = "%{y}: %{x} observaciones<extra></extra>"
        ) %>%
          layout(
            xaxis         = list(title = "Num. de transacciones", tickfont = list(color = COL_AXIS),
                                 gridcolor = COL_GRID),
            yaxis         = list(title = "", tickfont = list(color = COL_AXIS)),
            paper_bgcolor = BG_PLOT,
            plot_bgcolor  = BG_PLOT,
            font          = list(color = COL_TEXT),
            showlegend    = FALSE,
            margin        = list(l = 10)
          ) %>%
          config(displayModeBar = FALSE)
        
      } else {
        plot_ly(datos_cat,
                labels        = ~.data[[var]],
                values        = ~n,
                type          = "pie",
                marker        = list(colors = c(COL_PRIMARY, "#a0aaff", "#4a9eff", COL_OK,
                                                "#ba7517", COL_FRAUD, "#c8ceff", "#3c3489",
                                                "#50c88c", "#ffb347")),
                textinfo      = "label+percent",
                hovertemplate = "%{label}: %{value}<extra></extra>"
        ) %>%
          layout(
            paper_bgcolor = BG_PLOT,
            font          = list(color = COL_TEXT),
            legend        = list(font = list(color = COL_TEXT))
          ) %>%
          config(displayModeBar = FALSE)
      }
      
    } else {
      datos_num <- df %>% pull(.data[[var]]) %>% na.omit()
      datos_num <- datos_num[is.finite(datos_num)]
      
      if (tipo == "histograma") {
        plot_ly(x             = ~datos_num,
                type          = "histogram",
                nbinsx        = 50,
                marker        = list(color = COL_PRIMARY, opacity = 0.8,
                                     line = list(color = "#ffffff", width = 0.4)),
                hovertemplate = "Valor: %{x}<br>Frecuencia: %{y}<extra></extra>"
        ) %>%
          layout(
            xaxis         = list(title = var, tickfont = list(color = COL_AXIS),
                                 gridcolor = COL_GRID),
            yaxis         = list(title = "Frecuencia", tickfont = list(color = COL_AXIS),
                                 gridcolor = COL_GRID),
            paper_bgcolor = BG_PLOT,
            plot_bgcolor  = BG_PLOT,
            font          = list(color = COL_TEXT),
            showlegend    = FALSE
          ) %>%
          config(displayModeBar = FALSE)
        
      } else {
        plot_ly(y             = ~datos_num,
                type          = "box",
                marker        = list(color = COL_PRIMARY),
                line          = list(color = COL_PRIMARY),
                fillcolor     = "rgba(59,130,246,0.15)",
                hovertemplate = "%{y}<extra></extra>"
        ) %>%
          layout(
            yaxis         = list(title = var, tickfont = list(color = COL_AXIS),
                                 gridcolor = COL_GRID),
            xaxis         = list(tickfont = list(color = COL_AXIS)),
            paper_bgcolor = BG_PLOT,
            plot_bgcolor  = BG_PLOT,
            font          = list(color = COL_TEXT),
            showlegend    = FALSE
          ) %>%
          config(displayModeBar = FALSE)
      }
    }
  })
  
  output$eda_dt_tabla <- DT::renderDataTable({
    req(input$eda_variable)
    var <- input$eda_variable
    if (!var %in% vars_tabla) return(NULL)
    
    df %>%
      count(.data[[var]], name = "Frecuencia") %>%
      arrange(desc(Frecuencia)) %>%
      mutate(Porcentaje = paste0(round(Frecuencia / nrow(df) * 100, 2), "%")) %>%
      rename(Categoria = 1) %>%
      DT::datatable(
        options = list(scrollX = TRUE, pageLength = 15, dom = "tp"),
        class   = "display compact"
      ) %>%
      DT::formatStyle("Frecuencia", color = COL_PRIMARY, fontWeight = "bold") %>%
      DT::formatStyle("Porcentaje", color = COL_OK)
  })
  
  output$eda_msg_indicativa <- renderUI({
    req(input$eda_variable)
    var <- input$eda_variable
    if (!var %in% vars_indicativas) return(NULL)
    
    nombre_real <- switch(var,
                          "clave_ind"            = "clave",
                          "decimales"            = "decimales",
                          "descripcion"          = "descripcion",
                          "multiplicador_unidad" = "multiplicador_unidad"
    )
    
    tags$div(
      style = "background: rgba(245,158,11,0.06); border-left: 4px solid #f59e0b;
               border-radius: 0 10px 10px 0; padding: 20px 24px; margin-top: 10px;",
      tags$p("Variable no incluida en el analisis",
             style = "color: #fbbf24; font-weight: 600; font-size: 14px; margin-bottom: 8px;"),
      tags$p(
        paste0("La variable ", nombre_real,
               " tiene un caracter meramente indicativo dentro del dataset. ",
               "Su contenido no aporta informacion estadisticamente relevante para el analisis ",
               "exploratorio ni para la construccion del modelo predictivo, por lo que se excluye ",
               "de esta seccion."),
        style = "color: #94a3b8; font-size: 13px; line-height: 1.65; margin: 0;"
      )
    )
  })
  
  output$eda_stats <- renderUI({
    req(input$eda_variable)
    var <- input$eda_variable
    if (!var %in% vars_graficos) return(NULL)
    
    stat_box <- function(label, valor, color = COL_TEXT) {
      tags$div(style = "margin-bottom: 14px;",
               tags$p(label, style = "color: #64748b; font-size: 11px; margin: 0;"),
               tags$p(as.character(valor),
                      style = paste0("color:", color, "; font-size:1.05rem; font-weight:600; margin:0;"))
      )
    }
    
    if (var %in% vars_graficos_cat) {
      datos_cat <- df %>% count(.data[[var]], name = "n") %>% arrange(desc(n))
      total     <- nrow(df)
      n_na      <- sum(is.na(df[[var]]))
      moda      <- datos_cat[[var]][1]
      frec_moda <- datos_cat$n[1]
      pct_moda  <- round(frec_moda / total * 100, 1)
      top5      <- datos_cat %>% slice_head(n = 5) %>% mutate(pct = round(n / total * 100, 1))
      
      tagList(
        stat_box("Total observaciones", format(total, big.mark = ","),         "#f1f5f9"),
        stat_box("Valores unicos",      nrow(datos_cat),                       COL_PRIMARY),
        stat_box("Valores nulos",       n_na, if (n_na > 0) COL_FRAUD else COL_OK),
        stat_box("Moda",                moda,                                  "#f1f5f9"),
        stat_box("Frec. moda",          paste0(format(frec_moda, big.mark = ","), " (", pct_moda, "%)"), COL_SECONDARY),
        tags$hr(style = "border-color: rgba(255,255,255,0.07); margin: 10px 0;"),
        tags$p("Top 5", style = "color: #3b82f6; font-size: 12px; font-weight: 600; margin-bottom: 8px;"),
        tags$table(style = "width:100%; font-size:12px;",
                   tags$thead(tags$tr(
                     tags$th("Categ.", style = "color: #3b82f6; text-align:left; padding-bottom:4px;"),
                     tags$th("%",      style = "color: #3b82f6; text-align:right;")
                   )),
                   tags$tbody(lapply(seq_len(nrow(top5)), function(i) {
                     tags$tr(
                       tags$td(as.character(top5[[var]][i]), style = "color: #94a3b8; padding: 3px 0;"),
                       tags$td(paste0(top5$pct[i], "%"),    style = "color: #3b82f6; text-align:right;")
                     )
                   }))
        )
      )
      
    } else {
      datos_num <- df %>% pull(.data[[var]]) %>% na.omit()
      n_na      <- sum(is.na(df[[var]]))
      tagList(
        stat_box("Total observaciones", format(nrow(df), big.mark = ","),    "#f1f5f9"),
        stat_box("Valores nulos",       n_na, if (n_na > 0) COL_FRAUD else COL_OK),
        stat_box("Media",               round(mean(datos_num), 2),           COL_PRIMARY),
        stat_box("Mediana",             round(median(datos_num), 2),         COL_PRIMARY),
        stat_box("Desv. estandar",      round(sd(datos_num), 2),             COL_SECONDARY),
        stat_box("Minimo",              round(min(datos_num), 2),            COL_OK),
        stat_box("Maximo",              round(max(datos_num), 2),            COL_FRAUD),
        stat_box("Q1",                  round(quantile(datos_num, 0.25), 2), "#fbbf24"),
        stat_box("Q3",                  round(quantile(datos_num, 0.75), 2), "#fbbf24")
      )
    }
  })
  
  output$eda_interpretacion <- renderUI({
    req(input$eda_variable)
    var <- input$eda_variable
    
    texto <- switch(var,
                    "monto" = "La distribucion de monto para el tipo PN es altamente asimetrica, con fuerte concentracion de valores bajos y una cantidad significativa de valores extremos altos. Esto indica que aunque la mayoria de las transacciones tienen totales moderados, existen algunas con totales excepcionalmente altos que influyen notablemente en los estadisticos como la media y la desviacion estandar.",
                    
                    "frecuencia" = HTML(paste0(
                      "El grafico anterior describe la distribucion de la variable frecuencia del dataset, que permite caracterizar la recurrencia habitual de las transacciones. Las transacciones anuales (A) representan un 41.53% del total, mientras que la frecuencia semestral (H) y trimestral (Q) agrupan un 35.75% y 22.72%, cada una. En numeros exactos esto es 275.179, 236.884 y 150.553 transacciones respectivamente.",
                      "<br><br><b style='color:#60a5fa;'>Diccionario de categorias:</b><ul style='margin-top:8px;'>",
                      "<li><b>A (Annual):</b> Transacciones anuales.</li>",
                      "<li><b>H (Half-year):</b> Transacciones semestrales.</li>",
                      "<li><b>Q (Quarterly):</b> Transacciones trimestrales.</li></ul>"
                    )),
                    
                    "tipo_trx" = HTML(paste0(
                      "La tabla y grafico anteriores describen la distribucion de la variable tipo_trx del dataset, que permite caracterizar el movimiento bancario realizado y su instrumento. Los debitos directos y transferencias de credito son las categorias mas grandes con un porcentaje del 14.59% cada una, seguida por pagos electronicos (13.91%) y cheques (9.02%). El pago por tarjetas de credito predomina ligeramente sobre otros servicios de pago, observandose un 9.02% sobre un 8.60%. Con aproximadamente un 1% de participacion las categorias ND* son marginales y podria considerarse su agrupacion. Mientras que las columnas de TOTL y TOTL1 representan totales agregados, no instrumentos individuales.",
                      "<br><br><b style='color:#60a5fa;'>Diccionario de categorias:</b><ul style='margin-top:8px;'>",
                      "<li><b>DD:</b> Creditos directos.</li>",
                      "<li><b>CT0:</b> Transferencia de credito.</li>",
                      "<li><b>EMP0:</b> Pagos con dinero electronico.</li>",
                      "<li><b>CHQ:</b> Cheques.</li>",
                      "<li><b>CP0:</b> Pagos con tarjeta.</li>",
                      "<li><b>SER:</b> Otros servicios de pago.</li>",
                      "<li><b>MREM:</b> Envios de dinero.</li>",
                      "<li><b>TOTL:</b> Transacciones de pago totales [suma de CT, DD, CP, CW, EM, CHQ, MR, OTH].</li>",
                      "<li><b>TOTL1:</b> Total de transacciones de pago, excluyendo retiros de efectivo.</li>",
                      "<li><b>CW1:</b> Retiros de efectivo con tarjeta.</li></ul>"
                    )),
                    
                    "tipo_psp" = HTML(paste0(
                      "La tabla y grafico anteriores describen la distribucion de la variable tipo_psp del dataset, que permite caracterizar el rol de la transaccion. El 58.51% de las transacciones se registraron desde el PSP del pagador, esto es 387.724, frente a 270.818 o 40.87% asociadas al PSP del beneficiario. Por otro lado, se tiene un 0.61% de transacciones no asociadas a ninguna de las clasificaciones anteriores, quiza por tratarse de movimientos monetarios internos.",
                      "<br><br><b style='color:#60a5fa;'>Diccionario de categorias:</b><ul style='margin-top:8px;'>",
                      "<li><b>1 (Payer's PSP):</b> Proveedor de servicios de pago del pagador. Entidad que procesa el pago de quien envia el dinero.</li>",
                      "<li><b>2 (Payee's PSP):</b> Proveedor de servicios de pago del beneficiario. Entidad que procesa el pago de quien recibe el dinero.</li>",
                      "<li><b>_Z (NA):</b> Transacciones sin rol definido o internas.</li></ul>"
                    )),
                    
                    "unidad" = HTML(paste0(
                      "La tabla y grafico anteriores describen la distribucion de la variable unidad del dataset, que permite caracterizar el tipo de unidad o medida en la que se reporta una observacion. Destacan los grupos PN (numero puro o conteo), EUR y XDF (divisa domestica) con un 44.75%, 39% y 9.22% respectivamente. Adicionalmente, se presentan ratios por total de habitantes, numero de transacciones, total de transacciones, entre otros, en menor proporcion. Carece de sentido realizar comparaciones directas entre las distintas series; se debe realizar una transformacion para que puedan trabajarse de forma equivalente.",
                      "<br><br><b style='color:#60a5fa;'>Diccionario de categorias:</b><ul style='margin-top:8px;'>",
                      "<li><b>PN:</b> Numero puro.</li>",
                      "<li><b>EUR:</b> Euro.</li>",
                      "<li><b>XDF:</b> Moneda nacional (incluida la conversion a la moneda actual utilizando un tipo de cambio fijo de paridad o de mercado).</li>",
                      "<li><b>PN_R_POP:</b> Numero puro per capita.</li>",
                      "<li><b>EUR_R_POP:</b> Euros per capita.</li>",
                      "<li><b>EUR_R_TT:</b> Euro; proporcion respecto al valor total de las transacciones de pago.</li>",
                      "<li><b>PN_R_TT:</b> Numero puro; proporcion respecto al numero total de transacciones de pago.</li>",
                      "<li><b>EUR_R_PNT:</b> Euro; ratio respecto al numero de transacciones.</li>",
                      "<li><b>EUR_R_B1GQ:</b> Euro; ratio respecto al PIB.</li>",
                      "<li><b>XDF_R_TT:</b> Moneda nacional; proporcion respecto al valor total de las transacciones de pago.</li></ul>"
                    )),
                    
                    "tipo_monto" = HTML(paste0(
                      "La tabla y grafico anteriores describen la distribucion de la variable tipo_monto del dataset, que permite caracterizar la validez del monto registrado en la columna monto. De forma general vemos que el 72.86% de las observaciones fueron clasificadas como A, es decir, el monto fue validado correctamente. Mientras que el 28% restante presentan un monto poco fiable que pudo haber sido suprimido, estimado, no recolectado, etc.",
                      "<br><br><b style='color:#60a5fa;'>Diccionario de categorias:</b><ul style='margin-top:8px;'>",
                      "<li><b>A:</b> Valor normal.</li>",
                      "<li><b>Q:</b> Valor faltante, suprimido.</li>",
                      "<li><b>M:</b> Valor faltante, dato no puede existir.</li>",
                      "<li><b>P:</b> Valor temporal.</li>",
                      "<li><b>L:</b> Valor faltante, dato existente pero no pudo ser recolectado.</li>",
                      "<li><b>E:</b> Valor estimado.</li></ul>"
                    )),
                    
                    "tipo_fraude" = HTML(paste0(
                      "Muestra la distribucion del tipo de transaccion, confirmando que la mayoria de transacciones observadas no fueron marcadas como fraude. Puntualmente el 99.7% de las transacciones fueron consideradas legales, mientras que el 0.3% fueron asociadas con algun comportamiento irregular. Esta notable diferencia indica un alto desbalance en las clases de la variable objetivo, lo cual es importante destacar al momento de construir modelos predictivos.",
                      "<br><br><b style='color:#60a5fa;'>Diccionario de categorias:</b><ul style='margin-top:8px;'>",
                      "<li><b>_Z:</b> Transaccion sin fraude.</li>",
                      "<li><b>F:</b> Transaccion con fraude.</li></ul>"
                    )),
                    
                    "clave" = "La variable clave es un identificador unico compuesto por la concatenacion de las demas variables categoricas de la transaccion. Al ser una clave tecnica, el numero de valores unicos es igual al numero de filas del dataset, por lo que no aporta informacion analitica directa mas alla de servir como indice de referencia.",
                    
                    "pais_origen" = HTML(paste0(
                      "La tabla describe la distribucion de la variable pais_origen del dataset, que permite caracterizar el origen de las transacciones. A simple vista se puede notar que los paises tienen frecuencias muy similares; no hay un unico pais que destaque de forma dominante frente a los demas. Rumania, Hungria, Polonia, Republica Checa y Paises Bajos son los 5 territorios con el porcentaje de origen mas alto, superior al 4% cada uno. Por otro lado, encontramos entidades especiales como la 'Euro Area changing composition' y 'EU changing composition' que presentan una baja frecuencia frente a otros mercados (menos del 1%).",
                      "<br><br><b style='color:#60a5fa;'>Ejemplos de codigos de pais:</b><ul style='margin-top:8px;'>",
                      "<li><b>RO:</b> Rumania.</li>",
                      "<li><b>HU:</b> Hungria.</li>",
                      "<li><b>PL:</b> Polonia.</li>",
                      "<li><b>CZ:</b> Republica Checa.</li>",
                      "<li><b>NL:</b> Paises Bajos.</li>",
                      "<li><b>PT:</b> Portugal.</li></ul>"
                    )),
                    
                    "pais_destino" = HTML(paste0(
                      "La tabla anterior describe la distribucion de la variable pais_destino del dataset, que permite caracterizar el destino de las transacciones. Empezamos destacando que el 22.54% de las transacciones no especifican el destino final sino que generalizan en entidades como World, Rest of the World, Domestic y Extra EEA, cada una con una representacion del 13%, 3.28%, 3.25% y 2.62%. Para los paises europeos explicitamente listados se manejan porcentajes de representacion del 2% cada uno aproximadamente. Mientras que los paises destino fuera de la EEA comprenden menos del 1% cada uno.",
                      "<br><br><b style='color:#60a5fa;'>Ejemplos de codigos:</b><ul style='margin-top:8px;'>",
                      "<li><b>W0:</b> Mundo (todas las entidades, incluyendo el area de referencia, incluyendo las E/S).</li>",
                      "<li><b>W1:</b> Resto del mundo.</li>",
                      "<li><b>W2:</b> Domestico (hogar o area de referencia).</li>",
                      "<li><b>G1:</b> Extra EEE.</li>",
                      "<li><b>SE:</b> Suecia.</li></ul>"
                    )),
                    
                    "anio" = "La tabla anterior describe la distribucion de la variable anio del dataset, que permite caracterizar el ano o periodo de tiempo en el que se procesaron las transacciones. A simple vista se nota que hay anos representados solos, por trimestre o semestre. Es importante notar que estas divisiones no representan acumulados entre si, solo son categorias distintas de registro. Se nota progresivamente el incremento en movimientos bancarios desde el ano 2000, destacandose el incremento exponencial a partir del ano 2014. Los ultimos 5 anos han marcado records historicos en total de transacciones registradas.",
                    
                    paste0("La variable ", var, " es analizada en terminos de su distribucion y frecuencia de categorias dentro del conjunto de datos.")
    )
    
    tags$div(class = "corp-interp-box",
             tags$p(texto, style = "color: #94a3b8; font-size: 13px; line-height: 1.7; margin: 0;")
    )
  })
  
  # ================================================================
  #  EDA MULTIVARIADO
  # ================================================================
  vars_barras    <- c("frecuencia", "tipo_trx", "tipo_psp", "unidad", "tipo_monto")
  vars_tabla     <- c("pais_origen", "pais_destino", "anio")
  vars_excluidas <- c("clave", "decimales", "descripcion", "multiplicador_unidad")
  
  textos_excluidas <- list(
    decimales = "Para este analisis la variable decimales se excluye frente al tipo de fraude porque presenta baja frecuencia por categoria, haciendo que sea poco interpretable. Ademas, decimales corresponde a un atributo tecnico de formato numerico que no representa una caracteristica explicativa independiente con significado analitico propio.",
    descripcion = "Para este analisis la variable descripcion se excluye frente al tipo de fraude porque corresponde a un codigo estructural compuesto que integra multiples atributos tecnicos. En esta variable se describe la transaccion e indica si hubo fraude, el tipo de transaccion y si fue enviada, informacion que ya se encuentra recogida en otras variables previamente analizadas. Por tanto, no representa una caracteristica explicativa independiente con significado analitico propio.",
    multiplicador_unidad = "Para este analisis la variable multiplicador_unidad se excluye frente al tipo de fraude porque presenta baja frecuencia por categoria, haciendo que sea poco interpretable. Ademas, multiplicador_unidad corresponde a un atributo tecnico de escala monetaria que no representa una caracteristica explicativa independiente con significado analitico propio.",
    clave = "Para este analisis la variable clave se excluye frente al tipo de fraude porque presenta baja frecuencia por categoria, haciendo que sea poco interpretable. Ademas, clave corresponde a un identificador tecnico sin significado analitico propio."
  )
  
  interpretaciones_cat <- list(
    frecuencia   = "El grafico muestra que la gran mayoria de las transacciones corresponden a la clase sin fraude, distribuyendose principalmente en las categorias A (41.7%) y H (35.6%), mientras que Q representa una proporcion menor. En contraste, los casos de fraude son extremadamente pocos y se concentran completamente en una sola categoria de frecuencia (H), lo que evidencia el fuerte desbalance de la variable respuesta.",
    tipo_trx     = "El grafico muestra los tipos de transferencia con pagos con tarjeta (CP0), transferencias de credito (CT0), debitos directos (DD), pagos con dinero electronico (EMP0) y transacciones de pago totales (TOTL); aunque estos 5 tipos concentran el mayor numero absoluto de fraudes, la proporcion de transacciones fraudulentas dentro de cada tipo sigue siendo muy baja. En todos los casos, mas del 98% de las transacciones corresponden a la categoria sin fraude, mientras que los fraudes representan entre aproximadamente 0.1% y 1.2% del total por cada tipo de transaccion. Esto sigue demostrando el fuerte desbalance de la variable de respuesta.",
    tipo_psp     = "La mayoria de las transacciones se concentran en el rol 1 (Payer's PSP) con 58.5%, seguido del rol 2 (Payee's PSP) con 40.9%, mientras que la categoria _Z es marginal (0.6%). En los casos de fraude (F) se mantiene esta tendencia, predominando tambien el rol 1 (61.9%), lo que indica que tanto el volumen total como los eventos fraudulentos se concentran principalmente en el PSP del pagador.",
    unidad       = "La mayoria de las transacciones se registran en la categoria sin fraude, con proporciones cercanas al 99.7% en todas las unidades, mientras que las transacciones con fraude representan apenas alrededor del 0.3%. Aunque numero puro (PN), Euro (EUR) y moneda nacional (XDF) concentran los mayores volumenes, la incidencia relativa del fraude se mantiene estable entre monedas, lo que sugiere que el fraude se explica mas por el volumen total de operaciones que por la unidad de transaccion.",
    tipo_monto   = "El grafico de tipo_monto indica que la categoria A concentra la mayor parte de las transacciones (72.9%), seguido por Q (14.1%), M (7.4%) y P (5.3%), mientras que E y L son marginales. En los casos de fraude (F) se mantiene la misma estructura general, con predominio de A, aunque con una participacion relativamente mayor en P y Q frente al conjunto total. Esto sugiere que, si bien la distribucion global esta dominada por A, ciertas categorias como P y Q adquieren mayor relevancia relativa dentro de las operaciones fraudulentas.",
    pais_origen  = "La tabla muestra que, aunque los cinco paises principales concentran el mayor numero absoluto de fraudes, la proporcion de transacciones fraudulentas dentro de cada pais sigue siendo muy baja. En todos los casos, mas del 96% de las transacciones corresponden a la categoria sin fraude, mientras que los fraudes representan entre aproximadamente 0.3% y 3.5% del total por pais. Esto sigue demostrando el fuerte desbalance de la variable de respuesta.",
    pais_destino = "El grafico evidencia que el area W0 (Mundo, todas las entidades, incluido el area de referencia) concentra la totalidad de los fraudes observados (1.944 casos), aunque estos representan solo el 2.2% del total de transacciones en esa region, frente al 97.8% correspondiente a operaciones no fraudulentas. Esto indica que, si bien el fraude esta focalizado geograficamente en W0, su ocurrencia sigue siendo baja en terminos proporcionales, confirmando el fuerte desbalance de la variable.",
    anio         = "Los anos 2022, 2023 y 2024 concentran la mayor cantidad de fraudes, en el contexto de la nueva era tecnologica derivada de la pandemia de COVID-19.",
    clave        = "La variable clave presenta distribucion muy dispersa entre categorias. La tabla de contingencia permite explorar su relacion con tipo_fraude sin perder detalle por agregacion."
  )
  
  interpretaciones_chi2 <- list(
    frecuencia   = "Se rechaza H0: la prueba chi-cuadrado indica que la frecuencia con la que se realiza determinado pago esta asociada con el tipo de fraude (chi2(2) = 3504.1, p-valor < 0.001).",
    tipo_trx     = "Se rechaza H0: la prueba chi-cuadrado indica que la clasificacion de la transaccion esta asociada con el tipo de fraude (chi2(2) = 2645, p-valor < 0.001).",
    tipo_psp     = "Se rechaza H0: la prueba chi-cuadrado indica que la clasificacion de la entidad que procesa la transaccion esta asociada con el tipo de fraude (chi2(2) = 19.639, p-valor < 0.001).",
    unidad       = "Se rechaza H0: la prueba chi-cuadrado indica que la unidad o divisa involucrada en la transaccion esta asociada con el tipo de fraude (chi2(2) = 262.21, p-valor < 0.001).",
    tipo_monto   = "Se rechaza H0: la prueba chi-cuadrado indica que el tipo de monto de la transaccion esta asociado con el tipo de fraude (chi2(2) = 326.11, p-valor < 0.001).",
    pais_origen  = "Se rechaza H0: la prueba chi-cuadrado indica que el pais o zona de origen donde se realiza la transaccion esta asociado con el tipo de fraude (chi2(2) = 2288.9, p-valor < 0.001).",
    pais_destino = "Se rechaza H0: la prueba chi-cuadrado indica que el pais o zona de destino de la transaccion esta asociado con el tipo de fraude (chi2(2) = 12610, p-valor < 0.001).",
    anio  = "Para la variable ano no se realiza prueba de independencia formal, ya que no resulta necesaria para el presente analisis dada la naturaleza temporal de esta variable. No obstante, se observa que los anos 2022, 2023 y 2024 concentran la mayor cantidad de fraudes registrados.",
    clave = "La variable clave no se somete a prueba de independencia porque presenta baja frecuencia por categoria, lo que haria poco fiable el resultado del chi-cuadrado. Se muestra unicamente la tabla de contingencia con fines exploratorios."
  )
  
  output$bivariado_cat_contenido <- renderUI({
    req(input$var_cat)
    var <- input$var_cat
    if (var == "") return(NULL)
    
    if (var %in% vars_excluidas) {
      return(fluidRow(column(12,
                             tags$div(class = "corp-card",
                                      tags$div(style = "display:flex; align-items:flex-start; gap:14px; padding:6px 0;",
                                               tags$div(style = paste0("width:4px; min-height:60px; background:", COL_FRAUD,
                                                                       "; border-radius:4px; flex-shrink:0;")),
                                               tags$div(
                                                 tags$p("Variable excluida del analisis bivariado",
                                                        style = paste0("color:", COL_FRAUD, "; font-weight:600; font-size:14px; margin:0 0 6px;")),
                                                 tags$p(textos_excluidas[[var]],
                                                        style = "color:#94a3b8; font-size:13px; line-height:1.65; margin:0;")
                                               )
                                      )
                             )
      )))
    }
    
    if (var %in% vars_barras) {
      return(fluidRow(column(12,
                             tags$div(class = "corp-card",
                                      tags$div(class = "corp-section-title", uiOutput("titulo_grafico_cat")),
                                      tags$div(class = "corp-section-sub", "Grafico de barras multiple - frecuencias absolutas y porcentaje dentro de cada grupo"),
                                      plotlyOutput("plot_barras_cat", height = "420px")
                             )
      )))
    }
    
    if (var %in% vars_tabla) {
      return(fluidRow(column(12,
                             tags$div(class = "corp-card",
                                      tags$div(class = "corp-section-title", uiOutput("titulo_grafico_cat")),
                                      tags$div(class = "corp-section-sub", "Distribucion cruzada de la variable seleccionada con tipo_fraude"),
                                      tags$div(style = "overflow-x:auto; max-height:420px;",
                                               tableOutput("tabla_contingencia_cat"))
                             )
      )))
    }
  })
  
  output$titulo_grafico_cat <- renderUI({
    req(input$var_cat)
    if (input$var_cat %in% vars_barras)
      paste("Distribucion de", input$var_cat, "por tipo de fraude")
    else if (input$var_cat %in% vars_tabla)
      paste("Tabla de contingencia:", input$var_cat, "vs tipo_fraude")
  })
  
  output$plot_barras_cat <- renderPlotly({
    req(input$var_cat)
    var <- input$var_cat
    if (!var %in% vars_barras) return(NULL)
    
    df_plot <- df %>%
      mutate(grupo = .data[[var]]) %>%
      count(grupo, tipo_fraude, name = "n") %>%
      group_by(grupo) %>%
      mutate(
        pct      = n / sum(n) * 100,
        etiqueta = paste0(format(n, big.mark = ","), "<br>(", round(pct, 1), "%)")
      ) %>%
      ungroup()
    
    colores_fraude <- c("_Z" = COL_PRIMARY, "F" = COL_FRAUD)
    nombres_fraude <- c("_Z" = "sin fraude",  "F" = "con fraude")
    
    p <- plot_ly()
    for (gf in unique(df_plot$tipo_fraude)) {
      sub <- df_plot %>% filter(tipo_fraude == gf)
      p <- add_trace(p,
                     x             = sub$grupo,
                     y             = sub$n,
                     name          = nombres_fraude[gf],
                     type          = "bar",
                     text          = sub$etiqueta,
                     textposition  = "outside",
                     textfont      = list(color = COL_TEXT, size = 10),
                     marker        = list(color = colores_fraude[gf], opacity = 0.85),
                     hovertemplate = paste0("<b>%{x}</b><br>n: %{y:,}<extra></extra>")
      )
    }
    
    p %>% layout(
      barmode       = "group",
      yaxis         = list(title = "Cantidad de transacciones",
                           tickfont = list(color = COL_AXIS), gridcolor = COL_GRID),
      xaxis         = list(title = var, tickfont = list(color = COL_AXIS)),
      legend        = list(orientation = "h", x = 0.3, y = 1.12,
                           font = list(color = COL_TEXT)),
      plot_bgcolor  = BG_PLOT,
      paper_bgcolor = BG_PLOT,
      font          = list(color = COL_TEXT),
      margin        = list(t = 70, b = 50)
    ) %>%
      config(displayModeBar = FALSE)
  })
  
  output$tabla_contingencia_cat <- renderTable({
    req(input$var_cat)
    var <- input$var_cat
    if (!var %in% vars_tabla) return(NULL)
    
    df %>%
      count(.data[[var]], tipo_fraude, name = "n") %>%
      group_by(.data[[var]]) %>%
      mutate(
        pct_val     = n / sum(n) * 100,
        pct         = paste0(round(pct_val, 1), "%"),
        tipo_fraude = recode(tipo_fraude, "F" = "Con fraude", "_Z" = "Sin fraude")
      ) %>%
      ungroup() %>%
      arrange(desc(pct_val)) %>%
      select(-pct_val) %>%
      tidyr::pivot_wider(
        names_from  = tipo_fraude,
        values_from = c(n, pct),
        values_fill = list(n = 0, pct = "0%")
      ) %>%
      rename_with(~ gsub("n_",   "Casos: ",      .x), starts_with("n_")) %>%
      rename_with(~ gsub("pct_", "Porcentaje: ", .x), starts_with("pct_"))
    
  }, striped = TRUE, hover = TRUE, bordered = TRUE)
  
  output$chi2_resultado <- renderPrint({
    req(input$var_cat)
    var <- input$var_cat
    if (var == "" || var %in% vars_excluidas) return(invisible())
    if (var %in% c("anio", "clave")) {
      cat("Prueba no aplicada para esta variable.\nVer interpretacion mas abajo.")
      return(invisible())
    }
    suppressWarnings(chisq.test(table(df[[var]], df$tipo_fraude)))
  })
  
  output$chi2_interpretacion <- renderUI({
    req(input$var_cat)
    var <- input$var_cat
    if (var == "" || var %in% vars_excluidas) return(NULL)
    
    texto            <- interpretaciones_chi2[[var]]
    es_significativa <- !var %in% c("anio", "clave")
    
    if (es_significativa) {
      tags$div(style = paste0("color: #34d399; background: rgba(16,185,129,0.08); padding: 10px 14px;",
                              "border-radius: 8px; margin-top: 10px; font-size: 13px; border: 1px solid rgba(16,185,129,0.2);"),
               tags$strong("Se rechaza H0: "), texto)
    } else {
      tags$div(style = paste0("color: #60a5fa; background: rgba(59,130,246,0.08); padding: 10px 14px;",
                              "border-radius: 8px; margin-top: 10px; font-size: 13px; border: 1px solid rgba(59,130,246,0.2);"),
               tags$strong("Nota: "), texto)
    }
  })
  
  output$interpretacion_bloque <- renderUI({
    req(input$var_cat)
    var <- input$var_cat
    if (var == "" || var %in% vars_excluidas) return(NULL)
    
    texto <- interpretaciones_cat[[var]]
    if (is.null(texto)) return(NULL)
    
    fluidRow(column(12,
                    tags$div(class = "corp-card",
                             tags$div(class = "corp-section-title", "Interpretacion"),
                             tags$p(style = "color: #94a3b8; font-size: 13px; line-height: 1.75; margin: 0;", texto)
                    )
    ))
  })
  
  output$plot_boxplot_monto <- renderPlotly({
    colores_box <- c("F" = COL_FRAUD, "_Z" = COL_PRIMARY)
    nombres_box <- c("F" = "con fraude", "_Z" = "sin fraude")
    
    p <- plot_ly()
    for (grp in unique(df$tipo_fraude)) {
      sub <- df %>% filter(tipo_fraude == grp)
      p <- add_trace(p,
                     y         = ~sub$monto,
                     type      = "box",
                     name      = nombres_box[grp],
                     boxmean   = TRUE,
                     marker    = list(color = colores_box[grp], opacity = 0.5),
                     line      = list(color = colores_box[grp]),
                     fillcolor = paste0(substr(colores_box[grp], 1, 7), "30")
      )
    }
    
    p %>% layout(
      yaxis         = list(title = "Valor de la transaccion (monto)",
                           tickfont = list(color = COL_AXIS), gridcolor = COL_GRID),
      xaxis         = list(title = "Hubo fraude?", tickfont = list(color = COL_AXIS)),
      plot_bgcolor  = BG_PLOT,
      paper_bgcolor = BG_PLOT,
      font          = list(color = COL_TEXT),
      legend        = list(orientation = "h", font = list(color = COL_TEXT))
    ) %>%
      config(displayModeBar = FALSE)
  })
  
  output$tabla_desc_monto <- renderTable({
    df %>%
      group_by(`Tipo de fraude` = tipo_fraude) %>%
      summarise(
        n       = n(),
        Media   = round(mean(monto,           na.rm = TRUE), 2),
        DS      = round(sd(monto,             na.rm = TRUE), 2),
        Mediana = round(median(monto,         na.rm = TRUE), 2),
        Minimo  = round(min(monto,            na.rm = TRUE), 2),
        Maximo  = round(max(monto,            na.rm = TRUE), 2),
        Q1      = round(quantile(monto, 0.25, na.rm = TRUE), 2),
        Q3      = round(quantile(monto, 0.75, na.rm = TRUE), 2)
      )
  }, striped = TRUE, hover = TRUE, bordered = TRUE)
  
  output$ad_test_resultado <- renderPrint({
    cat("Con fraude\n")
    print(ad.test(df$monto[df$tipo_fraude == "F"]))
    cat("\nSin fraude\n")
    print(ad.test(df$monto[df$tipo_fraude == "_Z"]))
    
    output$ad_test_resultado_texto <- renderUI({
      tags$div(style = paste0("color: #34d399; background: rgba(16,185,129,0.08); padding: 10px 14px;",
                              "border-radius: 8px; margin-top: 10px; font-size: 13px; border: 1px solid rgba(16,185,129,0.2);"),
               tags$strong("Se rechaza H0: "),
               "Con un nivel de confianza del 95% y dado que en ambas pruebas el p-valor es menor a 0.05, se puede concluir que ambas poblaciones no siguen una distribucion normal.")
    })
  })
  
  output$wilcox_resultado <- renderPrint({
    wilcox.test(
      df$monto[df$tipo_fraude == "F"],
      df$monto[df$tipo_fraude == "_Z"]
    )
  })
  
  output$wilcox_interpretacion <- renderUI({
    res <- wilcox.test(
      df$monto[df$tipo_fraude == "F"],
      df$monto[df$tipo_fraude == "_Z"]
    )
    if (res$p.value < 0.05) {
      tags$div(style = paste0("color: #34d399; background: rgba(16,185,129,0.08); padding: 10px 14px;",
                              "border-radius: 8px; margin-top: 10px; font-size: 13px; border: 1px solid rgba(16,185,129,0.2);"),
               tags$strong("Se rechaza H0: "),
               "La prueba de Wilcoxon arrojo un p-valor extremadamente pequeno (menor a 0.05), lo que indica que existe diferencia estadisticamente significativa en los montos entre transacciones con fraude y sin fraude. En consecuencia, el valor de la transaccion no se comporta de la misma manera en operaciones fraudulentas y no fraudulentas, lo que constituye un indicio de dependencia entre ambas variables.")
    }
  })
  
  # ================================================================
  #  TRATAMIENTO DE FALTANTES
  # ================================================================
  metricas    <- read.csv("metricas_modelo.csv")
  resultados  <- read.csv("predicciones_test.csv")
  importancia <- read.csv("importancia_variables.csv")
  df_final    <- read.csv("df_final.csv")
  
  resultados$y_real     <- as.numeric(as.character(resultados$y_real))
  resultados$y_predicho <- as.numeric(as.character(resultados$y_predicho))
  
  output$tabla_metricas <- renderTable({
    metricas
  }, digits = 4, na = "")
  
  output$plot_predicciones <- renderPlot({
    # Evitar error si los datos no cargaron bien
    req(resultados) 
    
    set.seed(42)
    # Usamos drop = FALSE para mantener la estructura de data.frame pura
    resultados_plot <- resultados[sample(nrow(resultados), pmin(nrow(resultados), 2000)), , drop = FALSE]
    
    ggplot(resultados_plot, aes(x = y_real, y = y_predicho)) +
      geom_point(alpha = 0.3, color = "#38bdf8", size = 1.5) + # Color directo para evitar errores
      geom_abline(slope = 1, intercept = 0, color = "#f43f5e", linetype = "dashed", linewidth = 0.8) +
      labs(
        title = "Real vs Predicho (Muestra de 2000 puntos)",
        x = "Valor real",
        y = "Valor predicho"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.title        = element_text(color = "#1e293b", face = "bold", size = 14),
        axis.text         = element_text(color = "#64748b"), 
        axis.title        = element_text(color = "#1e293b"),
        panel.grid.major  = element_line(color = "#e2e8f0", linewidth = 0.2), 
        panel.grid.minor  = element_blank(),
        plot.background   = element_rect(fill = "#f1f5f9", color = NA),
        panel.background  = element_rect(fill = "#f1f5f9", color = NA),
        # Definición de margen ultra-segura
        plot.margin       = unit(c(20, 20, 20, 20), "pt") 
      )
  })
  
  output$plot_distribucion <- renderPlot({
    df_plot  <- data.frame(valor = df_final$monto,       tipo = "Original (con NA)")
    df_plot2 <- data.frame(valor = df_final$monto_final, tipo = "Despues de Imputacion (RF)")
    
    df_kde <- bind_rows(df_plot, df_plot2) %>% filter(!is.na(valor))
    df_kde$tipo <- factor(df_kde$tipo, levels = c("Original (con NA)", "Despues de Imputacion (RF)"))
    
    ggplot(df_kde, aes(x = valor, color = tipo, linetype = tipo)) +
      geom_density(linewidth = 0.9) +
      scale_color_manual(values = c("Original (con NA)"            = "#0284c7", # Azul
                                    "Despues de Imputacion (RF)"    = "#f59e0b")) + # Naranja
      scale_linetype_manual(values = c("Original (con NA)"          = "solid",
                                       "Despues de Imputacion (RF)" = "dashed")) +
      labs(title    = "Impacto de la Imputación RF en la Distribución de Monto",
           x        = "Monto", y = "Densidad",
           color    = "Estado del Dataset", linetype = "Estado del Dataset") +
      theme_minimal(base_size = 13) +
      theme(
        plot.title        = element_text(color = "#1e293b", face = "bold", size = 14),
        axis.text         = element_text(color = "#64748b"),
        axis.title        = element_text(color = "#1e293b"),
        legend.text       = element_text(color = "#334155"),
        legend.title      = element_text(color = "#1e293b", face = "bold"),
        legend.background = element_rect(fill = "#f1f5f9", color = NA),
        panel.grid.major  = element_line(color = "#e2e8f0", linewidth = 0.2),
        panel.grid.minor  = element_blank(),
        plot.background   = element_rect(fill = "#f1f5f9", color = NA),
        panel.background  = element_rect(fill = "#f1f5f9", color = NA),
        plot.margin       = unit(c(20, 20, 20, 20), "pt")
      )
  })
  
  output$resultado_ks <- renderPrint({
    original <- df_final$monto[!is.na(df_final$monto)]
    imputado <- df_final$monto_final[is.na(df_final$monto)]
    
    test <- ks.test(original, imputado)
    cat("Prueba de Kolmogorov-Smirnov (KS)\n")
    cat("--------------------------------\n")
    cat("Estadistico D:", test$statistic, "\n")
    cat("p-valor:     ", test$p.value,   "\n")
    
    alpha <- 0.05
    if (test$p.value < alpha) {
      cat("Conclusion: Las distribuciones son significativamente diferentes\n")
    } else {
      cat("Conclusion: No hay evidencia de diferencia en las distribuciones\n")
    }
  })
  
  outputOptions(output, "plot_tipo_fraude",    suspendWhenHidden = FALSE)
  outputOptions(output, "tabla_df_preview",    suspendWhenHidden = FALSE)
  outputOptions(output, "check_unit",          suspendWhenHidden = FALSE)
  outputOptions(output, "check_title",         suspendWhenHidden = FALSE)
  outputOptions(output, "tabla_nas",           suspendWhenHidden = FALSE)
  outputOptions(output, "plot_na_barras",      suspendWhenHidden = FALSE)
  outputOptions(output, "plot_predicciones",   suspendWhenHidden = FALSE)
  outputOptions(output, "plot_distribucion",   suspendWhenHidden = FALSE)
  outputOptions(output, "resultado_ks",        suspendWhenHidden = FALSE)
  outputOptions(output, "tabla_metricas",      suspendWhenHidden = FALSE)
  outputOptions(output, "bivariado_cat_contenido",      suspendWhenHidden = FALSE)
  outputOptions(output, "interpretacion_bloque",      suspendWhenHidden = FALSE)
}


