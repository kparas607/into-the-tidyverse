#load libraries 
library (here)
library (readr)
library (janitor)
library (dplyr)
library (tidyr)

here ("Documents","Practicum_data", "AL_psysciDat_osf.csv") %>%
  read_csv ()%>%
  slice (1:30)





