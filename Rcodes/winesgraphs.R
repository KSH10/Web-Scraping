##GRAPHS

###Pricerange 0-500
#fra 16690 - 16521
alltypes500 <- alltypes %>%
  filter(., price < 500)

###BOXPLOT TYPES OF WINE RATING####
boxplot(rating ~ type, data = alltypes500, names=c("Red Wine", "White Wine", "Sparkling"),
        xlab = "Type Of Wine", ylab = "Rating",
        main = "Red Wine, White Wine, & Sparkling Wine")


ggplot(alltypes, aes(x=type, y=rating, fill=type)) + 
  geom_boxplot(alpha=0.3, outlier.colour = "black", outlier.shape = 16) +
  labs(x = "Country", y = "Rating", title = "Rating - Red Wines below $1000",caption = "based on data scraped from Vivino") +
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=12))


#Scatter types of Wines
ggplot(alltypes500, aes(x=price, y = rating)) +
  geom_point(aes(color = type)) +
  labs(x = "Price $", y = "Rating", title = "Wines below $500",caption = "based on data scraped from Vivino")+
  theme_dark()+
  theme(plot.title = element_text(size=20, 
                                  face="bold",
                                  hjust = 0.5))+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=12,face="bold"))


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

#CORRELATION
#Red
red <- alltypes500 %>%
  filter(., type == "red")

#positve 0.68
cor(red$price, red$rating)

#White
white <- alltypes500 %>%
  filter(., type == "white")

cor(white$price, white$rating)

#Sparkling
spark <- alltypes500 %>%
  filter(., type == "sparkling")

cor(spark$price, spark$rating)








####REDWINE###

redwine1000 <- redwine %>%
  filter(., price1 < 1000)

##GGPLOT
#ALL Red wines
#Positive Linear reltatinship
ggplot(data = redwine1000, aes(x = price1, y = rating)) +
  geom_point(color = "Firebrick") +
  labs(x = "Price $", y = "Rating", title = "Red Wines below $1000",caption = "based on data scraped from Vivino")+
  theme_minimal()+
  theme(plot.title = element_text(size=20, 
                                  face="bold",
                                  hjust = 0.5))+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=12,face="bold"))


###Filtering out all the wines without YEAR FOR REDWINE
redwineyear <- filter(redwine, year %in% c(1958, 1964, 1966, 1970, 1974, 1975, 1978, 1979,
                                           1980, 1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989, 
                                           1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999,
                                           2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009,
                                           2010, 2011, 2012, 2013, 2014, 2015, 2016))

#drooping 1800 observations, if I want wines containing YEAR!
str(redwineyear)


#Positive Linear reltatinship
#Create the plot BEFORE converting year to a numeric, to get the correlation
ggplot(data = redwineyear, aes(x = rating, y = year))+
  geom_point()+
  geom_point(color = "Firebrick") +
  labs(x = "Rating", y = "Year", title = "Red Wines below $1000",caption = "based on data scraped from Vivino")+
  theme_minimal()+
  theme(plot.title = element_text(size=20, 
                                  face="bold",
                                  hjust = 0.5))+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=12,face="bold"))
  

#Correlation - Rating versus YEAR
redwineyear$year <- as.numeric(redwineyear$year)
cor(redwineyear$year, redwineyear$rating)



#Boxplot Country Rating
ggplot(redwine100, aes(x=country, y=rating, fill=country)) + 
  geom_boxplot(alpha=0.3, outlier.colour = "black", outlier.shape = 16) +
  theme(legend.position="none")+
  labs(x = "Country", y = "Rating", title = "Rating - Red Wines below $100",caption = "based on data scraped from Vivino") +
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=12))
  


#Boxplot Country Price
redwine100 <- redwine1000 %>%
  filter(., price1 < 100)

ggplot(redwine100, aes(x=country, y=price1, fill=country)) + 
  geom_boxplot(alpha=0.3, outlier.colour = "black", outlier.shape = 16) +
  theme(legend.position="none")+
  labs(x = "Country", y = "Price $", title = "Prices - Red Wines below $100",caption = "based on data scraped from Vivino") +
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=12))



#T-TEST

#filtering france
france <- redwine %>%
  filter(., country == "France")

mean(france$rating)
mean(remaining$rating)

#all countries without france
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


####TOP 30 under $30
####Cheap vines#####
cheap <- redwine %>%
  filter(., price1 < 30) %>%
  arrange(desc(rating))

str(cheap) #leaves me with 5459 observations/12000

##then, I want at least 100 reviews per bottle.
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
  geom_text(aes(label=price, color="red", hjust=1.0))+
  theme_classic()+
  theme(legend.position="none")+
  labs(x = "Country and Region", y = "Rating", title = "Top 30 Red Wines below $30 with min: 100 reviews, avg rating: 4.1",caption = "based on data scraped from Vivino") +
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=12))





###TESTS
#I believe the variane for rating of redwine and whitwine are different; Specifcally,
#I claim that rating for redwine has a higher variance than whitewine

#H0: Aveage(rating_redwine)=Aveage(rating_whitewine)
#H1: Aveage(rating_redwine)>Aveage(rating_whitewine)

# http://2012books.lardbucket.org/books/beginning-statistics/s15-chi-square-tests-and-f-tests.html
var.test(alltypes500$rating[alltypes500$type == "red"],
         alltypes500$rating[alltypes500$type == "white"],
         alternative = "greater")

#Under the null hypothesis, red wine and whitewine have the same rating variance;
#I test whether redwine have a statistically significantly higer rating variance than whitewine
#I find that the p-value is extremely low (2.2e-16). Thus,
#I reject the null hypothesis, in favor of the alternative, rating for redwine has a higer variance than whitewine.

#Bartletts
res <- bartlett.test(rating ~ type, data = alltypes500)
res

###regression
redwineyear1 <- redwineyear %>%
  filter(., price1 < 1000)

ggplot(redwineyear1, aes(x=price1, y = rating)) +
  geom_point() 


#Redwine: Rating versus price
linearredwine <- lm(formula = rating ~sqrt(price1), data=redwineyear)
summary(linearredwine)

#Year
linearredwineyear <- lm(formula = rating ~year, data=redwineyear1)
summary(linearredwineyear)


#No of rating - Negative effect.
ggplot(redwineyear1, aes(x=no, y = rating)) +
  geom_point() 

review <- redwineyear1 %>%
  filter(no < 5000)

linearredwineRating <- lm(formula = rating ~no, data=review)
summary(linearredwineRating)



