#!/usr/bin/env bash
set -eo pipefail

# Initialize result variables
EXIT_CODE=0
MESSAGE="Success"
DETAILS="All checks passed"
POWER_STATUS="on"
TALOS_STATUS="maintenance"

handle_error() {
    local code=$1
    local msg=$2
    local details=$3
    
    EXIT_CODE=$code
    MESSAGE="$msg"
    DETAILS="$details"
    
    case $code in
        2) POWER_STATUS="off";;
        4) TALOS_STATUS="normal";;
        5) POWER_STATUS="power_on_failed";;
        *) TALOS_STATUS="unknown";;
    esac
    
    output_json
    exit 0
}

output_json() {
    echo '{
        "exit_code": "'"$EXIT_CODE"'",
        "power_status": "'"$POWER_STATUS"'",
        "talos_status": "'"$TALOS_STATUS"'",
        "details": "'"${DETAILS//\"/\\\"}"'",
        "timestamp": "'"$(date -u +"%Y-%m-%dT%H:%M:%SZ")"'"
    }'
}

read_query() {
    echo "Reading input parameters..."
    eval "$(jq -r '@sh "
    IPMI_IP=\(.machine_ipmi_address)
    MACHINE_IP=\(.machine_ip_address)
    IPMI_USER=\(.machine_ipmi_username)
    IPMI_PASSWORD=\(.machine_ipmi_password)
    MAX_ATTEMPTS=\(.max_attempts // 5)
    WAIT_TIME=\(.wait_time // 10)
    BOOT_WAIT_TIME=\(.boot_wait_time // 60)
    POWER_ON_IF_OFF=\(.power_on_if_off // "false")
    "')"

    # Validate required parameters
    if [[ -z "$IPMI_IP" || -z "$MACHINE_IP" || -z "$IPMI_USER" || -z "$IPMI_PASSWORD" ]]; then
        echo >&2 "Error: Missing required parameters in input JSON"
        exit 1
    fi
}


check_deps() {
    echo "Checking dependencies..."
    command -v ipmitool >/dev/null || { echo >&2 "Error: ipmitool required"; exit 1; }
    command -v talosctl >/dev/null || { echo >&2 "Error: talosctl required"; exit 1; }
    command -v jq >/dev/null || { echo >&2 "Error: jq required"; exit 1; }
}

power_on() {
    echo "Attempting to power on machine..."
    if ! ipmitool -I lanplus -H "$IPMI_IP" -U "$IPMI_USER" -P "$IPMI_PASSWORD" power on; then
        handle_error 5 "Power-on failed" "IPMI command failed to start machine"
    fi
    echo "Waiting ${BOOT_WAIT_TIME}s for boot process..."
    sleep "$BOOT_WAIT_TIME"
}

check_power() {
    echo "Checking power status via IPMI..."
    local status
    status=$(ipmitool -I lanplus -H "$IPMI_IP" -U "$IPMI_USER" -P "$IPMI_PASSWORD" power status || true)
    
    if ! echo "$status" | grep -qi "Chassis Power is on"; then
        if [ "$POWER_ON_IF_OFF" = "true" ]; then
            power_on
            check_power || return 2
        else
            handle_error 2 "Machine powered off" "Node is not responding to IPMI power status check"
        fi
    fi
}

check_talos() {
    echo "Checking Talos status (attempts: ${MAX_ATTEMPTS}, interval: ${WAIT_TIME}s)..."
    local attempt=0
    
    while [ $attempt -lt "$MAX_ATTEMPTS" ]; do
        local output
        output=$(talosctl version --insecure -n "$MACHINE_IP" 2>&1 >/dev/null || true)

        if echo "$output" | grep -q "API is not implemented in maintenance mode"; then
            return 0
        elif echo "$output" | grep -q "certificate required"; then
            handle_error 4 "Normal cluster mode" "Node requires TLS certificates for access"
        fi

        echo "Attempt $((attempt+1))/${MAX_ATTEMPTS}: ${output:-"No response"}"
        sleep "$WAIT_TIME"
        attempt=$((attempt+1))
    done

    handle_error 3 "Verification timeout" "Failed to confirm maintenance mode after ${MAX_ATTEMPTS} attempts"
}

main() {
    check_deps
    read_query
    check_power || handle_error $? "Power check failed" "Unexpected power status error"
    check_talos || handle_error $? "Talos check failed" "Unexpected Talos error"
    
    # If we get here, all checks passed
    output_json
    exit 0
}

main "$@"