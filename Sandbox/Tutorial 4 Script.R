#Functions and variables
##trying different ways to find the mean
mean(c(2,6))

x <- c(2,6)
xm <- mean(x)
c(xm, mean (x))

x <- c(2,6)
c(xm)

##creating a custom function to understand the mean
custom_mean <- function(this_vector){
  sum(this_vector)/length(this_vector)
}
custom_mean(c(2,6))

my_vector <- c(2,6)
custom_mean(my_vector)

#Libraries
library(here)
library(readr)
library(dplyr)

##Dplyr
#filter: keep only some rows/observations
#select: keep only some columns/variables
#mutate: add a new column/variable
#summarise: reduce your dataset to a summarized version of a particular column/variable
#arrange: reorder your rows/observations
#group_by: perform operations based on some grouping of your data
#join: “merge” multiple dataframes together

#Reading in Data
##In the Data folder, there is a datafile called time_series_covid19_confirmed_US.csv. Using here and readr, load that data and assign it to a variable named covid

here ("Data", "time_series_covid19_confirmed_US.csv")
here ("Data", "time_series_covid19_confirmed_US.csv") %>%
  read_csv


covid <- here ("Data", "time_series_covid19_confirmed_US.csv") %>%
  read_csv ()

##Let’s take a quick look at this dataset. The dplyr::slice function returns only the first few rows so that you don’t have to scroll through thousands of observations.
covid%>%
slice (1:10)

#FILTER
covid %>%
  filter(Province_State == "California") %>%
  select(fips = FIPS, county = Admin2, `9/18/20`:`9/24/20`)

##dplyr:filter keeps only the observations that return TRUE when you test a particular logical condition. So let’s say that we’re only interested in counties where there were at least 1,000 cases on 9/14/20. How would we implement this?
covid%>%
  filter(Province_State == "California")%>%
  select(fips = FIPS, county = Admin2, `9/18/20`:`9/24/20`)%>%
  filter(`9/24/20`>= 1000)


#==: exactly equal to
#!=: not equal to
#>: greater than
#>=: at least (greater than or equal to)
#<: less than
#<=: at most (less than or equal to)

#SELECT
covid%>%
  filter (Province_State == "California")%>%
  filter (Admin2 == "Yolo")%>%
  select(FIPS, Admin2, `9/18/20`:`9/24/20`)

#this is why you need backticks ````
covid %>%
  filter(Province_State == "California") %>%
  filter(Admin2 == "Yolo") %>%
  select(FIPS, Admin2, 9/18/20:9/24/20)

#How to use dplyr to rename variables
covid%>%
  filter (Province_State == "California")%>%
  filter (Admin2 == "Yolo")%>%
  select(fips = FIPS, county = Admin2, `9/18/20`:`9/24/20`)

#Finally, you can use dplyr::select to get rid of columns you don’t want anymore.
covid %>%
  filter(Province_State == "California") %>%
  filter(Admin2 == "Yolo") %>%
  select(state = Province_State, fips = FIPS, county = Admin2, latest_cases = `9/24/20`) %>%
  # Actually, we've changed our mind, we don't want the state variable anymore
  # Get rid of it using the minus sign
  select(-state)

#MUTATE
##One of the standard assumptions of linear models (e.g., statistical tests like t-tests, correlations, and regressions) is that your data come from a normal distribution. 
##However, count data (e.g., the number of covid19 cases) are almost never normally distributed.
##A common solution to this is to apply some sort of transformation to the counts before analyzing them, like taking the logarithm or square root.
covid%>%
  filter (Province_State == "California")%>%
  slice(1:20)%>%
  select(fips = FIPS, county = Admin2, latest_cases = `9/24/20`) %>%
  mutate(latest_cases_log = log(latest_cases))

##For example, we can replace latest_cases with a version that contains log-transformed counts.
##So, be careful about using dplyr::mutate, as it can lead to overwriting data if you reuse an existing variable name!
##i.e. if you wrote mutate(fips = log(latest_cases)) then it would overrite all of the fips codes and replace it with the new logs you created
covid%>%
  filter (Province_State == "California")%>%
  slice(1:20)%>%
  select(fips = FIPS, county = Admin2, latest_cases = `9/24/20`) %>%
  mutate(latest_cases = log(latest_cases))

##You should also know that you can also create a column containing a single value for every single one of those observations.
##For the sake of demonstration, let’s pretend that the covid19 counts are stored in different CSV files according to what state they come from. 
##After opening up the California counts, we would then want to create a column indicating that these particular data come from California. How would we do this?
covid%>%
  filter (Province_State == "California")%>%
  slice(1:5)%>%
  select(fips=FIPS, county=Admin2, latest_cases=`9/24/20`)%>%
  mutate(state="California")

##Finally, you might be interesting in applying the same function to multiple columns. For example, you might be interested in applying a log transformation not just to the covid19 counts on 9/24/20, but for that entire week. We could do that using a function called dplyr::across. This function takes two arguments: one specifying which columns you want to mutate, and another specifying what you want to do with those columns.
covid %>%
  select(state = Province_State, county = Admin2, `9/18/20`:`9/24/20`) %>%
  filter(state == "California") %>%
  slice(1:10) %>%
  mutate(across(.cols = `9/18/20`:`9/24/20`,
                .fns = ~log(.x + 1)))

##~log(.x+1) is a lambda function

# Our custom function. Note its similarity with the lambda function we used earlier!
avoid_log_trap <- function(x) {
  log(x + 1)
}

