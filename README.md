# 🔴 Red Info — System Intelligence Report

> Script bash de reconnaissance et d'énumération système automatisé, conçu pour l'audit de sécurité et le pentest.

---

## Fonctionnalités

| Module | Description |
|--------|-------------|
| Identity & Privileges | Utilisateur, ID, groupes, répertoire courant |
| Sudo | Détection NOPASSWD, groupes sudo/wheel/adm |
| System Fingerprint | Hostname, OS, kernel, date système |
| Network Intelligence | Interfaces, ports en écoute, DNS, fichier hosts |
| User Enumeration | /etc/passwd, /etc/shadow |
| SUID / SGID | Fichiers avec permissions élevées |
| Scheduled Tasks | Crontabs système et utilisateur |
| System Resources | Espace disque, mémoire |

---

## Structure

```
red-info/
├── red_info.sh       # Point d'entrée
├── README.md
└── lib/
    ├── ui.sh         # Banner, spinner, fonctions d'affichage
    ├── system.sh     # Fingerprint, réseau, ressources
    └── privesc.sh    # Utilisateurs, sudo, SUID, crontabs
```

---

## Prérequis

- Bash 4+
- Linux uniquement
- Commandes requises : `ip`, `ss`, `hostnamectl`, `find`, `sudo`, `cut`, `awk`, `grep`

Le script vérifie automatiquement la présence de ces commandes au démarrage et s'arrête si l'une d'elles est manquante.

---

## Usage

```bash
chmod +x red_info.sh
./red_info.sh
```

Le rapport est généré automatiquement dans le répertoire courant :

```
rapport-DD-MM-YYYY_HH-MM.txt
```

---

## Rapport généré

Le rapport contient l'ensemble des informations collectées, sauvegardées dans un fichier texte horodaté. Il peut être exfiltré ou analysé hors ligne.

---

## Disclaimer

> Ce script est destiné **uniquement** à des environnements pour lesquels vous disposez d'une **autorisation explicite**.  
> Toute utilisation non autorisée est illégale et contraire à l'éthique.  
> L'auteur décline toute responsabilité en cas d'usage abusif.