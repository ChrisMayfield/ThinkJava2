"""Splits plastex XML into individual chapters."""

import sys

def name(num):
    """chapter number -> filename"""
    if num < 10:
        return "ch0" + str(num) + ".xml"
    elif num < 18:
        return "ch" + str(num) + ".xml"
    else:
        return "app" + chr(num + 79) + ".xml"

def main(xml):
    src = open(xml, 'U')
    num = 0
    out = open(name(num), 'w')
    for line in src:
        # if next chapter, open new file
        pos = line.find("<chapter ")
        if pos < 0:
            pos = line.find("<appendix ")
        if pos > -1:
            out.write(line[:pos])
            out.write('\n')
            line = line[pos:]
            num += 1
            out = open(name(num), 'w')
        # make our xml look more like Atlas's xml
        line = line.replace(' />', '/>')
        line = line.replace('></title', '/') # exercises
        line = line.replace('></ulink', '/') # \url
        line = line.replace('<literal>', '<literal moreinfo="none">') # \tt
        line = line.replace('<mml:math overflow="scroll"', '<mml:math') # inline math
        line = line.replace('mode="display" overflow="scroll"', 'mode="display"') # display math
        line = line.replace('<indexterm>', '<indexterm significance="normal">') # \index
        line = line.replace('<orderedlist>', '<orderedlist inheritnum="ignore" continuation="restarts">') # \enumerate
        line = line.replace('<literal remap="verb">', '<literal remap="verb" moreinfo="none">') # \java
        line = line.replace('<programlisting language="java">\n', '<programlisting language="java" format="linespecific">') # \code
        line = line.replace('<programlisting>', '<programlisting format="linespecific">') # \stdout
        # output the resulting line
        out.write(line)

if __name__ == "__main__":
    if len(sys.argv) == 2:
        main(sys.argv[1])
    else:
        print("Usage: python ../xmlsplit.py thinkjava.xml")
        print("       (run from plastex project directory)")
