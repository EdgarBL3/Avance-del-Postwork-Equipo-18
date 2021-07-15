library(shiny) #libreria para hacer dashboards
library(dplyr)
library(ggplot2)

ui <- fluidPage(
    headerPanel("Postwork 8"), #Agregamos el panel para poder tener pestañas
    mainPanel( 
        tabsetPanel(
            tabPanel("Plots", #Agregamos el selector para goles de casa o visitante
                     p("\n"),
                    selectInput("x", "Seleccione el valor de X", choices = c("Goles Local","Goles Visitante")),
                    h3(textOutput("output_text")), 
                     plotOutput("output_plot"), #Espacio donde se va a mostrar la grafica
            ),
            tabPanel("Distribuciones de los goles", #Pestaña donde mostraremos lo hecho en el postwork 3
                p("\n"),
                h4("FTHG"),
                img( src = "FTHG.png", height = 600, width = 1200),#Distribucion del numero de goles de casa
                h4("FTAG"),
                img( src = "FTAG.png", height = 600, width = 1200),#Distribucion del numero de goles de visitante
                h4("Heatmap"),
                img( src = "Heatmap.png", height = 840, width = 1200)),#Distribucion de probabilidad conjunta
            
            tabPanel("Data Table", #Panel donde se mostrara la tabla de datos
                     p("\n"),
                     dataTableOutput("data_table")),
            
            tabPanel("Momios", #Se muestran los escenarios maximo y promedio de los momios
                p("\n"),
                h5("Escenario con momios máximos"),
                img( src = "Img1.jpeg", height = 600, width = 1000),
                h5("Escenario con momios promedio"),
                img( src = "Img2.jpeg", height = 600, width = 1000)
            )
        )
    )
)

server <- function(input, output) {
    datos <- read.csv("match.data.csv")

    output$output_text <- renderText(input$x)
    
    
  
    output$output_plot <- renderPlot({
      #Agregamos la columna FTR usando el ifelse
        datos<-datos %>% mutate(FTR=ifelse(home.score > away.score, "H", ifelse(home.score < away.score,"A","D")))
        #Dependiendo de la opcion que seleccione el usuario, seleccionamos el valor para la x
        #Lo hiciomos de esta forma con un if, para que en las opciones apareciera bonito el nombre
        if(input$x=="Goles Local"){
            x<-datos$home.score
        }else{
            x<-datos$away.score
        }
        #graficamos haciendo facet wrap con el equipo visitante
        datos %>% ggplot(aes(x=x,fill=FTR))+
            geom_bar()+
            facet_wrap("away.team")+
            labs(x=input$x,y = "Frecuencia")
    }, width = 1000,
    height = 1000)
    
    
    output$data_table <- renderDataTable({datos}, 
                                         options = list(aLengthMenu = c(5,25,50),
                                                        iDisplayLength = 5))
}

shinyApp(ui = ui, server = server)
