from __future__ import print_function

from glob import glob
from re import findall

urls = set()

for tex in glob('../????.tex'):
    for line in open(tex):
        matches = findall(r'\\url\{([^\}]*)', line)
        for match in matches:
            #print match
            urls.add(match)

urls.remove('https://thinkjava.org/')
for url in sorted(urls):
    print('<p><a href="%s">%s</a>' % (url, url))
