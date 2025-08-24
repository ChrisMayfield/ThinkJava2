#!/usr/bin/env python3
"""
Split full_book.md into individual chapter files for Quarto.
"""

import re
from pathlib import Path

def convert_cross_references(content):
    """Convert LaTeX-style cross-references to Quarto format."""
    
    # First, convert all figure IDs from fig. to fig- format
    content = re.sub(r'id="fig\.([^"]+)"', r'id="fig-\1"', content)
    
    # Add proper Quarto labels to all HTML figures
    content = re.sub(
        r'(<figure id="fig-([^"]+)">)',
        r'\1\n{#fig-\2}',
        content
    )
    
    # Convert figure references (handle multi-line and single-line)
    content = re.sub(
        r'Figure\s+\[([^\]]+)\]\(#fig\.([^)]+)\)\{reference-type="ref"\s*reference="[^"]+"\}',
        r'Figure @ref(fig-\2)',
        content,
        flags=re.MULTILINE | re.DOTALL
    )
    
    # Convert section references
    content = re.sub(
        r'Section\s+\[([^\]]+)\]\(#([^)]+)\)\{reference-type="ref"\s*reference="[^"]+"\}',
        r'Section @ref(\2)',
        content,
        flags=re.MULTILINE | re.DOTALL
    )
    
    # Convert table references
    content = re.sub(
        r'Table\s+\[([^\]]+)\]\(#([^)]+)\)\{reference-type="ref"\s*reference="[^"]+"\}',
        r'Table @ref(\2)',
        content,
        flags=re.MULTILINE | re.DOTALL
    )
    
    # Convert appendix references
    content = re.sub(
        r'Appendix\s+\[([^\]]+)\]\(#([^)]+)\)\{reference-type="ref"\s*reference="[^"]+"\}',
        r'Appendix @ref(\2)',
        content,
        flags=re.MULTILINE | re.DOTALL
    )
    
    # Convert any remaining LaTeX-style references to simpler format
    # This catches references that don't follow the exact pattern above
    content = re.sub(
        r'\[([^\]]+)\]\(#([^)]+)\)\{reference-type="ref"\s*reference="[^"]+"\}',
        r'@ref(\2)',
        content,
        flags=re.MULTILINE | re.DOTALL
    )
    
    return content

def build_label_mapping(content):
    """Build a mapping from old LaTeX labels to new Quarto labels."""
    label_map = {}
    
    # Find all chapter headings with labels
    lines = content.split('\n')
    for line in lines:
        if line.startswith('# '):
            # Extract title and label from "# Title {#label}"
            match = re.match(r'^#\s+(.+?)\s+\{#([^}]+)\}', line)
            if match:
                title = match.group(1).strip()
                old_label = match.group(2)
                
                # Generate new Quarto label based on title
                new_label = title.lower().replace(' ', '-').replace('&', 'and')
                new_label = re.sub(r'[^\w\-]', '', new_label)
                
                label_map[old_label] = new_label
                print(f"Mapping: {old_label} -> {new_label} ({title})")
            else:
                # This H1 heading doesn't have a label, so create one
                title = line[2:].strip()
                # Generate label from title
                new_label = title.lower().replace(' ', '-').replace('&', 'and')
                new_label = re.sub(r'[^\w\-]', '', new_label)
                
                # Create a mapping from the generated label to itself
                # This allows references to work even if they use the generated label
                label_map[new_label] = new_label
                print(f"Auto-generated label: {new_label} ({title})")
    
    return label_map

def convert_chapter_references(content, label_map):
    """Convert chapter cross-references using the label mapping."""
    
    # Convert references like [Title](#old-label){reference-type="ref" reference="..."} to @ref(new-label)
    for old_label, new_label in label_map.items():
        # Handle complex LaTeX references with reference-type attributes
        content = re.sub(
            rf'\[([^\]]+)\]\(#{re.escape(old_label)}\)\{{[^}}]*\}}',
            rf'@ref({new_label})',
            content
        )
        
        # Also handle simple references without attributes
        content = re.sub(
            rf'\[([^\]]+)\]\(#{re.escape(old_label)}\)',
            rf'@ref({new_label})',
            content
        )
    
    return content

def ensure_heading_labels(content, title, chapter_number=None):
    """Ensure the main heading has a proper label for cross-referencing."""
    lines = content.split('\n')
    
    for i, line in enumerate(lines):
        if line.startswith('# '):
            # Check if this line already has a label
            if '{#' in line:
                # Already has a label, leave it alone
                break
            else:
                # No label, add one
                if chapter_number is not None:
                    if isinstance(chapter_number, str):
                        # This is an appendix - use the auto-generated label
                        label = title.lower().replace(' ', '-').replace('&', 'and')
                        label = re.sub(r'[^\w\-]', '', label)
                    else:
                        # This is a regular chapter - use the auto-generated label
                        label = title.lower().replace(' ', '-').replace('&', 'and')
                        label = re.sub(r'[^\w\-]', '', label)
                else:
                    # For preface - use the auto-generated label
                    label = title.lower().replace(' ', '-').replace('&', 'and')
                    label = re.sub(r'[^\w\-]', '', label)
                
                # Add the label to the heading
                lines[i] = f"{line} {{#{label}}}"
                break
    
    return '\n'.join(lines)

