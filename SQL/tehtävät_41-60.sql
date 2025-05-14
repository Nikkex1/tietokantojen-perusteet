/*
Tehtävät liittyvät kurssin 4. lukuun, jonka aiheena ovat
    tyypit ja lausekkeet,
    NULL-arvot,
    alikyselyt
    sekä liuta muita hyödyllisiä tekniikoita.
*/

-- Tehtävä 41: Hae jokaisen tuotteen hinta kaksinkertaisena.
SELECT T.nimi, T.hinta * 2
FROM Tuotteet T;

-- Tehtävä 42: Hae kaikki tuotteet, joiden hinta on parillinen. 
SELECT T.nimi, t.hinta
FROM Tuotteet T
WHERE T.hinta % 2 = 0;

-- Tehtävä 43: Hae jokaisen sanan pituus merkkeinä. 
SELECT S.sana, length(S.sana)
FROM Sanat S;

-- Tehtävä 44: Hae kaikki sanat, joiden pituus on alle 6 merkkiä. 
SELECT S.sana
FROM Sanat S
WHERE length(S.sana) < 6;

-- Tehtävä 45: Hae sanat järjestettynä ensisijaisesti pituuden mukaan ja toissijaisesti aakkosjärjestyksen mukaan. 
SELECT S.sana
FROM Sanat S
ORDER BY length(S.sana), S.sana;

-- Tehtävä 46: Hae käyttäjien koko nimet yhtenä sarakkeena. 
SELECT K.etunimi || " " || K.sukunimi
FROM Kayttajat K;

-- Tehtävä 47: Hae kaikkien sanojen yhteispituus. 
SELECT SUM(length(S.sana))
FROM Sanat S;

-- Tehtävä 48: Laske jokaisen tilauksen yhteishinta. 
SELECT T.tuote, T.hinta * T.maara
FROM Tilaukset T;

-- Tehtävä 49: Laske kaikkien tilausten yhteishintojen summa. 
SELECT SUM(T.hinta * T.maara)
FROM Tilaukset T;

-- Tehtävä 50: Hae kaikkien elokuvien nimet, jotka on julkaistu karkausvuonna. (Vuosi on karkausvuosi, jos se on jaollinen 4:llä. Jos vuosi on jaollinen 100:lla, se on karkausvuosi vain, jos se on myös jaollinen 400:lla.) 
SELECT E.nimi
FROM Elokuvat E
WHERE (E.vuosi % 100 = 0 AND E.vuosi % 400 = 0) OR
(E.vuosi % 4 = 0 AND E.vuosi % 100 <> 0);

-- Tehtävä 51: Hae kaikki tuotteet, joiden hinta on halvin hinta. 
SELECT T.nimi
FROM Tuotteet T
WHERE T.hinta = (SELECT MIN(hinta) FROM Tuotteet);

-- Tehtävä 52: Hae kaikki tuotteet, joiden hinta on enintään kaksinkertainen halvimpaan hintaan verrattuna. 
SELECT T.nimi
FROM Tuotteet T
WHERE T.hinta <= 2 * (SELECT MIN(hinta) FROM Tuotteet);

-- Tehtävä 53: Hae kaikki tuotteet, joiden hintaa ei ole millään muulla tuotteella. 
SELECT T.nimi
FROM Tuotteet T
WHERE T.hinta NOT IN (
SELECT hinta FROM Tuotteet
WHERE T.id <> id);

-- Tehtävä 54: Hae aakkosjärjestyksessä ensimmäinen sana. 
SELECT S.sana
FROM Sanat S
ORDER BY S.sana LIMIT 1;

-- Tehtävä 55: Hae aakkosjärjestyksessä toinen sana. Voit olettaa, että taulussa ei ole kahta samaa sanaa. 
SELECT MAX(sana)
FROM(SELECT sana
FROM Sanat
ORDER BY sana
LIMIT 2);

-- Tehtävä 56: Hae kaikki sanat paitsi aakkosjärjestyksessä ensimmäinen. Voit olettaa, että taulussa ei ole kahta samaa sanaa. 
SELECT S.sana
FROM Sanat S
WHERE S.sana NOT IN (
SELECT sana
FROM Sanat
ORDER BY sana LIMIT 1);

-- Tehtävä 57: Hae kaikki sanat, joissa esiintyy i-kirjain. 
SELECT S.sana
FROM Sanat S
WHERE S.sana LIKE "%i%";

-- Tehtävä 58: Hae kaikki sanat, jotka alkavat a-kirjaimella.
SELECT S.sana
FROM Sanat S
WHERE S.sana LIKE "a%";

-- Tehtävä 59: Hae kaikki sanat, joissa on tasan viisi kirjainta ja toinen kirjain on p. 
SELECT S.sana
FROM Sanat S
WHERE S.sana LIKE "_p___";

-- Tehtävä 60: Hae kaikki sanat, joissa on tasan kaksi a-kirjainta. 
SELECT S.sana
FROM Sanat S
WHERE S.sana LIKE "%a%a%" AND
S.sana NOT LIKE "%a%a%a%";