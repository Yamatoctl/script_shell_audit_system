# Red Info — System Intelligence Report

Script bash de reconnaissance et d'énumération système orienté pentest.

## Fonctionnalités

- Identité & privilèges
- Droits sudo
- Fingerprint système
- Réseau & ports
- Énumération utilisateurs & shadow
- Fichiers SUID/SGID
- Tâches planifiées
- Ressources système

## Structure

projet/
├── red_info.sh
├── README.md
└── lib/
    ├── ui.sh
    ├── system.sh
    └── privesc.sh

## Utilisation

chmod +x red_info.sh
./red_info.sh

Le rapport est généré dans : rapport-DD-MM-YYYY_HH-MM.txt

## Avertissement

À utiliser uniquement sur des systèmes dont vous avez l'autorisation.