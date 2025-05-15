import sqlite3

db = sqlite3.connect('bikes.db')
db.isolation_level = None

# Ilmoittaa käyttäjän ajaman yhteismatkan:
def distance_of_user(user):
    query = """
            SELECT SUM(T.distance)
            FROM Trips T JOIN Users U ON T.user_id = U.id
            WHERE U.name = ?
            """
    # [user] on lista tiedoista, jotka sijoitetaan kysymysmerkkien tilalle.
    result = db.execute(query, [user]).fetchone()
    return result[0]

# Ilmoittaa käyttäjän keskinopeuden (km/h) kaikilla matkoilla kahden desimaalin tarkkuudella:
def speed_of_user(user):
    # Metrit kilometreiksi / minuutit tunneiksi
    query = """
            SELECT ROUND((SUM(T.distance) / 1000.0) / (SUM(T.duration) / 60.0),2)
            FROM Trips T JOIN Users U ON T.user_id = U.id
            WHERE U.name = ?
            """
    result = db.execute(query, [user]).fetchone()
    return result[0]

# Ilmoittaa jokaisesta kaupungista, kauanko pyörillä ajettiin annettuna päivänä:
def duration_in_each_city(day):
    query = """
            SELECT C.name, SUM(T.duration)
            FROM Trips T JOIN Stops S ON T.from_id = S.id
            JOIN Cities C ON S.city_id = C.id
            WHERE T.day = ?
            GROUP BY C.name
            """
    result = db.execute(query, [day]).fetchall()
    return result

# Ilmoittaa, montako eri käyttäjää pyörillä on ollut annetussa kaupungissa:
def users_in_city(city):
    query = """
            SELECT COUNT(DISTINCT user_ID)
            FROM Trips T JOIN Stops S ON T.from_id = S.id
            JOIN Cities C ON S.city_id = C.id
            WHERE C.name = ?
            """
    result = db.execute(query, [city]).fetchall()
    return result[0]

# Ilmoittaa jokaisesta päivästä, montako matkaa kyseisenä päivänä on ajettu:
def trips_on_each_day(city):
    query = """
            SELECT T.day, COUNT(T.from_id)
            FROM Trips T JOIN Stops S ON T.from_id = S.id
            JOIN Cities C ON S.city_id = C.id
            WHERE C.name = ?
            GROUP BY T.day
            """
    result = db.execute(query, [city]).fetchall()
    return result

# Ilmoittaa kaupungin suosituimman aloitusaseman matkalle sekä matkojen määrän (jos vaihtoehtoja on useita, valitaan niistä aakkosjärjestyksessä viimeisin):
def most_popular_start(city):
    query = """
            SELECT S.name, COUNT(T.from_id)
            FROM Trips T JOIN Stops S ON T.from_id = S.id
            JOIN Cities C ON S.city_id = C.id
            WHERE C.name = ?
            GROUP BY S.name
            ORDER BY COUNT(T.from_id) DESC, S.name DESC
            LIMIT 1
            """
    result = db.execute(query, [city]).fetchall()
    return result