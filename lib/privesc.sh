#!/usr/bin/env bash

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