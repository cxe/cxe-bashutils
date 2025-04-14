
cpuinfo() {
  if [ -f /proc/cpuinfo ]; then
    model=$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2-)
    cores=$(grep -c ^processor /proc/cpuinfo)
    arch=$(uname -m)
    echo "$model | Cores: $cores | Arch: $arch"
  elif command -v sysctl &>/dev/null; then
    model=$(sysctl -n machdep.cpu.brand_string)
    cores=$(sysctl -n hw.ncpu)
    arch=$(uname -m)
    echo "$model | Cores: $cores | Arch: $arch"
  else
    echo "Unsupported system"
    return 1
  fi
}
