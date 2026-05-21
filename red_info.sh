#!/usr/bin/env bash

# Nom           : red_info.sh
# Description   : Script de reconnaissance et d'énumération système
# Auteur        : Yamatoctl
# Version       : 1.0
# Date          : 15-05-2026
# Usage         : ./red_info.sh

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/lib/ui.sh"
source "$DIR/lib/system.sh"
source "$DIR/lib/privesc.sh"

ROUGE='\033[0;31m'
LROUGE='\033[1;31m'
RESET='\033[0m'
DATE=$(date +%d-%m-%Y_%H-%M)
FICHIER_FINAL="rapport-$DATE.txt"

generer_rapport() {
    banner
    user_info
    password_policy
    key_ssh
    droit_sudo
    fingerprint
    network
    user_enum
    suid_sgid
    taches
    ressources
    fin
}

banner
start_time=$(date +%s)

FICHIER_FINAL="rapport-$DATE"
generer_rapport 2>&1 | tee >(aha --black > "${FICHIER_FINAL}.html") > "${FICHIER_FINAL}.txt" &
pid=$!
spinner "$pid"
wait "$pid"
end_time=$(date +%s)
duree=$(( end_time - start_time ))
sync
echo -e "${LROUGE}[✓] SYSTÈME DÉCRYPTÉ EN ${duree}s${RESET}"
echo -e "  └─ Rapport TXT  : ${FICHIER_FINAL}.txt"
echo -e "  └─ Rapport HTML : ${FICHIER_FINAL}.html"
xdg-open "${FICHIER_FINAL}.html"