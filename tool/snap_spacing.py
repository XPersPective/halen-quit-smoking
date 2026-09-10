# -*- coding: utf-8 -*-
"""Snaps spacing literals onto the token scale (premium brief §A.6).

The codebase had ten spacing values in circulation — 4, 6, 8, 10, 12, 14, 16,
18, 20, 24, 28 — none of them wrong alone and all of them wrong together. The
eye reads an unrhythmic layout as unfinished long before anyone can name why.

The rule this applies, deliberately narrow so it cannot damage geometry:

  * only `SizedBox(height: N)` / `SizedBox(width: N)` and `EdgeInsets.all(N)`,
    `EdgeInsets.symmetric(...)`, `EdgeInsets.fromLTRB(...)`;
  * only values of 48 or less — above that a number is a *size* (a chart
    height, an avatar) rather than a gap, and snapping it would be wrong;
  * nearest token, ties rounding up, so the layout gains air rather than
    losing it.

Run once; after that the tokens are what get edited.
"""
import io
import os
import re
import sys

SCALE = [
    (4, 'HalenSpace.x1'),
    (8, 'HalenSpace.x2'),
    (12, 'HalenSpace.x3'),
    (16, 'HalenSpace.x4'),
    (20, 'HalenSpace.x5'),
    (24, 'HalenSpace.x6'),
    (32, 'HalenSpace.x8'),
    (48, 'HalenSpace.x12'),
]
MAX = 48


def token_for(value):
    best = None
    for size, name in SCALE:
        distance = abs(size - value)
        # Ties round up: prefer the larger token.
        if best is None or distance < best[0] or (distance == best[0] and size > best[1]):
            best = (distance, size, name)
    return best[2]


SIZED = re.compile(r'SizedBox\((height|width): (\d+)(?:\.0)?\)')
ALL = re.compile(r'EdgeInsets\.all\((\d+)(?:\.0)?\)')
SYM = re.compile(
    r'EdgeInsets\.symmetric\(\s*(horizontal|vertical): (\d+)(?:\.0)?,?\s*\)')


def snap_number(match_value):
    value = int(match_value)
    return None if value > MAX else token_for(value)


def convert(text):
    changed = [0]

    def sized(m):
        token = snap_number(m.group(2))
        if token is None:
            return m.group(0)
        changed[0] += 1
        return 'SizedBox(%s: %s)' % (m.group(1), token)

    def all_(m):
        token = snap_number(m.group(1))
        if token is None:
            return m.group(0)
        changed[0] += 1
        return 'EdgeInsets.all(%s)' % token

    def sym(m):
        token = snap_number(m.group(2))
        if token is None:
            return m.group(0)
        changed[0] += 1
        return 'EdgeInsets.symmetric(%s: %s)' % (m.group(1), token)

    text = SIZED.sub(sized, text)
    text = ALL.sub(all_, text)
    text = SYM.sub(sym, text)
    return text, changed[0]


def ensure_import(text, path):
    if 'HalenSpace' not in text or 'design/tokens.dart' in text:
        return text
    depth = path.replace('\\', '/').split('/')
    # lib/presentation/... -> how far back to lib/core
    up = '../' * (len(depth) - 2)
    directive = "import '%score/design/tokens.dart';\n" % up
    lines = text.split('\n')
    last_import = max(
        (i for i, line in enumerate(lines) if line.startswith('import ')),
        default=-1)
    if last_import < 0:
        return text
    lines.insert(last_import + 1, directive.rstrip('\n'))
    return '\n'.join(lines)


def main():
    total_files = 0
    total_changes = 0
    for root, _dirs, files in os.walk('lib/presentation'):
        for name in files:
            if not name.endswith('.dart') or name.endswith('.g.dart'):
                continue
            path = os.path.join(root, name).replace('\\', '/')
            original = io.open(path, encoding='utf-8').read()
            converted, changes = convert(original)
            if changes == 0:
                continue
            converted = ensure_import(converted, path)
            io.open(path, 'w', encoding='utf-8').write(converted)
            total_files += 1
            total_changes += changes
            sys.stdout.write('%s: %d\n' % (path, changes))
    sys.stdout.write('\n%d files, %d literals snapped\n'
                     % (total_files, total_changes))


if __name__ == '__main__':
    main()
