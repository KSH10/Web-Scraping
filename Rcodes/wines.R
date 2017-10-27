setwd('/Users/Kenneth S. Hansen/Dropbox/NYC Data Science/Projects/Web Scraping - Data/Ready')

#Reading in the scraped files:
#PLEASe notice, that my sites was ONLY able to load maxium 2025 items (infinite scroll page), which is why I was forced to scrape the wines by either country or the price!

####REDWINES######

###FRANCE####
france1 <- read.csv('france0-110.csv', sep=";" , header = TRUE)
View(france1)
str(france1)

france2 <- read.csv('france110+.csv', sep=";" , header = TRUE)
View(france2)
str(france2)

france <- rbind(france1, france2)
str(france)
View(france)

###Italy
italy1 <- read.csv('italy1.csv', sep=";", header = TRUE)
italy2 <- read.csv('italy2.csv', sep=";", header = TRUE)

italy <- rbind(italy1, italy2)
str(italy)

###Austrailia, Austria, Chile Argentina
multiple <- read.csv('multiple.csv', sep=";", header = TRUE)
str(multiple)

###Portugal
portugal <- read.csv('portugal.csv', sep=";", header = TRUE)
str(portugal)

###Spain
spain <- read.csv('spain.csv', sep=";", header = TRUE)
str(spain)

#USA
usa1 <- read.csv('usa1.csv', sep=";", header = TRUE)
usa2 <- read.csv('usa2.csv', sep=";", header = TRUE)
usa3 <- read.csv('usa3.csv', sep=";", header = TRUE)

usa <- rbind(usa1, usa2, usa3)
str(usa)


#Rbinding all the datasets containing REDWINE
redwine <- rbind(italy, france, multiple, portugal, spain, usa)

write.csv(redwine, file='redwine.csv', row.names=FALSE)

str(redwine)
View(redwine)





#####White whine######
whitewine1 <- read.csv('whitewine1.csv', sep=";")
whitewine2 <- read.csv('whitewine2.csv', sep=";")

whitewine <- rbind(whitewine1, whitewine2)
str(whitewine)

#saving the combinded data
write.csv(whitewine, file='whitewine.csv', row.names=FALSE)

whitewine <- read.csv('whitewine.csv', sep=";")


###SPARKLING###
sparkling <- read.csv('sparkling1.csv', sep=";")
View(sparkling)
sum(is.na(sparkling))


##Redwine##
red <- read.csv('redwine1.csv', sep=";")


##ALL wine types
alltypes <- rbind(red, whitewine, sparkling)


View(all)
str(all)



############################DATA MANIPULATION#################################
##### INSPECTION REDWINE FIRST, to get an insight of the data.
sum(is.na(redwine))
summary(redwine)

#Converting name, from factor to character. Enabling me to extract the year from the name.
class(redwine$name)
redwine$name <- as.character(redwine$name)


###Extracting the last four elements, corresponding to the year.
xx = 4
redwine$year <- substr(redwine$name,(nchar(redwine$name)+1)-xx,nchar(redwine$name))

###Extracting the price WITHOUT the $ sign
library(stringi)
redwine$price1 <- stri_sub(redwine$price, 2)
#Converting the new price from character to numeric
class(redwine$price1)
redwine$price1 <- as.numeric(redwine$price1)

class(redwine$rating)


#Saving the data changes, and all the redwines scraped at Viviono into one file.
write.csv(redwine, file='redwinecleaned.csv', row.names=FALSE)

#Reading in redwine
redwine <- read.csv('redwinecleaned.csv', sep=",")

str(redwine)
View(redwine)




###Data Exploration####
##NUMERICAL EDA
summary(redwine)


##Graphical EDA
# check the distributions

##Price1 - Historgram
ggplot(data = redwine, aes(x = price1))+
              geom_histogram(binwidth = 200)

##Changing x-axis to maximum 250
ggplot(data = redwine, aes(x = price1))+
  geom_histogram(bins = 200)+
  coord_cartesian(xlim = c(10, 250))



#LOW END: Variable: Price - HISTOGRAM
lowend <- redwine %>%
  filter(., price1 < 100)

ggplot(data = lowend, aes(x = price1))+
  geom_histogram(binwidth = 5)


##Variable: rating
#ALL
mean(redwine$rating)
hist(redwine$rating)


#ALL redwines
country <- redwine %>%
  group_by(country) %>%
  summarise(Ratings=sum(no), average=mean(rating))


#Average rating TOTAL per TYPE per country
ggplot(data=country, aes(x=country, y=average))+
  geom_bar(stat = "identity")+
  geom_text(aes(label=average))


###Pricerange 0-500
#fra 16690 - 16521
alltypes500 <- alltypes %>%
  filter(., price < 500)

#FACETING
#Price range 0-500$
g <- ggplot(alltypes500, 
            aes(x = price, y = rating))
g + geom_point() + facet_grid(. ~ type)+
  labs(x = "Price $", y = "Rating", title = "Wines",caption = "based on data scraped from Vivino")+
  theme(plot.title = element_text(size=20, 
                                  face="bold",
                                  hjust = 0.5))+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=12,face="bold"))