def create_chapter_file(filename, title, content, chapter_number=None, chapter_id=None):
    """Create a chapter file with minimal YAML header and title in content."""
    
    # Create minimal YAML header 
    yaml_header = "---\n"
    if chapter_number:
        if isinstance(chapter_number, str):
            # This is an appendix - include chapter letter for numbering
            yaml_header += f"chapter: {chapter_number}\n"
            yaml_header += "---\n\n"
        else:
            # This is a regular chapter - include chapter number
            yaml_header += f"chapter: {chapter_number}\n"
            yaml_header += "---\n\n"
    else:
        # For preface only (no chapter number), no title in YAML
        # This prevents Quarto from treating it as a numbered chapter
        yaml_header = "---\n"
        yaml_header += "numbered: false\n"
        yaml_header += "---\n\n"
    
    # Keep all titles in markdown content for cross-referencing
    # Don't remove any H1 headings
    filtered_content = content
    
    # Ensure the main heading has a proper label
    filtered_content = ensure_heading_labels(filtered_content, title, chapter_number)
    
    # Convert cross-references to Quarto format
    # This is not working well, so we're not using it for now
    # filtered_content = convert_cross_references(filtered_content)
    
    # Write the file
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(yaml_header)
        f.write(filtered_content)
    
    print(f"Created {filename}")

def find_chapter_headings(content):
    """Find all chapter headings in the content."""
    lines = content.split('\n')
    chapters = []
    
    # Look for lines that start with # and contain chapter-like content
    for i, line in enumerate(lines):
        if line.startswith('# '):
            # Extract the title and ID attributes
            title_match = re.match(r'^#\s+(.+?)(?:\s+\{([^}]*)\})?$', line)
            if title_match:
                title = title_match.group(1).strip()
                chapter_id = title_match.group(2) if title_match.group(2) else None
                
                # Determine if this is a chapter or appendix
                if title == "Preface":
                    chapters.append((i, title, "index.qmd", None, chapter_id))
                elif title in ["Tools", "Javadoc", "Graphics", "Debugging"]:
                    # These are appendices - assign letter numbers
                    app_count = len([c for c in chapters if c[1] in ["Tools", "Javadoc", "Graphics", "Debugging"]])
                    app_letter_upper = chr(ord('A') + app_count)  # For chapter numbering (A, B, C, D)
                    app_letter_lower = chr(ord('a') + app_count)  # For filename (a, b, c, d)
                    chapters.append((i, title, f"app{app_letter_lower}.qmd", app_letter_upper, chapter_id))
                else:
                    # This is a regular chapter (not preface, not appendix)
                    chapter_num = len([c for c in chapters if c[1] not in ["Preface", "Tools", "Javadoc", "Graphics", "Debugging"]]) + 1
                    chapters.append((i, title, f"ch{chapter_num:02d}.qmd", chapter_num, chapter_id))
    
    return chapters

def split_book():
    """Split the full book into individual chapter files."""
    
    # Read the full book
    with open('full_book.md', 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Build label mapping first
    print("Building label mapping...")
    label_map = build_label_mapping(content)
    print(label_map)
    
    # Find chapter headings automatically
    chapters = find_chapter_headings(content)
    
    print(f"Found {len(chapters)} chapters/appendices:")
    for line_num, title, filename, chapter_num, chapter_id in chapters:
        print(f"  Line {line_num}: {title} -> {filename} (ID: {chapter_id})")
    
    # Process each chapter
    for i, (start_line, title, filename, chapter_num, chapter_id) in enumerate(chapters):
        # Calculate end line (next chapter start or end of file)
        if i + 1 < len(chapters):
            end_line = chapters[i + 1][0]
        else:
            end_line = len(content.split('\n'))
        
        # Extract chapter content
        lines = content.split('\n')
        chapter_content = '\n'.join(lines[start_line:end_line])
        
        # Convert chapter cross-references using the label mapping
        # chapter_content = convert_chapter_references(chapter_content, label_map)
        
        # Create the chapter file
        create_chapter_file(filename, title, chapter_content, chapter_num, chapter_id)

if __name__ == "__main__":
    split_book()
    print("\nBook split complete! Update _quarto.yml to include all chapter files.")
