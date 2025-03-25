#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/../lib/spec"
source "${BASH_SOURCE[0]%/*}/../lib/log"
source "${BASH_SOURCE[0]%/*}/../lib/args"

declare -A opts_example=(
    ["find / -name \"myfile.txt\""]='[-name]=name'
    ["grep -e \"error\" -e \"warning\" /var/log/syslog"]='[-e]=[]'
)

declare -A args_example=(
    ["exit 503"]='-a args=([0]="503") -A opts=()'
    ["ls -la"]='-a args=() -A opts=([l]="l" [a]="a" )'
    ["cd /home/user/documents"]='-a args=([0]="/home/user/documents") -A opts=()'
    ["whoami"]='-a args=() -A opts=()'
    ["id -u -n"]='-a args=() -A opts=([u]="u" [n]="n" )'
    ["mv \"My File (2024).txt\" \"New File [backup].txt\""]='-a args=([0]="My File (2024).txt" [1]="New File [backup].txt") -A opts=()'
    ["touch \"\${FILE:-default.txt}\""]='-a args=([0]="default.txt") -A opts=()'
    ["find / -name \"myfile.txt\""]='-a args=([0]="/") -A opts=([name]="myfile.txt" )'
    ["rm -rf /path/to/directory"]='-a args=([0]="/path/to/directory") -A opts=([r]="r" [f]="f" )'
    ["cp -r source/ destination/"]='-a args=([0]="source/" [1]="destination/") -A opts=([r]="r" )'
    ["grep -e \"error\" -e \"warning\" /var/log/syslog"]=''
    ["awk '{print \$1\"\t\"\$2}' file.txt"]=''
    ["sed -i 's/old/new/g' file.txt"]=''
    ["cut -d ',' -f1-3 data.csv"]=''
    ["diff -u file1.txt file2.txt"]=''
    ["ping -c 4 google.com"]=''
    ["curl -X GET https://api.example.com/data"]=''
    ["wget --output-document=downloaded_file.html https://example.com"]=''
    ["netstat -tulnp | grep LISTEN"]=''
    ["ssh -i private_key.pem user@server"]=''
    ["scp -P 2222 user@host:/remote/path /local/path"]=''
    ["tar -czvf archive.tar.gz /path/to/folder"]=''
    ["tar --exclude=*.log -czvf backup.tar.gz /var/log"]=''
    ["zip -r archive.zip folder/"]=''
    ["unzip archive.zip"]=''
    ["ps aux --sort=-%mem"]=''
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
            if [[ "$example" == *[[:space:]]* ]]; then
                eval "args=(${example#* })"
                args "${args[@]}"
            else
                args
            fi
            declare output="$( declare -p args opts | paste -sd' ' )" && output="${output//declare /}"
            if [ "$output" != "${args_example[$example]}" ]; then
                log --fail "$example" "$output"
            else
                log --good "$example"
            fi
        else
            example="${example//\\/\\\\}"
            example="${example//\"/\\\"}"
            example="\"${example//\$/\\\$}\""
            echo "[$example]=''"
        fi
        
    done < "${BASH_SOURCE[0]%/*}/files/example.sh"

describe