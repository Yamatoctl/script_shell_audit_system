#!/usr/bin/env bash

# ═══════════════════════════════════════════════════
#   SYSTEM INTELLIGENCE REPORT - CLASSIFIED
# ═══════════════════════════════════════════════════

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