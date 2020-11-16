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


tidy_read_mod <- here("Data", "PVD_2020_Property_Tax_Roll.csv")%>%
  read_csv(col_types = cols(ZIP_POSTAL = col_character(),
                            plat = col_character()))
tidy_read_mod <- here ("Data","PVD_2020_Property_Tax_Roll.csv") %>%
  read_csv()

tidy_read_mod %>%
  str()
