#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
dataset <- readRDS("./Data/temp_data.rds")
dataset = dataset[c(1,3,4,2)]
dataset = dataset[complete.cases(dataset),]


newRisk <- function(mean_sbp, mean_dbp) {
  
  difference = mean_sbp - 130
  risk_rate = 1 + 0.05*(difference/10)
  
  difference = mean_dbp - 80
  risk_rate = risk_rate + 0.04*(difference/5)
  
  return(risk_rate)}




library(shiny)
shinyServer(
    function(input, output) {
      
      pop = nrow(dataset)
      
      popint1 <- reactive({round(input$pop1 * 0.01 * pop)})
      popint2 <- reactive({round(input$pop1 * 0.01 * pop)})
      popint3 <- reactive({round(input$pop1 * 0.01 * pop)})
      
      tryint <- round(33 * 0.01 * pop)
      
      sbp1M <- reactive({input$risk1sbpM})
      sbp1S <- reactive({input$risk1sbpS})
      dbp1M <- reactive({input$risk1dbpM})
      dbp1S <- reactive({input$risk1dbpS})
      
      sbp2M <- reactive({input$risk2sbpM})
      sbp2S <- reactive({input$risk2sbpS})
      dbp2M <- reactive({input$risk2dbpM})
      dbp2S <- reactive({input$risk2dbpS})
      
      sbp3M <- reactive({input$risk1sbpM})
      sbp3S <- reactive({input$risk1sbpS})
      dbp3M <- reactive({input$risk1dbpM})
      dbp3S <- reactive({input$risk1dbpS})
      
      summary_func <- function(df){
        df %>%
          group_by(age_group) %>%
          summarise(original_cvd_count = sum(as.numeric(s723d)),
                    meanSBP = mean(sb16s, na.rm = T),
                    meanDBP = mean(sb16d, na.rm = T)) %>%
          mutate(new_cvd_count = newRisk(meanSBP, meanDBP) * original_cvd_count)
      }
      
      seed = 0
      env <- reactive({
        
      set.seed(0)
      req(dataset)
      dataset[sample(nrow(dataset), popint1()), 'sb16s'] <- dataset[sample(nrow(dataset), popint1()), 'sb16s'] + rnorm(popint1(), mean = sbp1M(),sd = sbp1S())
      dataset[sample(nrow(dataset), popint1()), 'sb16d'] <- dataset[sample(nrow(dataset), popint1()), 'sb16d'] + rnorm(popint1(), mean = dbp1M(),sd = dbp1S())
      
      set.seed(1)
      dataset[sample(nrow(dataset), popint2()), 'sb16s'] <- dataset[sample(nrow(dataset), popint2()), 'sb16s'] + rnorm(popint2(), mean = sbp2M(),sd = sbp2S())
      dataset[sample(nrow(dataset), popint2()), 'sb16d'] <- dataset[sample(nrow(dataset), popint2()), 'sb16d'] + rnorm(popint2(), mean = dbp2M(),sd = dbp2S())
      
      set.seed(2)
      dataset[sample(nrow(dataset), popint3()), 'sb16s'] <- dataset[sample(nrow(dataset), popint3()), 'sb16s'] + rnorm(popint3(), mean = sbp3M(),sd = sbp3S())
      dataset[sample(nrow(dataset), popint3()), 'sb16d'] <- dataset[sample(nrow(dataset), popint3()), 'sb16d'] + rnorm(popint3(), mean = dbp3M(),sd = dbp3S())
      return(dataset)
      })

      
      int3_summary<- reactive({
        env() %>%
          summary_func
      })
      
      #env <- reactive({
      #  riskVals = newRisk(int3_summary()$meanSBP, int3_summary()$meanDBP)
      #  int3_summary()$new_cvd_count = round(riskVals * int3_summary()$original_cvd_count)
      #})



      
      output$totalcost = renderPrint(popint1()*as.numeric(input$cost1)+popint2()*as.numeric(input$cost2)+popint3()*as.numeric(input$cost3))
      output$riskred = renderPrint(round(sum(int3_summary()$original_cvd_count) - sum(int3_summary()$new_cvd_count)))
      
      output$summary2 =  renderTable({int3_summary()})
        })
  
