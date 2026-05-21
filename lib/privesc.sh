#!/usr/bin/env bash

#info generale user
user_info() {
    titre   "IDENTITY & PRIVILEGES"

    info    "Utilisateur →"         "$(whoami)"   
    info    "ID →"                  "$(id)"
    info    "Groupes →"             "$(groups)" 
    info    "Repertoire →"          "$(pwd)"
    info    "Sessions actives ↓"    "$(echo -e "\n$(w)")"
}

password_policy() {
    echo -e "\n${ROUGE}Politique de mots de passe ↓${RESET}"
    logindefs=$(grep "^PASS_MAX_DAYS\|^PASS_MIN_DAYS\|^PASS_WARN_AGE\|^ENCRYPT_METHOD" /etc/login.defs 2>/dev/null)
    if [ -z "$logindefs" ]; then
        printf "Aucune politique trouvée\n"
    else
        while read -r line; do
            printf "%s\n" "$line"
        done <<< "$logindefs"
    fi
}

# clés SSH et fichiers sensibles
key_ssh() {
    echo -e "\n${ROUGE}Clés SSH et fichiers sensibles ↓${RESET}"
    key1=$(find / -mount \
        ! -path "/opt/metasploit-framework/*" \
        \( \
            -name "id_rsa*" \
            -o -name "id_dsa*" \
            -o -name "authorized_keys" \
            -o -name "authorized_hosts" \
            -o -name "known_hosts" \
        \) -exec ls -la {} 2>/dev/null \;)
    if [ -z "$key1" ]; then
        printf "Aucune clé trouvée\n"
    else
        while read -r line; do
            printf "%s\n" "$line"
        done <<< "$key1"
    fi
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
            echo
            info "Droits sudo →" "Sudo sans mot de passe (NOPASSWD) configuré"
        else
            echo
            info "Droits sudo →" "Sudo configuré (session déjà authentifiée)"
        fi
        while read -r line; do
            [ -z "$line" ] && continue
            echo -e "${LROUGE}[!]${RESET} $line"
        done <<< "$output"
    elif id -nG 2>/dev/null | grep -qE '\bsudo\b|\bwheel\b|\badm\b'; then
        echo
        info "Droits sudo →" "Sudo nécessite un mot de passe"
    else
        echo
        info "Droits sudo →" "Aucun droit sudo détecté"
    fi

    sleep 1
    
    sudover=$(sudo -V 2>/dev/null | grep "Sudo version" 2>/dev/null)
    if [ -n "$sudover" ]; then
        info "Version sudo →" "$sudover"
    else
        printf "Sudo non disponible\n"
    fi

}

user_enum() {
    titre "USER ENUMERATION"

    echo -e "${ROUGE}Utilisateurs ↓${RESET}"
    cut -d: -f1 /etc/passwd

    echo -e "\n${ROUGE}Fichier /etc/shadow ↓${RESET}"
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
    titre "Fichier suid/sgid"

    echo -e "${ROUGE}Fichiers SUID ↓${RESET}"
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

    echo -e "\n${ROUGE}Cron.d & cron.* ↓${RESET}"
    ls -la /etc/cron* 2>/dev/null

    echo -e "\n${ROUGE}Crontab utilisateur ↓${RESET}"
    local CRONTAB
    CRONTAB=$(crontab -l 2>/dev/null)
    if [ -z "$CRONTAB" ]; then
        echo -e "${LROUGE}[!]${RESET} Aucune tâche configurée"
    else
        echo "$CRONTAB"
    fi

    echo -e "\n${ROUGE}Crontabs tous utilisateurs ↓${RESET}"
    local SPOOL
    SPOOL=$(ls -la /var/spool/cron/crontabs 2>/dev/null)
    if [ -z "$SPOOL" ]; then
        echo -e "${LROUGE}[!]${RESET} Accès refusé ou vide"
    else
        echo "$SPOOL"
    fi
    
    sleep 1
}