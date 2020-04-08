DEBIAN_FRONTEND=noninteractive
sudo dpkg --add-architecture i386; 
# Install dependencies
apt-get update && \
    apt-get install -y --no-install-recommends \
    lib32gcc1 \
    curl \
    wget \
    libstdc++6

mkdir -p src && \
    curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz \
    | tar -v -C src -zx && \
    chmod +x src/steamcmd.sh && \
    src/steamcmd.sh +login anonymous +quit


if [ ! -d "src/rust" ]; then
	mkdir -p src/rust
fi

cd src
# Install and update
# Get some info
./steamcmd.sh +login anonymous +app_info_update 1 +app_info_print "258550" +quit > serverinfo.txt

sbuildid=$(cat serverinfo.txt | grep -m1 buildid | awk '{ printf $2; }' | awk -F'"' '$0=$2')
server_time=$(cat serverinfo.txt | grep -m1 timeupdated | awk '{ printf $2; }' | awk -F'"' '$0=$2')
timestamp=$(date -Iseconds -d @$server_time)
echo "##vso[task.setvariable variable=buildid]$sbuildid"
echo "##vso[task.setvariable variable=published_at]$timestamp"

# Start install
./steamcmd.sh +login anonymous +force_install_dir rust +app_update 258550 -beta public +quit
