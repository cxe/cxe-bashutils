#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/../lib/testing"
source "${BASH_SOURCE[0]%/*}/../lib/log"
source "${BASH_SOURCE[0]%/*}/../lib/args"

# bash command call samples
declare -A args_example=(
    ["exit 503"]='-a args=([0]="503") -A opts=()'
    ["ls -la"]='-a args=() -A opts=([l]="1" [a]="1" )'
    ["cd /home/user/documents"]='-a args=([0]="/home/user/documents") -A opts=()'
    ["whoami"]='-a args=() -A opts=()'
    ["id -u -n"]='-a args=() -A opts=([u]="1" [n]="1" )'
    ["mv \"My File (2024).txt\" \"New File [backup].txt\""]='-a args=([0]="My File (2024).txt" [1]="New File [backup].txt") -A opts=()'
    ["touch \"\${FILE:-default.txt}\""]='-a args=([0]="default.txt") -A opts=()'
    ["find / -name \"myfile.txt\""]='-a args=([0]="/") -A opts=([name]="myfile.txt" )'
    ["rm -rf /path/to/directory"]='-a args=([0]="/path/to/directory") -A opts=([r]="1" [f]="1" )'
    ["cp -r source/ destination/"]='-a args=([0]="source/" [1]="destination/") -A opts=([r]="1" )'
    ["grep -e \"error\" -e \"warning\" /var/log/syslog"]='-a args=([0]="/var/log/syslog") -A opts=([e_list]="'\'error\'' '\'warning\''" [e]="warning" )'
    ["awk '{print \$1\"\t\"\$2}' file.txt"]='-a args=([0]="{print \$1\"\\''t\"\$2}" [1]="file.txt") -A opts=()'
    ["sed -i 's/old/new/g' file.txt"]='-a args=([0]="s/old/new/g" [1]="file.txt") -A opts=([i]="1" )'
    ["cut -d ',' -f1-3 data.csv"]='-a args=([0]="data.csv") -A opts=([f]="1-3" [d]="," )'
    ["diff -u file1.txt file2.txt"]='-a args=([0]="file1.txt" [1]="file2.txt") -A opts=([u]="1" )'
    ["json --engines.node=21 engines"]='-a args=([0]="engines") -A opts=([engines.node]="21" )'
    ["ping -4 -c 4 google.com"]='-a args=([0]="google.com") -A opts=([4]="1" [c]="4" )'
    ["curl -X GET https://api.example.com/data"]='-a args=([0]="GET" [1]="https://api.example.com/data") -A opts=([X]="1" )'
    ["wget --output-document=downloaded_file.html https://example.com"]='-a args=([0]="https://example.com") -A opts=([output_document]="downloaded_file.html" )'
    ["netstat -tulnp"]='-a args=() -A opts=([u]="1" [t]="1" [p]="1" [n]="1" [l]="1" )'
    ["ssh -i private_key.pem user@server"]='-a args=([0]="private_key.pem" [1]="user@server") -A opts=([i]="1" )'
    ["scp -P 2222 user@host:/remote/path /local/path"]='-a args=([0]="user@host:/remote/path" [1]="/local/path") -A opts=([P]="2222" )'
    ["tar -czvf archive.tar.gz /path/to/folder"]='-a args=([0]="/path/to/folder") -A opts=([z]="1" [v]="1" [f]="archive.tar.gz" [c]="1" )'
    ["tar --exclude=*.log -czvf backup.tar.gz /var/log"]='-a args=([0]="/var/log") -A opts=([exclude]="*.log" [z]="1" [v]="1" [f]="backup.tar.gz" [c]="1" )'
    ["zip -r archive.zip folder/"]='-a args=([0]="archive.zip" [1]="folder/") -A opts=([r]="1" )'
    ["unzip archive.zip"]='-a args=([0]="archive.zip") -A opts=()'
    ["ps aux --sort=-%mem"]='-a args=([0]="aux") -A opts=([sort]="-%mem" )'
    ["htop -u username"]=''
    ["top"]=''
    ["tail -n 100 log.txt"]=''
    ["du -sh * | sort -rh"]=''
    ["chmod 755 script.sh"]=''
    ["chown user:group file.txt"]=''
    ["sudo chown -R www-data:www-data /var/www/html"]=''
    ["find . -type f -exec chmod 644 {} +"]=''
    ["echo \"\${VAR:-default_value}\""]=''
    ["export VAR=\"Hello\" && echo \$VAR"]=''
    ["FOO=123; echo \$FOO"]=''
    ["\$(echo \"Dynamic command execution\")"]=''
    ["for file in *.txt; do echo \"Processing \$file\"; done"]=''
    ["echo \"Today is \$(date)\""]=''
    ["command > output.log 2>&1"]=''
    ["ls /nonexistent 2>/dev/null || echo \"File not found\""]=''
    ["echo \"Hello\" | tee output.txt"]=''
    ["sort file.txt | uniq | tee sorted.txt"]=''
    ["diff <(ls dir1) <(ls dir2)"]=''
    ["awk '{print \$1}' <(grep \"error\" log.txt)"]=''
    ["mysql -u root -p -e \"SHOW DATABASES;\" -e \"SELECT * FROM users;\""]=''
    ["jq '.key' data.json"]=''
    ["curl --data-urlencode \"param=value\" https://api.example.com/submit"]=''
    ["docker run --rm -it ubuntu bash"]=''
    ["docker-compose up -d"]=''
    ["kubectl get pods -n mynamespace"]=''
    ["git clone https://github.com/user/repo.git"]=''
    ["git config --global user.name=\"John Doe\""]=''
    ["perl -ne 'print if /pattern/' file.txt"]=''
    ["perl -pe 's/\x00/ /g' binaryfile.bin"]=''
    ["echo -e \"Unicode: \u2603\""]=''
    ["echo -n \"Base64\" | base64"]=''
    ["echo \"hello\" | iconv -f utf-8 -t utf-16"]=''
    ["cat /dev/zero | head -c 1M > testfile"]=''
    ["dd if=/dev/urandom of=random.bin bs=1M count=10"]=''
    ["tail -f /var/log/syslog"]=''
    ["ls /proc/"]=''
    ["mkfifo mypipe && cat < mypipe & echo \"Hello\" > mypipe"]=''
    ["sudo !!"]=''
    ["echo \"Nested \\\"quotes\\\" and \\\\\\escaped\\\\ backslashes\""]=''
    ["echo 'Single quotes: '\'' and double quotes: \"'"]=''
    ["printf 'Line1\nLine2\n'"]=''
    ["curl -vvvv -X GET https://example.com"]=''
    ["grep -i -i -i \"pattern\" file.txt"]=''
    ["tar -vvv -czf backup.tar.gz /mydata"]=''
    ["date --rfc-3339=seconds"]=''
    ["tmux new -s mysession"]=''
    ["systemctl restart nginx.service"]=''
    ["rsync -a --exclude \"*.{tmp,log,swp}\" --partial --progress /src/ /dst/"]=''
    ["tar -cf - . | ssh user@server 'tar -xf - -C /destination'"]=''
    ["sed 's/[[:space:]]\+/ /g' file.txt'"]=''
    ["cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 16"]=''
    ["hexdump -C file.bin | head -n 20"]=''
)

