import urllib2
from urllib2 import *

proxy = ProxyHandler({'http': r'http://DO100400001001\T004314:luglio2014@proxy.gruppo.mps.local:80'})
auth =  HTTPBasicAuthHandler()
opener = build_opener(proxy, auth, HTTPHandler)
install_opener(opener)

conn = urlopen('http://google.com')
return_str = conn.read()

print return_str
print "programma terminato"