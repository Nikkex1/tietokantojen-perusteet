/*
Tehtävät liittyvät kurssin 2. lukuun, joka käsittelee SQL-kielen perusteita.
*/

-- Tehtävä 1: Hae kaikkien elokuvien nimet.
SELECT nimi FROM Elokuvat

-- Tehtävä 2: Hae kaikkien elokuvien nimet ja julkaisuvuodet.
SELECT nimi, vuosi FROM Elokuvat

-- Tehtävä 3: Hae kaikkien vuonna 1940 julkaistujen elokuvien nimet.
SELECT nimi FROM Elokuvat WHERE vuosi = 1940

-- Tehtävä 4: Hae ennen vuotta 1950 julkaistujen elokuvien nimet.
SELECT nimi FROM Elokuvat WHERE vuosi < 1950

-- Tehtävä 5: Hae vuosina 1940–1950 julkaistujen elokuvien nimet.
SELECT nimi FROM Elokuvat WHERE vuosi >= 1940 AND vuosi <=1950

-- Tehtävä 6: Hae ennen vuotta 1950 tai vuoden 1980 jälkeen julkaistujen elokuvien nimet. 
SELECT nimi FROM Elokuvat WHERE vuosi < 1950 OR vuosi > 1980

-- Tehtävä 7: Hae kaikkien elokuvien nimet, joita ei ole julkaistu vuonna 1940.
SELECT nimi FROM Elokuvat WHERE vuosi <> 1940

-- Tehtävä 8: Hae kaikkien elokuvien nimet aakkosjärjestyksessä.
SELECT nimi FROM Elokuvat ORDER BY nimi

-- Tehtävä 9: Hae kaikkien elokuvien nimet käänteisessä aakkosjärjestyksessä.
SELECT nimi FROM Elokuvat ORDER BY nimi DESC

-- Tehtävä 10: Hae elokuvien nimet ja julkaisuvuodet ensisijaisesti käänteisessä järjestyksessä julkaisuvuoden mukaan, toissijaisesti aakkosjärjestyksessä.
SELECT nimi, vuosi FROM Elokuvat ORDER BY vuosi DESC, nimi

-- Tehtävä 11: Hae kaikki eri etunimet.
SELECT DISTINCT etunimi FROM Nimet

-- Tehtävä 12: Hae kaikki eri nimet.
SELECT DISTINCT etunimi, sukunimi FROM Nimet

-- Tehtävä 13: Hae työntekijöiden määrä.
SELECT COUNT(*) FROM Tyontekijat

-- Tehtävä 14: Hae niiden työntekijöiden määrä, joiden palkka on yli 2000.
SELECT COUNT(*) FROM Tyontekijat WHERE palkka > 2000

-- Tehtävä 15: Hae työntekijöiden yhteispalkka.
SELECT SUM(palkka) FROM Tyontekijat

-- Tehtävä 16: Hae suurin työntekijän palkka.
SELECT MAX(palkka) FROM Tyontekijat

-- Tehtävä 17: Hae eri yritysten määrä.
SELECT COUNT(DISTINCT yritys) FROM Tyontekijat

-- Tehtävä 18: Hae jokaisen yrityksen työntekijöiden määrä.
SELECT yritys, COUNT(*) FROM Tyontekijat GROUP BY yritys

-- Tehtävä 19: Hae jokaisesta yrityksestä suurin työntekijän palkka.
SELECT yritys, MAX(palkka) FROM Tyontekijat GROUP BY yritys

-- Tehtävä 20: Näytä suurin työntekijän palkka yrityksistä, joissa se on ainakin 5000.
SELECT yritys, MAX(palkka) FROM Tyontekijat GROUP BY yritys HAVING palkka >= 5000