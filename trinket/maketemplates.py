from __future__ import print_function
import sys
from pyquery import PyQuery
import re
import glob
"""
  Run from project directory - paths are relative from there
"""

index_file = "trinkethtml/index.html"

output_dir = "trinkethtml/nunjucks/" # Where to write files locally
web_dir = "{{ bookprefix }}"    # Prefix for links

# Pyquery to get TOC from index
with open(index_file) as index:


    # Process chapter TOC from index.
    indextext = index.read()
    d = PyQuery(indextext)

    files = sorted(glob.glob("trinkethtml/*.html"))

    link_replacements = {}

    # Build link swapping dict
    for i, file in enumerate(files[1:]): # skip book index
        special_chapters = {
            15: "appendix-a.html",
            16: "appendix-b.html",
            17: "appendix-c.html",
            18: "appendix-d.html",
            19: "appendix-e.html",
            20: "book-index.html"
        }
        # Create new output file for chapter
        if i == 0:
            newfile = "preface.html"
        elif i < 15:
            newfile = "chapter{0}.html".format(str(i))
        else:
            newfile = special_chapters[i]
        # TODO: handle appendices and index
        link_replacements[file.replace('trinkethtml/','')] = newfile

    for i, file in enumerate(files[1:]): # skip book index
        print("Processing: ", file)
        selector = 'div.columns > ul > li:nth-child(' + str(i+1) + ')'
        list_items = d(selector)
        list_items('li').eq(0).addClass('has-dropdown')
        list_items('ul').addClass('dropdown')
        toc = PyQuery('<div><ul class="right"></ul></div>')
        toc('ul').html(list_items)
        thisfile = file.replace('trinkethtml/','')
        newfile = link_replacements[thisfile]
        toc_text = re.sub(thisfile, web_dir + newfile, toc.html(method='html'))
        #print(toc_text)

        # Extract chapter text
        with open(file) as f:
            chapter_raw = f.read()
        chapter_query = PyQuery(chapter_raw)
        chapter_text = chapter_query(".bookchapter").html(method='html')

        # Replace old links
        for old, new in link_replacements.items():
            chapter_text = re.sub(old, web_dir + new, chapter_text)
        # placeholder for tabs and newlines since re.sub will clobber them otherwise
        # print(re.findall(r'^.*?\\[tn].*?$', chapter_text, flags=re.M))
        chapter_text = re.sub(r'\\([tn])', 'shouldbe\g<1>', chapter_text, flags=re.M)


        # TODO: transform chapter text somehow

        # Get title
        title = chapter_query("title").text()
        title += " | Think Java | Trinket"

        print("Making ", newfile)
        with open(output_dir + newfile, 'w') as nf:
            template = """

{% extends 'books/thinkjava2/base.html' %}
{% block chaptercontent %}
<div class="row">
<div class="columns small-12">

$body$
</div>

</div>
{% endblock %}

{% block toc %}
$toc$
{% endblock %}

{% block title%}$title${% endblock %}
"""
            template = re.sub('\$title\$', title, template)
            template = re.sub('\$toc\$', toc_text, template)
            template = re.sub('\$body\$', chapter_text, template)
            # convert ids to names
            #template = re.sub(r'id\=\"', 'name="', template)
            # form valid <a> elements
            template = re.sub(r'<a (.*?[^<])/>', '<a \g<1>></a>', template)
            # Easier to post process than read Hevea docs for this
            template = re.sub(r'hevea_default', 'item', template)
            # form valid iframes
            template = re.sub(r'<iframe(.*?)=""/>', '<iframe\g<1>></iframe>', template)
            # change image paths
            template = re.sub(r'<img src="(.*?)"\w*?/?>', '<img src="https://trinket-app-assets.trinket.io/thinkjava2/\g<1>"/>', template)
            #print(template)

            # replace tabs and newlines
            # print(re.findall(r"^.*?shouldbe[tn].*?$", template, flags=re.M))
            template = re.sub(r'shouldbe([tn])', '\\\\\g<1>', template, flags=re.M)


            # Write template
            nf.write(template.encode('utf8'))
sys.exit(0)