here("Data", "PVD_2020_Property_Tax_Roll.csv")
here("Data", "PVD_2020_Property_Tax_Roll.csv") %>%
  read.csv ()%>%
  head()
base_read<- here("Data","PVD_2020_Property_Tax_Roll.csv") %>%
  read.csv()

base_read %>%
  str()

tic()
base_read<- here("Data","PVD_2020_Property_Tax_Roll.csv") %>%
  read.csv()
toc()

tic()
tidy_read<- here("Data","PVD_2020_Property_Tax_Roll.csv") %>%
  read_csv()
toc()

tidy_read %>%
  str()

tidy_read_mod <- here("Data", "PVD_2020_Property_Tax_Roll.csv") %>%
  read_csv(col_types = cols(ZIP_POSTAL = col_character(),
                            plat = col_character()))

#This argument made zip_postal and plat read as strings instead of numbers
tidy_read_mod <- here("Data", "PVD_2020_Property_Tax_Roll.csv") %>%
  read_csv(col_types = cols(ZIP_POSTAL = col_character(),
                            plat = col_character()))
#Exercise 1
#This is how you check that  zip_postal and plat are numbers
tidy_read_mod %>%
  str()

#Exercise 2
#attempt 1
#I think the following lines preform the same function
covid_usa <- read_csv ("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv")%>%
  head()

#attempt 2
url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"
covid_usa <- read_csv (url)

#attempt 3 - this works, but i'm not sure which part actually changed url from variable to data
url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"
url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv" %>%
  read_csv () %>%
  head ()
covid_usa <- url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv") %>%
  read_csv()

#Exercise 3
here("Data","BankBranchesData.txt")
here("Data","BankBranchesData.txt") %>%
  read_csv ()%>%
  head ()
bank_branches <- here("Data","BankBranchesData.txt") %>%
  read_csv()


