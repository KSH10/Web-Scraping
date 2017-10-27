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


#WHITEwine at Vivono price range 1-17
driver.get("https://www.vivino.com/explore?e=eJzLLbI1VMvNzLM1UMtNrLA1NFdLrrQtLVYrAAoX2yYnqpUl25YUlaaqlZdEx9oaAQBljg8v")

csv_file = open('whitewine.csv', 'w', encoding="utf-8")
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


time.sleep(5)
whitewines = driver.find_elements_by_xpath('//div[@class="wine-explorer__results__item"]/div')
	
for wine in whitewines:
			# Initialize an empty dictionary for each review
	wine_dict = {}
			# Using Xpath to locate the wineyard, name of the wine, country, region, the rating, total number of rating, and the average price.
			# after locating the elements, I used 'element.text' to return its string.
			# Remember! To get the attribute instead of the text of each element, use 'element.get_attribute()'
	try:
		yard = wine.find_element_by_xpath('.//span[@class="wine-card__header__winery"]').text
	except:
		yard ="NA"
	try:
		name = wine.find_element_by_xpath('.//span[@class="wine-card__header__wine"]').text
	except:
		name ="NA"	
	try:
		country = wine.find_element_by_xpath('.//div[@class="location"]//a[2]').text
	except:
		country = "NA"
	try:
		region = wine.find_element_by_xpath('.//div[@class="location"]//a[3]').text
	except:
		region = "NA"
	try:
		rating = wine.find_element_by_xpath('.//div[@class="statistics-item__content__value"]').text
	except:
		rating = "NA"
	try:
		noratings = wine.find_element_by_xpath('.//div[@class="statistics-item__content__description"]').text
	except:
		noratings = "NA"
	try:
		price = wine.find_element_by_xpath('.//span[@class="price"]').text
	except:
		price = "NA"


	wine_dict['yard'] = yard
	wine_dict['name'] = name
	wine_dict['country'] = country
	wine_dict['region'] = region
	wine_dict['rating'] = rating
	wine_dict['noratings'] = noratings
	wine_dict['price'] = price
			
	writer.writerow(wine_dict.values())


	
csv_file.close()
driver.close()