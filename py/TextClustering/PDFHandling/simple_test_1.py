import urllib2
import re

url='https://www.ecb.europa.eu/home/search/html/index.en.html?q=ilaap'

#connect to a URL
website = urllib2.urlopen(url)

#read html code
html = website.read()

#use re.findall to get all the links
links = re.findall('"((http|ftp)s?://.*?)"', html)

print links