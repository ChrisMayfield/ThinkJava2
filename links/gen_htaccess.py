import csv
import re

with open('urls.csv') as csvfile:
    reader = csv.reader(csvfile)
    for i, row in enumerate(reader):
        slashtag, destination = row
        short_url = '/modsimpy/' + slashtag

        print('Redirect', short_url, destination)
