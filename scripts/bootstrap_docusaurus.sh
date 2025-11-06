#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  script_name=$(basename "$0")
  echo "Usage: $script_name <title> <tagline>" >&2
  exit 1
fi

TITLE=$1
TAGLINE=$2

CONFIG_FILE="docusaurus.config.ts"
DOCS_DIR="docs"
DEFAULT_DOC="$DOCS_DIR/index.md"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: $CONFIG_FILE not found in $(pwd)" >&2
  exit 1
fi

mkdir -p "$DOCS_DIR"

node - "$CONFIG_FILE" "$TITLE" "$TAGLINE" <<'NODE'
const fs = require('fs');
const path = require('path');

const [, , configPath, title, tagline] = process.argv;
const resolved = path.resolve(configPath);

if (!fs.existsSync(resolved)) {
  console.error(`Config file not found: ${resolved}`);
  process.exit(1);
}

let content = fs.readFileSync(resolved, 'utf8');

const escapeSingleQuotes = (value) => value.replace(/\\/g, '\\\\').replace(/'/g, "\\'");

const replacements = [
  {
    pattern: /title:\s*'[^']*'/,
    replacement: `title: '${escapeSingleQuotes(title)}'`,
  },
  {
    pattern: /tagline:\s*'[^']*'/,
    replacement: `tagline: '${escapeSingleQuotes(tagline)}'`,
  },
  {
    pattern: /(navbar:\s*{\s*\n\s*)title:\s*'[^']*'/,
    replacement: (_match, prefix) => `${prefix}title: '${escapeSingleQuotes(title)}'`,
  },
];

replacements.forEach(({pattern, replacement}) => {
  content = content.replace(pattern, replacement);
});

if (/blog:\s*{/.test(content)) {
  content = content.replace(/blog:\s*{[\s\S]*?},(\n\s*theme:)/, "blog: false,$1");
} else if (!/blog:\s*false/.test(content)) {
  const presetPattern = /(docs:\s*{[\s\S]*?})(\n\s*theme:\s*{)/;
  if (presetPattern.test(content)) {
    content = content.replace(presetPattern, (_match, docsBlock, themeBlock) => {
      return `${docsBlock}\n        blog: false,${themeBlock}`;
    });
  }
}

const docsBlockPattern = /(docs:\s*{[\s\S]*?)(\n\s*},)/;
content = content.replace(docsBlockPattern, (match, body, closing) => {
  if (/routeBasePath\s*:/.test(body)) {
    return match;
  }
  const withInsertion = body.replace(/(sidebarPath:[^\n]*\n)/, `$1          routeBasePath: '/',\n`);
  if (withInsertion !== body) {
    return withInsertion + closing;
  }
  return `${body}\n          routeBasePath: '/',${closing}`;
});

fs.writeFileSync(resolved, content);
NODE

python3 - "$DEFAULT_DOC" "$TITLE" "$TAGLINE" <<'PY'
import json
import sys
from pathlib import Path

doc_path, title, tagline = sys.argv[1:4]

content = (
    "---\n"
    f"title: {json.dumps(title)}\n"
    f"description: {json.dumps(tagline)}\n"
    "slug: /\n"
    "---\n\n"
    f"# {title}\n\n"
    f"{tagline}\n"
)

Path(doc_path).write_text(content, encoding="utf-8")
PY

echo "Updated $CONFIG_FILE and wrote $DEFAULT_DOC"
