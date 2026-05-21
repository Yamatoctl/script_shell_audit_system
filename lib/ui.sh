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
    local frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    local messages=(
        "Extraction des identités..."
        "Analyse des privilèges..."
        "Recherche de clés SSH..."
        "Enumération des utilisateurs..."
        "Scan des fichiers SUID/SGID..."
        "Lecture des tâches planifiées..."
        "Cartographie du réseau..."
        "Collecte des ressources système..."
    )
    local i=0
    local m=0
    local msg_counter=0

    while kill -0 "$pid" 2>/dev/null; do
        local frame=${frames[$((i % ${#frames[@]}))]}
        local msg=${messages[$((m % ${#messages[@]}))]}
        printf "\r  ${LROUGE}%s${RESET} ${ROUGE}%-45s${RESET}" "$frame" "$msg" 
        sleep 0.1
        ((i++))
        ((msg_counter++))
        if (( msg_counter % 20 == 0 )); then
            ((m++))
        fi
    done
    printf "\r%-60s\r" " " 
}