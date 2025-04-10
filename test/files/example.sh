# Basic Commands
exit 503
ls -la
cd /home/user/documents
whoami
id -u -n

# File and Directory Operations
mv "My File (2024).txt" "New File [backup].txt"
touch "${FILE:-default.txt}"
find / -name "myfile.txt"
rm -rf /path/to/directory
cp -r source/ destination/

# Text Processing
grep -e "error" -e "warning" /var/log/syslog
awk '{print $1"\t"$2}' file.txt
sed -i 's/old/new/g' file.txt
cut -d ',' -f1-3 data.csv
diff -u file1.txt file2.txt
json --engines.node=21 engines

# Network Commands
ping -4 -c 4 google.com
curl -X GET https://api.example.com/data
wget --output-document=downloaded_file.html https://example.com
netstat -tulnp
ssh -i private_key.pem user@server
scp -P 2222 user@host:/remote/path /local/path

# Archive and Compression
tar -czvf archive.tar.gz /path/to/folder
tar --exclude=*.log -czvf backup.tar.gz /var/log
zip -r archive.zip folder/
unzip archive.zip

# Process and System Monitoring
ps aux --sort=-%mem
htop -u username
top
tail -n 100 log.txt
du -sh * | sort -rh

# Permissions and Ownership
chmod 755 script.sh
chown user:group file.txt
sudo chown -R www-data:www-data /var/www/html
find . -type f -exec chmod 644 {} +

# Environment Variables and Subshells
echo "${VAR:-default_value}"
export VAR="Hello" && echo $VAR
FOO=123; echo $FOO
$(echo "Dynamic command execution")
for file in *.txt; do echo "Processing $file"; done
echo "Today is $(date)"

# Redirection and Piping
command > output.log 2>&1
ls /nonexistent 2>/dev/null || echo "File not found"
echo "Hello" | tee output.txt
sort file.txt | uniq | tee sorted.txt
diff <(ls dir1) <(ls dir2)
awk '{print $1}' <(grep "error" log.txt)

# Database and Data Processing
mysql -u root -p -e "SHOW DATABASES;" -e "SELECT * FROM users;"
jq '.key' data.json
curl --data-urlencode "param=value" https://api.example.com/submit

# Docker and Kubernetes
docker run --rm -it ubuntu bash
docker-compose up -d
kubectl get pods -n mynamespace

# Development and Version Control
git clone https://github.com/user/repo.git
git config --global user.name="John Doe"
perl -ne 'print if /pattern/' file.txt
perl -pe 's/\x00/ /g' binaryfile.bin

# Encoding and Formatting
echo -e "Unicode: \u2603"
echo -n "Base64" | base64
echo "hello" | iconv -f utf-8 -t utf-16

# Special Devices and System Utilities
cat /dev/zero | head -c 1M > testfile
dd if=/dev/urandom of=random.bin bs=1M count=10
tail -f /var/log/syslog
ls /proc/

# Advanced Shell Features
mkfifo mypipe && cat < mypipe & echo "Hello" > mypipe
sudo !!
echo "Nested \"quotes\" and \\\escaped\\ backslashes"
echo 'Single quotes: '\'' and double quotes: "'
printf 'Line1\nLine2\n'

# Repeated Flags and Complex Arguments
curl -vvvv -X GET https://example.com
grep -i -i -i "pattern" file.txt
tar -vvv -czf backup.tar.gz /mydata

# Miscellaneous Commands
date --rfc-3339=seconds
tmux new -s mysession
systemctl restart nginx.service
rsync -a --exclude "*.{tmp,log,swp}" --partial --progress /src/ /dst/
tar -cf - . | ssh user@server 'tar -xf - -C /destination'
sed 's/[[:space:]]\+/ /g' file.txt'
cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 16
hexdump -C file.bin | head -n 20
