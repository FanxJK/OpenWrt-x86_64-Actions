#!/bin/sh
set -eu

fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }
[ "$#" -eq 1 ] || fail 'Usage: sh custom-vantage.sh <luci-theme-vantage source directory>'
theme=$1
d="$theme/ucode/template/themes/vantage"
a="$theme/htdocs/luci-static/vantage"
h="$d/header.ut"
l="$d/sysauth.ut"
c="$a/vantage.css"
for f in "$h" "$l" "$c"; do
    [ -s "$f" ] || fail "Missing or empty file: $f"
done
if [ ! -w "$d" ] || [ ! -w "$a" ]; then
    fail 'Theme source directories are not writable.'
fi
grep -Fq 'class="vt-brand-tile"' "$h" || fail 'Unexpected header.ut structure; no files changed.'
grep -Fq 'class="vt-brand-tile"' "$l" || fail 'Unexpected sysauth.ut structure; no files changed.'
for token in accent accent-hover accent-ink accent-text accent-soft accent-line focus v-chart-1; do
    grep -Fq -- "--$token:" "$c" || fail "Missing theme variable --$token; no files changed."
done

umask 022
work=$(mktemp -d "${TMPDIR:-/tmp}/vantage-blue.XXXXXX") || fail 'Unable to create a temporary directory.'
cleanup() {
    rm -f "$h.blue-tmp.$$" "$l.blue-tmp.$$" "$c.blue-tmp.$$" "$a/logo.svg.blue-tmp.$$"
    rm -rf "$work"
}
trap cleanup 0
trap 'exit 130' INT
trap 'exit 143' TERM

body='<rect x="1" y="1" width="30" height="30" rx="7" class="vt-brand-tile"/><path d="M9.2 16.2a7.6 7.6 0 1 0 13.6 0" class="vt-iw-ring"/><path d="M7.5 10.5q8.5-7 17 0M10.5 13.8q5.5-4.8 11 0M13.5 17q2.5-2.2 5 0" class="vt-iw-waves"/><circle cx="16" cy="20.8" r="1.35" class="vt-brand-dot"/>'

# Update header and login logos.
for page in header sysauth; do
    awk -v body="$body" -v page="$page" '
        function mark(size, cls) {
            return "<svg" cls " viewBox=\"0 0 32 32\" width=\"" size "\" height=\"" size "\" aria-hidden=\"true\" data-iw-logo=\"1\">" body "</svg>"
        }
        {
            if (page == "header" && index($0, "class=\"vt-brand vt-brand-static\"")) small = 1
            if (index($0, "class=\"vt-brand-tile\"")) {
                size = page == "sysauth" ? 44 : (small ? 28 : 32)
                cls = page == "sysauth" ? " class=\"vt-login-mark\"" : ""
                sub(/<svg .*<\/svg>/, mark(size, cls))
            }
            print
            if (small && index($0, "</span>")) small = 0
        }
    ' "$d/$page.ut" > "$work/$page.ut"
done

[ "$(grep -Fc 'data-iw-logo="1"' "$work/header.ut")" = 2 ] || fail 'Unexpected header logo structure; no files changed.'
[ "$(grep -Fc 'data-iw-logo="1"' "$work/sysauth.ut")" = 1 ] || fail 'Unexpected login logo structure; no files changed.'

# Generate the favicon.
cat > "$work/logo.svg" <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
<style>
.vt-brand-tile{fill:#fff;stroke:#c1c7ce;stroke-width:1}
.vt-iw-ring,.vt-iw-waves{fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
.vt-iw-ring{stroke:#14171a}.vt-iw-waves{stroke:#1d4ed8}.vt-brand-dot{fill:#1d4ed8}
@media(prefers-color-scheme:dark){.vt-brand-tile{fill:#16181b;stroke:#353a41}.vt-iw-ring{stroke:#e8eaed}.vt-iw-waves{stroke:#93c5fd}.vt-brand-dot{fill:#93c5fd}}
</style>
SVG
printf '%s\n' "$body" '</svg>' >> "$work/logo.svg"

# Replace the palette override block.
begin_count=$(grep -Fc '/* IMMORTALWRT_BLUE_BEGIN */' "$c" || :)
end_count=$(grep -Fc '/* IMMORTALWRT_BLUE_END */' "$c" || :)
[ "$begin_count" = "$end_count" ] || fail 'Incomplete blue palette markers; no files changed.'
[ "$begin_count" -le 1 ] || fail 'Duplicate blue palette blocks; no files changed.'
sed '/^\/\* IMMORTALWRT_BLUE_BEGIN \*\/$/,/^\/\* IMMORTALWRT_BLUE_END \*\/$/d' "$c" > "$work/vantage.css"
cat >> "$work/vantage.css" <<'CSS'
/* IMMORTALWRT_BLUE_BEGIN */
:root {
    --accent: #2563eb;
    --accent-hover: #1d4ed8;
    --accent-ink: #ffffff;
    --accent-text: #1d4ed8;
    --accent-soft: rgba(37, 99, 235, .10);
    --accent-line: #3b82f6;
    --focus: #2563eb;
    --ok: #0878ba;
    --ok-text: #075f99;
    --ok-soft: rgba(8, 120, 186, .11);
    --v-chart-1: #2563eb;
    --v-chart-2: #0891b2;
}
html[data-darkmode="true"] {
    --accent: #60a5fa;
    --accent-hover: #93c5fd;
    --accent-ink: #081b34;
    --accent-text: #93c5fd;
    --accent-soft: rgba(96, 165, 250, .12);
    --accent-line: rgba(96, 165, 250, .50);
    --focus: #60a5fa;
    --ok: #38bdf8;
    --ok-text: #7dd3fc;
    --ok-soft: rgba(56, 189, 248, .12);
    --v-chart-1: #60a5fa;
    --v-chart-2: #22d3ee;
}
html[data-darkmode="true"] .vt-login-page {
    background:
        radial-gradient(900px 520px at 50% 0%, rgba(96, 165, 250, .09), transparent 60%),
        linear-gradient(rgba(255, 255, 255, .025) 1px, transparent 1px) 0 0 / 32px 32px,
        linear-gradient(90deg, rgba(255, 255, 255, .025) 1px, transparent 1px) 0 0 / 32px 32px,
        var(--bg);
}
.vt-iw-ring, .vt-iw-waves {
    fill: none;
    stroke-width: 1.8;
    stroke-linecap: round;
    stroke-linejoin: round;
}
.vt-iw-ring { stroke: var(--text); }
.vt-iw-waves { stroke: var(--accent-text); }
/* IMMORTALWRT_BLUE_END */
CSS

# Atomically replace each file.
install_file() {
    source=$1
    target=$2
    tmp="$target.blue-tmp.$$"
    cp "$source" "$tmp"
    chmod 644 "$tmp"
    mv -f "$tmp" "$target"
}
install_file "$work/logo.svg" "$a/logo.svg"
install_file "$work/vantage.css" "$c"
install_file "$work/header.ut" "$h"
install_file "$work/sysauth.ut" "$l"

grep -Fq -- '--accent: #2563eb;' "$c"
grep -Fq -- '--accent: #60a5fa;' "$c"
[ -s "$a/logo.svg" ]
printf '%s\n' 'Vantage source customized: ImmortalWrt icons, inline SVG, original logo.svg, blue palette.'
