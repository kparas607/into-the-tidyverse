library(tidyr)
library(dplyr)


#PIVOT LONGER
billboard %>%
  slice(1:10)

billboard%>%
  pivot_longer(cols=starts_with("wk"),
               names_to="week",
               values_to="ranking")%>%
  drop_na()%>%
  group_by(track)%>%
  slice(1:5)%>%
  ungroup()%>%
  slice(1:30)

#what it would look like if you didn't drop missing data
billboard %>%
  filter(artist == "2Ge+her") %>%
  pivot_longer(cols = starts_with("wk"),
               names_to = "week",
               values_to = "ranking")

#PIVOT WIDER
us_rent_income
us_rent_income%>%
  pivot_wider(names_from = "variable", values_from = c("estimate", "moe"))

#And now that we have our data in this tidy format, we can easily manipulate it using our dplyr tools. This analysis shows that the cheapest places to live in the US are all in the Midwest.
us_rent_income%>%
  pivot_wider(names_from = "variable", values_from = c("estimate", "moe"))%>%
  select(locale = NAME, estimate_income, estimate_rent) %>%
  group_by(locale) %>%
  summarise(p_income_spent_on_rent = 12*estimate_rent / estimate_income) %>%
  arrange(p_income_spent_on_rent)

#SEPARATE
library (readr)
library (here)
here ("Data", "JustCon5_TPP_Order1.csv")
conformity <- here ("Data", "JustCon5_TPP_Order1.csv")%>%
  read_csv() %>%
  select(sub_id = mTurkCode,
         starts_with("assault"),
         starts_with("theft")) %>%
  # Don't worry about this for the time being
  slice(-1) %>%
  type_convert()

conformity


#let's tidy the data
conformity %>%
  # A neat trick: the cols specification tells tidyr to pivot everything *except* for sub_id
  pivot_longer(cols = -sub_id,
               names_to = "condition",
               values_to = "rating")
#separating information that's bunched together in a cell
conformity %>%
  pivot_longer(cols = -sub_id,
               names_to = "condition",
               values_to = "rating") %>%
  separate(col = condition,
           into = c("crime_type", "crime_severity", "n_endorsing_punishment",
                    "repetition_number", "qualtrics_junk")) %>%
  select(-qualtrics_junk)


#UNITE
##Sometimes, you want to smoosh different columns together. To illustrate, let’s pull up a dataset we looked at last time: county-level presidential election returns. To refresh our memory of what it looks like, let’s take a look now.
elections <- here("Data", "countypres_2000-2016.csv") %>%
  read_csv() %>%
  select(year, county, state, candidate, party, candidatevotes, totalvotes)

elections

elections %>%
  unite(col = "location",
        county, state)
#if you want it joined by comma instead of underscore
elections %>%
  unite(col = "location",
        county, state,
        sep = ", ")
#JANITOR
banks <- here("Data", "BankBranchesData.txt") %>%
  read_tsv()

banks

library (janitor)

banks%>%
  clean_names


#example of really ugly variable names
candy <- here("Data", "candyhierarchy2017.csv") %>%
  read_csv()
candy%>%
  clean_names()


#EXERCISE 1
candy <- here("Data", "candyhierarchy2017.csv") %>%
  read_csv()

candy%>%
  clean_names()%>%
  slice(1:10)


pivot_longer(cols = q6,
             names_to= "candy",
             values_to = "ranking")%>%
  drop_na()%>%
  group_by(candy)%>%
  slice(1:10)%>%
  ungroup()%>%
  slice (1:30)


#attempt 2
library(here)
here("Data", "candyhierarchy2017.csv")

candy <- here("Data", "candyhierarchy2017.csv") %>%
  read_csv()

candy%>%
  clean_names()%>%
  slice(1:10)

candy%>%
  pivot_longer(cols = starts_with ("Q6"),
               names_to = )


