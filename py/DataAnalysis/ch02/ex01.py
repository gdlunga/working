import json
from pandas import DataFrame, Series
from collections import defaultdict

def get_counts(sequence):
    counts=defaultdict(int)
    for x in sequence:
        counts[x]  +=1
    return counts

path = "Z:\pydata-book-master\ch02\usagov_bitly_data2012-03-16-1331923249.txt"
records = [json.loads(line) for line in open(path)]

# extract time zones
time_zones = [rec['tz'] for rec in records if 'tz' in rec]
counts     = get_counts(time_zones)

for t in time_zones:
    print t
    
print counts['America/New_York']
    