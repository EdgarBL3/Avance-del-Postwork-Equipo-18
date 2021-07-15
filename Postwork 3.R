# BEDU equipo 18
# Ana Cristina Castillo Escobar
# Edgar Balderas Loranca
# José Alberto Cortes Ayala
# Leandro Marcelo Pantoja Acosta
# Marcos Yáñez Espíndola
# Luis Arturo Rosas León

library(ggplot2)

#Extraer los goles en casa y de visitante de cada equipo
goles<-data %>% select(FTHG,FTAG)

#Creamos una funcion que nos da como salida las probabilidad conjunta 
# y las 2 marginales en una lista como salida
calcular_probabilidades<-function(df){
  probabilidad_conjunta <- table(df)/dim(df)[1]
  probabilidad_conjunta
  
  marginal_FTHG <- apply(probabilidad_conjunta, 1, sum)
  marginal_FTHG
  
  marginal_FTAG <- apply(probabilidad_conjunta, 2, sum)
  marginal_FTAG
  
  probabilidad_conjunta<-as.data.frame(probabilidad_conjunta)
  marginal_FTHG<-as.data.frame(marginal_FTHG)
  marginal_FTHG$goles<-rownames(marginal_FTHG)
  marginal_FTAG<-as.data.frame(marginal_FTAG)
  marginal_FTAG$goles<-rownames(marginal_FTAG)
  return(list(marginal_FTHG,marginal_FTAG, probabilidad_conjunta))
}


probabilidades<-calcular_probabilidades(goles)


#Funcion de probabilidad marginal de que el equipo en casa anote "x" goles
marginal_FTHG<-probabilidades[[1]]
#Funcion de probabilidad marginal de que el equipo visitante anote "y" goles
marginal_FTAG<-probabilidades[[2]]
#Funcion de probabilidad conjunta
probabilidad_conjunta<-probabilidades[[3]]

#Crear un barplot con la probabilidad de que el equipo local anote "x" goles
p<-marginal_FTHG %>%
  ggplot()+
  aes(x=goles,y=marginal_FTHG, fill=goles)+
  geom_bar(stat = "identity", width=0.7, alpha=0.7) +
  theme(legend.position="none")+
  xlab("Número de goles")+
  ylab("Probabilidad")+
  ggtitle("Probabilidad marginal del número de goles que anota el equipo de casa")
ggplotly(p)
#Crear un barplot con la probabilidad de que el equipo visitante anote "y" goles
p<-marginal_FTAG %>%
  ggplot()+
  aes(x=goles,y=marginal_FTAG, fill=goles)+
  geom_bar(stat = "identity", width=0.7, alpha=0.7) +
  theme(legend.position="none")+
  xlab("Número de goles")+
  ylab("Probabilidad")+
  ggtitle("Probabilidad marginal del número de goles que anota el equipo visitante")
ggplotly(p)
#Crear un heatmap con la funcion de probabilidad conjunta
p<-probabilidad_conjunta %>% ggplot()+
  aes(FTHG , FTAG        , fill= Freq)+
  geom_tile()+
  scale_fill_distiller(palette = "RdPu")+
  xlab("Número de goles que anota el equipo de casa")+
  ylab("Número de goles que anota el equipo visitante")+
  labs(fill = "Probabilidad")+
  ggtitle("Probabilidad conjunta del numero de goles que anota el equipo de casa y el equipo visitante")
ggplotly(p)

