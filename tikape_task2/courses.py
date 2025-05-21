import os
import os.path
import sqlite3

# poistaa tietokannan alussa (kätevä moduulin testailussa)
if os.path.exists("courses.db"):
    os.remove("courses.db")

db = sqlite3.connect("courses.db")
db.isolation_level = None # ilman tätä tarvitaan erillinen commit käsky


# **TAULUKOIDEN LISÄYS**


# opettaja: nimi
# kurssi: nimi, krediitit, opettajat
# opiskelija: nimi
# suoritus: opiskelija, kurssi, päivämäärä, arvosana
# ryhmä: nimi, opettajat, opiskelijat

# luo tietokantaan tarvittavat taulut
def create_tables():
    db.executescript("""
            CREATE TABLE Teachers
            (
                id          INTEGER PRIMARY KEY,
                name        TEXT
            );
            CREATE TABLE Courses
            (
                id          INTEGER PRIMARY KEY,
                name        TEXT,
                credits     INTEGER
            );
            CREATE TABLE Students
            (
                id          INTEGER PRIMARY KEY,
                name        TEXT
            );
            CREATE TABLE Accomplishments
            (
                id          INTEGER PRIMARY KEY,
                date        DATE,
                grade       INTEGER,
                student_id  INTEGER REFERENCES Students(id),
                course_id   INTEGER REFERENCES Courses(id)
            );
            CREATE TABLE Groups
            (
                id          INTEGER PRIMARY KEY,
                name        TEXT
            );
            CREATE TABLE TaughtCourses
            (
                id          INTEGER PRIMARY KEY,
                teacher_id  INTEGER REFERENCES Teachers(id),
                course_id   INTEGER REFERENCES Courses(id)
            );
            CREATE TABLE GroupMembers
            (
                group_id    INTEGER REFERENCES Groups(id),
                teacher_id  INTEGER REFERENCES Teachers(id),
                student_id  INTEGER REFERENCES Students(id)
            );
        """)


# **RIVIEN LISÄYS**


# lisää opettajan tietokantaan
def create_teacher(name):
    query = """
    INSERT INTO Teachers(name) VALUES (?)
    """
    id = db.execute(query,[name]).lastrowid
    return id

# lisää kurssin tietokantaan
def create_course(name, credits, teacher_ids):
    query1 = """
    INSERT INTO Courses(name,credits) VALUES (?,?)
    """
    id = db.execute(query1, [name,credits]).lastrowid # Kurssin id-numero
    query2 = """
    INSERT INTO TaughtCourses(teacher_id,course_id) VALUES (?,?)
    """
    for t_id in teacher_ids:
        db.execute(query2,[t_id,id]) # Opettajan id, kurssin id
    return id


# lisää opiskelijan tietokantaan
def create_student(name):
    query = """
    INSERT INTO Students(name) VALUES (?)
    """
    id = db.execute(query,[name]).lastrowid
    return id

# antaa opiskelijalle suorituksen kurssista
def add_credits(student_id, course_id, date, grade):
    query = """
    INSERT INTO Accomplishments(date,grade,student_id,course_id) VALUES (?,?,?,?)
    """
    id = db.execute(query,[date,grade,student_id,course_id]).lastrowid
    return id

# lisää ryhmän tietokantaan
def create_group(name, teacher_ids, student_ids):
    query1 = """
    INSERT INTO Groups(name) VALUES (?)
    """
    id = db.execute(query1,[name]).lastrowid # Ryhmän id-numero
    query2 = """
    INSERT INTO GroupMembers(group_id,teacher_id) VALUES (?,?)
    """
    for t_id in teacher_ids:
        db.execute(query2,[id,t_id]) # kurssin id, opettajan id
    query3 = """
    INSERT INTO GroupMembers(group_id,student_id) VALUES (?,?)
    """
    for s_id in student_ids:
        db.execute(query3,[id,s_id]) # kurssin id, opiskelijan id
    return id


# **HAKUFUNKTIOT**


# hakee kurssit, joissa opettaja opettaa (aakkosjärjestyksessä)
def courses_by_teacher(teacher_name):
    query = """
    SELECT C.name
    FROM Teachers T JOIN TaughtCourses TC ON T.id = TC.teacher_id
    JOIN Courses C ON TC.course_id = C.id
    WHERE T.name = ?
    ORDER BY C.name
    """
    result = db.execute(query,[teacher_name]).fetchall()
    return [item[0] for item in result]

# hakee opettajan antamien opintopisteiden määrän
def credits_by_teacher(teacher_name):
    query = """
    SELECT SUM(C.credits)
    FROM Teachers T JOIN TaughtCourses TC ON T.id = TC.teacher_id
    JOIN Courses C ON TC.course_id = C.id
    JOIN Accomplishments A ON C.id = A.course_id
    WHERE T.name = ? 
    """
    result = db.execute(query,[teacher_name]).fetchone()
    return result[0]

