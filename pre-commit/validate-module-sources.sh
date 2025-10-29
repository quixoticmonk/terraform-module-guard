#!/bin/bash

CONFIG_FILE="$(dirname "$0")/../allowed-sources.yaml"
EXIT_CODE=0

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo "ERROR: yq is required but not installed. Install with: brew install yq"
    exit 1
fi

check_source() {
    local source="$1"
    local registry_sources git_sources
    
    registry_sources=$(yq '.allowed_sources.registry[]' "$CONFIG_FILE")
    git_sources=$(yq '.allowed_sources.git[]' "$CONFIG_FILE")
    
    if [[ $source == git::* ]]; then
        local git_url="${source#git::}"
        git_url="${git_url%%\?*}"
        while IFS= read -r allowed; do
            allowed_prefix="${allowed%/*}"
            [[ $git_url == $allowed_prefix* ]] && return 0
        done <<< "$git_sources"
    else
        while IFS= read -r allowed; do
            allowed_prefix="${allowed%/*}"
            [[ $source == $allowed_prefix* ]] && return 0
        done <<< "$registry_sources"
    fi
    return 1
}

for file in "$@"; do
    [[ $file == *.tf ]] || continue
    
    while IFS= read -r line; do
        if [[ $line =~ source[[:space:]]*=[[:space:]]*\"([^\"]+)\" ]]; then
            source="${BASH_REMATCH[1]}"
            if ! check_source "$source"; then
                echo "ERROR: Disallowed module source in $file: $source"
                EXIT_CODE=1
            fi
        fi
    done < "$file"
done

exit $EXIT_CODE
