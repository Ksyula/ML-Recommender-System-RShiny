# Recommender System
## Project
This is a prototype of Recommender System to recommend loyalty cards to customers.
## How does it work?
Assume the case where customers have some loyalty cards of different brands in their wallets.
Customer 1 has cards of brands **A, B, C, D, E** whereas customer 2 has cards of **A, B, C, D**. Customer 2 is better to consider the possibility of getting the loyalty card of the brand **E** because some other customers have a similar taste on brands. The system will recommend **E** to customer 2 provided that a sufficient number of other customers have already had similar loyalty cards including **E** in their wallets.
## What is under the hood?
To build recommendations the system use **Apriori algorithm for frequent item set mining and association rule learning**.
R code is wrapped into interactive web apps with RShiny.
## Dataset
Dataset for this project is randomly generated relationships between customers and loyalty cards of brands.
## Enjoy the demo
<a href="https://ksenia-l.shinyapps.io/shinydev/">Play with the prototype!</a>

