#Carga de librerias necesarias  
library(shiny)
library(tidyverse)
library(DT)
library(caret)
library(plotly)
library(pROC)
library(randomForest)
library(nortest)

#Carga del dataset
datos<-read.csv("data_payments.txt", stringsAsFactors = FALSE)
#Se cambia el nombre de las variables para mejor claridad
datos %>% 
  select(clave=KEY, frecuencia=FREQ, pais_origen=REF_AREA, pais_destino=COUNT_AREA,
         tipo_trx=TYP_TRNSCTN, tipo_psp=RL_TRNSCTN, tipo_fraude=FRD_TYP, unidad=UNIT_MEASURE,
         anio=TIME_PERIOD, monto=OBS_VALUE, tipo_monto=OBS_STATUS, decimales=DECIMALS,
         descripcion=TITLE, multiplicador_unidad=UNIT_MULT) -> df
cat("Datos cargados y preprocesados en global.R\n")


