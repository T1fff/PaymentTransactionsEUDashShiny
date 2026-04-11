library(shiny)
library(nortest)

# Paleta de colores globales (estilo Python dashboard)
COL_PRIMARY   <- "#6c63ff"
COL_SECONDARY <- "#7c6af7"
COL_FRAUD     <- "#e53935"
COL_OK        <- "#1d9e75"
COL_TEXT      <- "#444466"
COL_AXIS      <- "#888899"
COL_GRID      <- "rgba(200,195,240,0.25)"
BG_PLOT       <- "rgba(0,0,0,0)"

function(input, output, session) {
  
  # ================================================================
  #  KPIs - Introducción
  # ================================================================
  output$kpi_registros <- renderText({ paste0(format(nrow(df), big.mark = ","), ", 29") })
  output$kpi_columnas  <- renderText({ paste0(ncol(df), " columnas tras limpieza y selección") })
  
  output$kpi_fraude <- renderText({
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
  #  Gráfico distribución tipo_fraude - Problema
  # ================================================================
  output$plot_tipo_fraude <- renderPlotly({
    conteos <- df %>%
      count(tipo_fraude) %>%
      mutate(
        label = ifelse(tipo_fraude == "_Z", "sin fraude", "con fraude"),
        pct   = round(n / sum(n) * 100, 1),
        color = ifelse(tipo_fraude == "_Z", COL_PRIMARY, COL_FRAUD)
      )
    
    plot_ly(
      data         = conteos,
      x            = ~label,
      y            = ~n,
      type         = "bar",
      marker       = list(color = conteos$color, opacity = 0.85),
      text         = ~paste0(format(n, big.mark = ","), " (", pct, "%)"),
      textposition = "outside",
      textfont     = list(color = COL_TEXT, size = 12)
    ) %>%
      layout(
        xaxis         = list(title = "Tipo de transacción", tickfont = list(color = COL_AXIS, size = 12),
                             gridcolor = COL_GRID),
        yaxis         = list(title = "Núm. de transacciones", range = c(0, max(conteos$n) * 1.18),
                             tickfont = list(color = COL_AXIS), gridcolor = COL_GRID),
        margin        = list(t = 30, b = 40),
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
    if (resultado) "TRUE — Son columnas idénticas" else "FALSE — No son idénticas"
  })
  
  output$check_title <- renderText({
    resultado <- identical(datos$TITLE, datos$TITLE_COMPL)
    if (resultado) "TRUE — Son columnas idénticas" else "FALSE — No son idénticas"
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
    
    subtitulo <- if (var %in% vars_tabla)         "Tabla de frecuencias y porcentajes por categoría"
    else if (var %in% vars_graficos_cat) "Top 10 categorías por frecuencia"
    else if (var %in% vars_graficos_num) "Distribución de valores numéricos"
    else                                 "Variable indicativa"
    
    tags$div(
      tags$h5(paste0("Distribución: ", var),
              style = "color: #1a1a2e; font-weight: 600; margin-bottom: 4px; font-size: 15px;"),
      tags$p(subtitulo, style = "color: #8888aa; font-size: 11px; margin-bottom: 16px;")
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
            xaxis         = list(title = "Núm. de transacciones", tickfont = list(color = COL_AXIS),
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
                fillcolor     = "rgba(108,99,255,0.18)",
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
      rename(Categoría = 1) %>%
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
      style = "background: rgba(186,117,23,0.07); border-left: 4px solid #ba7517;
               border-radius: 0 10px 10px 0; padding: 20px 24px; margin-top: 10px;",
      tags$p("Variable no incluida en el análisis",
             style = "color: #ba7517; font-weight: 600; font-size: 14px; margin-bottom: 8px;"),
      tags$p(
        paste0("La variable ", nombre_real,
               " tiene un carácter meramente indicativo dentro del dataset. ",
               "Su contenido no aporta información estadísticamente relevante para el análisis ",
               "exploratorio ni para la construcción del modelo predictivo, por lo que se excluye ",
               "de esta sección."),
        style = "color: #666688; font-size: 13px; line-height: 1.65; margin: 0;"
      )
    )
  })
  
  output$eda_stats <- renderUI({
    req(input$eda_variable)
    var <- input$eda_variable
    if (!var %in% vars_graficos) return(NULL)
    
    stat_box <- function(label, valor, color = COL_TEXT) {
      tags$div(style = "margin-bottom: 14px;",
               tags$p(label, style = "color: #8888aa; font-size: 11px; margin: 0;"),
               tags$p(as.character(valor),
                      style = paste0("color:", color, "; font-size:1.1rem; font-weight:600; margin:0;"))
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
        stat_box("Total observaciones", format(total, big.mark = ","),         "#1a1a2e"),
        stat_box("Valores únicos",      nrow(datos_cat),                       COL_PRIMARY),
        stat_box("Valores nulos",       n_na, if (n_na > 0) COL_FRAUD else COL_OK),
        stat_box("Moda",                moda,                                  "#1a1a2e"),
        stat_box("Frec. moda",          paste0(format(frec_moda, big.mark = ","), " (", pct_moda, "%)"), COL_SECONDARY),
        tags$hr(style = "border-color: #e8e5f8; margin: 10px 0;"),
        tags$p("Top 5", style = "color: #6c63ff; font-size: 12px; font-weight: 600; margin-bottom: 8px;"),
        tags$table(style = "width:100%; font-size:12px;",
                   tags$thead(tags$tr(
                     tags$th("Categ.", style = "color: #6c63ff; text-align:left; padding-bottom:4px;"),
                     tags$th("%",      style = "color: #6c63ff; text-align:right;")
                   )),
                   tags$tbody(lapply(seq_len(nrow(top5)), function(i) {
                     tags$tr(
                       tags$td(as.character(top5[[var]][i]), style = "color: #444466; padding: 3px 0;"),
                       tags$td(paste0(top5$pct[i], "%"),    style = "color: #6c63ff; text-align:right;")
                     )
                   }))
        )
      )
      
    } else {
      datos_num <- df %>% pull(.data[[var]]) %>% na.omit()
      n_na      <- sum(is.na(df[[var]]))
      tagList(
        stat_box("Total observaciones", format(nrow(df), big.mark = ","),    "#1a1a2e"),
        stat_box("Valores nulos",       n_na, if (n_na > 0) COL_FRAUD else COL_OK),
        stat_box("Media",               round(mean(datos_num), 2),           COL_PRIMARY),
        stat_box("Mediana",             round(median(datos_num), 2),         COL_PRIMARY),
        stat_box("Desv. estándar",      round(sd(datos_num), 2),             COL_SECONDARY),
        stat_box("Mínimo",              round(min(datos_num), 2),            COL_OK),
        stat_box("Máximo",              round(max(datos_num), 2),            COL_FRAUD),
        stat_box("Q1",                  round(quantile(datos_num, 0.25), 2), "#ba7517"),
        stat_box("Q3",                  round(quantile(datos_num, 0.75), 2), "#ba7517")
      )
    }
  })
  
  output$eda_interpretacion <- renderUI({
    req(input$eda_variable)
    var <- input$eda_variable
    
    texto <- switch(var,
                    "monto" = "La distribución de monto para el tipo PN es altamente asimétrica, con fuerte concentración de valores bajos y una cantidad significativa de valores extremos altos. Esto indica que aunque la mayoría de las transacciones tienen totales moderados, existen algunas con totales excepcionalmente altos que influyen notablemente en los estadísticos como la media y la desviación estándar.",
                    
                    "frecuencia" = HTML(paste0(
                      "El gráfico anterior describe la distribución de la variable frecuencia del dataset, que permite caracterizar la recurrencia habitual de las transacciones. Las transacciones anuales (A) representan un 41.53% del total, mientras que la frecuencia semestral (H) y trimestral (Q) agrupan un 35.75% y 22.72%, cada una. En números exactos esto es 275.179, 236.884 y 150.553 transacciones respectivamente.",
                      "<br><br><b>Diccionario de categorías:</b><ul>",
                      "<li><b>A (Annual):</b> Transacciones anuales.</li>",
                      "<li><b>H (Half-year):</b> Transacciones semestrales.</li>",
                      "<li><b>Q (Quarterly):</b> Transacciones trimestrales.</li></ul>"
                    )),
                    
                    "tipo_trx" = HTML(paste0(
                      "La tabla y gráfico anteriores describen la distribución de la variable tipo_trx del dataset, que permite caracterizar el movimiento bancario realizado y su instrumento. Los débitos directos y transferencias de crédito son las categorías más grandes con un porcentaje del 14.59% cada una, seguida por pagos electrónicos (13.91%) y cheques (9.02%). El pago por tarjetas de crédito predomina ligeramente sobre otros servicios de pago, observándose un 9.02% sobre un 8.60%. Con aproximadamente un 1% de participación las categorías ND* son marginales y podría considerarse su agrupación. Mientras que las columnas de TOTL y TOTL1 representan totales agregados, no instrumentos individuales.",
                      "<br><br><b>Diccionario de categorías:</b><ul>",
                      "<li><b>DD:</b> Créditos directos.</li>",
                      "<li><b>CT0:</b> Transferencia de crédito.</li>",
                      "<li><b>EMP0:</b> Pagos con dinero electrónico.</li>",
                      "<li><b>CHQ:</b> Cheques.</li>",
                      "<li><b>CP0:</b> Pagos con tarjeta.</li>",
                      "<li><b>SER:</b> Otros servicios de pago.</li>",
                      "<li><b>MREM:</b> Envíos de dinero.</li>",
                      "<li><b>TOTL:</b> Transacciones de pago totales [suma de CT, DD, CP, CW, EM, CHQ, MR, OTH].</li>",
                      "<li><b>TOTL1:</b> Total de transacciones de pago, excluyendo retiros de efectivo.</li>",
                      "<li><b>CW1:</b> Retiros de efectivo con tarjeta.</li></ul>"
                    )),
                    
                    "tipo_psp" = HTML(paste0(
                      "La tabla y gráfico anteriores describen la distribución de la variable tipo_psp del dataset, que permite caracterizar el rol de la transacción. El 58.51% de las transacciones se registraron desde el PSP del pagador, esto es 387.724, frente a 270.818 o 40.87% asociadas al PSP del beneficiario. Por otro lado, se tiene un 0.61% de transacciones no asociadas a ninguna de las clasificaciones anteriores, quizá por tratarse de movimientos monetarios internos.",
                      "<br><br><b>Diccionario de categorías:</b><ul>",
                      "<li><b>1 (Payer's PSP):</b> Proveedor de servicios de pago del pagador. Entidad que procesa el pago de quien envía el dinero.</li>",
                      "<li><b>2 (Payee's PSP):</b> Proveedor de servicios de pago del beneficiario. Entidad que procesa el pago de quien recibe el dinero.</li>",
                      "<li><b>_Z (NA):</b> Transacciones sin rol definido o internas.</li></ul>"
                    )),
                    
                    "unidad" = HTML(paste0(
                      "La tabla y gráfico anteriores describen la distribución de la variable unidad del dataset, que permite caracterizar el tipo de unidad o medida en la que se reporta una observación. Destacan los grupos PN (número puro o conteo), EUR y XDF (divisa doméstica) con un 44.75%, 39% y 9.22% respectivamente. Adicionalmente, se presentan ratios por total de habitantes, número de transacciones, total de transacciones, entre otros, en menor proporción. Carece de sentido realizar comparaciones directas entre las distintas series; se debe realizar una transformación para que puedan trabajarse de forma equivalente.",
                      "<br><br><b>Diccionario de categorías:</b><ul>",
                      "<li><b>PN:</b> Número puro.</li>",
                      "<li><b>EUR:</b> Euro.</li>",
                      "<li><b>XDF:</b> Moneda nacional (incluida la conversión a la moneda actual utilizando un tipo de cambio fijo de paridad o de mercado).</li>",
                      "<li><b>PN_R_POP:</b> Número puro per cápita.</li>",
                      "<li><b>EUR_R_POP:</b> Euros per cápita.</li>",
                      "<li><b>EUR_R_TT:</b> Euro; proporción respecto al valor total de las transacciones de pago.</li>",
                      "<li><b>PN_R_TT:</b> Número puro; proporción respecto al número total de transacciones de pago.</li>",
                      "<li><b>EUR_R_PNT:</b> Euro; ratio respecto al número de transacciones.</li>",
                      "<li><b>EUR_R_B1GQ:</b> Euro; ratio respecto al PIB.</li>",
                      "<li><b>XDF_R_TT:</b> Moneda nacional; proporción respecto al valor total de las transacciones de pago.</li></ul>"
                    )),
                    
                    "tipo_monto" = HTML(paste0(
                      "La tabla y gráfico anteriores describen la distribución de la variable tipo_monto del dataset, que permite caracterizar la validez del monto registrado en la columna monto. De forma general vemos que el 72.86% de las observaciones fueron clasificadas como A, es decir, el monto fue validado correctamente. Mientras que el 28% restante presentan un monto poco fiable que pudo haber sido suprimido, estimado, no recolectado, etc.",
                      "<br><br><b>Diccionario de categorías:</b><ul>",
                      "<li><b>A:</b> Valor normal.</li>",
                      "<li><b>Q:</b> Valor faltante, suprimido.</li>",
                      "<li><b>M:</b> Valor faltante, dato no puede existir.</li>",
                      "<li><b>P:</b> Valor temporal.</li>",
                      "<li><b>L:</b> Valor faltante, dato existente pero no pudo ser recolectado.</li>",
                      "<li><b>E:</b> Valor estimado.</li></ul>"
                    )),
                    
                    "tipo_fraude" = HTML(paste0(
                      "Muestra la distribución del tipo de transacción, confirmando que la mayoría de transacciones observadas no fueron marcadas como fraude. Puntualmente el 99.7% de las transacciones fueron consideradas legales, mientras que el 0.3% fueron asociadas con algún comportamiento irregular. Esta notable diferencia indica un alto desbalance en las clases de la variable objetivo, lo cual es importante destacar al momento de construir modelos predictivos.",
                      "<br><br><b>Diccionario de categorías:</b><ul>",
                      "<li><b>_Z:</b> Transacción sin fraude.</li>",
                      "<li><b>F:</b> Transacción con fraude.</li></ul>"
                    )),
                    
                    "clave" = "La variable clave es un identificador único compuesto por la concatenación de las demás variables categóricas de la transacción. Al ser una clave técnica, el número de valores únicos es igual al número de filas del dataset, por lo que no aporta información analítica directa más allá de servir como índice de referencia.",
                    
                    "pais_origen" = HTML(paste0(
                      "La tabla describe la distribución de la variable pais_origen del dataset, que permite caracterizar el origen de las transacciones. A simple vista se puede notar que los países tienen frecuencias muy similares; no hay un único país que destaque de forma dominante frente a los demás. Rumanía, Hungría, Polonia, República Checa y Países Bajos son los 5 territorios con el porcentaje de origen más alto, superior al 4% cada uno. Por otro lado, encontramos entidades especiales como la 'Euro Area changing composition' y 'EU changing composition' que presentan una baja frecuencia frente a otros mercados (menos del 1%).",
                      "<br><br><b>Ejemplos de códigos de país:</b><ul>",
                      "<li><b>RO:</b> Rumanía.</li>",
                      "<li><b>HU:</b> Hungría.</li>",
                      "<li><b>PL:</b> Polonia.</li>",
                      "<li><b>CZ:</b> República Checa.</li>",
                      "<li><b>NL:</b> Países Bajos.</li>",
                      "<li><b>PT:</b> Portugal.</li></ul>"
                    )),
                    
                    "pais_destino" = HTML(paste0(
                      "La tabla anterior describe la distribución de la variable pais_destino del dataset, que permite caracterizar el destino de las transacciones. Empezamos destacando que el 22.54% de las transacciones no especifican el destino final sino que generalizan en entidades como World, Rest of the World, Domestic y Extra EEA, cada una con una representación del 13%, 3.28%, 3.25% y 2.62%. Para los países europeos explícitamente listados se manejan porcentajes de representación del 2% cada uno aproximadamente. Mientras que los países destino fuera de la EEA comprenden menos del 1% cada uno.",
                      "<br><br><b>Ejemplos de códigos:</b><ul>",
                      "<li><b>W0:</b> Mundo (todas las entidades, incluyendo el área de referencia, incluyendo las E/S).</li>",
                      "<li><b>W1:</b> Resto del mundo.</li>",
                      "<li><b>W2:</b> Doméstico (hogar o área de referencia).</li>",
                      "<li><b>G1:</b> Extra EEE.</li>",
                      "<li><b>SE:</b> Suecia.</li></ul>"
                    )),
                    
                    "anio" = "La tabla anterior describe la distribución de la variable anio del dataset, que permite caracterizar el año o periodo de tiempo en el que se procesaron las transacciones. A simple vista se nota que hay años representados solos, por trimestre o semestre. Es importante notar que estas divisiones no representan acumulados entre sí, solo son categorías distintas de registro. Se nota progresivamente el incremento en movimientos bancarios desde el año 2000, destacándose el incremento exponencial a partir del año 2014. Los últimos 5 años han marcado récords históricos en total de transacciones registradas.",
                    
                    paste0("La variable ", var, " es analizada en términos de su distribución y frecuencia de categorías dentro del conjunto de datos.")
    )
    
    tags$div(
      style = "background: rgba(108,99,255,0.06); border-left: 4px solid #6c63ff;
               border-radius: 0 10px 10px 0; padding: 14px 18px; margin-top: 16px;",
      tags$p(texto, style = "color: #444466; font-size: 13px; line-height: 1.7; margin: 0;")
    )
  })
  
  # ================================================================
  #  EDA MULTIVARIADO
  # ================================================================
  vars_barras    <- c("frecuencia", "tipo_trx", "tipo_psp", "unidad", "tipo_monto")
  vars_tabla     <- c("pais_origen", "pais_destino", "anio")
  vars_excluidas <- c("clave", "decimales", "descripcion", "multiplicador_unidad")
  
  textos_excluidas <- list(
    decimales = "Para este análisis la variable decimales se excluye frente al tipo de fraude porque presenta baja frecuencia por categoría, haciendo que sea poco interpretable. Además, decimales corresponde a un atributo técnico de formato numérico que no representa una característica explicativa independiente con significado analítico propio.",
    
    descripcion = "Para este análisis la variable descripcion se excluye frente al tipo de fraude porque corresponde a un código estructural compuesto que integra múltiples atributos técnicos. En esta variable se describe la transacción e indica si hubo fraude, el tipo de transacción y si fue enviada, información que ya se encuentra recogida en otras variables previamente analizadas. Por tanto, no representa una característica explicativa independiente con significado analítico propio.",
    
    multiplicador_unidad = "Para este análisis la variable multiplicador_unidad se excluye frente al tipo de fraude porque presenta baja frecuencia por categoría, haciendo que sea poco interpretable. Además, multiplicador_unidad corresponde a un atributo técnico de escala monetaria que no representa una característica explicativa independiente con significado analítico propio.",
    
    clave = "Para este análisis la variable clave se excluye frente al tipo de fraude porque presenta baja frecuencia por categoría, haciendo que sea poco interpretable. Además, clave corresponde a un identificador técnico sin significado analítico propio."
  )
  
  interpretaciones_cat <- list(
    frecuencia   = "El gráfico muestra que la gran mayoría de las transacciones corresponden a la clase sin fraude, distribuyéndose principalmente en las categorías A (41.7%) y H (35.6%), mientras que Q representa una proporción menor. En contraste, los casos de fraude son extremadamente pocos y se concentran completamente en una sola categoría de frecuencia (H), lo que evidencia el fuerte desbalance de la variable respuesta.",
    
    tipo_trx     = "El gráfico muestra los tipos de transferencia con pagos con tarjeta (CP0), transferencias de crédito (CT0), débitos directos (DD), pagos con dinero electrónico (EMP0) y transacciones de pago totales (TOTL); aunque estos 5 tipos concentran el mayor número absoluto de fraudes, la proporción de transacciones fraudulentas dentro de cada tipo sigue siendo muy baja. En todos los casos, más del 98% de las transacciones corresponden a la categoría sin fraude, mientras que los fraudes representan entre aproximadamente 0.1% y 1.2% del total por cada tipo de transacción. Esto sigue demostrando el fuerte desbalance de la variable de respuesta.",
    
    tipo_psp     = "La mayoría de las transacciones se concentran en el rol 1 (Payer's PSP) con 58.5%, seguido del rol 2 (Payee's PSP) con 40.9%, mientras que la categoría _Z es marginal (0.6%). En los casos de fraude (F) se mantiene esta tendencia, predominando también el rol 1 (61.9%), lo que indica que tanto el volumen total como los eventos fraudulentos se concentran principalmente en el PSP del pagador.",
    
    unidad       = "La mayoría de las transacciones se registran en la categoría sin fraude, con proporciones cercanas al 99.7% en todas las unidades, mientras que las transacciones con fraude representan apenas alrededor del 0.3%. Aunque número puro (PN), Euro (EUR) y moneda nacional (XDF) concentran los mayores volúmenes, la incidencia relativa del fraude se mantiene estable entre monedas, lo que sugiere que el fraude se explica más por el volumen total de operaciones que por la unidad de transacción.",
    
    tipo_monto   = "El gráfico de tipo_monto indica que la categoría A concentra la mayor parte de las transacciones (72.9%), seguido por Q (14.1%), M (7.4%) y P (5.3%), mientras que E y L son marginales. En los casos de fraude (F) se mantiene la misma estructura general, con predominio de A, aunque con una participación relativamente mayor en P y Q frente al conjunto total. Esto sugiere que, si bien la distribución global está dominada por A, ciertas categorías como P y Q adquieren mayor relevancia relativa dentro de las operaciones fraudulentas.",
    
    pais_origen  = "La tabla muestra que, aunque los cinco países principales concentran el mayor número absoluto de fraudes, la proporción de transacciones fraudulentas dentro de cada país sigue siendo muy baja. En todos los casos, más del 96% de las transacciones corresponden a la categoría sin fraude, mientras que los fraudes representan entre aproximadamente 0.3% y 3.5% del total por país. Esto sigue demostrando el fuerte desbalance de la variable de respuesta.",
    
    pais_destino = "El gráfico evidencia que el área W0 (Mundo, todas las entidades, incluido el área de referencia) concentra la totalidad de los fraudes observados (1.944 casos), aunque estos representan solo el 2.2% del total de transacciones en esa región, frente al 97.8% correspondiente a operaciones no fraudulentas. Esto indica que, si bien el fraude está focalizado geográficamente en W0, su ocurrencia sigue siendo baja en términos proporcionales, confirmando el fuerte desbalance de la variable.",
    
    anio         = "Los años 2022, 2023 y 2024 concentran la mayor cantidad de fraudes, en el contexto de la nueva era tecnológica derivada de la pandemia de COVID-19.",
    
    clave        = "La variable clave presenta distribución muy dispersa entre categorías. La tabla de contingencia permite explorar su relación con tipo_fraude sin perder detalle por agregación."
  )
  
  interpretaciones_chi2 <- list(
    frecuencia   = "Se rechaza H\u2080: la prueba chi-cuadrado indica que la frecuencia con la que se realiza determinado pago está asociada con el tipo de fraude (\u03c7\u00b2(2) = 3504.1, p-valor < 0.001).",
    
    tipo_trx     = "Se rechaza H\u2080: la prueba chi-cuadrado indica que la clasificación de la transacción está asociada con el tipo de fraude (\u03c7\u00b2(2) = 2645, p-valor < 0.001).",
    
    tipo_psp     = "Se rechaza H\u2080: la prueba chi-cuadrado indica que la clasificación de la entidad que procesa la transacción está asociada con el tipo de fraude (\u03c7\u00b2(2) = 19.639, p-valor < 0.001).",
    
    unidad       = "Se rechaza H\u2080: la prueba chi-cuadrado indica que la unidad o divisa involucrada en la transacción está asociada con el tipo de fraude (\u03c7\u00b2(2) = 262.21, p-valor < 0.001).",
    
    tipo_monto   = "Se rechaza H\u2080: la prueba chi-cuadrado indica que el tipo de monto de la transacción está asociado con el tipo de fraude (\u03c7\u00b2(2) = 326.11, p-valor < 0.001).",
    
    pais_origen  = "Se rechaza H\u2080: la prueba chi-cuadrado indica que el país o zona de origen donde se realiza la transacción está asociado con el tipo de fraude (\u03c7\u00b2(2) = 2288.9, p-valor < 0.001).",
    
    pais_destino = "Se rechaza H\u2080: la prueba chi-cuadrado indica que el país o zona de destino de la transacción está asociado con el tipo de fraude (\u03c7\u00b2(2) = 12610, p-valor < 0.001).",
    
    anio  = "Para la variable año no se realiza prueba de independencia formal, ya que no resulta necesaria para el presente análisis dada la naturaleza temporal de esta variable. No obstante, se observa que los años 2022, 2023 y 2024 concentran la mayor cantidad de fraudes registrados.",
    
    clave = "La variable clave no se somete a prueba de independencia porque presenta baja frecuencia por categoría, lo que haría poco fiable el resultado del chi-cuadrado. Se muestra únicamente la tabla de contingencia con fines exploratorios."
  )
  
  # ── Contenido central bivariado ──────────────────────────────────
  output$bivariado_cat_contenido <- renderUI({
    req(input$var_cat)
    var <- input$var_cat
    if (var == "") return(NULL)
    
    if (var %in% vars_excluidas) {
      return(fluidRow(column(12,
                             div(class = "py-card",
                                 tags$div(style = "display:flex; align-items:flex-start; gap:14px; padding:6px 0;",
                                          tags$div(style = paste0("width:4px; min-height:60px; background:", COL_FRAUD,
                                                                  "; border-radius:4px; flex-shrink:0;")),
                                          tags$div(
                                            tags$p("Variable excluida del análisis bivariado",
                                                   style = paste0("color:", COL_FRAUD, "; font-weight:600; font-size:14px; margin:0 0 6px;")),
                                            tags$p(textos_excluidas[[var]],
                                                   style = "color:#555577; font-size:13px; line-height:1.65; margin:0;")
                                          )
                                 )
                             )
      )))
    }
    
    if (var %in% vars_barras) {
      return(fluidRow(column(12,
                             div(class = "py-card",
                                 div(class = "py-card-title", uiOutput("titulo_grafico_cat")),
                                 div(class = "py-card-sub",   "Gráfico de barras múltiple · frecuencias absolutas y porcentaje dentro de cada grupo"),
                                 plotlyOutput("plot_barras_cat", height = "420px")
                             )
      )))
    }
    
    if (var %in% vars_tabla) {
      return(fluidRow(column(12,
                             div(class = "py-card",
                                 div(class = "py-card-title", uiOutput("titulo_grafico_cat")),
                                 div(class = "py-card-sub",   "Distribución cruzada de la variable seleccionada con tipo_fraude"),
                                 div(style = "overflow-x:auto; max-height:420px;",
                                     tableOutput("tabla_contingencia_cat"))
                             )
      )))
    }
  })
  
  output$titulo_grafico_cat <- renderUI({
    req(input$var_cat)
    if (input$var_cat %in% vars_barras)
      paste("Distribución de", input$var_cat, "por tipo de fraude")
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
  
  # ── Bloque chi-cuadrado ──────────────────────────────────────────
  
  
  output$chi2_resultado <- renderPrint({
    req(input$var_cat)
    var <- input$var_cat
    if (var == "" || var %in% vars_excluidas) return(invisible())
    if (var %in% c("anio", "clave")) {
      cat("Prueba no aplicada para esta variable.\nVer interpretación más abajo.")
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
      div(style = paste0("color: #0f5132; background: #d1e7dd; padding: 10px 14px;",
                         "border-radius: 8px; margin-top: 10px; font-size: 13px;"),
          icon("circle-check"), tags$strong(" Se rechaza H\u2080: "), texto)
    } else {
      div(style = paste0("color: #0c3660; background: #cfe2ff; padding: 10px 14px;",
                         "border-radius: 8px; margin-top: 10px; font-size: 13px;"),
          icon("circle-info"), tags$strong(" Nota: "), texto)
    }
  })
  
  # ── Bloque interpretación ────────────────────────────────────────
  output$interpretacion_bloque <- renderUI({
    req(input$var_cat)
    var <- input$var_cat
    if (var == "" || var %in% vars_excluidas) return(NULL)
    
    texto <- interpretaciones_cat[[var]]
    if (is.null(texto)) return(NULL)
    
    fluidRow(column(12,
                    div(class = "py-card",
                        div(class = "py-card-title", "Interpretación"),
                        tags$p(style = "color: #444466; font-size: 13px; line-height: 1.75; margin: 0;", texto)
                    )
    ))
  })
  
  # ── Boxplot monto ────────────────────────────────────────────────
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
      yaxis         = list(title = "Valor de la transacción (monto)",
                           tickfont = list(color = COL_AXIS), gridcolor = COL_GRID),
      xaxis         = list(title = "¿Hubo fraude?", tickfont = list(color = COL_AXIS)),
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
        Mínimo  = round(min(monto,            na.rm = TRUE), 2),
        Máximo  = round(max(monto,            na.rm = TRUE), 2),
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
      div(style = paste0("color: #0f5132; background: #d1e7dd; padding: 10px 14px;",
                         "border-radius: 8px; margin-top: 10px; font-size: 13px;"),
          icon("circle-check"),
          tags$strong(" Se rechaza H\u2080: "),
          "Con un nivel de confianza del 95% y dado que en ambas pruebas el p-valor es menor a 0.05, se puede concluir que ambas poblaciones no siguen una distribución normal.")
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
      div(style = paste0("color: #0f5132; background: #d1e7dd; padding: 10px 14px;",
                         "border-radius: 8px; margin-top: 10px; font-size: 13px;"),
          icon("circle-check"),
          tags$strong(" Se rechaza H\u2080: "),
          "La prueba de Wilcoxon arrojó un p-valor extremadamente pequeño (menor a 0.05), lo que indica que existe diferencia estadísticamente significativa en los montos entre transacciones con fraude y sin fraude. En consecuencia, el valor de la transacción no se comporta de la misma manera en operaciones fraudulentas y no fraudulentas, lo que constituye un indicio de dependencia entre ambas variables.")
    }
  })
  
  # ================================================================
  #  TRATAMIENTO DE FALTANTES - gráficos ggplot
  # ================================================================
  metricas    <- read.csv("metricas_modelo.csv")
  resultados  <- read.csv("predicciones_test.csv")
  importancia <- read.csv("importancia_variables.csv")
  df_final    <- read.csv("df_final.csv")
  
  output$tabla_metricas <- renderTable({
    metricas
  }, digits = 4, na = "")
  
  output$plot_predicciones <- renderPlot({
    # 1. Aplicamos el muestreo para mejorar el rendimiento del gráfico
    set.seed(42)
    # Usamos pmin para evitar errores si el dataset tiene menos de 2000 filas
    resultados_plot <- resultados[sample(nrow(resultados), pmin(nrow(resultados), 2000)), ]
    
    # 2. Generamos el ggplot con los datos filtrados
    ggplot(resultados_plot, aes(x = y_real, y = y_predicho)) +
      geom_point(alpha = 0.3, color = "steelblue", size = 1.5) + # Cambiado a steelblue
      geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed", linewidth = 0.8) + # Cambiado a red
      labs(
        title = "Real vs Predicho (Muestra de 2000 puntos)", 
        x = "Valor real", 
        y = "Valor predicho"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.title       = element_text(color = "#1a1a2e", face = "bold", size = 14),
        axis.text        = element_text(color = COL_AXIS),
        axis.title       = element_text(color = COL_TEXT),
        panel.grid.major = element_line(color = "#e8e5f8"),
        panel.grid.minor = element_blank(),
        plot.background  = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA)
      )
  })
  
  
  output$plot_distribucion <- renderPlot({
    df_plot  <- data.frame(valor = df_final$monto,       tipo = "Original (con NA)")
    df_plot2 <- data.frame(valor = df_final$monto_final, tipo = "Después de Imputación (RF)")
    
    df_kde <- bind_rows(df_plot, df_plot2) %>% filter(!is.na(valor))
    df_kde$tipo <- factor(df_kde$tipo, levels = c("Original (con NA)", "Después de Imputación (RF)"))
    
    ggplot(df_kde, aes(x = valor, color = tipo, linetype = tipo)) +
      geom_density(linewidth = 0.9) +
      scale_color_manual(values = c("Original (con NA)"          = COL_PRIMARY,
                                    "Después de Imputación (RF)" = COL_FRAUD)) +
      scale_linetype_manual(values = c("Original (con NA)"          = "solid",
                                       "Después de Imputación (RF)" = "dashed")) +
      labs(title    = "Impacto de la Imputación RF en la Distribución de Monto",
           x        = "Monto", y = "Densidad",
           color    = "Estado del Dataset", linetype = "Estado del Dataset") +
      theme_minimal(base_size = 13) +
      theme(
        plot.title       = element_text(color = "#1a1a2e", face = "bold", size = 14),
        axis.text        = element_text(color = COL_AXIS),
        axis.title       = element_text(color = COL_TEXT),
        legend.text      = element_text(color = COL_TEXT),
        legend.title     = element_text(color = COL_TEXT),
        panel.grid.major = element_line(color = "#e8e5f8"),
        panel.grid.minor = element_blank(),
        plot.background  = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA)
      )
  })
  
  output$resultado_ks <- renderPrint({
    original <- df_final$monto[!is.na(df_final$monto)]
    imputado <- df_final$monto_final[is.na(df_final$monto)]
    
    test <- ks.test(original, imputado)
    cat("Prueba de Kolmogorov-Smirnov (KS)\n")
    cat("--------------------------------\n")
    cat("Estadístico D:", test$statistic, "\n")
    cat("p-valor:     ", test$p.value,   "\n")
    
    alpha <- 0.05
    if (test$p.value < alpha) {
      cat("Conclusión: Las distribuciones son significativamente diferentes\n")
    } else {
      cat("Conclusión: No hay evidencia de diferencia en las distribuciones\n")
    }
  })
  
}

