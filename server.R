server <- function(input, output, session) {
  ## UPLOAD --------------------------------------------------------------------
  source("fileUpload/server.R", local=TRUE)

  ## CLUSTER --------------------------------------------------------------------
  source("clustering/server.R", local=TRUE)

  ## RANKING --------------------------------------------------------------------
  source("ranking/server.R", local=TRUE)
}

