# BEDU equipo 18
# Ana Cristina Castillo Escobar
# Edgar Balderas Loranca
# José Alberto Cortes Ayala
# Leandro Marcelo Pantoja Acosta
# Marcos Yáñez Espíndola

library(dplyr)
#Declaramos los links de los archivos
datos_1718<-"https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
datos_1819<-"https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
datos_1920<-"https://www.football-data.co.uk/mmz4281/1920/SP1.csv"

#Descargamos los archivos en la carpeta Data
download.file(url = datos_1718, destfile = "Data/SP1-1718.csv", mode = "wb")
download.file(url = datos_1819, destfile = "Data/SP1-1819.csv", mode = "wb")
download.file(url = datos_1920, destfile = "Data/SP1-1920.csv", mode = "wb")


dir("Data")

#Para cada uno de los archivos de la carpeta Data lo leemos con read.csv
#y guardamos todos los dataframe en una lista
lista <- lapply(paste("Data/",dir("Data"), sep = ""), read.csv) # Guardamos los archivos en lista
lista

#Revisar la estructura de los dataframes
str(lista[[1]])
str(lista[[2]])
str(lista[[3]])

head(lista[[1]])
head(lista[[2]])
head(lista[[3]])

View(lista[[1]])
View(lista[[2]])
View(lista[[3]])

summary(lista[[1]])
summary(lista[[2]])
summary(lista[[3]])

#Seleccionamos las columnas que usaremos
lista <- lapply(lista, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)

#Cambiamos el formato de las fechas
lista[[1]]<-lista[[1]] %>% mutate(Date=as.Date(lista[[1]]$Date,format="%d/%m/%y"))
lista[[2]]<-lista[[2]] %>% mutate(Date=as.Date(lista[[2]]$Date,format="%d/%m/%Y"))
lista[[3]]<-lista[[3]] %>% mutate(Date=as.Date(lista[[3]]$Date,format="%d/%m/%Y"))

# Integramos los datos en un solo dataframe
data <- do.call(rbind, lista)
View(data)
dim(data)