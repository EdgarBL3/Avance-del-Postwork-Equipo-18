# BEDU equipo 18
# Ana Cristina Castillo Escobar
# Edgar Balderas Loranca
# José Alberto Cortes Ayala
# Leandro Marcelo Pantoja Acosta
# Marcos Yáñez Espíndola

#Importar los datos a R
library(dplyr)
data <- read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")

#Obtener las caracteristicas de los datos
dim(data)
class(data)
str(data)

#Extraer los goles en casa y de visitante de cada equipo
goles<-data %>% select(FTHG,FTAG)

#Funcion de probabilidad marginal de que el equipo en casa anote "x" goles
FTHG.P <- prop.table(table(goles$FTHG))
(FTHG.P <- round(FTHG.P,4))

#Funcion de probabilidad marginal de que el equipo visitante anote "y" goles
FTAG.P <- prop.table(table(goles$FTAG))
(FTAG.P <- round(FTAG.P,4))

#Funcion de probabilidad conjunta
TPC <- with(goles,table(goles$FTHG,goles$FTAG))
PT.TPC <- prop.table(TPC)
(PT.TPC <- round(PT.TPC,4))

#Comprobamos que suman 1
sum(PT.TPC)