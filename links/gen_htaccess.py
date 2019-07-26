import csv
import re

with open('urls2.csv') as csvfile:
    reader = csv.reader(csvfile)
    for i, row in enumerate(reader):
        slashtag, destination = row
        short_url = '/think-java-2e/' + slashtag

        print('Redirect', short_url, destination)
