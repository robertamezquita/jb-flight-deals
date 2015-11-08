# Objective
*JetBlue Flight Deals* (_JFD_) provides an intuitive viewer powered by efficacious algorithms to surface the best deals in an infinitely scrollable fashion that are relevant to your preferences. 

## The _JFD_ Stack
_JFD_ is powered by the `R` statistical language, utilizing the [R Shiny](http://shiny.rstudio.com) and [R Shiny dashboard](http://rstudio.github.io/shinydashboard/) framework developed by _RStudio_ to create an interactive, modular, fast, platform agnostic web application. Prototyping is made simple thanks to the speed of development in `R`, and the ability to use and distribute powerful statistical analyses packages on the central `R` repository, `CRAN`, enable `R` to do even more than just stats, with an infinitely scrollable table powered by the Javascript library [DataTables](http://datatables.net).

## The Dataset
*Jet Blue* provided a sample dataset consisting of their available flight offerings running from October 26, 2015 thru February 29, 2016. Each flight consists of the following information:

* Origin, Destination : three-letter airport codes
* Flight Time : consists of departure date and time
* FareType : "POINTS" and "LOWEST" designated the type of fare described subsequently
* DollarFare, DollarTax or PointsFare, PointsTax : the cost of the given flight
* Flight Type : in this sample dataset, the only type available was "NONSTOP" 
* isDomesticRoute, isPrivateFare : domestic and private flight designations

Additionally, a database of annotation corresponding to each airport was made available. Each airport is annotated with the following information:

* MarketGroupName, MarketGroupId : local market group that airport belongs to, whose values include the following: "Mountain/Desert | Northeast | Caribbean | SouthSW | California | Mid-Atlantic"
* GeographicRegionName, GeographicRegionId : a finer version of market, identifies the local geographic region/id that airport belongs to, whose values include the following: ANC | BOS Area | Colombia | Desert West | DR | FLL | Gulf | LA Area | MCO | MidWest | Mtn West | NE Islands | NYC | Other Carrib | Pac NW | PBI | PR | SF Bay | Texas | The South | Upstate | WAS
* DestinationTypeName : the getaway type, which includes: "Family | Nightlife | Exploration | Romance | Beach"

In this dataset, only nonstop, outbound flights were considered, however, all the methods below could be easily extended to account for inbound (return) flights - while multiple stops would require a not inconsequential effort to implement, this would certainly be an avenue worth pursuing for future development.

## The Algorithm
The method behind the flight ranking takes into account a variety and multiples of inputs and their relative importance to one another, ranging from getaway types, specific or regional origin and destination sites and consideration of airports nearby, budget, and desired dates of travel. Our approach provides an infinitely scrollable list of options - but the secret sauce is in taking into account this multitude of potential preferences and weighing them against one another to surface the best possible flights.

### Logistic Scaling of Fuzzy Matches
Our approach looks for exact matches when possible (as in the case of getaway type, region, airport codes), but there are cases where we need to consider the "fuzzy" matches, and how to weight these. For example, let's say we specify that we would like to fly between June 5th and June 10th. If we simply used a binary encoding, we would miss out on a potentially great deal on June 11th or June 4th. However, we don't really care to see anything on May 25th, no matter how good of a deal - that simply would be too far from our desired weights. Similarly, given a budget of $200, we would hate to miss out on a $225 flight that fits all the rest of our preferences! 

To address this "close but not quite" problem, we implemented a logistic scaling function to allow for close matches in preferred dates and budgets. This logistic scaling function rapidly decays as it goes outside of the given boundaries - as in the case of preferred dates. For a given budget, this is modified slightly, such that for a cost that exceeds budget, the penalty grows slowly, but then rapidly increases as cost exceeds the budget by $50 to $100. Conversely, as cost goes below a given budget, at first it is of slow benefit, but then rapidly gets "rewarded" the lower the cost goes, representing a steal of a deal.

### Order Importance Scaling
An additional factor to consider is when inputting multiple options, one needs to consider whether they are _unordered_ (of equal importance) or _ordered_ (ranked from high to low importance). Here, we have taken into account the order by which certain options, such as getaway type or to/from departure info (which could be specific airport codes or geographic regions).

To account for ordering of such preferences, we applied an order importance function which weights the first to last preferences of a given field (such as to _or_ from _or_ getaways) from high to low importance. To do this, we add together a uniform and exponential distribution, each scaled by (1 -) parameter `Order Importance` (`OI`). This parameter, filed under `Advanced Options`, determines whether the preferences should be treated as unordered (`OI = 0`) thus resembling the uniform distribution, or exponential (`OI = 1`), where the first preferences are highly weighted and lower preferences are heavily penalized. By default, `OI` is set to `0.7`, to allow for a moderate weighting of higher preferences, and thus is represented by a mixture of exponential (`70%`, with a rate of `3`) and uniform (`30%`) distributions.

### Nearby?
Sometimes, your favorite airport might not be the best place to go for the best flight deals - for example, from New Haven, it is equally easy (or difficult) to navigate to either *BDL* or *JFK* or *LGA*. To address this, we have added an option to include nearby airports, leveraging the local geographic region each airport is classified under to cluster them together.

### Preference Importance - Coefficients
For cases where some preferences may be more important than others, the `Coefficients` under `Advanced Options` allows for the ultimate tweaking of our algorithm. For cases where the departure date is an absolute must, and everything else is secondary, the user can tweak up the coefficient for `Depart Date`, or if budget is of no concern, this can be set to `0`.

### Infinitely Scrollable & Rapidly Updateable
Any good algorithm must provide results post haste, and to that end, our solution provides an infinitely scrollable ranking of pertinent flight results, and rapidly updates upon any tweaks to the settings made therein.

## Happy Deal Hunting!
Thanks for trying our app!

