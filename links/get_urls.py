from re import findall

urls = set()

for line in open('../thinkjava.expand'):
    matches = findall(r'\\url\{([^\}]*)', line)
    for match in matches:
        #print match
        urls.add(match)

for url in sorted(urls):
    print(",%s" % url)
