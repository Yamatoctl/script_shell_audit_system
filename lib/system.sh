#!/usr/bin/env bash

fingerprint() {
    titre "SYSTEM FINGERPRINT"

    # nom de l'hote
    echo -e "${ROUGE}hostname ↓${RESET}"
    hostnamectl | while read -r line; do
        printf "%s\n" "$line"
    done

    sleep 1  

    # version os
    echo -e "\n${ROUGE}OS ↓${RESET}"
    while read -r line; do          
        printf "%s\n" "$line"
    done < /etc/os-release

    # kernel option ALL
    echo -e "\n${ROUGE}Kernel ↓${RESET}"
    uname -a 

    # configuration path actuel
    echo -e "\n${ROUGE}Configuration du PATH actuel ↓${RESET}"
    pathswriteable=$(echo $PATH | tr ":" "\n" | while read -r line; do ls -ld "$line" 2>/dev/null; done)
    if [ "$pathswriteable" ]; then
        while read -r line; do
            printf "%s\n" "$line"
        done <<< "$pathswriteable"
    fi
      
    # shell actuel
    echo -e "\n${ROUGE}Shell actuel ↓${RESET}"
    shell_actuel=$(echo $SHELL 2>/dev/null)
    printf "%s\n" "$shell_actuel"

    # shell disponible
    echo -e "\n${ROUGE}Shell disponible ↓${RESET}"
    shell_info=$(cat /etc/shells 2>/dev/null)
    if [ "$shell_info" ]; then
        while read -r line; do
            printf "%s\n" "$line"
        done <<< "$shell_info"
    fi
    
    # date actuel
    echo -e "\n${ROUGE}Date ↓${RESET}"
    date

    sleep 1
}

network() {
    titre "NETWORK INTELLIGENCE"

    # interfaces & ip
    echo -e "${ROUGE}Interfaces & IPs ↓${RESET}"
    ip a 2>/dev/null || hostname -I

    # ports en écoute
    echo -e "\n${ROUGE}Ports en écoute :${RESET}"
    ss -tlnp 2>/dev/null

    # fichier resolv.conf
    echo -e "\n${ROUGE}DNS ↓${RESET}"
    grep nameserver /etc/resolv.conf 2>/dev/null | awk '{print $2}'

    # fichier hosts
    echo -e "\n${ROUGE}Fichier Hosts ↓${RESET}"
    cat /etc/hosts

    sleep 1
}

ressources() {
    titre "SYSTEM RESOURCES"

    # ressource disque
    echo -e "${ROUGE}Espace disque :${RESET}"; df -h /

    # ressource memoire
    echo -e "\n${ROUGE}Mémoire :${RESET}"; free -h
}