##GGPLOT ALL TYPES of Wines ENTIRE price range
#SCATTER
ggplot(alltypes, aes(x=price, y = rating)) +
  geom_point(aes(color = type)) +
  labs(x = "Price $", y = "Rating", title = "Wines",caption = "based on data scraped from Vivino")+
  theme(plot.title = element_text(size=20, 
                                  face="bold",
                                  hjust = 0.5))+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=12,face="bold"))


lowendall <- alltypes %>%
  filter(., price < 500)
str(lowendall)

ggplot(gg, aes(x=price, y = rating)) +
  geom_point(aes(color = type))



##GGPLOT
#ALL Red wines
#Positive Linear reltatinship
ggplot(data = redwine, aes(x = price1, y = rating)) +
  geom_point(color = "Firebrick") +
  labs(x = "Price $", y = "Rating", title = "Red Wines",caption = "based on data scraped from Vivino")+
  theme_minimal()+
  theme(plot.title = element_text(size=20, 
                                  face="bold",
                                  hjust = 0.5))+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=12,face="bold"))
 
#0.52
cor(redwine$price1, redwine$rating)

#LOW END
ggplot(data = lowend, aes(x = price1, y = rating)) +
  geom_point()

#with line
ggplot(data = lowend, aes(x = price1, y = rating)) +
  geom_point() + geom_smooth(method = "lm")

#Positve linear relationship 0.7
cor(lowend$rating, lowend$price1)





## BOXPLOT 
#ALL
gg <- ggplot(redwine, aes(x = country, y = price1))
g + geom_boxplot()

gg <- g <- ggplot(redwine, aes(x = country, y = rating))
g + geom_boxplot()


#Low end
g <- ggplot(lowend, aes(x = country, y = price1))
g + geom_boxplot()

g <- ggplot(lowend, aes(x = country, y = rating))
g + geom_boxplot()



####Cheap vines#####
cheap <- redwine %>%
  filter(., price1 < 30) %>%
  arrange(desc(rating))


str(cheap) #leaves me with 5459 observations/12000

##then, I want at least 20 reviews per bottle.
cheap1 <- cheap %>%
  filter(., no >= 100)

selected <- cheap1 %>%
  group_by(rating, name, country) %>%
  filter(., rating > 4.1)


#Top wines under 30, with at least 100 reviews, and a rating above 4.2
selected$Wine_Region <- paste(selected$country, selected$region, sep=" ")

ggplot(data=selected, aes(x=reorder(Wine_Region, rating), y = rating)) +
  geom_bar(position="dodge", stat="identity") +
  coord_flip()+
  geom_text(aes(label=price1))


#observe that the rating decrease signifanctly for all the countries
gg <- ggplot(cheap, aes(x = country, y = rating))
gg + geom_boxplot()





#T-TESTS
#filtering france
francemean <- redwine %>%
  filter(., country == "France")

mean(francemean$rating)
mean(remaining1$rating)

#filtering out france
remaining <- redwine %>%
  filter(., country != "France")

#H0: Average rating France = the remaining countries
#H1: average rating France > the remaining countries

#FRANCE versus Remaining
t.statistic = (mean(remaining$rating)-mean(france$rating))/(sd(remaining$rating)/sqrt(9467))
t.statistic
#Comparing with the critical values
  #computing critical values
qt(0.95, 9446) #compare with the t-value.
#since the t-values is LESS than the critical value, I retain H0.

#Comparing with the p-value.
  #Computing the p-value
##df = n-1
pt(q = t.statistic, df = 9446) #compare with 0.05
#since the p-value is greather than 0.05 we retain H0.

#Alternative
t.test(remaining$rating, mu = mean(france$rating), alternative = "greater")
#P-value greather than 0.05, retian H0. I do NOT have any evidence for that Frances average rating for wines is higher than the remaining countries.


###Filtering out all the wines without YEAR FOR REDWINE
library(dplyr)
min(redwine$year)
max(redwine$year)

redwineyear <- filter(redwine, year %in% c(1958, 1964, 1966, 1970, 1974, 1975, 1978, 1979,
                            1980, 1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989, 
                            1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999,
                            2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009,
                            2010, 2011, 2012, 2013, 2014, 2015, 2016))

#drooping 1800 observations, if I want wines containing YEAR!
str(redwineyear)
redwineyear$year <- as.numeric(redwineyear$year)

#Positive Linear reltatinship
ggplot(data = redwineyear, aes(x = rating, y = year))+
  geom_point()

cor(redwineyear$year, redwineyear$rating)


###VARIANCE TEST
#I believe the variane for rating of redwine and whitwine are different; Specifcally,
#I claim that rating for redwine has a higher variance than whitewine

#H0: Aveage(rating_redwine)=Aveage(rating_whitewine)
#H1: Aveage(rating_redwine)>Aveage(rating_whitewine)
var.test(alltypes500$rating[alltypes500$type == "red"],
         alltypes500$rating[alltypes500$type == "white"],
         alternative = "greater")

#Under the null hypothesis, red wine and whitewine have the same rating variance;
#I test whether redwine have a statistically significantly higer rating variance than whitewine
#I find that the p-value is extremely low (2.2e-16). Thus,
#I reject the null hypothesis, in favor of the alternative, rating for redwine has a higer variance than whitewine.



###REGRESSION###
redwineyear$year <- as.numeric(redwineyear$year)

model <- lm(formula = rating ~ sqrt(price1) + no, data=redwineyear)

print(model)
summary(model)
#Assumption tests.
plot(model)
