epoch() { if [ $# -eq 0 ]; then date +%s else date -d @"$@" -R; fi; }
