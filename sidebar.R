## SIDEBAR

sidebar <- dashboardSidebar(
  sidebarMenu(
        menuItem(
            "Get Started",
            tabName = "start",
            icon = icon("play")
        ),
        menuItem(
            "Find Deals",
            tabName = "deals",
            icon = icon("plane")
        ),
        ## menuItem(
        ##     "Cluster",
        ##     tabName = "cluster",
        ##     icon = icon("sitemap")
        ## ),
        ## menuItem(
        ##     "Rank",
        ##     tabName = "ranking",
        ##     icon = icon("bars")
        ## ),
        menuItem(
            "Acknowledgements",
            tabName = "acknowledgements",
            icon = icon("trophy")
        )
    )
)
