# Website we want to scrape is: https://www.viviono.com
# The documentatio of selenium is here: http://selenium-python.readthedocs.io/index.html

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import csv

#As a Windows User, I need to specify the parth to my chrome driver (to the folder)
#Remember to unzip it
# driver = webdriver.Chrome(r'path\to\where\you\download\the\chromedriver.exe')
driver = webdriver.Chrome(r'C:/Users/Kenneth S. Hansen/Desktop/Selenium/chromedriver.exe')


#usa price range 21-50
driver.get("https://www.vivino.com/explore?e=eJzLLbI1VMvNzLM1AlKJFbamBmrJlbalxWoFQPFi2-REtbJk25Ki0lS18pLoWKBYcmUxkC4tBgAKCBKw")

csv_file = open('usa1.csv', 'w', encoding="utf-8")
# Windows users need to open the file using 'wb' or 'w'. In my case, only w is working (Windows user)
writer = csv.writer(csv_file)
writer.writerow(['yard', 'name', 'country', 'region', 'rating', 'noratings', 'price'])


#Infinite Scroll
lastHeight = driver.execute_script("return document.body.scrollHeight")
while True:
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    time.sleep(2)
    newHeight = driver.execute_script("return document.body.scrollHeight")
    if newHeight == lastHeight:
        break
    lastHeight = newHeight


usa1 = driver.find_elements_by_xpath('//div[@class="wine-explorer__results__item"]/div')
	
for review in usa1:
			# Initialize an empty dictionary for each review
	review_dict = {}
			# Using Xpath to locate the wineyard, name of the wine, country, region, the rating, total number of rating, and the average price.
			# after locating the elements, I used 'element.text' to return its string.
			# Remember! To get the attribute instead of the text of each element, use 'element.get_attribute()'
	try:
		yard = review.find_element_by_xpath('.//span[@class="wine-card__header__winery"]').text
	except:
		yard = "NA"
	try:
		name = review.find_element_by_xpath('.//span[@class="wine-card__header__wine"]').text
	except:
		name = "NA"
	try:
		country = review.find_element_by_xpath('.//div[@class="location"]//a[2]').text
	except:
		country = "NA"
	try:
		region = review.find_element_by_xpath('.//div[@class="location"]//a[3]').text
	except:
		region = "NA"
	try:
		rating = review.find_element_by_xpath('.//div[@class="statistics-item__content__value"]').text
	except:
		rating = "NA"
	try:
		noratings = review.find_element_by_xpath('.//div[@class="statistics-item__content__description"]').text
	except:
		noratings = "NA"
	try:
		price = review.find_element_by_xpath('.//span[@class="price"]').text
	except:
		price = "NA"

	review_dict['yard'] = yard
	review_dict['name'] = name
	review_dict['country'] = country
	review_dict['region'] = region
	review_dict['rating'] = rating
	review_dict['noratings'] = noratings
	review_dict['price'] = price
			
	writer.writerow(review_dict.values())

		
	
csv_file.close()
driver.close()