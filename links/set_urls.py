import csv
import glob
import re

link_map = {}
with open('urls2.csv') as csvfile:
    reader = csv.reader(csvfile)
    for i, row in enumerate(reader):
        slashtag, destination = row
        link_map[destination] = 'https://thinkjava.org/' + slashtag

for tex in glob.glob('../book/????.tex'):
    out = open(tex[3:], 'w')
    for line in open(tex):
        matches = re.findall(r'\\url\{([^\}]*)', line)
        if matches:
            for url in matches:
                key = url.replace('\\#', '#')
                try:
                    short = link_map[key]
                    line = line.replace(url, short)
                except KeyError:
                    pass
                    #print url
        out.write(line)
