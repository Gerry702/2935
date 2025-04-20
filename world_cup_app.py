import tkinter as tk
from tkinter import ttk
import psycopg2
from psycopg2 import Error
import pandas as pd
from pandastable import Table

class WorldCupApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Statistiques Coupe du Monde")
        self.root.geometry("800x600")
        
        # Configuration de la connexion à la base de données
        self.db_config = {
            'dbname': 'world_cup',
            'user': 'postgres',
            'password': 'postgres',
            'host': 'localhost',
            'port': '5432'
        }
        
        # Création du frame principal
        self.main_frame = ttk.Frame(self.root, padding="10")
        self.main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Création des boutons pour les requêtes
        self.create_buttons()
        
        # Zone d'affichage des résultats
        self.result_frame = ttk.Frame(self.main_frame)
        self.result_frame.grid(row=1, column=0, columnspan=4, pady=10, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Initialisation de la table pour afficher les résultats
        self.table = None
        
    def create_buttons(self):
        # Bouton pour la requête 1
        ttk.Button(self.main_frame, text="Joueurs avec le plus de cartons rouges",
                  command=self.query_red_cards).grid(row=0, column=0, padx=5, pady=5)
        
        # Bouton pour la requête 2
        ttk.Button(self.main_frame, text="Pays organisateurs",
                  command=self.query_host_countries).grid(row=0, column=1, padx=5, pady=5)
        
        # Bouton pour la requête 3
        ttk.Button(self.main_frame, text="Stades les plus utilisés",
                  command=self.query_stadium_usage).grid(row=0, column=2, padx=5, pady=5)
        
        # Bouton pour la requête 4
        ttk.Button(self.main_frame, text="Arbitres les plus actifs",
                  command=self.query_referee_activity).grid(row=0, column=3, padx=5, pady=5)
    
    def execute_query(self, query):
        try:
            # Connexion à la base de données
            conn = psycopg2.connect(**self.db_config)
            cursor = conn.cursor()
            
            # Exécution de la requête
            cursor.execute(query)
            
            # Récupération des résultats
            results = cursor.fetchall()
            columns = [desc[0] for desc in cursor.description]
            
            # Création d'un DataFrame pandas
            df = pd.DataFrame(results, columns=columns)
            
            # Fermeture de la connexion
            cursor.close()
            conn.close()
            
            return df
            
        except Error as e:
            print(f"Erreur lors de l'exécution de la requête: {e}")
            return None
    
    def display_results(self, df):
        # Suppression de l'ancienne table si elle existe
        if self.table:
            self.table.destroy()
        
        # Création d'une nouvelle table
        self.table = Table(self.result_frame, dataframe=df,
                         showtoolbar=True, showstatusbar=True)
        self.table.show()
    
    def query_red_cards(self):
        query = """
        SELECT j.nom, j.prenom, COUNT(*) as nombre_cartons_rouges
        FROM joueur j
        JOIN sanction s ON j.id_joueur = s.id_joueur
        WHERE s.type_sanction = 'rouge'
        GROUP BY j.id_joueur, j.nom, j.prenom
        ORDER BY nombre_cartons_rouges DESC;
        """
        df = self.execute_query(query)
        if df is not None:
            self.display_results(df)
    
    def query_host_countries(self):
        query = """
        SELECT p.nom_pays, COUNT(*) as nombre_organisations
        FROM pays p
        JOIN edition_coupe_monde e ON p.id_pays = e.pays_hote
        GROUP BY p.id_pays, p.nom_pays
        ORDER BY nombre_organisations DESC;
        """
        df = self.execute_query(query)
        if df is not None:
            self.display_results(df)
    
    def query_stadium_usage(self):
        query = """
        SELECT s.nom_stade, COUNT(*) as nombre_matchs
        FROM stade s
        JOIN match m ON s.id_stade = m.id_stade
        GROUP BY s.id_stade, s.nom_stade
        ORDER BY nombre_matchs DESC;
        """
        df = self.execute_query(query)
        if df is not None:
            self.display_results(df)
    
    def query_referee_activity(self):
        query = """
        SELECT a.nom, a.prenom, 
               (SELECT COUNT(*) FROM match WHERE id_arbitre_principal = a.id_arbitre) +
               (SELECT COUNT(*) FROM match WHERE id_arbitre_assistant1 = a.id_arbitre) +
               (SELECT COUNT(*) FROM match WHERE id_arbitre_assistant2 = a.id_arbitre) +
               (SELECT COUNT(*) FROM match WHERE id_arbitre_assistant3 = a.id_arbitre) as nombre_matchs
        FROM arbitre a
        ORDER BY nombre_matchs DESC;
        """
        df = self.execute_query(query)
        if df is not None:
            self.display_results(df)

if __name__ == "__main__":
    root = tk.Tk()
    app = WorldCupApp(root)
    root.mainloop() 