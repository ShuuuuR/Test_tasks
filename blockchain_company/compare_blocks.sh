#!/usr/bin/env bash 

ETHERSCAN_API_KEY=${ETHERSCAN_API_KEY}
ETHERSCAN_URL="https://api.etherscan.io/api?module=proxy&action=eth_blockNumber&apikey=${ETHERSCAN_API_KEY}"

BLOCKCYPHER_URL="https://api.blockcypher.com/v1/eth/main"

# Get results
ETHERSCAN_RESULT=$(curl -s "${ETHERSCAN_URL}" | jq -r '.result')
BLOCKCYPHER_HEIGHT=$(curl -s "${BLOCKCYPHER_URL}" | jq -r '.height')

# Compare results
if [[ "${ETHERSCAN_RESULT}" != "null" && "${BLOCKCYPHER_HEIGHT}" != "null" ]]; then
    # Convert to decimal
    ETHERSCAN_RESULT=$((16#"${ETHERSCAN_RESULT#0x}"))

    echo "Etherscan Block Number: ${ETHERSCAN_RESULT}"
    echo "Blockcypher Height: ${BLOCKCYPHER_HEIGHT}"

    if [[ "${ETHERSCAN_RESULT}" -eq "${BLOCKCYPHER_HEIGHT}" ]]; then
        echo "The block numbers are the same!"
    else
        echo "The block numbers are different!"
    fi
else
    echo "Error: Unable to fetch data from the APIs."
fi
