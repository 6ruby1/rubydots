import re
import sys


def load_palette(palette_file):
    with open(palette_file, "r", encoding="utf-8") as f:
        xml_str = f.read()
    palette = {}
    palette_match = re.search(r"<palette>(.*?)</palette>", xml_str, re.DOTALL)
    if palette_match:
        palette_content = palette_match.group(1)
        color_matches = re.findall(
            r'<color\s+name="([^"]+)"\s+value="([^"]+)"\s*/?>', palette_content
        )
        for name, value in color_matches:
            palette[name] = value
    return palette


def resolve_var(name, palette, seen=None):
    if seen is None:
        seen = set()
    if name in seen:
        return name
    seen.add(name)
    value = palette.get(name)
    if value is None:
        return name
    match = re.fullmatch(r"\$\{([^\}]+)\}", value.strip())
    if match:
        ref = match.group(1)
        return resolve_var(ref, palette, seen)
    return value


def preprocess_theme(input_file, output_file, palette_file):
    with open(input_file, "r", encoding="utf-8") as f:
        xml_str = f.read()

    # Load palette from a separate file
    palette = load_palette(palette_file)

    # Step 2: Replace <string>${var}</string> with value and comment
    def string_replacer(match):
        var_name = match.group(1)
        value = resolve_var(var_name, palette)
        return f"<string>{value}</string> <!-- {var_name} -->"

    xml_str = re.sub(r"<string>\$\{([^\}]+)\}</string>", string_replacer, xml_str)

    def generic_replacer(match):
        var_name = match.group(1)
        value = resolve_var(var_name, palette)
        return value

    xml_str = re.sub(r"\$\{([^\}]+)\}", generic_replacer, xml_str)

    # Optionally remove palette section from theme (if it exists)
    xml_str = re.sub(r"<palette>.*?</palette>", "", xml_str, flags=re.DOTALL)

    with open(output_file, "w", encoding="utf-8") as out:
        out.write(xml_str)


if __name__ == "__main__":
    # Usage: python ththeme-preprocessor.py theme.xml output.xml palette.xml
    input_file = sys.argv[1] if len(sys.argv) > 1 else "input.thTheme.xml"
    output_file = sys.argv[2] if len(sys.argv) > 2 else "output.thTheme.xml"
    palette_file = sys.argv[3] if len(sys.argv) > 3 else "palette.xml"
    preprocess_theme(input_file, output_file, palette_file)
