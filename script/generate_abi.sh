#!/bin/bash
chmod +x script/generate_abi.sh
if command -v forge > /dev/null; then
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

# Function to process each .sol file
process_sol_file() {
    local sol_file=$1
    local relative_path=${sol_file#src/}
    local dir=$(dirname "$relative_path")
    local base_name=$(basename "$sol_file" .sol)

    # Create the output directories if they don't exist
    mkdir -p "flattenContracts/$dir"
    mkdir -p "abi/$dir"

    # Flatten the .sol file and generate the ABI
    forge flatten "$sol_file" -o "flattenContracts/$dir/${base_name}_flattened.sol"
    forge inspect "flattenContracts/$dir/${base_name}_flattened.sol:$base_name" abi > "abi/$dir/${base_name}.json"
}

# Export the function so it can be used by find
export -f process_sol_file

# Find all .sol files in the src directory and process them
find src -name "*.sol" -exec bash -c 'process_sol_file "$0"' {} \;

echo "Flattened and ABI files have been generated."