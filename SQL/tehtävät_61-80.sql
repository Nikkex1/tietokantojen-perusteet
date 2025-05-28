/*
Ensimmäinen kurssin kaikkia aiheita yhdistelevä vaikeampi tehtäväsetti.
*/

-- Tehtävä 61: Hae jokaisesta käyttäjästä tieto, monessako ryhmässä hän on.
SELECT K.tunnus, IFNULL(COUNT(O.ryhma_id),0)
FROM Kayttajat K LEFT JOIN Oikeudet O ON K.id = O.kayttaja_id
GROUP BY K.tunnus;

-- Tehtävä 62: Hae jokaisesta ryhmästä tieto, montako käyttäjää siihen kuuluu.
SELECT R.nimi, IFNULL(COUNT(O.ryhma_id),0)
FROM Ryhmat R LEFT JOIN Oikeudet O ON R.id = O.ryhma_id
GROUP BY R.nimi;

-- Tehtävä 63: Hae kaikki käyttäjät, jotka kuuluvat yli yhteen ryhmään. 
SELECT K.tunnus
FROM Kayttajat K JOIN Oikeudet O ON K.id = O.kayttaja_id
GROUP BY K.tunnus
HAVING COUNT(*) > 1;

-- Tehtävä 64: Hae kaikki käyttäjät, jotka kuuluvat ainakin yhteen samaan ryhmään käyttäjän "uolevi" kanssa.
SELECT DISTINCT K.tunnus
FROM kayttajat K JOIN Oikeudet O ON K.id = O.kayttaja_id
WHERE O.ryhma_id IN(
SELECT ryhma_id
FROM Kayttajat JOIN Oikeudet ON id = kayttaja_id
WHERE kayttaja_id = 1);

-- Tehtävä 65: Hae kaikki käyttäjät, jotka eivät kuulu mihinkään samaan ryhmään käyttäjän "uolevi" kanssa.
SELECT tunnus
FROM Kayttajat
WHERE tunnus NOT IN (
SELECT DISTINCT K1.tunnus nimet
FROM Kayttajat K1 JOIN Oikeudet O1 ON K1.id = O1.kayttaja_id
WHERE O1.ryhma_id IN (
SELECT O2.ryhma_id
FROM Kayttajat K2 JOIN Oikeudet O2 ON K2.id = O2.kayttaja_id
WHERE K2.tunnus = "uolevi"
)
);

-- Tehtävä 66: Hae sanat järjestettynä niin, että kirjainkoolla ei ole merkitystä. Jokainen sana muodostuu kirjaimista a–z ja A–Z.
SELECT S.sana
FROM Sanat S
ORDER BY LOWER(S.sana);

-- Tehtävä 67: Hae tuote, jonka hinta on halvin (jos halvimpia tuotteita on useita, valitse aakkosjärjestyksessä ensimmäinen). 
SELECT T.nimi, T.hinta
FROM Tuotteet T
WHERE T.hinta = (SELECT MIN(hinta) FROM Tuotteet)
ORDER BY T.nimi
LIMIT 1;

-- Tehtävä 68: Hae jokaisesta tuotteesta tieto, monenko tuotteen hinta eroaa enintään yhdellä (tässä lasketaan mukaan myös tuote itse).
SELECT A.nimi, COUNT(*)
FROM Tuotteet A, Tuotteet B
WHERE ABS(A.hinta - B.hinta) <= 1
GROUP BY A.nimi;

-- Tehtävä 69: Laske, monellako tavalla voit valita kaksi tuotetta niin, että yhteishinta on tasan 10.
-- Huom! Yhdistelmässä voi olla kaksi samaa tuotetta ja halutaan laskea erilaiset yhdistelmät. Esimerkissä yhdistelmät ovat selleri+selleri ja lanttu+nauris (eli nauris+lanttu ei ole mukana).
SELECT COUNT(*)
FROM Tuotteet A, Tuotteet B
WHERE A.hinta + B.hinta = 10 AND
A.id <= B.id;

-- Tehtävä 70: Laske, mikä on pienin ero kahden tuotteen hinnassa.
SELECT MIN(hintaero)
FROM(
SELECT A.hinta - B.hinta hintaero
FROM Tuotteet A, Tuotteet B
WHERE (A.hinta - B.hinta) > 0
);

