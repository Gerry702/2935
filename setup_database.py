import psycopg2
from psycopg2 import Error
import os
import sys

def create_database():
    try:
        # Connexion à la base de données par défaut
        conn = psycopg2.connect(
            dbname='postgres',
            user='postgres',
            password='postgres',
            host='localhost',
            port='5432'
        )
        conn.autocommit = True
        cursor = conn.cursor()
        
        # Vérification si la base de données existe déjà
        cursor.execute("SELECT 1 FROM pg_database WHERE datname = 'world_cup'")
        exists = cursor.fetchone()mlknlm
        
        if not exists:
            # Création de la base de données
            cursor.execute('CREATE DATABASE world_cup')
            print("Base de données 'world_cup' créée avec succès.")
        else:
            print("La base de données 'world_cup' existe déjà.")
        
        cursor.close()
        conn.close()
        
    except Error as e:
        print(f"Erreur lors de la création de la base de données: {e}")
        sys.exit(1)

def import_schema():
    try:
        # Connexion à la nouvelle base de données
        conn = psycopg2.connect(
            dbname='world_cup',
            user='postgres',
            password='postgres',
            host='localhost',
            port='5432'
        )
        cursor = conn.cursor()
        
        # Lecture du fichier SQL
        with open('world_cup.sql', 'r') as file:
            sql_script = file.read()
        
        # Exécution du script SQL
        cursor.execute(sql_script)
        conn.commit()
        
        print("Schéma et données importés avec succès.")
        
        cursor.close()
        conn.close()
        
    except Error as e:
        print(f"Erreur lors de l'importation du schéma: {e}")
        sys.exit(1)

def main():
    print("Début de la configuration de la base de données...")
    create_database()
    import_schema()
    print("Configuration terminée avec succès!")

if __name__ == "__main__":
    main() 