# BEDU equipo 18
# Ana Cristina Castillo Escobar
# Edgar Balderas Loranca
# José Alberto Cortes Ayala
# Leandro Marcelo Pantoja Acosta
# Marcos Yáñez Espíndola
# Luis Arturo Rosas León

library(mongolite)
library(dplyr)

# Descargar el archivo match.csv y leerlo en la variable file
setwd("/Users/leandro/Desktop/Bedu/R/Postwork/CSV")
url <- "https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2021/main/Sesion-07/Postwork/match.data.csv"
download.file(url = url, destfile = "match.csv", mode = "wb")
file <- read.csv("match.csv")

# Crear la conexión a la base de datos alojada en Mongo Atlas en la colección match dentro de la base de datos match_games
con <- mongo(collection = "match", db ="match_games", url = "mongodb+srv://equipo18:LSnS64XzHkix8Ft1@cluster0.sqcun.mongodb.net/test")

# Si la colección no contiene documentos, insertar los registros del archivo CSV
if (con$count() == 0) {
  con$insert(file)
}

# Desplegar la cantidad de registros que es igual a 3800
con$count('{}')

# Crear la consulta para obtener como resultado Real Madrid 10 - Rayo Vallecano 2
con$find(
  '{
  "$and": [
      {
        "date" : {"$eq" : "2015-12-20"}
      },
      {
        "$or" : [
          { "home_team" : "Real Madrid" }, 
          { "away_team" : "Real Madrid" }
        ]
      }
  ]
}')

#Desconectarse del servidor
con$disconnect()