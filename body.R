## GET STARTED ----------------------------------------------------------------------
source('introduction/intro.R', local=TRUE)

start <- tabItem(
  tabName = "start",
  start.box
)

## DEALS  --------------------------------------------------------------------------
source('deals/ui.R', local=TRUE)

deals <- tabItem(
  tabName = "deals",
  deals.box
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
    deals,
    acknowledgements
  )
)
