#!/bin/bash

# --- Script Metadata ---
SCRIPT_NAME="moonshot-agent.sh"
SCRIPT_VERSION="1.0.0"

# --- Configuration ---
USER="agentuser"
URL="http://hldca-vmw-rhel-17811.pdcd.net/agents/check-mk-agent-2.3.0p28-57d94250985d034c.noarch.rpm"
RPM_FILE="check-mk-agent-2.3.0p28-57d94250985d034c.noarch.rpm"
LOG_FILE="/var/log/moonshot-agent.log"

# --- Color codes ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- ASCII Art Header ---
ascii_art() {
cat << "EOF"

    dMMMMMMMMb .aMMMb  .aMMMb  dMMMMb  .dMMMb  dMP dMP .aMMMb dMMMMMMP 
   dMP"dMP"dMPdMP"dMP dMP"dMP dMP dMP dMP" VP dMP dMP dMP"dMP   dMP    
  dMP dMP dMPdMP dMP dMP dMP dMP dMP  VMMMb  dMMMMMP dMP dMP   dMP     
 dMP dMP dMPdMP.aMP dMP.aMP dMP dMP dP .dMP dMP dMP dMP.aMP   dMP      
dMP dMP dMP VMMMP"  VMMMP" dMP dMP  VMMMP" dMP dMP  VMMMP"   dMP       
                                                                       
    .aMMMb  .aMMMMP dMMMMMP dMMMMb dMMMMMMP                            
   dMP"dMP dMP"    dMP     dMP dMP   dMP                               
  dMMMMMP dMP MMP"dMMMP   dMP dMP   dMP                                
 dMP dMP dMP.dMP dMP     dMP dMP   dMP                                 
dMP dMP  VMMMP" dMMMMMP dMP dMP   dMP                                  
                                                                       
EOF
}

# --- Logging function ---
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$LOG_FILE"
}

# --- Spinner function ---
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# --- Section divider ---
divider() {
    echo -e "${CYAN}------------------------------------------------------------${NC}"
}

# --- Usage function ---
usage() {
    ascii_art
    echo -e "${CYAN}Moonshot Agent Installer v$SCRIPT_VERSION${NC}"
    echo -e "Usage: sudo ./$SCRIPT_NAME [OPTIONS]"
    echo
    echo "Options:"
    echo "  --dry-run      Show what would happen, but do not download or install"
    echo "  --help         Show this help message and exit"
    echo "  --version      Show script version and exit"
    echo
    echo "Example:"
    echo "  sudo ./$SCRIPT_NAME"
    echo "  sudo ./$SCRIPT_NAME --dry-run"
}

# --- Version function ---
version() {
    echo "$SCRIPT_NAME version $SCRIPT_VERSION"
}

# --- Parse CLI arguments ---
DRY_RUN=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        --version|-v)
            version
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            usage
            exit 1
            ;;
    esac
done

# --- Root check ---
if [[ $EUID -ne 0 ]]; then
    ascii_art
    echo -e "${RED}Error: This script must be run as root or with sudo.${NC}"
    log "ERROR: Script not run as root."
    exit 1
fi

# --- Start Script ---
clear
ascii_art
divider
echo -e "${CYAN}Welcome to the Moonshot Agent Installer!${NC}"
divider
log "INFO: Script started by user $(whoami)."

if [[ $DRY_RUN -eq 1 ]]; then
    echo -e "${YELLOW}DRY RUN MODE ENABLED${NC}"
    echo -e "No changes will be made. The following steps would be performed:"
    divider
    echo -e "${YELLOW}Step 1: Authentication${NC}"
    echo "  - Prompt for HTTP password for user '$USER'"
    echo -e "${YELLOW}Step 2: Downloading the Agent${NC}"
    echo "  - Download agent package from:"
    echo "    $URL"
    echo "  - Save as $RPM_FILE"
    echo -e "${YELLOW}Step 3: Installing the Agent${NC}"
    echo "  - Install the agent RPM on your system"
    echo -e "${YELLOW}Step 4: Cleaning Up${NC}"
    echo "  - Remove the downloaded RPM file"
    divider
    echo -e "${CYAN}Dry run complete. No actions were performed.${NC}"
    exit 0
fi

# --- Step 1: Prompt for password securely ---
echo -e "${YELLOW}Step 1: Authentication${NC}"
echo -e "To download the agent, we need your HTTP password for user '${USER}'."
read -s -p "Please enter the password: " PASS
echo
divider

# --- Step 2: Download the agent package ---
echo -e "${YELLOW}Step 2: Downloading the Agent${NC}"
echo -e "Connecting to the server and downloading the agent package..."
log "INFO: Attempting to download agent package from $URL."
(wget --user="$USER" --password="$PASS" "$URL" -O "$RPM_FILE" >> "$LOG_FILE" 2>&1) & spinner
WGET_STATUS=$?

if [ $WGET_STATUS -ne 0 ] || [ ! -f "$RPM_FILE" ]; then
    echo -e "${RED}Download failed!${NC}"
    echo -e "Could not download the agent. Please check your credentials, network, or contact your administrator."
    log "ERROR: Download failed."
    exit 2
fi

echo -e "${GREEN}Download successful!${NC}"
echo -e "The agent package has been saved as ${CYAN}${RPM_FILE}${NC}."
log "INFO: Download successful."
divider

# --- Step 3: Install the agent package ---
echo -e "${YELLOW}Step 3: Installing the Agent${NC}"
echo -e "Installing the agent package on your system. This may take a moment..."
log "INFO: Installing RPM package."
(rpm -i "$RPM_FILE" >> "$LOG_FILE" 2>&1) & spinner
RPM_STATUS=$?

# --- Step 4: Clean up ---
echo -e "${YELLOW}Step 4: Cleaning Up${NC}"
echo -e "Removing the downloaded package to keep your system tidy."
rm -f "$RPM_FILE"
log "INFO: Cleaned up RPM file."
divider

# --- Final status ---
if [ $RPM_STATUS -eq 0 ]; then
    echo -e "${GREEN}Installation complete!${NC}"
    echo -e "The Checkmk agent is now installed and ready for launch."
    log "INFO: Agent installed successfully."
    echo -e "${CYAN}Mission accomplished. Welcome to the monitoring universe!${NC}"
    divider
    exit 0
else
    echo -e "${RED}Installation failed!${NC}"
    echo -e "There was a problem installing the agent. Please see ${CYAN}$LOG_FILE${NC} for details."
    log "ERROR: RPM installation failed."
    divider
    exit 3
fi
