# Website we want to scrape is: https://www.verizonwireless.com/smartphones/samsung-galaxy-s7/
# The documentatio of selenium is here: http://selenium-python.readthedocs.io/index.html

# Please follow the instructions below to setup the environment of selenium
# Step #1
# Windows users: download the chromedriver from here: https://chromedriver.storage.googleapis.com/index.html?path=2.30/
# Mac users: Install homebrew: http://brew.sh/
#			 Then run 'brew install chromedriver' on the terminal
#
# Step #2
# Windows users: open Anaconda prompt and switch to python3 environment. Then run 'conda install -c conda-forge selenium'
# Mac users: open Terminal and switch to python3 environment. Then run 'conda install -c conda-forge selenium'

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import csv

# Windows users need to specify the path to chrome driver you just downloaded.
# You need to unzip the zipfile first and move the .exe file to any folder you want.
# driver = webdriver.Chrome(r'path\to\where\you\download\the\chromedriver.exe')
driver = webdriver.Chrome(r'C:/Users/Kenneth S. Hansen/Desktop/Selenium/chromedriver.exe')

#Portugal: https://www.vivino.com/explore?e=eJzLLbI1VMvNzLM1NFDLTaywNTUwUEuutC0tVisAShTbJieqlSXblhSVpqqVl0THAsWSK4uBdEEJABaEEto=
#portugal
driver.get("https://www.vivino.com/explore?e=eJzLLbI1VMvNzLM1NFDLTaywNTUwUEuutC0tVisAShTbJieqlSXblhSVpqqVl0THAsWSK4uBdEEJABaEEto=")

csv_file = open('reviews.csv', 'w')
# Windows users need to open the file using 'wb'
# csv_file = open('reviews.csv', 'wb')
writer = csv.writer(csv_file)
writer.writerow(['yard', 'name', 'country', 'region', 'rating', 'noratings', 'price'])
# Page index used to keep track of where we are.

#Alternative Calculateion: 5 per 1000 pixel'ish. See further below.
for i in range(1,3):
	#0,3 Duplicates many actually.
	#1,3 SAME as 0,2, first 50 wines are duplicates, and then it scrapes all the wines. Thus, this makes more sense, since each page load 25 wine per scroll.
	#0,2 BEST: first 50 wines, duplicates, and then it scrape all the wines
	#1,2 No duplicates, but it scrapes only 50 wines!
	#2,3 no duplictes, but scrapes only 50/73
	#2,4 Get all the wines, but the first 51 wines are duplicates
	#0,4 MANY duplicates!
	#1,4 MANY duplicates
	driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
	time.sleep(3)


#for i in range(1,int(73/5) + 5 ):
	#driver.execute_script('scroll(0,{}000);'.format(i))
	#driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
	#time.sleep(.5)

		# Find all the reviews.
reviews = driver.find_elements_by_xpath('//div[@class="wine-explorer__results__item"]/div')

for review in reviews:
			# Initialize an empty dictionary for each review
	review_dict = {}
			# Use Xpath to locate the wineyard, name of the wine, country, region, the rating, total number of rating, and the average price.
			# after locating the elements, I used 'element.text' to return its string.
			# Remember! To get the attribute instead of the text of each element, use 'element.get_attribute()'
	yard = review.find_element_by_xpath('.//span[@class="wine-card__header__winery"]').text
	name = review.find_element_by_xpath('.//span[@class="wine-card__header__wine"]').text
	country = review.find_element_by_xpath('.//div[@class="location"]//a[2]').text
	region = review.find_element_by_xpath('.//div[@class="location"]//a[3]').text
	rating = review.find_element_by_xpath('.//div[@class="statistics-item__content__value"]').text
	noratings = review.find_element_by_xpath('.//div[@class="statistics-item__content__description"]').text
	price = review.find_element_by_xpath('.//span[@class="price"]').text

	
	review_dict['yard'] = yard
	review_dict['name'] = name
	review_dict['country'] = country
	review_dict['region'] = region
	review_dict['rating'] = rating
	review_dict['noratings'] = noratings
	review_dict['price'] = price
			
	writer.writerow(review_dict.values())

		# Locate the next button on the page.
		#button = driver.find_element_by_xpath('//span[@class="bv-content-btn-pages-next"]')
		#driver.execute_script("arguments[0].click();", button)
		# button.click()

		#driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
	
csv_file.close()
driver.close()


	# Better solution using Explicit Waits in selenium: http://selenium-python.readthedocs.io/waits.html?highlight=element_to_be_selected#explicit-waits

	# try:
	# 	wait_review = WebDriverWait(driver, 10)
	# 	reviews = wait_review.until(EC.presence_of_all_elements_located((By.XPATH,
	# 								'//ol[@class="bv-content-list bv-content-list-Reviews bv-focusable"]/li')))
	# 	print(index)
	# 	print('review ok')
	# 	# reviews = driver.find_elements_by_xpath('//ol[@class="bv-content-list bv-content-list-Reviews bv-focusable"]/li')
	#
	# 	wait_button = WebDriverWait(driver, 10)
	# 	button = wait_button.until(EC.element_to_be_clickable((By.XPATH,
	# 								'//div[@class="bv-content-list-container"]//span[@class="bv-content-btn-pages-next"]')))
	# 	print('button ok')
	# 	# button = driver.find_element_by_xpath('//span[@class="bv-content-btn-pages-next"]')
	# 	button.click()
	# except Exception as e:
	# 	print(e)
	# 	driver.close()
	# 	break
