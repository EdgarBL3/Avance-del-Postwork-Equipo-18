# BEDU equipo 18
# Ana Cristina Castillo Escobar
# Edgar Balderas Loranca
# José Alberto Cortes Ayala
# Leandro Marcelo Pantoja Acosta
# Marcos Yáñez Espíndola
# Luis Arturo Rosas León

library(dplyr)
library(fbRanks)

#Declarar los links de los archivos
datos_1718<-"https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
datos_1819<-"https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
datos_1920<-"https://www.football-data.co.uk/mmz4281/1920/SP1.csv"

#Descargar los archivos en la carpeta Postwork S5
download.file(url = datos_1718, destfile = "C:/Users/Dell/OneDrive/Documentos/ArchivosR/Sesion5/Postwork5 F2/SP1-1718.csv", mode = "wb")
download.file(url = datos_1819, destfile = "C:/Users/Dell/OneDrive/Documentos/ArchivosR/Sesion5/Postwork5 F2/SP1-1819.csv", mode = "wb")
download.file(url = datos_1920, destfile = "C:/Users/Dell/OneDrive/Documentos/ArchivosR/Sesion5/Postwork5 F2/SP1-1920.csv", mode = "wb")

setwd("C:/Users/Dell/OneDrive/Documentos/ArchivosR/Sesion5/Postwork5 F2")
getwd()

#Juntar en una lista todos los datasets dentro del directorio de trabajo
lista.SP <- lapply(dir(), read.csv)
lista.SP <- lapply(lista.SP, select, c(Date,HomeTeam:FTAG))
str(lista.SP)
head(lista.SP[[1]]); head(lista.SP[[2]]); head(lista.SP[[3]])

#Cambiar el formato de las fechas
lista.SP[[1]]<-lista.SP[[1]] %>% mutate(Date=as.Date(lista.SP[[1]]$Date,format="%d/%m/%y"))
lista.SP[[2]]<-lista.SP[[2]] %>% mutate(Date=as.Date(lista.SP[[2]]$Date,format="%d/%m/%Y"))
lista.SP[[3]]<-lista.SP[[3]] %>% mutate(Date=as.Date(lista.SP[[3]]$Date,format="%d/%m/%Y"))

#Transformar la lista con los datasets a un solo dataset
data.SP <- do.call(rbind, lista.SP)
class(data.SP)
str(data.SP)

#Renombrar las columnas del dataframe
SmallData <- select(data.SP, date=Date, home.team=HomeTeam, away.team=AwayTeam, home.score=FTHG, away.score=FTAG)
class(SmallData)
str(SmallData)

#Guardar el dataframe "SmallData" como un archivo csv
setwd("C:/Users/Dell/OneDrive/Documentos/ArchivosR/Sesion5/Soccer")
getwd()
write.csv(SmallData,"soccer.csv", row.names = FALSE)

#Usar fbRanks para importar el archivo csv que contiene el dataframe más reciente
listasoccer <- create.fbRanks.dataframes("soccer.csv")
str(listasoccer)

#Guardar las anotaciones y los equipos en dos variables
(anotaciones <- listasoccer$scores)
(equipos <- listasoccer$teams)

#Crear un vector con las fechas en las que se jugaron los partidos
(fechas <- unique(listasoccer$scores$date))
(fechas <- fechas[order(fechas)])

#Crear una variable con el número de fechas contenidas en el vector que se hizo en el paso anterior
(n <- count(as.data.frame(fechas)))
class(n)

# primera fecha (fechas[1])
# penúltima fecha (fechas[n[1,]-1])
#Obtener el ranking de los equipos hasta la penúltima fecha
ranking <- rank.teams(scores = anotaciones, teams = equipos, max.date = fechas[n[1,]-1], min.date = fechas[1])

#Predecir los resultados de la última fecha de juego
pred <- predict.fbRanks(ranking,max.date = fechas[n[1,]],min.date = fechas[n[1,]])
str(pred)

#Obtener una tabla con los resultados reales y las predicciones
t.pred <- pred$scores
class(t.pred)
str(t.pred)
tf <- select(t.pred, HT=home.team, AT=away.team, AHS=home.score, AAS=away.score, HR=home.residuals, AR=away.residuals,PHS=pred.home.score, PAS=pred.away.score)
tf

#Generar un archivo csv para obtener una tabla que facilite la exposición de los datos
write.csv(tf,"pred.csv", row.names = FALSE)