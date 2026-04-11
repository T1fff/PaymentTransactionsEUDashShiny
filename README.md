
# Dashboard de Detección de Fraude en Transacciones de Pago — Unión Europea
Este dashboard se encuentra online en el siguiente link: [https://vys7bz-tiffany-mendoza.shinyapps.io/Data_Payments_ShinyDash/]

Dashboard analítico interactivo desarrollado en R Shiny sobre transacciones de pago de la Unión Europea.

---

## Requisitos

- R 4.0 o superior
- RStudio (recomendado)

---

## Instalación de paquetes

Ejecuta esto en la consola de R antes de correr la app:

```r
install.packages(c(
  "shiny",
  "shinydashboard",
  "bslib",
  "dplyr",
  "ggplot2",
  "plotly",
  "DT",
  "readr",
  "scales"
))
```

> Si algún paquete adicional falta, R lo indicará en la consola al correr la app.

---

## Estructura del proyecto

```
├── ui.R                      # Interfaz de usuario
├── server.R                  # Lógica del servidor
├── global.R                  # Carga de datos y configuración global
├── data_payments.csv         # Datos originales de transacciones
├── df_final.csv              # Dataset procesado
├── metricas_modelo.csv       # Métricas del modelo Random Forest
├── importancia_variables.csv # Importancia de variables del modelo
├── predicciones_test.csv     # Predicciones del modelo
└── www/                      # Recursos estáticos (imágenes, íconos)
```

---

## Cómo correr la app

1. Clona el repositorio:
```bash
git clone https://github.com/T1fff/PaymentTransactionsEUDashShiny.git
```

2. Abre el archivo `Data_Payments_ShinyDash.Rproj` en RStudio

3. Instala los paquetes (ver sección anterior)

4. En la consola de RStudio ejecuta:
```r
shiny::runApp()
```

O presiona el botón **Run App** en RStudio.

---

## Datos

Los archivos de datos están almacenados con **Git LFS**. Si al clonar los archivos `.csv` aparecen vacíos, instala Git LFS y ejecuta:

```bash
git lfs install
git lfs pull
```
```
