import sys

from Filist import Filist

def main(name, filename, *argv):
    # print the contents of the given file
    ft = Filist(filename)
    ft.sub_lines(r'<programlisting>plasTeXjava', r'<programlisting language="java">')

    # label the last three chapters as appendices
    i, match = ft.search_lines('<chapter id="development">')
    ft.sub_lines(r'<chapter', r'<appendix', start=i)
    ft.sub_lines(r'</chapter', r'</appendix', start=i+1)

    ft.sub_lines(r'<emphasis role="bold">feedback@greenteapress.com</emphasis>',
                 r'<phrase role="keep-together"><emphasis role="bold">feedback@greenteapress.com</emphasis></phrase>')
    print ft

if __name__ == '__main__':
    main(*sys.argv)
