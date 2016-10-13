## Load data
install.packages("dplyr")
library(dplyr)
install.packages("hflights")
library(hflights)
data(hflights)
head(hflights)
str(hflights)

## Convert to data frame
flights <- tbl_df(hflights)
flights
data.frame(head(flights))

## filter: keep rows matching creteria
filter(flights, Month == 1, DayofMonth == 1)
filter(flights, Year == 2011)
filter(flights, UniqueCarrier == "AA" | UniqueCarrier == "UA")

# select: pick columns by names
select(flights, UniqueCarrier, FlightNum, TailNum)
select(flights, Year:DayOfWeek, contains("Dep"), contains("Arr"))
# use colon to select multiple contiguous columns, and use `contains` to match columns by name
# "chaining" and "pipelining" methods
filter(select(flights, Year:DayOfWeek, FlightNum, TailNum, AirTime), AirTime > 60)
flights %>%
  select(Year:DayOfWeek, FlightNum, TailNum, AirTime) %>%
  filter(AirTime > 60)

## arrange: reorder rows
flights %>%
  select(UniqueCarrier, DepDelay) %>%
  arrange(DepDelay)
dat <- flights %>%
  select(Year:DayOfWeek, FlightNum, TailNum, DepDelay, ArrDelay) %>%
  filter(DepDelay > 0, ArrDelay >0) %>%
  arrange(DepDelay, ArrDelay)

## mutate: add new variables
flights %>%
  select(Distance, AirTime) %>%
  mutate(Speed = Distance/AirTime*60)
flights <- flights %>% mutate(Speed = Distance/AirTime*60)

## summarise: reduce variables to values by group_by and summarise
flights %>%
  group_by(Dest) %>%
  summarise(avg_delay = mean(ArrDelay, na.rm = T))
flights1 <- flights %>% group_by(Dest) %>% summarise(avg_delay = mean(ArrDelay, na.rm = T))

# calculate average delay time of arrival and depart group by UniqueCarrier
flights2 <- flights %>% group_by(UniqueCarrier) %>% summarise(avg_ArrDelay = mean(ArrDelay, na.rm = T), avg_DepDelay = mean(DepDelay, na.rm = T))
flights3 <- flights %>% group_by(UniqueCarrier) %>% summarise_each(funs(mean(., na.rm = T)), avg_ArrDelay = ArrDelay, avg_DepDelay = DepDelay)

# calculate min and max arrival and departure delays of each UniqueCarrier
flights4 <- flights %>% group_by(UniqueCarrier) %>% summarise_each(funs(min(., na.rm = T), max(., na.rm = T)), matches("Delay"))

# which day of week has most delay time
flights5 <- flights %>% group_by(DayOfWeek) %>% summarise_each(funs(mean(., na.rm = T)), matches("Delay"))

# which month has most delay time
flights6 <- flights %>% group_by(Month) %>% summarise_each(funs(mean(., na.rm = T)), matches("Delay"))

# function n() counts the number of rows in the group
# functions n_distinct(vector) counts the unique items in that vector
# for each day of the year, counts the total number of flights and sort in descenting order
flights7 <- flights %>% group_by(Month, DayofMonth) %>% summarise(flight_count = n()) %>% arrange(desc(flight_count))

# for each destination, count the number of distinct planes that flew there
flights8 <- flights %>% group_by(Dest) %>% summarise(flight_count = n(), plane_count = n_distinct(TailNum))

# for each destinations, counts the number of cancelled and not cancelled flights
flights9 <- flights %>% group_by(Dest) %>% select(Cancelled) %>% table() %>% head()

# for each carrier, calculate which two days they had the longest departure delays
flights10 <- flights %>% group_by(UniqueCarrier) %>% select(Month, DayofMonth, DepDelay) %>% filter(min_rank(desc(DepDelay)) <= 2) %>% arrange(UniqueCarrier, desc(DepDelay))

# for each month, calculate the number of flights and the change from the precious month
flights11 <- flights %>% group_by(Month) %>% summarise(flight_count = n()) %>% mutate(change = flight_count - lag(flight_count))
