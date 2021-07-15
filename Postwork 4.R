# BEDU equipo 18
# Ana Cristina Castillo Escobar
# Edgar Balderas Loranca
# José Alberto Cortes Ayala
# Leandro Marcelo Pantoja Acosta
# Marcos Yáñez Espíndola
# Luis Arturo Rosas León

library(rsample) #Libreria para hacer bootstraping

#Obtenemos el producto de las marginales, haciendo el cross join
#entre las 2 marginales y hacemos el producto de las probabilidades
#para cada par
producto<-merge(x=marginal_FTHG,y=marginal_FTAG,by=NULL) %>% 
  mutate(producto=marginal_FTHG*marginal_FTAG, FTHG=goles.x,FTAG=goles.y) %>% 
  select(FTHG,FTAG,producto)

#Hacemos un join con el dataframe de probabilidad conjunta y producto
#Asi, para cada renglon donde coincida el numero de goles de visita y 
#Tambien coincida el numero de goles de casa hara el cociente
#Si este cociente es cercano a 1 para todos los renglones
#diremos que las variables son independientes
cocientes<-merge(x=producto,y=probabilidad_conjunta, by=c("FTHG","FTAG")) %>% 
  mutate(cociente=Freq/producto) %>% 
  select(FTHG,FTAG,cociente)
cocientes
#En este caso concluimos que no son independientes, ya que hay
#muchos casos en donde no se cumple que el cociente sea cercano a 1,
#aproximadamente la mitad de ellos el cociente es muy lejano a 1
#en algunos casos es demasiado lejano como por ejemplo 3.45 o 4.71
#ademas tenemos muchos, donde este vale 0.


#Generamos 100 muestras usando bootstraping
goles_boot <- bootstraps(goles, times = 100)
cocientes<-NULL

#Para cada una de esas muestras obtenemos sus coeficientes y los almacenamos 
#en un dataframe, para asi obtener la distribucion de los cocientes
for(i in goles_boot$splits){
  probabilidades<-calcular_probabilidades(as.data.frame(i))
  marginal_FTHG<-probabilidades[[1]]
  marginal_FTAG<-probabilidades[[2]]
  probabilidad_conjunta<-probabilidades[[3]]
  producto<-merge(x=marginal_FTHG,y=marginal_FTAG,by=NULL) %>% 
    mutate(producto=marginal_FTHG*marginal_FTAG, FTHG=goles.x,FTAG=goles.y) %>% 
    select(FTHG,FTAG,producto)
  cocientes_muestra<-merge(x=producto,y=probabilidad_conjunta, by=c("FTHG","FTAG")) %>% 
    mutate(cociente=Freq/producto) %>% 
    select(cociente)
  cocientes<-rbind(cocientes,cocientes_muestra)
}

#Hacemos el histograma de los cocientes con bins de ancho 0.5 para tener 
#una idea de la distribucion
p<-cocientes %>% ggplot()+
  aes(x=cociente,y=..density..)+
  geom_histogram(binwidth = 0.5, fill="darkorange1", col="Black", alpha=0.7)+
  xlab("Cociente")+
  ylab("Probabilidad")+
  ggtitle("Distribucion de los cocientes")
ggplotly(p)

#Observamos que la mayoria de estos cocientes son 0, ademas observamos que
#de ahi la siguiente moda es 1 o muy cercano a este, sin embargo como
#tenemos gran cantidad de cocientes muy diferentes de 1 consideraremos
#que las variables no son independientes
