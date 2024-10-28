#!/bin/bash

# Initialize variables
domain=""
output_file=""
declare -a results

# Colors for readability
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
NC='\033[0m'  # No Color

# Usage function for displaying help
usage() {
    echo -e "${GREEN}Usage:${NC} $0 --domain <domain> [--save <filename>]"
    echo -e "  --domain <domain>    Specify the domain to search (required)"
    echo -e "  --save <filename>    Specify a file to save results in JSON format (optional)"
    echo
    exit 1
}

# Parse command-line options
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --domain)
            domain="$2"
            shift ;;
        --save)
            output_file="$2"
            shift ;;
        -h|--help)
            usage ;;
        *)
            echo "Unknown parameter passed: $1"
            usage ;;
    esac
    shift
done

# Validate that domain was provided
if [[ -z "$domain" ]]; then
    echo -e "${RED}Error:${NC} --domain is required."
    usage
fi

# List of Common Crawl indexes
indexes=(
    "CC-MAIN-2024-42" "CC-MAIN-2024-38" "CC-MAIN-2024-33" "CC-MAIN-2024-30" 
    "CC-MAIN-2024-26" "CC-MAIN-2024-22" "CC-MAIN-2024-18" "CC-MAIN-2024-10"
    "CC-MAIN-2023-50" "CC-MAIN-2023-40" "CC-MAIN-2023-23" "CC-MAIN-2023-14" 
    "CC-MAIN-2023-06" "CC-MAIN-2022-49" "CC-MAIN-2022-40" "CC-MAIN-2022-33"
    "CC-MAIN-2022-27" "CC-MAIN-2022-21" "CC-MAIN-2022-05" "CC-MAIN-2021-49"
    "CC-MAIN-2021-43" "CC-MAIN-2021-39" "CC-MAIN-2021-31" "CC-MAIN-2021-25" 
    "CC-MAIN-2021-21" "CC-MAIN-2021-17" "CC-MAIN-2021-10" "CC-MAIN-2021-04"
    "CC-MAIN-2020-50" "CC-MAIN-2020-45" "CC-MAIN-2020-40" "CC-MAIN-2020-34" 
    "CC-MAIN-2020-29" "CC-MAIN-2020-24" "CC-MAIN-2020-16" "CC-MAIN-2020-10"
    "CC-MAIN-2020-05" "CC-MAIN-2019-51" "CC-MAIN-2019-47" "CC-MAIN-2019-43" 
    "CC-MAIN-2019-39" "CC-MAIN-2019-35" "CC-MAIN-2019-30" "CC-MAIN-2019-26"
    "CC-MAIN-2019-22" "CC-MAIN-2019-18" "CC-MAIN-2019-13" "CC-MAIN-2019-09"
    "CC-MAIN-2019-04" "CC-MAIN-2018-51" "CC-MAIN-2018-47" "CC-MAIN-2018-43" 
    "CC-MAIN-2018-39" "CC-MAIN-2018-34" "CC-MAIN-2018-30" "CC-MAIN-2018-26"
    "CC-MAIN-2018-22" "CC-MAIN-2018-17" "CC-MAIN-2018-13" "CC-MAIN-2018-09"
    "CC-MAIN-2018-05" "CC-MAIN-2017-51" "CC-MAIN-2017-47" "CC-MAIN-2017-43"
    "CC-MAIN-2017-39" "CC-MAIN-2017-34" "CC-MAIN-2017-30" "CC-MAIN-2017-26"
    "CC-MAIN-2017-22" "CC-MAIN-2017-17" "CC-MAIN-2017-13" "CC-MAIN-2017-09"
    "CC-MAIN-2017-04" "CC-MAIN-2016-50" "CC-MAIN-2016-44" "CC-MAIN-2016-40"
    "CC-MAIN-2016-36" "CC-MAIN-2016-30" "CC-MAIN-2016-26" "CC-MAIN-2016-22"
    "CC-MAIN-2016-18" "CC-MAIN-2016-07" "CC-MAIN-2015-48" "CC-MAIN-2015-40"
    "CC-MAIN-2015-35" "CC-MAIN-2015-32" "CC-MAIN-2015-27" "CC-MAIN-2015-22"
    "CC-MAIN-2015-18" "CC-MAIN-2015-14" "CC-MAIN-2015-11" "CC-MAIN-2015-06"
    "CC-MAIN-2014-52" "CC-MAIN-2014-49" "CC-MAIN-2014-42" "CC-MAIN-2014-41"
    "CC-MAIN-2014-35" "CC-MAIN-2014-23" "CC-MAIN-2014-15" "CC-MAIN-2014-10"
    "CC-MAIN-2013-48" "CC-MAIN-2013-20" "CC-MAIN-2012" "CC-MAIN-2009-2010"
    "CC-MAIN-2008-2009"
)

# Loop through each index and search for the domain
for index in "${indexes[@]}"; do
    echo -e "${BLUE}Searching in index $index...${NC}"
    index_url="https://index.commoncrawl.org/$index-index?url=$domain&output=json"
    
    # Fetch results line-by-line
    curl -s "$index_url" | while IFS= read -r line; do
        # Check if the line is valid JSON and contains the necessary fields
        if echo "$line" | jq -e 'select(.url and .timestamp and .status)' >/dev/null 2>&1; then
            # Extract and display the fields with colorized output
            url=$(echo "$line" | jq -r '.url')
            timestamp=$(echo "$line" | jq -r '.timestamp')
            status=$(echo "$line" | jq -r '.status')
            echo -e "${GREEN}URL:${NC} $url"
            echo -e "${GREEN}Timestamp:${NC} $timestamp"
            echo -e "${GREEN}Status:${NC} $status"
            echo "---"
            
            # If saving to output, store valid entries
            if [[ -n "$output_file" ]]; then
                results+=("$line")
            fi
        fi
    done

    echo -e "${GREEN}Done searching in index $index.${NC}"
    echo "---------------------------------"
done

# Save results to JSON file if --save is specified
if [[ -n "$output_file" ]]; then
    echo "[" > "$output_file"
    printf "%s,\n" "${results[@]}" | sed '$ s/,$//' >> "$output_file"  # Remove trailing comma
    echo "]" >> "$output_file"
    echo -e "${GREEN}Results saved to $output_file${NC}"
fi
