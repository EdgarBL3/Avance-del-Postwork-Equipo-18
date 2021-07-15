library(ggplot2)
library(gganimate)
library(hrbrthemes)
library(plotly)

#Importar el conjunto de datos match_data.csv a R y realizar lo siguiente:
setwd("C:/Users/Dell/OneDrive/Documentos/ArchivosR/Sesion6")
data <- read.csv("match_data.csv")

#Agregar una nueva columna sumagoles que contenga la suma de goles por partido.
library(dplyr)
names(data)
data <- mutate(data, sumagoles = home.score + away.score)

#Obtener el promedio por mes de la suma de goles.
class(data$date)
data <- mutate(data, date = as.Date(date, "%Y-%m-%d"))

prom <- (data %>% 
  group_by(format(date, format="%Y-%m")) %>%
  summarise(mean(sumagoles)) %>% as.data.frame())[1:96,]

#Cambiar el nombre de las columnas
str(prom)
colnames(prom) <- c("date", "mean")
str(prom)

#Cambiar las fechas de "mm/aaaa" a "dd/mm/aaaa" para que R reconozca las fechas como valores númericos y se pueda graficar correctamente
#Se utilizo el primer día del mes en todos los meses
prom$date <- as.Date(paste(prom$date,"-01",sep=""), format = "%Y-%m-%d")

#Crear la gráfica de la serie de tiempo
p<-prom  %>%
  ggplot() +
  aes(x=date, y=mean, text = paste('Goles Promedio: ', mean,
                                   '<br>Fecha:', format(date,"%Y-%m")),group=1)+
  geom_line(color="aquamarine4") +
  geom_point(shape=21, color="aquamarine4", fill="aquamarine3", size=2, alpha=0.7)+
  xlab("Mes")+
  ylab("Gooles Promedio")+
  ggtitle("Promedio mensual de gooles desde 2010-08 hasta 2019-12")

#Utilizar "plotly" para poder interactuar con las gráfica
ggplotly(p, tooltip = "text")

#Guardar la gráfica de la serie de tiempo como un archivo png
ggsave("ts.png",width = 10, height = 5)