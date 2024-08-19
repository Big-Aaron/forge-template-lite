#!/bin/bash
chmod +x script/generate_abi.sh
if  command -v forge > /dev/null; then
    echo "forge command has found"
else
    curl -L https://foundry.paradigm.xyz | bash
    echo "forge command has installed"
    source ~/.bashrc
    foundryup
    echo "forge command has started"
fi

forge build --force

if [ ! -d "abi" ]; then
  mkdir abi
fi

if [ ! -d "flattenContracts" ]; then
  mkdir flattenContracts
fi

# Loop through all .sol files in the src directory
for solfile in src/*.sol; do
  # Get the base name of the .sol file (without directory and extension)
  base=$(basename "$solfile" .sol)
  
  # Flatten the .sol file and generate the ABI
  forge flatten "$solfile" -o "flattenContracts/${base}_flattened.sol"
  forge inspect "flattenContracts/${base}_flattened.sol:$base" abi > "abi/${base}.json"
done

echo "ABI files have generated"