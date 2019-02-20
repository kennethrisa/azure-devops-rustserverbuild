# Start server
cd src/rust
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`dirname $0`$SCRIPT_DIR/RustDedicated_Data/Plugins/x86_64
timeout 1m ./RustDedicated -batchmode -nographics \
    +server.hostname "Test server" \
    +server.seed 1234 \
    +server.worldsize 1000 \
    -logfile output.log

exit 0