# these option settings must correlate with the args above and the intention of the command
declare -A opts_example=(
    ["find"]='[-name]=-name+'
    ["grep"]='[-e]=@+'
    ["cut"]='[-d]=+ [-f]=?'
    ["ping"]='[-c]=+'
    ["scp"]='[-P]=+'
    ["tar"]='[-f]=+'
)

describe args

    while IFS= read -r line || [[ -n $line ]]; do
        # Trim leading/trailing whitespace
        example="${line#"${line%%[![:space:]]*}"}"
        example="${example%"${example##*[![:space:]]}"}"

        # Skip empty lines and comments
        [[ -z "$example" || "$example" == \#* ]] && continue

        # check if the example is registered
        if [[ -n "${args_example["$example"]+set}" ]]; then
            declare -A opts=() && declare -a args=()
            [[ "${opts_example["$example"]}" ]] && eval "opts=(${opts_example["$example"]})"
            [[ "${opts_example["${example%% *}"]}" ]] && eval "opts=(${opts_example["${example%% *}"]})"
            if [[ "$example" == *[[:space:]]* ]]; then
                eval "args=(${example#* })"
                args "${args[@]}"
            else
                args
            fi
            declare output="$( declare -p args opts | paste -sd' ' )"
            output="${output//declare /}"
            expectation="${args_example[$example]}"
            if [ "$output" != "$expectation" ]; then
                log --fail "$example" "$output \033[33m\nexpect: $expectation"
            else
                log --good "$example"
            fi
        else
            example="${example//\\/\\\\}"
            example="${example//\"/\\\"}"
            example="\"${example//\$/\\\$}\""
            echo "MISSING [$example]=''"
        fi
        
    done < "${BASH_SOURCE[0]%/*}/files/example.sh"

describe