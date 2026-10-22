#!/bin/sh
# JavaParserをクラスパスに載せて、Javaの1ファイルを直接実行する。終了コードを末尾に付ける
d="$(cd "$(dirname "$0")" && pwd)"
java -cp "$d/lib/javaparser-core-3.28.2.jar" "$d/java/$1" 2>&1
echo "exit code: $?"
