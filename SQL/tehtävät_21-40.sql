/*
Tehtävät liittyvät kurssin 3. lukuun, joka käsittelee useamman taulun kyselyitä.
*/

--Tehtävä 21: Muodosta tuloslista, jossa näkyvät kaikki tulokset.
SELECT P.nimi, T.tulos
FROM Pelaajat P, Tulokset T
WHERE P.id = T.pelaaja_id;

--Tehtävä 22: Muodosta tuloslista, jossa näkyvät Uolevin tulokset.
SELECT P.nimi, T.tulos
FROM Pelaajat P, Tulokset T
WHERE P.id = T.pelaaja_id
AND P.nimi = "Uolevi";

--Tehtävä 23: Muodosta tuloslista, jossa näkyvät tulokset, jotka ovat parempia kuin 250.
SELECT P.nimi, T.tulos
FROM Pelaajat P, Tulokset T
WHERE P.id = T.pelaaja_id
AND T.tulos > 250;

--Tehtävä 24: Muodosta tuloslista, jossa näkyy kaikki tulokset järjestettynä ensisijaisesti käänteisesti pistemäärän mukaan ja toissijaisesti nimen mukaan.
SELECT P.nimi, T.tulos
FROM Pelaajat P, Tulokset T
WHERE P.id = T.pelaaja_id
ORDER BY T.tulos DESC, P.nimi;

--Tehtävä 25: Ilmoita jokaisesta pelaajasta, mikä on hänen paras tuloksensa. Voit olettaa, että jokaisella pelaajalla on ainakin yksi tulos.
SELECT P.nimi, MAX(T.tulos)
FROM Pelaajat P, Tulokset T
WHERE P.id = T.pelaaja_id
GROUP BY P.nimi;

--Tehtävä 26: Ilmoita jokaisesta pelaajasta, montako tulosta hänellä on. Voit olettaa, että jokaisella pelaajalla on ainakin yksi tulos.
SELECT P.nimi, COUNT(*)
FROM Pelaajat P, Tulokset T
WHERE P.id = T.pelaaja_id
GROUP BY P.nimi;

--Tehtävä 27: Hae kaikista suorituksista opiskelijan nimi, kurssin nimi ja arvosana. 
SELECT O.nimi, K.nimi, S.arvosana
FROM Opiskelijat O, Kurssit K, Suoritukset S
WHERE O.id = S.opiskelija_id AND
K.id = S.kurssi_id;

--Tehtävä 28: Hae kaikista Uolevin suorituksista kurssin nimi ja arvosana.
SELECT K.nimi, S.arvosana
FROM Opiskelijat O JOIN Suoritukset S ON O.id = S.opiskelija_id
JOIN Kurssit K ON K.id = S.kurssi_id
WHERE O.nimi = "Uolevi";

--Tehtävä 29: Hae kaikista Ohpen suorituksista opiskelijan nimi ja arvosana. 
SELECT O.nimi, S.arvosana
FROM Opiskelijat O JOIN Suoritukset S ON O.id = S.opiskelija_id
JOIN Kurssit K ON K.id = S.kurssi_id
WHERE K.nimi = "Ohpe";

--Tehtävä 30: Hae kaikki suoritukset, joissa arvosana on 4 tai 5. 
SELECT O.nimi, K.nimi, S.arvosana
FROM Opiskelijat O JOIN Suoritukset S ON O.id = S.opiskelija_id
JOIN Kurssit K ON K.id = S.kurssi_id
WHERE S.arvosana >= 4;

--Tehtävä 31: Hae jokaisesta opiskelijasta suoritusten määrä. Voit olettaa, että jokaisella opiskelijalla on ainakin yksi suoritus. 
SELECT O.nimi, COUNT(*)
FROM Opiskelijat O JOIN Suoritukset S on O.id = S.opiskelija_id
JOIN Kurssit K ON K.id = S.kurssi_id
GROUP BY O.nimi
ORDER BY COUNT(*) DESC;

--Tehtävä 32: Hae jokaisesta opiskelijasta paras suorituksen arvosana. Voit olettaa, että jokaisella opiskelijalla on ainakin yksi suoritus. 
SELECT O.nimi, MAX(S.arvosana)
FROM Opiskelijat O JOIN Suoritukset S ON O.id = S.opiskelija_id
JOIN Kurssit K ON K.id = S.kurssi_id
GROUP BY O.nimi;

--Tehtävä 33: Hae tiedot kaikista lentoyhteyksistä. 
SELECT A.nimi, B.nimi
FROM Kaupungit A, Kaupungit B, Lennot L
WHERE A.id = L.mista_id
AND B.id = L.minne_id;

--Tehtävä 34: Hae kohteet kaikista lennoista, jotka lähtevät Helsingistä. 
SELECT minne.nimi
FROM Kaupungit mista, Kaupungit minne, Lennot L
WHERE mista.id = L.mista_id AND
minne.id = L.minne_id AND
mista.nimi = "Helsinki";

--Tehtävä 35: Ilmoita jokaisesta pelaajasta, montako tulosta hänellä on (myös vaikka ei olisi tuloksia). 
SELECT P.nimi, IFNULL(COUNT(T.pelaaja_id),0)
FROM Pelaajat P LEFT JOIN Tulokset T ON P.id = T.pelaaja_id
GROUP BY P.nimi;

--Tehtävä 36: Hae jokaisesta opiskelijasta suoritusten määrä (myös vaikka ei olisi suorituksia). 
SELECT O.nimi, IFNULL(COUNT(S.opiskelija_id),0)
FROM Opiskelijat O LEFT JOIN Suoritukset S ON O.id = S.opiskelija_id
GROUP BY O.nimi;

--Tehtävä 37: Hae jokaisesta kurssista suorittajien määrä (myös vaikka ei olisi suorituksia). 
SELECT K.nimi, IFNULL(COUNT(S.arvosana),0)
FROM Kurssit K LEFT JOIN Suoritukset S ON K.id = S.kurssi_id
GROUP BY K.nimi;

--Tehtävä 38: Hae nimet kaikista kursseista, joita on suoritettu ainakin kerran. 
SELECT DISTINCT K.nimi
FROM Kurssit K, Suoritukset S
WHERE K.id = S.kurssi_id;

--Tehtävä 39: Hae nimet kaikista kursseista, joita ei ole suoritettu kertaakaan. 
SELECT K.nimi
FROM Kurssit K LEFT JOIN Suoritukset S ON K.id = S.kurssi_id
WHERE S.arvosana IS NULL;

--Tehtävä 40: Hae jokaisesta kaupungista, montako lentoa sieltä lähtee (myös vaikka ei olisi lentoja). 
SELECT K.nimi, IFNULL(COUNT(L.mista_id),0)
FROM Kaupungit K LEFT JOIN Lennot L ON K.id = L.mista_id
GROUP BY K.nimi;