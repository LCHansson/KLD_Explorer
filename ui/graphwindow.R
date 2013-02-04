tabsetPanel(
  tabPanel("Start", verbatimTextOutput("frontpage"))
  ,tabPanel("Tidsserier", plotOutput("timeseries_plot", height="400px"))
  ,tabPanel("Tvåvägsplot", plotOutput("twoway_plot", height="500px"))
  ,tabPanel("Kartplot", plotOutput("map_plot", height="800px"))
  #       ,tabPanel("")
  #       ,tabPanel("Utveckling", h3(verbatimTextOutput("devcaption")), verbatimTextOutput("development"))
  #       ,tabPanel("Session info", verbatimTextOutput("sessioninfo"))
  ,id="tab"
)