#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

textInputRow<-function (inputId, label, value = "") 
{
    div(style="display:inline-block",
        tags$label(label, `for` = inputId), 
        tags$input(id = inputId, type = "text", value = value,class="input-small"))
}

shinyUI(pageWithSidebar(
    headerPanel("Intervention strategies"),
    sidebarPanel(
        #numericInput('id1', 'Number of strategies to implement:', 0, min = 0, max = 10, step= 1),
        h6('No. of strategies currently locked at 3'),
        br(),
        h5('Strategy 1'),
        numericInput('cost1',    'Cost per person      ', 0.0),
        numericInput('risk1sbpM', 'SBP change (mean)     ', 0.0),
        numericInput('risk1sbpS', 'SBP change (std. dev.)', 0.0),
        numericInput('risk1dbpM', 'DBP change (mean)            ', 0.0),
        numericInput('risk1dbpS', 'DBP change (std. dev.)       ', 0.0),
        numericInput('pop1',     '% population affected', 33.33),
        br(),
        h5('Strategy 2'),
        numericInput('cost2',    'Cost per person      ', 0.0),
        numericInput('risk2sbpM', 'SBP change (mean)            ', 0.0),
        numericInput('risk2sbpS', 'SBP change (std. dev.)       ', 0.0),
        numericInput('risk2dbpM', 'DBP change (mean)            ', 0.0),
        numericInput('risk2dbpS', 'DBP change (std. dev.)       ', 0.0),
        numericInput('pop2',     '% population affected', 33.33),
        br(),
        h5('Strategy 3'),
        numericInput('cost3',    'Cost per person      ', 0.0),
        numericInput('risk3sbpM', 'SBP change (mean)                  ', 0.0),
        numericInput('risk3sbpS', 'SBP change (std. dev.)             ', 0.0),
        numericInput('risk3dbpM', 'DBP change (mean)                  ', 0.0),
        numericInput('risk3dbpS', 'DBP change (std. dev.)             ', 0.0),
        numericInput('pop3',     '% population affected', 33.33),
    ),
    mainPanel(
        h3('Results'),
        h4('Total cost:'),
        verbatimTextOutput("totalcost"),
        h4('Total cases reduction:'),
        verbatimTextOutput("riskred"),
        h4("Summary of intervention results:"),
        tableOutput("summary2")
    ) ))
