## GET STARTED ----------------------------------------------------------------------
source('introduction/intro.R', local=TRUE)

start <- tabItem(
  tabName = "start",
  start.box
)

## UPLOAD ----------------------------------------------------------------------
source('fileUpload/ui.R', local=TRUE)

upload <- tabItem(
  tabName = "upload",
  upload.box
  ## fluidRow(
  ##     box(
  ##         plotOutput("plot1", height = 250)),
  ##     box(
  ##         title = "Controls",
  ##         sliderInput("slider", "Number of observations:", 1, 100, 50)
  ##     )
  ## )
)

## CLUSTER ---------------------------------------------------------------------
source('clustering/ui.R', local=TRUE)

cluster <- tabItem(
  tabName = "cluster",
  cluster.box
)

## RANKING ---------------------------------------------------------------------
source('ranking/ui.R', local=TRUE)

ranking <- tabItem(
  tabName = "ranking",
  ranking.box
)


## ACKNOWLEDGEMENTS ------------------------------------------------------------
source('acknowledgements/acknowledgements.R', local=TRUE)

acknowledgements <- tabItem(
  tabName = "acknowledgements",
  ack.box
)

## BODY ------------------------------------------------------------------------
body <- dashboardBody(
  includeCSS("www/custom.css"),
  tabItems(
    start,
    upload,
    cluster,
    ranking,
    acknowledgements
  )
)
