# alustus
import os
import os.path
import sqlite3
from random import randint, choice
from string import printable
from time import process_time

# poistaa tietokannan alussa (kätevä moduulin testailussa)
if os.path.exists("tehokkuustesti.db"):
    os.remove("tehokkuustesti.db")

db = sqlite3.connect("tehokkuustesti.db")
db.isolation_level = None # ilman tätä tarvitaan erillinen commit käsky

def random_string():
    return "".join(choice(printable) for _ in range(8))

# Luo taulu Elokuvat, jossa on sarakkeet id, nimi ja vuosi
db.executescript("""
        CREATE TABLE Elokuvat
                (
                id         INTEGER PRIMARY KEY,
                nimi       TEXT,
                vuosi      DATE
                )
    """)

# 1: ei indeksiä
# 2: indeksi ennen rivien lisäämistä
# 3: indeksi ennen kyselyitä
cmd = 2

if cmd == 1:

    # Rivien lisääminen:
    start_time = process_time()
    db.execute("BEGIN")
    for i in range(1000000):
        db.execute("""
            INSERT INTO Elokuvat (nimi, vuosi) VALUES (?,?)
        """,[random_string(),randint(1900,2000)])
    db.execute("COMMIT")
    print(f"Rivien lisäämiseen kulunut aika: {process_time()-start_time} sekuntia.")

    # Kysely elokuvien määrästä:
    start_time = process_time()
    for i in range(1000):
        db.execute("""
        SELECT COUNT(*)
        FROM Elokuvat
        WHERE vuosi = ?
        """,[randint(1900,2000)])
    print(f"Kyselyiden suoritukseen kulunut aika: {process_time()-start_time} sekuntia.")

elif cmd == 2:

    # Indeksi:
    

    # Rivien lisääminen:
    start_time = process_time()
    db.execute("BEGIN")
    #db.execute("CREATE INDEX idx ON Elokuvat (vuosi)")
    for i in range(1000000):
        db.execute("""
            CREATE INDEX idx ON Elokuvat (vuosi),
            INSERT INTO Elokuvat (nimi, vuosi) VALUES (?,?)
        """,[random_string(),randint(1900,2000)])
    db.execute("COMMIT")
    print(f"Rivien lisäämiseen kulunut aika: {process_time()-start_time} sekuntia.")

    # Kysely elokuvien määrästä:
    start_time = process_time()
    for i in range(1000):
        db.execute("""
        SELECT COUNT(*)
        FROM Elokuvat
        WHERE vuosi = ?
        """,[randint(1900,2000)])
    print(f"Kyselyiden suoritukseen kulunut aika: {process_time()-start_time} sekuntia.")

elif cmd == 3:
    
    # Rivien lisääminen:
    start_time = process_time()
    db.execute("BEGIN")
    for i in range(1000000):
        db.execute("""
            INSERT INTO Elokuvat (nimi, vuosi) VALUES (?,?)
        """,[random_string(),randint(1900,2000)])
    db.execute("COMMIT")
    print(f"Rivien lisäämiseen kulunut aika: {process_time()-start_time} sekuntia.")

    # Indeksi:
    db.execute("CREATE INDEX idx ON Elokuvat (vuosi)")

    # Kysely elokuvien määrästä:
    start_time = process_time()
    for i in range(1000):
        db.execute("""
        SELECT COUNT(*)
        FROM Elokuvat
        WHERE vuosi = ?
        """,[randint(1900,2000)])
    print(f"Kyselyiden suoritukseen kulunut aika: {process_time()-start_time} sekuntia.")