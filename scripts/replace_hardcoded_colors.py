#!/usr/bin/env python3
"""
Replace hardcoded Color(0xFF...) values with AppColors references in Dart files.

Usage:
  python3 scripts/replace_hardcoded_colors.py --dry-run   # Preview changes
  python3 scripts/replace_hardcoded_colors.py              # Apply changes

Only replaces colors used in button/widget contexts (backgroundColor, foregroundColor).
Does NOT touch scaffold backgrounds, container backgrounds, or gradient colors
unless they match known AppColors values.
"""

import re
import os
import sys
from pathlib import Path

DRY_RUN = "--dry-run" in sys.argv

# Map hardcoded hex → AppColors constant
# Group similar shades that should all become one AppColors reference
COLOR_MAP = {
    # Primary blue buttons (various shades of light blue → AppColors.primary)
    "0xFF87C4F2": "AppColors.primary",
    "0xFF8CC8F5": "AppColors.primary",
    "0xFF8CCFF0": "AppColors.primary",
    "0xFF89CFF0": "AppColors.primary",
    "0xFF88C6E0": "AppColors.primary",
    "0xFF88CBE6": "AppColors.primary",
    "0xFF8EC9F5": "AppColors.primary",
    "0xFF8CCFF0": "AppColors.primary",

    # Error / destructive red → AppColors.error
    "0xFFEF4444": "AppColors.error",
    "0xFFE74C3C": "AppColors.error",

    # Danger red (darker, for destructive actions) → AppColors.error
    "0xFFD92D20": "AppColors.error",

    # Success green → AppColors.success
    "0xFF22C55E": "AppColors.success",
    "0xFF10B981": "AppColors.success",

    # Warning → AppColors.warning
    "0xFFF59E0B": "AppColors.warning",

    # Dark button → AppColors.buttonDark
    "0xFF1D2939": "AppColors.buttonDark",
    "0xFF1F2937": "AppColors.buttonDark",

    # Secondary blue → AppColors.secondary
    "0xFF4090B8": "AppColors.secondary",
    "0xFF4BA8C8": "AppColors.secondary",
    "0xFF00A3E0": "AppColors.secondary",

    # Background color → AppColors.background
    "0xFFD6EDF6": "AppColors.background",
    "0xFFE6F4FB": "AppColors.background",

    # Soft background surfaces (light blue tints used as screen/card bg)
    "0xFFF3FAFD": "AppColors.surfaceTint",
    "0xFFF0F9FF": "AppColors.surfaceTint",
    "0xFFF2F9FF": "AppColors.surfaceTint",
    "0xFFE7F5FC": "AppColors.surfaceTint",
    "0xFFEAF6FF": "AppColors.surfaceTint",
    "0xFFE0F2F9": "AppColors.surfaceTint",
    "0xFFD6F0FA": "AppColors.surfaceTint",
    "0xFFE4F4FC": "AppColors.surfaceTint",
    "0xFFEAF6FF": "AppColors.surfaceTint",

    # Coral accent
    "0xFFE8896B": "AppColors.coralAccent",

    # Text primary
    "0xFF1A3A4A": "AppColors.textPrimary",

    # Input border
    "0xFFE0E8EC": "AppColors.inputBorder",
}

# Patterns where we should replace Color(...) references
# These are the contexts where hardcoded colors appear in button/widget styling
CONTEXT_PATTERN = re.compile(
    r'(?:const\s+)?Color\((0xFF[A-Fa-f0-9]{6})\)'
)

def process_file(filepath: Path) -> list[tuple[int, str, str]]:
    """Process a single Dart file. Returns list of (line_num, old_line, new_line)."""
    changes = []
    content = filepath.read_text()
    lines = content.split('\n')

    for i, line in enumerate(lines):
        new_line = line
        for match in CONTEXT_PATTERN.finditer(line):
            hex_val = match.group(1).upper()
            # Normalize to 0xFF... format
            normalized = "0xFF" + hex_val[4:]
            if normalized in COLOR_MAP:
                old_expr = match.group(0)  # e.g. "const Color(0xFF87C4F2)" or "Color(0xFF87C4F2)"
                new_expr = COLOR_MAP[normalized]
                new_line = new_line.replace(old_expr, new_expr)

        if new_line != line:
            changes.append((i + 1, line.strip(), new_line.strip()))
            lines[i] = new_line

    if changes and not DRY_RUN:
        new_content = '\n'.join(lines)
        # Ensure core import exists
        if "package:core/core.dart" not in new_content:
            # Add import after first import line
            import_added = False
            for j, line in enumerate(lines):
                if line.startswith("import "):
                    lines.insert(j, "import 'package:core/core.dart';")
                    import_added = True
                    break
            if not import_added:
                lines.insert(0, "import 'package:core/core.dart';")
            new_content = '\n'.join(lines)
        filepath.write_text(new_content)

    return changes


def main():
    lib_dir = Path("apps/babysitter_app/lib")
    if not lib_dir.exists():
        lib_dir = Path("lib")
    if not lib_dir.exists():
        print("Error: Cannot find lib directory. Run from babysitter-flutter-app root.")
        sys.exit(1)

    dart_files = sorted(lib_dir.rglob("*.dart"))
    total_changes = 0
    files_changed = 0

    print(f"{'[DRY RUN] ' if DRY_RUN else ''}Scanning {len(dart_files)} Dart files...\n")

    # Track which new AppColors constants are needed
    new_constants_needed = set()

    for filepath in dart_files:
        changes = process_file(filepath)
        if changes:
            files_changed += 1
            total_changes += len(changes)
            print(f"  {filepath}")
            for line_num, old, new in changes:
                print(f"    L{line_num}: {old}")
                print(f"        → {new}")
                # Track new constants
                for val in COLOR_MAP.values():
                    if val in new and val.split('.')[-1] not in (
                        'primary', 'primarySoft', 'secondary', 'coralAccent',
                        'background', 'surface', 'error', 'warning', 'success',
                        'buttonDark', 'textPrimary', 'inputBorder', 'textOnButton',
                    ):
                        new_constants_needed.add(val)
            print()

    print(f"{'[DRY RUN] ' if DRY_RUN else ''}Summary: {total_changes} replacements across {files_changed} files")

    if new_constants_needed:
        print(f"\n⚠️  New AppColors constants needed in app_colors.dart:")
        for c in sorted(new_constants_needed):
            name = c.split('.')[-1]
            # Find the hex values that map to this constant
            hexes = [k for k, v in COLOR_MAP.items() if v == c]
            print(f"  static const Color {name} = Color({hexes[0]});  // from {', '.join(hexes)}")


if __name__ == "__main__":
    main()
