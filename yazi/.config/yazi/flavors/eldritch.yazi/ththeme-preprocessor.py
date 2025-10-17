import re
import sys


def resolve_var(name, palette, seen=None):
    """
    Recursively resolve variable references in palette.
    Supports nested variables like value="${red}".
    Accepts any variable name including uppercase, '@', '.', etc.
    """
    if seen is None:
        seen = set()
    if name in seen:
        return name  # Prevent infinite recursion
    seen.add(name)
    value = palette.get(name)
    if value is None:
        return name  # fallback: unresolved
    match = re.fullmatch(r"\$\{([^\}]+)\}", value.strip())
    if match:
        ref = match.group(1)
        return resolve_var(ref, palette, seen)
    return value


def preprocess_theme(input_file, output_file):
    # Parse XML
    with open(input_file, "r", encoding="utf-8") as f:
        xml_str = f.read()

    # Step 1: Extract palette colors (with nested resolution)
    palette = {}
    # Find the palette block
    palette_match = re.search(r"<palette>(.*?)</palette>", xml_str, re.DOTALL)
    if palette_match:
        palette_content = palette_match.group(1)
        # Find all <color .../>
        color_matches = re.findall(r"<color\s+([^/>]+?)/?>", palette_content)
        for color_str in color_matches:
            attrs = dict(re.findall(r'([a-zA-Z0-9@._-]+)="([^"]+)"', color_str))
            name = attrs.pop("name", None)
            if not name:
                continue
            value = attrs.get("value")
            if value:
                palette[name] = value
        # Resolve nested variables (supports any palette name)
        for name in palette:
            palette[name] = resolve_var(name, palette)

    # Step 2: Replace <string>${var}</string> with value and comment
    def string_replacer(match):
        var_name = match.group(1)
        value = resolve_var(var_name, palette)
        return f"<string>{value}</string> <!-- {var_name} -->"

    # Only replace exact <string>${var}</string>
    xml_str = re.sub(r"<string>\$\{([^\}]+)\}</string>", string_replacer, xml_str)

    # Step 3: Replace generic ${var} elsewhere with value (no comment)
    def generic_replacer(match):
        var_name = match.group(1)
        value = resolve_var(var_name, palette)
        return value

    xml_str = re.sub(r"\$\{([^\}]+)\}", generic_replacer, xml_str)

    # Step 4: Remove palette section from output
    xml_str = re.sub(r"<palette>.*?</palette>", "", xml_str, flags=re.DOTALL)

    # Step 5: Write to output file
    with open(output_file, "w", encoding="utf-8") as out:
        out.write(xml_str)


if __name__ == "__main__":
    input_file = sys.argv[1] if len(sys.argv) > 1 else "input.thTheme.xml"
    output_file = sys.argv[2] if len(sys.argv) > 2 else "output.thTheme.xml"
    preprocess_theme(input_file, output_file)
