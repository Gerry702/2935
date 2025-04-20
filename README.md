# Application de Gestion de la Coupe du Monde

Cette application permet de gérer et d'analyser les données de la Coupe du Monde de football.

## Prérequis

- Python 3.x
- PostgreSQL
- pip (gestionnaire de paquets Python)

## Installation

1. Clonez le dépôt :
```bash
git clone [URL_DU_REPO]
cd [NOM_DU_REPERTOIRE]
```

2. Installez les dépendances Python :
```bash
pip install -r requirements.txt
```

3. Assurez-vous que PostgreSQL est installé et en cours d'exécution sur votre machine.

4. Configurez la base de données :
```bash
python setup_database.py
```
Cette commande va :
- Créer la base de données 'world_cup'
- Importer le schéma et les données initiales

## Configuration de la Base de Données

Par défaut, l'application utilise les paramètres suivants :
- Base de données : world_cup
- Utilisateur : postgres
- Mot de passe : postgres
- Hôte : localhost
- Port : 5432

Si vous souhaitez utiliser des paramètres différents, modifiez les valeurs dans le fichier `setup_database.py`.

## Utilisation

Pour lancer l'application :
```bash
python world_cup_app.py
```

## Fonctionnalités

L'application permet de :
- Consulter les informations sur les équipes
- Voir les matchs et leurs résultats
- Analyser les statistiques des joueurs
- Gérer les données de la Coupe du Monde

## Structure du Projet

- `world_cup_app.py` : Application principale
- `setup_database.py` : Script de configuration de la base de données
- `world_cup.sql` : Schéma et données de la base de données
- `requirements.txt` : Dépendances Python

## Support

Pour toute question ou problème, veuillez ouvrir une issue dans le dépôt GitHub.

## Licence

[Spécifiez la licence ici] 