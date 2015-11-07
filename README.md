jb-flight-deals
===============

# Get Started
Use the online version (available soon) of SparseData's JetBlue Deal Finder.

# Details

## The challenge
> Hack #2 (provided by JetBlue's IT team): JetBlue software often requires iteration and parsing of huge data sets in order to make complex data consumable by rich client user interfaces.  For our second challenge we invite the hackers to build a highly performant infinite scrolling “Flight Deals” interface for either web or native mobile using the Deals data CSVs provided.  In addition to the rich, performant scroller,  hackers must derive an algorithm to prioritize and display the data based on which Deals apply to the mock users referenced below.  The algorithm for determining what qualifies as a “Deal” should evaluate a combination of user’s distance to destination, user setting’s preferences and ticket pricing. In order to view the data per user, the interface must provide some means of switching between users and updating the list in the scroller. Hacks will be judged on the speed of data processing, performance of the scroller and the creativity of the UX for infinite scrolling user interface.

A further description of the prizes can be found [here](https://drive.google.com/file/d/0B-ddf2SdUe0Fb2ZZNDVwOVJVTVE/view).

## The solution

Our solution harnesses [Shiny](http://shiny.rstudio.com) and [Shiny dashboard](http://rstudio.github.io/shinydashboard/) to create a website that responds to user preferences and updates flight deals accordingly.  Our scrolling through 100,000+ fares is handles by the Javascript library [DataTables](http://datatables.net).

# Acknowledgements
Stefan Avey and Rob Amezquita contructed this app during YHack2015.
