#!/usr/bin/env bash

# ═══════════════════════════════════════════════════
#   SYSTEM INTELLIGENCE REPORT - CLASSIFIED
# ═══════════════════════════════════════════════════

ROUGE='\033[0;31m'
LROUGE='\033[1;31m'
RESET='\033[0m'
GRIS='\033[0;90m'
DATE=$(date +%d-%m-%Y_%H-%M)
FICHIER_FINAL="rapport-$DATE.txt"

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
    # sleep 2
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

user_info() {
    titre   "IDENTITY & PRIVILEGES"

    info    "Utilisateur →"   "$(whoami)"   
    info    "ID →"            "$(id)"
    info    "Groupes →"       "$(groups)" 
    info    "Repertoire →"    "$(pwd)"
}

droit_sudo() {
    if [ "$(id -u)" -eq 0 ]; then
        info "Droits sudo →" "Exécuté en tant que root"
        sleep 1
        return
    fi

    local output exit_code
    LANG=C sudo -n -l >/dev/null 2>&1
    exit_code=$?

    if [ "$exit_code" -eq 0 ]; then
        output=$(LANG=C sudo -n -l 2>/dev/null)
        if echo "$output" | grep -q "NOPASSWD"; then
            info "Droits sudo →" "Sudo sans mot de passe (NOPASSWD) configuré"
        else
            info "Droits sudo →" "Sudo configuré (session déjà authentifiée)"
        fi
        while read -r line; do
            [ -z "$line" ] && continue
            echo -e "${LROUGE}[!]${RESET} $line"
        done <<< "$output"
    elif id -nG 2>/dev/null | grep -qE '\bsudo\b|\bwheel\b|\badm\b'; then
        info "Droits sudo →" "Sudo nécessite un mot de passe"
    else
        info "Droits sudo →" "Aucun droit sudo détecté"
    fi
    sleep 1
}

fingerprint() {
    titre "SYSTEM FINGERPRINT"
    echo -e "${ROUGE}hostname ↓${RESET}"
    hostnamectl | while read -r line; do
        printf "%s\n" "$line"
    done
    sleep 1  

    echo -e "${ROUGE}OS ↓${RESET}"
    while read -r line; do          
        printf "%s\n" "$line"
    done < /etc/os-release

    echo -e "${ROUGE}Kernel ↓${RESET}"
    uname -a 

    echo -e "${ROUGE}Date ↓${RESET}"
    date
    sleep 1
}

network() {
    titre "NETWORK INTELLIGENCE"

    echo -e "${ROUGE}Interfaces & IPs ↓${RESET}"
    ip a 2>/dev/null || hostname -I

    echo -e "${ROUGE}Ports en écoute :${RESET}"
    ss -tlnp 2>/dev/null

    echo -e "${ROUGE}DNS ↓${RESET}"
    grep nameserver /etc/resolv.conf 2>/dev/null | awk '{print $2}'

    echo -e "${ROUGE}Fichier Hosts ↓${RESET}"
    cat /etc/hosts
    sleep 1
}

user_enum() {
    titre "USER ENUMERATION"
    echo -e "${ROUGE}Utilisateurs ↓${RESET}"
    cut -d: -f1 /etc/passwd
    echo -e "${ROUGE}Fichier /etc/shadow ↓${RESET}"
    local SHADOW
    SHADOW=$(cat /etc/shadow 2>/dev/null)
    if [ -n "$SHADOW" ]; then
        while read -r line; do
            echo -e "${LROUGE}[+]${RESET} $line"
        done <<< "$SHADOW"
    else
        echo -e "${LROUGE}[!]${RESET} Accès refusé"
    fi
    sleep 1
}

suid_sgid() {
    titre "SUID / SGID FILES"
    echo -e "${ROUGE}Fichiers SUID :${RESET}"
    local SUID
    SUID=$(find / -mount -perm -4000 -type f \
        ! -path "/proc/*" \
        ! -path "/sys/*" \
        ! -path "/run/*" \
        2>/dev/null)
    while read -r f; do
        echo -e "${LROUGE}[!]${RESET} $f"
    done <<< "$SUID"
    echo -e "\n  ${ROUGE}Fichiers SGID :${RESET}"
    local SGID
    SGID=$(find / -mount -perm -2000 -type f \
        ! -path "/proc/*" \
        ! -path "/sys/*" \
        ! -path "/run/*" \
        2>/dev/null)
    while read -r f; do
        echo -e "${LROUGE}[!]${RESET} $f"
    done <<< "$SGID"
    sleep 1
}

taches() {
    titre "TACHES PLANIFIEES"

    echo -e "${ROUGE}Crontab système ↓${RESET}"
    
    while read -r line; do
        printf "%s\n" "$line"
    done < /etc/crontab 2>/dev/null
    echo -e "${ROUGE}Cron.d & cron.* ↓${RESET}"
    ls -la /etc/cron* 2>/dev/null
    echo -e "${ROUGE}Crontab utilisateur ↓${RESET}"
    local CRONTAB
    CRONTAB=$(crontab -l 2>/dev/null)
    if [ -z "$CRONTAB" ]; then
        echo -e "${LROUGE}[!]${RESET} Aucune tâche configurée"
    else
        echo "$CRONTAB"
    fi
    echo -e "${ROUGE}Crontabs tous utilisateurs ↓${RESET}"
    local SPOOL
    SPOOL=$(ls -la /var/spool/cron/crontabs 2>/dev/null)
    if [ -z "$SPOOL" ]; then
        echo -e "${LROUGE}[!]${RESET} Accès refusé ou vide"
    else
        echo "$SPOOL"
    fi
    sleep 1
}

ressources() {
    titre "SYSTEM RESOURCES"
    echo -e "${ROUGE}Espace disque :${RESET}"; df -h /
    echo -e "${ROUGE}Mémoire :${RESET}"; free -h
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

banner
generer_rapport() {
    banner
    user_info
    droit_sudo
    fingerprint
    network
    user_enum
    suid_sgid
    taches
    ressources
    fin
}

start_time=$(date +%s)
touch "$FICHIER_FINAL" 2>/dev/null || {
    echo -e "${LROUGE}[!]${RESET} Impossible d'écrire dans $FICHIER_FINAL"
    exit 1
}
generer_rapport > "$FICHIER_FINAL" 2>&1 &
pid=$!
spinner "$pid"
wait $pid
end_time=$(date +%s)
duree=$(( end_time - start_time ))
sync
echo -e "${LROUGE}[✓] SYSTÈME DÉCRYPTÉ EN ${duree}s${RESET}"
echo -e "  └─ Rapport généré : $FICHIER_FINAL"

