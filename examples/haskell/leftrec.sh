#!/bin/sh
# LeftRec.hsをスタック16MBで実行する。中間ファイルは一時ディレクトリに置き、終わったら消す
d="$(cd "$(dirname "$0")" && pwd)"
t="$(mktemp -d)"
direnv exec ~/atcoder ghc -O0 -v0 -rtsopts -outputdir "$t" -o "$t/LeftRec" "$d/LeftRec.hs" 2>/dev/null
timeout 20 "$t/LeftRec" +RTS -K16m >"$t/out" 2>&1
e=$?
sed "s|$t/||" "$t/out"
rm -rf "$t"
echo "exit code: $e"