covid %>%
  select(state = Province_State, county = Admin2, `9/18/20`:`9/24/20`) %>%
  filter(state == "California") %>%
  slice(1:10) %>%
  mutate(across(.cols = `9/18/20`:`9/24/20`,
                # Everything is the same up to this point
                # Now we replace the lambda function with our custom function
                .fns = avoid_log_trap))

#SUMMARIZE
##So for example, we might be interested in knowing the total number of confirmed covid19 cases on a particular day. How would we compute that?
covid%>%
  filter(Province_State == "California")%>%
  select(fips = FIPS, county = Admin2, latest_cases = `9/24/20`) %>%
  summarize(total_cases=sum(latest_cases))
  
##what about across all of California?
covid%>%
  filter(Province_State == "California")%>%
  select(fips = FIPS, county = Admin2,`9/18/20`:`9/24/20`) %>%
  summarize(across(.cols = `9/18/20`:`9/24/20`,
                   .fns = sum))
#ARRANGE
##It is oftentimes useful to reorder your observations. You can do this easily using dplyr::arrange. For example, we might want to reorder our dataframe according to the number of covid19 cases.
covid%>%
  filter (Province_State == "California")%>%
  slice(1:7)%>%
  select (fips=FIPS, county=Admin2, latest_cases = `9/24/20`)%>%
  arrange(latest_cases)
            
##Similarly, we could arrange the dataframe according to county names. Just for demonstration, we’ll do it in reverse alphabetical order using the function desc.
covid%>%
  filter (Province_State == "California")%>%
  slice(1:7)%>%
  select (fips=FIPS, county=Admin2, latest_cases = `9/24/20`)%>%
  arrange(desc(county))            
            
 
#GROUP BY
##For example, in our original covid dataframe, we have data for every county in every state in the US. We could be interested in summarizing the total number of covid19 cases at the state level, which requires grouping together observations from counties that belong to the same state.
covid%>%
  rename (state=Province_State, latest_cases = `9/24/20`)%>%
  group_by(state)%>%
  summarize(n_cases=sum(latest_cases))%>%
  # When you're done manipulating grouped data, remember to ungroup!
  # Otherwise, you may get unexpected (and hard-to-diagnose) problems later on.
  ungroup()%>%
  arrange(desc(n_cases))
            



#JOIN
#joining together different data to explain why we see different covid rates
urbanicity <- here("Data", "NCHSURCodes2013.xlsx") %>%
  readxl::read_excel(na = c(".")) %>%
  janitor::clean_names() %>%
  select(fips_code, urbanicity = x2013_code, population = county_2012_pop)

urbanicity %>%
  slice(1:5)


elections <- here("Data", "countypres_2000-2016.csv") %>%
  read_csv() %>%
  filter(year == 2016) %>%
  filter(party %in% c("democrat", "republican")) %>%
  group_by(state, county, FIPS) %>%
  mutate(lean_republican = candidatevotes / first(candidatevotes)) %>%
  ungroup() %>%
  filter(party == "republican") %>%
  select(state, county, FIPS, lean_republican)
            
elections %>%
  slice(1:5)          

##left joining data
# Start with the covid count data
covid %>%
  select(FIPS, county = Admin2, state = Province_State, latest_cases = `9/24/20`) %>%
  filter(state == "California") %>%
  slice(1:10) %>%
  # Join with the election data
  left_join(elections) %>%
  # Join with the population data
  left_join(urbanicity, by=c("FIPS"="fips_code"))

#right joining data
covid %>%
  select(FIPS, county = Admin2, state = Province_State, latest_cases = `9/24/20`) %>%
  filter(state == "California") %>%
  slice(1:10) %>%
  # Join with the election data
  right_join(elections) %>%
  # Restrict to first 20 observations so we don't print 1000s of rows
  slice(1:20)

#what if no data on one side
elections %>%
  filter(state == "Puerto Rico")
covid %>%
  select(FIPS, county = Admin2, state = Province_State, latest_cases = `9/24/20`) %>%
  filter(state %in% c("Puerto Rico", "California")) %>%
  # Note how the combination of group_by and slice results in an output where we keep
  # the first five rows from *both* Puerto Rico and California!
  group_by(state) %>%
  slice(1:5) %>%
  ungroup() %>%
  left_join(elections)

#inner join
covid %>%
  select(FIPS, county = Admin2, state = Province_State, latest_cases = `9/24/20`) %>%
  filter(state %in% c("Puerto Rico", "California")) %>%
  group_by(state) %>%
  slice(1:5) %>%
  ungroup() %>%
  inner_join(elections)

#full join
covid %>%
  select(FIPS, county = Admin2, state = Province_State, latest_cases = `9/24/20`) %>%
  filter(state %in% c("Puerto Rico", "California")) %>%
  group_by(state) %>%
  slice(1:5) %>%
  ungroup() %>%
  # For the purpose of illustration, restricting elections to 5 Alabama counties
  full_join(elections %>%
              filter(state == "Alabama") %>%
              slice(1:5))


#EXERCISES

library(here)
library(readr)
library(dplyr)

incarceration <- here ("Data", "incarceration_trends.csv")%>%
  filter (state=="CA")%>%
  filter (year == "2008")
  
  



  covid %>%
  filter(Province_State == "California") %>%
  select(fips = FIPS, county = Admin2, `9/18/20`:`9/24/20`)












