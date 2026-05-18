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