-- Tehtävä 71: Laske jokaisen tilin saldo tapahtumien perusteella (jokaisen tilin saldo on aluksi 0).
SELECT T1.haltija, IFNULL(SUM(T2.muutos),0)
FROM Tilit T1 LEFT JOIN Tapahtumat T2 ON T1.id = T2.tili_id
GROUP BY T1.haltija;

-- Tehtävä 72: Laske Uolevin tilin saldon historia. Tapahtumat ovat järjestyksessä id:n mukaisesti.
SELECT SUM(alikysely_muutos2)
FROM (
SELECT T2.id alikysely_id1, T2. muutos alikysely_muutos1
FROM Tilit T1 JOIN Tapahtumat T2 ON T1.id = T2.tili_id
WHERE T1.haltija = "Uolevi"),
(SELECT T2.id alikysely_id2, T2. muutos alikysely_muutos2
FROM Tilit T1 JOIN Tapahtumat T2 ON T1.id = T2.tili_id
WHERE T1.haltija = "Uolevi")
WHERE alikysely_id2 <= alikysely_id1
GROUP BY alikysely_id1;

-- Tehtävä 73: Laske jokaisen tilin suurin saldo historian aikana (jokaisen tilin saldo on aluksi 0).
SELECT T1.haltija, IFNULL(MAX(kumulatiivinen),0)
FROM Tilit T1 LEFT JOIN (
SELECT tili_id, SUM(muutos) OVER (PARTITION BY tili_id ORDER BY id) kumulatiivinen
FROM Tapahtumat
ORDER BY tili_id, id) ON T1.id = tili_id
GROUP BY T1.haltija;

-- Tehtävä 74: Laske, montako eri tehtävää kukin opiskelija on ratkaissut oikein (lähetyksen tila on 0 = väärin tai 1 = oikein).
SELECT nimet, IFNULL(SUM(ratkaisut),0)
FROM (
SELECT O.nimi nimet, SUM(DISTINCT L.tila) ratkaisut
FROM Opiskelijat O LEFT JOIN Lahetykset L ON O.id = L.opiskelija_id
GROUP BY O.nimi, L.tehtava_id
)
GROUP BY nimet;

-- Tehtävä 75: Laske jokaiselle opiskelijalle, montako lähetystä enimmillään hän on lähettänyt samaan tehtävään.
SELECT nimet, MAX(teht_lahetykset)
FROM (
SELECT O.nimi nimet, COUNT(L.tila) teht_lahetykset
FROM Opiskelijat O LEFT JOIN Lahetykset L ON O.id = L.opiskelija_id
GROUP BY O.nimi, L.tehtava_id
)
GROUP BY nimet;

-- Tehtävä 76: Laske tulosten moodi (eli yleisin tulos). Jos vaihtoehtoja on useita, valitse niistä pienin.
SELECT tulos
FROM Tulokset
GROUP BY tulos
ORDER BY COUNT(*) DESC, tulos
LIMIT 1;

-- Tehtävä 77: Laske tulosten mediaani (eli keskimmäinen tulos, kun tulokset on järjestetty pienimmästä suurimpaan). Voit olettaa, että tulosten määrä on pariton.
SELECT MAX(T)
FROM (
SELECT tulos T
FROM Tulokset
ORDER BY tulos
LIMIT (SELECT (COUNT(*) + 1) / 2 FROM Tulokset)
);

-- Tehtävä 78: Laske tulosten mediaani (eli keskimmäinen tulos, kun tulokset on järjestetty pienimmästä suurimpaan). Jos tulosten määrä on parillinen, tulosta keskikohdan vasemmalla puolella oleva tulos.
SELECT MAX(T)
FROM (
SELECT tulos T
FROM Tulokset
ORDER BY tulos
LIMIT (SELECT COUNT(*) / 2 FROM Tulokset)
);

-- Tehtävä 79: Ilmoita jokaisesta junan vaunusta, montako matkustajaa siellä on.
SELECT V.nimi, COUNT(M.nimi)
FROM Vaunut V LEFT JOIN Matkustajat M ON V.id = M.vaunu_id
GROUP BY V.nimi;

-- Tehtävä 80: Ilmoita jokaisesta junan vaunusta, montako tyhjää paikkaa siellä on.
SELECT V.nimi, V.paikat - COUNT(M.nimi)
FROM Vaunut V LEFT JOIN Matkustajat M ON V.id = M.vaunu_id
GROUP BY V.nimi;