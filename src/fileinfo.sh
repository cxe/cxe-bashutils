
# Detects file type and metadata
#
# Populates the global associative array `fileinfo` with information about a given file.
# - Determines file existence, name, and type via:
#   * File name (e.g. Makefile, Dockerfile)
#   * File extension (normalized and mapped)
#   * Shebang line interpreter
#   * MIME type via `file` command
#   * Magic bytes (first 4 bytes, hex-encoded)
# - Supports symlinks and distinguishes between empty and existing files.
#
# Usage:
#   fileinfo "/path/to/file"
#   echo "${fileinfo[type]}"  # => e.g. "python", "text", "image", ...
fileinfo() {
  declare file="$1" magic mime exists=false
  declare -gxA fileinfo=([exists]="" [type]="" [name]="")
  [[ -z "$file" ]] && return 1
  local basename="${file##*/}" && fileinfo[name]="$basename"
  if [ -e "$file" ]; then
    fileinfo[exists]=empty;
    [[ -s "$file" ]] && exists=true && fileinfo[exists]=exists
    [[ -d "$file" ]] && { fileinfo[type]="directory"; return; }
    [[ -L "$file" ]] && file=$(readlink "$file")
  fi

  local ext="" double_ext=""
  if [[ "$basename" == *.* ]]; then
    ext="${basename##*.}" && ext="${ext,,}"
    double_ext="$ext" && [[ "$basename" =~ \.([^.]+)\.([^.]+)$ ]] && double_ext="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
    [[ "$basename" == "$ext" ]] && ext=""
    [[ "$basename" == "$double_ext" ]] && double_ext=""
  fi

  [[ -n "${FILETYPE_EXT_NORMALIZED[$double_ext]}" ]] && ext="${FILETYPE_EXT_NORMALIZED[$double_ext]}"
  [[ -n "${FILETYPE_EXT_NORMALIZED[$ext]}" ]] && ext="${FILETYPE_EXT_NORMALIZED[$ext]}"

  $exists && {
    local shebang interpreter
    [[ -r "$file" ]] && read -r shebang < "$file"
    [[ "$shebang" =~ ^#! ]] && {
      interpreter="${shebang#\#!}"
      interpreter="${interpreter%% *}"
      interpreter="${interpreter##*/}"
      [[ -n "${FILETYPE_BY_SHEBANG[$interpreter]}" ]] && fileinfo[type]="${FILETYPE_BY_SHEBANG[$interpreter]}" && return
    }
  }

  [[ -n "${FILETYPE_BY_NAME[$basename]}" ]] && fileinfo[type]="${FILETYPE_BY_NAME[$basename]}" && return
  [[ -n "${FILETYPE_BY_EXT[$ext]}" ]] && fileinfo[type]="${FILETYPE_BY_EXT[$ext]}" && return

  $exists && {
    mime=$(file --mime-type -b "$file" 2>/dev/null)
    [[ -n "${FILETYPE_BY_MIME[$mime]}" ]] && fileinfo[type]="${FILETYPE_BY_MIME[$mime]}" && return

    magic=$(head -c 4 "$file" | hexdump -v -e '1/1 "%02x"')
    [[ -n "${FILETYPE_BY_MAGIC[$magic]}" ]] && fileinfo[type]="${FILETYPE_BY_MAGIC[$magic]}" && return
  }
}

declare -gxA FILETYPE_BY_NAME=(
  # --- Build systems ---
  [Makefile]=make
  [CMakeLists.txt]=cmake
  [Dockerfile]=docker
  [Jenkinsfile]=groovy
  [Rakefile]=ruby
  [Gemfile]=ruby
  [Vagrantfile]=ruby
  [Procfile]=text
  [SConstruct]=python
  [SConscript]=python
  [stack.yaml]=yaml

  # --- Shell scripts and infra ---
  [envrc]=text
  [.env]=dotenv
  [.env.example]=dotenv
  [rust-toolchain]=text

  # --- Dotfiles and meta ---
  [.editorconfig]=ini
  [.gitignore]=text
  [.gitattributes]=text
  [LICENSE]=text
  [README]=text
  [CHANGELOG]=text
)

declare -gxA FILETYPE_EXT_NORMALIZED=(
  # --- JavaScript / TypeScript / Web ---
  [spec.js]=js
  [test.js]=js
  [min.js]=js
  [bundle.js]=js
  [mjs]=js
  [cjs]=js
  [jsx]=js
  [tsx]=ts
  [d.ts]=ts

  # --- Config / Markup normalization ---
  [yaml]=yml
  [conf]=ini
  [cfg]=ini
  [htm]=html
  [xhtml]=html
  [mdown]=md
  [markdown]=md
  [ad]=adoc

  # --- Archives & compression ---
  [tgz]=gz
  [tbz]=bz2
  [tbz2]=bz2
  [tlz]=lzma
  [txz]=xz
  [z]=gz
  [tar.gz]=tar
  [tar.bz2]=tar
  [tar.xz]=tar
  [tar.zst]=tar
  [rar4]=rar

  # --- Image formats (normalization) ---
  [jpeg]=jpg
  [jpe]=jpg
  [jfif]=jpg
  [tiff]=tif
  [svgz]=svg
  [ico]=png
  [bmp]=png

  # --- Audio formats ---
  [oga]=ogg
  [m4a]=mp4
  [opus]=ogg
  [wma]=mp3
  [aiff]=wav
  [weba]=webm

  # --- Video formats ---
  [m4v]=mp4
  [webm]=mp4
  [mov]=mp4
  [wmv]=mp4
  [flv]=mp4
  [avi]=mp4

  # --- Fonts ---
  [woff2]=woff
  [ttc]=ttf

  # --- Other ---
  [gdoc]=docx
  [gsheet]=xlsx
  [gslides]=pptx
  [sqlite3]=sqlite
)

declare -gxA FILETYPE_BY_EXT=(
  # --- Scripting & programming ---
  [sh]=bash [bash]=bash [zsh]=zsh [py]=python [rb]=ruby
  [php]=php [pl]=perl [lua]=lua [js]=javascript [ts]=typescript
  [c]=c [h]=c [cpp]=cpp [cc]=cpp [cxx]=cpp [hpp]=cpp
  [java]=java [scala]=scala [go]=go [rs]=rust
  [groovy]=groovy [gradle]=groovy [kt]=kotlin [kts]=kotlin
  [r]=r [swift]=swift [m]=objective-c [cs]=csharp

  # --- Config / Markup / Templates ---
  [yml]=yaml [yaml]=yaml [json]=json [toml]=toml
  [ini]=ini [cfg]=ini [env]=dotenv [conf]=ini
  [html]=html [htm]=html [xml]=xml [svg]=xml
  [md]=markdown [rst]=restructuredtext [adoc]=asciidoc
  [tex]=latex

  # --- Styles / Layout ---
  [css]=css [scss]=css [sass]=css [less]=css

  # --- Shell/environment ---
  [service]=systemd [unit]=systemd [desktop]=freedesktop

  # --- Containers / Infrastructure ---
  [dockerfile]=docker [compose]=yaml [tf]=terraform [tfvars]=terraform
  [nix]=nix

  # --- Archives / Compression ---
  [zip]=zip [tar]=tar [gz]=gzip [tgz]=gzip [xz]=xz
  [bz2]=bzip2 [7z]=7z [rar]=rar
  [iso]=iso [img]=diskimage

  # --- Documents ---
  [pdf]=pdf [doc]=word [docx]=word
  [xls]=excel [xlsx]=excel [ppt]=powerpoint [pptx]=powerpoint
  [odt]=openoffice [ods]=openoffice [odp]=openoffice
  [rtf]=rtf [txt]=text [log]=text

  # --- Images ---
  [jpg]=image [jpeg]=image [png]=image [gif]=image [bmp]=image
  [webp]=image [tif]=image [tiff]=image [ico]=image
  [heic]=image [svg]=vector

  # --- Audio ---
  [mp3]=audio [wav]=audio [flac]=audio [aac]=audio [ogg]=audio
  [m4a]=audio [wma]=audio [opus]=audio [aiff]=audio

  # --- Video ---
  [mp4]=video [mkv]=video [mov]=video [avi]=video
  [flv]=video [wmv]=video [webm]=video [m4v]=video

  # --- Fonts ---
  [ttf]=font [otf]=font [woff]=font [woff2]=font

  # --- Data & Serialization ---
  [csv]=csv [tsv]=csv [xls]=excel [xlsx]=excel
  [parquet]=parquet [orc]=orc [avro]=avro
  [ndjson]=jsonl [jsonl]=jsonl [msgpack]=msgpack [protobuf]=protobuf
  [db]=sqlite [sqlite]=sqlite

  # --- Executables & Binaries ---
  [exe]=exe [dll]=dll [so]=sharedlib [dylib]=sharedlib
  [bin]=binary [elf]=elf [appimage]=appimage

  # --- Code packaging / metadata ---
  [lock]=lockfile [pkg]=package [deb]=deb [rpm]=rpm

  # --- Misc ---
  [pem]=pem [crt]=cert [cer]=cert [key]=key
  [asc]=pgp [sig]=signature [sha256]=checksum
)

declare -gxA FILETYPE_BY_SHEBANG=(
  # --- Shells ---
  [sh]=bash
  [bash]=bash
  [zsh]=zsh
  [dash]=bash
  [ksh]=ksh
  [fish]=fish
  [xonsh]=python

  # --- Python ecosystem ---
  [python]=python
  [python3]=python
  [python2]=python
  [ipython]=python
  [pypy]=python

  # --- JavaScript / TypeScript ---
  [node]=javascript
  [nodejs]=javascript
  [ts-node]=typescript
  [deno]=typescript

  # --- JVM-based ---
  [groovy]=groovy
  [groovysh]=groovy
  [groovyConsole]=groovy
  [java]=java
  [kotlin]=kotlin
  [kotlinc]=kotlin
  [clojure]=clojure
  [lein]=clojure
  [gradle]=groovy

  # --- Ruby & Perl ---
  [ruby]=ruby
  [irb]=ruby
  [perl]=perl

  # --- PHP / Lua / Tcl ---
  [php]=php
  [lua]=lua
  [luajit]=lua
  [tclsh]=tcl
  [expect]=tcl

  # --- Functional languages ---
  [racket]=scheme
  [guile]=scheme
  [sbcl]=lisp
  [clisp]=lisp
  [ocaml]=ocaml
  [haskell]=haskell
  [runghc]=haskell
  [ghc]=haskell

  # --- Systems languages ---
  [go]=go
  [cargo]=rust
  [rustc]=rust
  [zig]=zig
  [nim]=nim

  # --- Data processing / notebooks ---
  [Rscript]=r
  [R]=r
  [stata]=stata
  [julia]=julia

  # --- Nix / Infra / CI ---
  [nix-shell]=nix
  [terraform]=terraform
  [ansible-playbook]=yaml
  [ansible]=yaml

  # --- Build systems / meta tools ---
  [make]=make
  [cmake]=cmake
  [ninja]=ninja
  [scons]=python
  [meson]=python
)

declare -gxA FILETYPE_BY_MIME=(
  # --- Shell and scripting ---
  [text/x-shellscript]=bash
  [text/x-sh]=bash
  [application/x-sh]=bash
  [text/x-zsh]=zsh
  [text/x-ksh]=ksh
  [text/x-script.zsh]=zsh
  [application/x-csh]=csh
  [text/x-python]=python
  [application/x-python-code]=python
  [application/x-py]=python
  [text/x-perl]=perl
  [application/x-perl]=perl
  [text/x-ruby]=ruby
  [application/x-ruby]=ruby
  [text/x-php]=php
  [application/x-httpd-php]=php
  [text/x-lua]=lua
  [application/x-lua]=lua
  [text/x-groovy]=groovy
  [application/x-groovy]=groovy

  # --- Compiled / Systems languages ---
  [text/x-c]=c
  [text/x-c++]=cpp
  [text/x-java-source]=java
  [text/x-objective-c]=objective-c
  [application/x-rust]=rust
  [text/x-scala]=scala
  [text/x-haskell]=haskell
  [application/x-go]=go
  [application/x-kotlin]=kotlin
  [text/x-clojure]=clojure
  [text/x-nim]=nim

  # --- Web & frontend ---
  [application/javascript]=javascript
  [text/javascript]=javascript
  [application/x-javascript]=javascript
  [application/ecmascript]=javascript
  [text/ecmascript]=javascript
  [application/typescript]=typescript
  [text/typescript]=typescript
  [text/html]=html
  [application/xhtml+xml]=html
  [text/css]=css
  [application/json]=json
  [application/ld+json]=json
  [application/xml]=xml
  [text/xml]=xml
  [application/rss+xml]=xml
  [application/atom+xml]=xml
  [image/svg+xml]=svg

  # --- Config / serialization / data ---
  [application/x-yaml]=yaml
  [text/yaml]=yaml
  [application/toml]=toml
  [application/x-toml]=toml
  [text/x-ini]=ini
  [text/csv]=csv
  [application/csv]=csv
  [application/x-ndjson]=jsonl
  [application/x-parquet]=parquet
  [application/x-avro]=avro
  [application/vnd.apache.orc]=orc
  [application/x-protobuf]=protobuf
  [application/x-msgpack]=msgpack

  # --- Documents ---
  [application/pdf]=pdf
  [application/msword]=word
  [application/vnd.openxmlformats-officedocument.wordprocessingml.document]=word
  [application/vnd.ms-excel]=excel
  [application/vnd.openxmlformats-officedocument.spreadsheetml.sheet]=excel
  [application/vnd.ms-powerpoint]=powerpoint
  [application/vnd.openxmlformats-officedocument.presentationml.presentation]=powerpoint
  [application/rtf]=rtf
  [text/plain]=text
  [text/markdown]=markdown
  [application/vnd.oasis.opendocument.text]=openoffice
  [application/vnd.oasis.opendocument.spreadsheet]=openoffice
  [application/vnd.oasis.opendocument.presentation]=openoffice

  # --- Archives & compression ---
  [application/zip]=zip
  [application/gzip]=gzip
  [application/x-gzip]=gzip
  [application/x-tar]=tar
  [application/x-bzip2]=bzip2
  [application/x-xz]=xz
  [application/x-7z-compressed]=7z
  [application/x-rar-compressed]=rar
  [application/vnd.debian.binary-package]=deb
  [application/x-redhat-package-manager]=rpm

  # --- Images ---
  [image/jpeg]=image
  [image/png]=image
  [image/gif]=image
  [image/bmp]=image
  [image/webp]=image
  [image/heic]=image
  [image/heif]=image
  [image/tiff]=image
  [image/x-icon]=image
  [image/vnd.microsoft.icon]=image
  [image/svg+xml]=svg

  # --- Audio ---
  [audio/mpeg]=audio
  [audio/wav]=audio
  [audio/x-wav]=audio
  [audio/ogg]=audio
  [audio/flac]=audio
  [audio/aac]=audio
  [audio/mp4]=audio
  [audio/webm]=audio
  [audio/x-ms-wma]=audio
  [audio/vnd.wave]=audio
  [audio/x-aiff]=audio

  # --- Video ---
  [video/mp4]=video
  [video/x-matroska]=video
  [video/webm]=video
  [video/quicktime]=video
  [video/x-msvideo]=video
  [video/x-flv]=video
  [video/x-ms-wmv]=video
  [video/x-ms-asf]=video

  # --- Fonts ---
  [font/ttf]=font
  [font/otf]=font
  [font/woff]=font
  [font/woff2]=font
  [application/font-woff]=font
)

declare -gxA FILETYPE_BY_MAGIC=(
  [25504446]=pdf      # %PDF
  [504b0304]=zip      # PK..
  [7f454c46]=elf      # ELF binary
  [89504e47]=png      # PNG
  [ffd8ffe0]=jpg      # JPEG (common header)
  [ffd8ffe1]=jpg      # JPEG (Exif)
  [47494638]=gif      # GIF87a or GIF89a
  [000001ba]=mpeg     # MPEG PS
  [000001b3]=mpeg     # MPEG video
  [1f8b0800]=gzip     # GZIP (some variants)
)
