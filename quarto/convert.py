import re
import sys
from pathlib import Path

def replace_java_inline(text):
    """Replace \java{...} commands with \lstinline, handling nested braces correctly."""
    result = []
    i = 0
    
    while i < len(text):
        # Look for \java{
        java_pos = text.find('\\java{', i)
        if java_pos == -1:
            # No more \java{ found, append rest of text
            result.append(text[i:])
            break
        
        # Append everything before \java{
        result.append(text[i:java_pos])
        
        # Start after \java{
        content_start = java_pos + 6  # len('\\java{') = 6
        
        # Find matching closing brace - but ignore escaped braces
        brace_depth = 1
        j = content_start
        while j < len(text) and brace_depth > 0:
            if j < len(text) - 1 and text[j] == '\\':
                # Skip escaped characters (including \{ and \})
                j += 2
                continue
            elif text[j] == '{':
                brace_depth += 1
            elif text[j] == '}':
                brace_depth -= 1
            j += 1
        
        if brace_depth != 0:
            raise ValueError(f"Unmatched brace in \\java{{...}} at position {java_pos}")
        
        # Extract content between braces (j-1 because j moved past the closing brace)
        content = text[content_start:j-1]
        
        # Escape any tildes in the content to avoid delimiter conflict
        content = content.replace('~', r'\textasciitilde{}')
        
        # Append the replacement
        result.append(f'\\lstinline[language=Java]~{content}~')
        
        # Continue after the closing brace
        i = j
    
    return ''.join(result)


def replace_custom_env(text, env_name, lst_opts='language=Java'):
    # Replace begin and end environments
    # Use raw strings and escape the backslashes properly
    begin_pat = rf'\\begin\{{{env_name}\}}(?:\[[^\]]*\])?(?:\{{[^}}]*\}})?'
    end_pat = rf'\\end\{{{env_name}\}}'

    text = re.sub(begin_pat, f'\\\\begin{{lstlisting}}[{lst_opts}]', text)
    text = re.sub(end_pat, r'\\end{lstlisting}', text)
    return text

def replace_java_commands(text):
    """Replace \java{...} commands with \lstinline, handling nested braces correctly."""
    # This regex finds \java{...} where ... can contain nested braces
    # It uses a recursive approach to match balanced braces
    pattern = r'\\java\{((?:[^{}]|(?:\{[^{}]*\}))*)\}'
    
    def replace_match(match):
        content = match.group(1)
        # Escape any remaining braces in the content
        content = content.replace('{', '\\{').replace('}', '\\}')
        return f'\\lstinline[language=Java]~{content}~'
    
    return re.sub(pattern, replace_match, text)

def replace_sf_commands(text):
    """Replace {... \sf ...} with \\textsf{...}, handling nested braces."""
    out = []
    i = 0
    n = len(text)
    needle = '{\\sf'

    while i < n:
        j = text.find(needle, i)
        if j == -1:
            out.append(text[i:])
            break

        # copy text before the match
        out.append(text[i:j])

        # move past "{\sf" and skip any following whitespace
        k = j + len(needle)
        while k < n and text[k].isspace():
            k += 1

        # brace depth: we already consumed the opening '{' at position j
        depth = 1
        p = k
        while p < n and depth > 0:
            ch = text[p]
            if ch == '\\':
                # skip escaped brace or escaped backslash
                if p + 1 < n and text[p+1] in '{}\\':
                    p += 2
                    continue
            if ch == '{':
                depth += 1
            elif ch == '}':
                depth -= 1
            p += 1

        # if unmatched, bail out by leaving the remainder unchanged
        if depth != 0:
            out.append(text[j:])
            break

        # content is everything up to (but not including) the closing '}' that balanced the initial '{'
        content = text[k:p-1]
        out.append(f'\\textsf{{{content}}}')

        # continue after the closing '}'
        i = p

    return ''.join(out)

def replace_figure_references(text):
    """Replace PDF figure references with SVG references."""
    # Pattern to match \includegraphics commands that reference PDF files
    # This will match both \includegraphics{figs/filename.pdf} and \includegraphics[options]{figs/filename.pdf}
    pattern = r'\\includegraphics(?:\[([^\]]*)\])?\{([^}]*\.pdf)\}'
    
    def replace_match(match):
        options = match.group(1) if match.group(1) else ''
        pdf_path = match.group(2)
        
        # Extract the filename without extension
        if '/' in pdf_path:
            directory, filename = pdf_path.rsplit('/', 1)
            base_name = filename.replace('.pdf', '')
            svg_path = f"{directory}/{base_name}-.svg"
        else:
            base_name = pdf_path.replace('.pdf', '')
            svg_path = f"{base_name}-.svg"
        
        # Reconstruct the \includegraphics command
        # Keep any existing options 
        if options:
            return f'\\includegraphics[{options}]{{{svg_path}}}'
        else:
            return f'\\includegraphics{{{svg_path}}}'
    
    return re.sub(pattern, replace_match, text)



def process_file(input_path, output_dir):
    # Read from parent directory
    parent_dir = Path(__file__).parent.parent
    input_file = parent_dir / input_path
    
    if not input_file.exists():
        print(f"Error: Input file {input_file} not found")
        return
    
    original = input_file.read_text(encoding='utf-8')
    modified = original
    
    # Replace custom environments with listings
    for env in ['code', 'stdout', 'trinket']:
        if env == 'stdout':
            # For stdout/text output, don't specify a language
            opts = ''
        else:
            opts = 'language=Java'
        modified = replace_custom_env(modified, env, lst_opts=opts)
    
    # Replace \java{} commands with \lstinline[language=Java] using ~ delimiter
    # This handles nested braces correctly
    modified = replace_java_inline(modified)
    
    # Replace {\sf ...} commands with \textsf{...} for better Pandoc compatibility
    modified = replace_sf_commands(modified)
    
    # Replace PDF figure references with SVG references
    modified = replace_figure_references(modified)
    
    # Write output to quarto directory
    output_path = output_dir / f"{input_path.stem}.tex"
    output_path.write_text(modified, encoding='utf-8')
    print(f'Wrote converted file to {output_path}')

def main():
    if len(sys.argv) < 2:
        print("Usage: python convert.py <filename1> [filename2] [filename3] ...")
        print("Example: python convert.py ch01.tex ch02.tex ch03.tex")
        print("Example: python convert.py ch*.tex")
        sys.exit(1)
    
    output_dir = Path(__file__).parent  # quarto directory
    
    # Process each file provided on the command line
    for filename in sys.argv[1:]:
        input_file = Path(filename)
        print(f"Processing {filename}...")
        process_file(input_file, output_dir)

if __name__ == "__main__":
    main()