# hakee opiskelijan suorittamat kurssit arvosanoineen (aakkosjärjestyksessä)
def courses_by_student(student_name):
    query = """
    SELECT C.name, A.grade
    FROM Courses C JOIN Accomplishments A ON C.id = A.course_id
    JOIN Students S ON A.student_id = S.id
    WHERE S.name = ?
    ORDER BY C.name
    """
    result = db.execute(query,[student_name]).fetchall()
    return result

# hakee tiettynä vuonna saatujen opintopisteiden määrän
def credits_by_year(year):
    query = """
    SELECT SUM(C.credits)
    FROM Courses C JOIN Accomplishments A ON C.id = A.course_id
    WHERE grade > 0 AND
    ? = CAST(SUBSTR(A.date,1,4) AS INT)
    """
    result = db.execute(query,[year]).fetchone()
    return result[0]

# hakee kurssin arvosanojen jakauman (järjestyksessä arvosanat 1-5)
def grade_distribution(course_name):
    grades = {n:0 for n in range(1,6)}
    query = """
    SELECT A.grade, COUNT(a.grade)
    FROM Courses C JOIN Accomplishments A ON C.id = A.course_id
    WHERE C.name = ?
    GROUP BY A.grade
    """
    result = db.execute(query,[course_name]).fetchall()
    return grades | dict(result)

# hakee listan kursseista (nimi, opettajien määrä, suorittajien määrä) (aakkosjärjestyksessä)
def course_list():
    query = """
    SELECT C.name, COUNT(DISTINCT TC.teacher_id), COUNT(DISTINCT A.student_id)
    FROM Teachers T JOIN TaughtCourses TC ON T.id = TC.teacher_id
    RIGHT JOIN Courses C ON TC.course_id = C.id
    LEFT JOIN Accomplishments A ON C.id = A.course_id
    GROUP BY C.name
    """
    result = db.execute(query).fetchall()
    return result

# hakee listan opettajista kursseineen (aakkosjärjestyksessä opettajat ja kurssit)
def teacher_list():
    t_dict = {}
    t_list = []
    query = """
    SELECT T.name, C.name
    FROM Teachers T JOIN TaughtCourses TC ON T.id = TC.teacher_id
    JOIN Courses C ON TC.course_id = C.id
    ORDER BY T.name
    """
    result = db.execute(query).fetchall()
    for item in result:
        if item[0] not in t_dict:
            t_dict[item[0]] = []
        t_dict[item[0]].append(item[1])

    for key,value in t_dict.items():
        t_list.append((key,value))

    return t_list

# hakee ryhmässä olevat henkilöt (aakkosjärjestyksessä)
def group_people(group_name):
    query = """
    SELECT S.name
    FROM Groups G JOIN GroupMembers GM ON G.id = GM.group_id
    JOIN Students S ON S.id = GM.student_id
    WHERE G.name = ?
    UNION
    SELECT T.name
    FROM Groups G JOIN GroupMembers GM ON G.id = GM.group_id
    JOIN Teachers T ON T.id = GM.teacher_id
    WHERE G.name = ?
    """
    result = db.execute(query,[group_name,group_name]).fetchall()
    result = [item[0] for item in result]
    return sorted(result)

# hakee ryhmissä saatujen opintopisteiden määrät (aakkosjärjestyksessä)
def credits_in_groups():
    query = """
    SELECT G.name, IFNULL(SUM(C.credits),0)
    FROM Groups G JOIN GroupMembers GM ON G.id = GM.group_id
    JOIN Students S ON GM.student_id = S.id
    LEFT JOIN Accomplishments A ON S.id = A.student_id
    LEFT JOIN Courses C ON A.course_id = C.id
    GROUP BY G.name
    ORDER BY G.name
    """
    result = db.execute(query).fetchall()
    return result

# hakee ryhmät, joissa on tietty opettaja ja opiskelija (aakkosjärjestyksessä)
def common_groups(teacher_name, student_name):
    query = """
    SELECT G.name
    FROM Groups G JOIN GroupMembers GM ON G.id = GM.group_id
    JOIN Teachers T ON GM.teacher_id = T.id
    WHERE t.name = ? AND
    G.name IN (
    SELECT G.name
    FROM Groups G JOIN GroupMembers GM ON G.id = GM.group_id
    JOIN Students S ON GM.student_id = S.id
    WHERE S.name = ?
    )
    ORDER BY G.name
    """
    result = db.execute(query,[teacher_name,student_name]).fetchall()
    return [item[0] for item in result]