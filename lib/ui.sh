#!/usr/bin/env bash

separateur() {
    echo -e "${ROUGE}$(printf '%.0s═' {1..60})${RESET}"; 
}

titre() {
    echo -e "\n${LROUGE}▓▓ $1 ${RESET}"; echo -e "${ROUGE}$(printf '%.0s─' {1..60})${RESET}"; 
}

info() {
    printf "${ROUGE}%-30s${RESET} %s\n" "$1" "$2"; 
}

banner() {
    echo -e "${LROUGE}"
    cat << 'BANNER'
██████╗ ███████╗██████╗     ██╗███╗   ██╗███████╗ ██████╗ 
██╔══██╗██╔════╝██╔══██╗    ██║████╗  ██║██╔════╝██╔═══██╗
██████╔╝█████╗  ██║  ██║    ██║██╔██╗ ██║█████╗  ██║   ██║
██╔══██╗██╔══╝  ██║  ██║    ██║██║╚██╗██║██╔══╝  ██║   ██║
██║  ██║███████╗██████╔╝    ██║██║ ╚████║██║     ╚██████╔╝
╚═╝  ╚═╝╚══════╝╚═════╝     ╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝ 
BANNER
    echo -e "${RESET}"
    separateur
    echo -e "${ROUGE}[CLASSIFIED]${RESET} SYSTEM INTELLIGENCE REPORT"
    echo -e " Generated : $(date)"
    echo -e " Operator  : $(whoami)@$(hostname)"
    separateur

    sleep 1
}

fin() {
    echo -e ""; separateur
    echo -e "${LROUGE}[✓] RAPPORT TERMINÉ${RESET} — $(date '+%H:%M:%S')"
    separateur

    sleep 2
}

spinner() {
    local pid=$1
    local frames='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0

    while kill -0 "$pid" 2>/dev/null; do
        printf "\r${LROUGE}%s scan en cours...${RESET}" "${frames:$(( i % ${#frames} )):1}"
        sleep 0.1
        (( i++ ))
    done

    printf "\r                          \r"
}