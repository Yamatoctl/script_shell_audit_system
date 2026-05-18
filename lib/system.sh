#!/usr/bin/env bash

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

cve_check() {
    titre "CVE KERNEL CHECK"

    local kernel version result cves
    kernel=$(uname -r)
    version=$(echo "$kernel" | grep -oE '^[0-9]+\.[0-9]+\.[0-9]+')
    info "Kernel →" "$kernel"
    info "Version extraite →" "$version"
    if [ -z "$NVD_API_KEY" ]; then
        echo -e "${LROUGE}[!]${RESET} NVD_API_KEY non définie — CVE check désactivé"
        return
    fi
    echo -e "${ROUGE}Recherche CVE NVD...${RESET}"
    result=$(curl -4 -s -A "Mozilla/5.0" "https://services.nvd.nist.gov/rest/json/cves/2.0?keywordSearch=linux+kernel+$version" 2>/dev/null)
    cves=$(echo "$result" | grep -o '"CVE-[0-9-]*"' | tr -d '"' | head -n 10)
    while read -r cve; do
        echo -e "${LROUGE}[!]${RESET} $cve"
    done <<< "$cves"
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

ressources() {
    titre "SYSTEM RESOURCES"

    echo -e "${ROUGE}Espace disque :${RESET}"; df -h /
    echo -e "${ROUGE}Mémoire :${RESET}"; free -h
}