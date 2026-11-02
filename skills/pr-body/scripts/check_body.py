#!/usr/bin/env python3
"""Reject prose newlines that GitHub PR bodies render as hard line breaks."""
import argparse
import re
from pathlib import Path


def violations(body):
    issues = []
    prose = False
    fence = None
    comment = False
    for number, line in enumerate(body.splitlines(), 1):
        stripped = line.strip()
        if comment or stripped.startswith('<!--'):
            comment = '-->' not in stripped
            prose = False
            continue
        marker = re.match(r'^\s*(`{3,}|~{3,})', line)
        if marker:
            token = marker.group(1)
            if fence is None:
                fence = token[0]
            elif token[0] == fence:
                fence = None
            prose = False
            continue
        if fence:
            continue
        if not stripped or re.match(r'^(#{1,6}\s|>|\||(?:[-*_]\s*){3,}$)', stripped):
            prose = False
            continue
        item = re.match(r'^\s*(?:[-*+] |\d+[.)] )', line)
        if prose and not item:
            issues.append((number, 'Prose continues on another source line. Join the paragraph or list-item text with spaces.'))
        if line.endswith('  ') or line.endswith('\\') or re.search(r'<br\s*/?>', line, re.I):
            issues.append((number, 'Explicit prose line break. Use a paragraph or list structure instead.'))
        prose = True
    return issues


def selftest():
    assert violations('First sentence.\nSecond sentence.\n')
    assert not violations('First sentence. Second sentence.\n\nAnother paragraph.\n')
    assert violations('- First sentence.\n  Second sentence.\n')
    assert not violations('- First sentence. Second sentence.\n- Another item.\n')
    assert not violations('```ts\nfirst()\nsecond()\n```\n\n## Heading\n\nA paragraph.\n')
    assert not violations('| Column | Other |\n| --- | --- |\n| A | B |\n')
    assert not violations('<!--\nmetadata\n-->\n\nA paragraph.\n')
    assert violations('A paragraph.<br>Next sentence.')
    print('Formatting self-tests passed.')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('draft', nargs='?', type=Path)
    parser.add_argument('--selftest', action='store_true')
    args = parser.parse_args()
    if args.selftest:
        selftest()
        return
    if args.draft is None:
        parser.error('provide a draft file or --selftest')
    issues = violations(args.draft.read_text())
    for line, message in issues:
        print(f'{args.draft}:{line}: {message}')
    if issues:
        raise SystemExit(1)
    print('PR body paragraph formatting passed.')


if __name__ == '__main__':
    main()
