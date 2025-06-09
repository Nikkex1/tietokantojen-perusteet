/*
Toinen kurssin kaikkia aiheita yhdistelevä vaikeampi tehtäväsetti.
*/

-- Tehtävä 81: Laske, montako tyhjää paikkaa junassa on kaikkiaan.
SELECT SUM(T)
FROM (
SELECT V.paikat - COUNT(M.nimi) T
FROM Vaunut V LEFT JOIN Matkustajat M ON V.id = M.vaunu_id
GROUP BY V.nimi
);

-- Tehtävä 82: Hae jokaisesta matkustajasta tieto, montako muuta matkustajaa on samassa vaunussa.
SELECT A.nimi, COUNT(*) - 1
FROM Matkustajat A, Matkustajat B
WHERE A.vaunu_id = B.vaunu_id
GROUP BY A.nimi;

-- Tehtävä 83: Hae kaikki matkustajat, jotka ovat yksin vaunussaan.
SELECT nimi
FROM Matkustajat
GROUP BY vaunu_id
HAVING COUNT(vaunu_id) = 1;

-- Tehtävä 84: Hae kaikki vaunut, joissa ei ole yhtään matkustajaa.
SELECT V.nimi
FROM Vaunut V LEFT JOIN Matkustajat M ON V.id = M.vaunu_id
WHERE M.vaunu_id IS NULL;

-- Tehtävä 85: Laske, monellako tavalla voidaan valita kaksi matkustajaa, jotka ovat samassa vaunussa.
SELECT COUNT(*)
FROM Matkustajat M1, Matkustajat M2
WHERE M1.vaunu_id = M2.vaunu_id AND
M1.nimi <> M2.nimi AND
M1.id <= M2.id;

-- Tehtävä 86: Hae jokaisesta paketista tuotteiden määrä ja eri tuotteiden määrä.
SELECT P.nimi, IFNULL(COUNT(S.paketti_id),0), IFNULL(COUNT(DISTINCT S.tuote_id),0)
FROM Paketit P LEFT JOIN Sisallot S ON P.id = S.paketti_id
GROUP BY P.nimi;

-- Tehtävä 87: Ilmoita jokaisesta paketista hinta, tuotteiden hinta erikseen ostettuna sekä paketin tuottama säästö.
SELECT nimi, hinta, IFNULL(hinta_erikseen,0), IFNULL(hinta_erikseen - hinta,-hinta)
FROM Paketit LEFT JOIN (
SELECT S.paketti_id alakysely_id, SUM(T.hinta) hinta_erikseen
FROM Tuotteet T JOIN Sisallot S ON T.id = S.tuote_id
GROUP BY S.paketti_id
) ON id = alakysely_id;

-- Tehtävä 88: Hae jokaisesta tuotteesta tieto, monessako paketissa se esiintyy (yhden tai useamman kerran).
SELECT T.nimi, IFNULL(COUNT(DISTINCT S.paketti_id),0)
FROM Tuotteet T LEFT JOIN Sisallot S ON T.id = S.tuote_id
GROUP BY T.nimi;

-- Tehtävä 89: Hae jokaisesta tuotteesta tieto, montako kertaa se esiintyy enimmillään samassa paketissa.
SELECT T.nimi, IFNULL(MAX(maara),0)
FROM Tuotteet T LEFT JOIN (
SELECT paketti_id, tuote_id alikysely_id, COUNT(tuote_id) maara
FROM Sisallot
GROUP BY paketti_id, tuote_id
) ON T.id = alikysely_id
GROUP BY T.nimi;

-- Tehtävä 90: Muodosta tuloslista, jossa on sijaluku, pelaajan nimi ja paras tulos. Jos kahdella pelaajalla on sama tulos, nimet järjestetään aakkosjärjestykseen. Jokaisella pelaajalla on eri nimi ja ainakin yksi tulos.
SELECT RANK() OVER (ORDER BY T.tulos DESC, P.nimi), P.nimi, MAX(T.tulos)
FROM Pelaajat P JOIN Tulokset T ON P.id = T.pelaaja_id
GROUP BY P.nimi;

-- Tehtävä 91: Muodosta tuloslista, jossa on sijaluku, pelaajan nimi ja paras tulos. Jos kahdella pelaajalla on sama tulos, he ovat jaetulla sijalla aakkosjärjestyksessä (ks. esimerkki). Jokaisella pelaajalla on eri nimi ja ainakin yksi tulos.
SELECT RANK() OVER (ORDER BY T.tulos DESC) sijat, P.nimi nimet, MAX(T.tulos)
FROM Pelaajat P JOIN Tulokset T ON P.id = T.pelaaja_id
GROUP BY P.nimi
ORDER BY sijat, nimet;

-- Tehtävä 92: Ilmoita jokaisesta käyttäjästä, montako sellaista kaveria hänen kaverilistallaan on, joiden kaverilistalla hän esiintyy itse.
SELECT nimi, IFNULL(maara,0)
FROM Kayttajat LEFT JOIN (
SELECT A.kayttaja_id alikysely_id, COUNT(*) maara
FROM Kaverit A, Kaverit B
WHERE A.kaveri_id = B.kayttaja_id AND
A.kayttaja_id = B.kaveri_id
GROUP BY A.kayttaja_id
) ON id = alikysely_id;

-- Tehtävä 93: Ilmoita jokaisesta käyttäjästä, monellako muulla käyttäjällä on täysin sama kaverilista.
SELECT nimi, IFNULL(maarat,(SELECT COUNT(*) FROM Kayttajat)-1)
FROM Kayttajat LEFT JOIN (SELECT alikysely_id, -1 + COUNT(samat) OVER (PARTITION BY samat ORDER BY samat) maarat
FROM (
SELECT kayttaja_id alikysely_id, GROUP_CONCAT (kaveri_id) samat
FROM Kaverit
GROUP BY kayttaja_id
)
) ON id = alikysely_id;

-- Tehtävä 94: Ilmoita jokaisesta käyttäjästä, monellako muulla käyttäjällä on kaverilistalla kaikki käyttäjän kaverit.


-- Tehtävä 95: Ilmoita jokaisesta käyttäjästä, montako muuta eri käyttäjää on joko hänen kaverilistallaan tai jonkun kaverin kaverilistalla.


-- Tehtävä 96: Pelaajat jaetaan joukkueisiin niin, että aakkosjärjestyksessä joka toinen pelaaja kuuluu joukkueeseen 1 ja 2. Ilmoita joukkuejako annetuille pelaajille.
SELECT nimet,
CASE WHEN sija % 2 <> 0 THEN 1 ELSE 2 END
FROM (
SELECT RANK() OVER (ORDER BY nimi) sija, nimi nimet
FROM Pelaajat
ORDER BY nimi
);

-- Tehtävä 97: Pelaajat jaetaan joukkueisiin niin, että aakkosjärjestyksessä joka toinen pelaaja kuuluu joukkueeseen "Puput" ja "Kilit". Ilmoita joukkuejako annetuille pelaajille.
SELECT nimet,
CASE WHEN sija % 2 <> 0 THEN "Puput" ELSE "Kilit" END
FROM (
SELECT RANK() OVER (ORDER BY nimi) sija, nimi nimet
FROM Pelaajat
ORDER BY nimi
);

-- Tehtävä 98: Jokaisesta varauksesta on tiedossa alkupäivä ja loppupäivä. Kaksi varausta ovat päällekkäin, jos jokin päivä kuuluu kumpaankin varaukseen. Laske jokaiselle varaukselle, moniko toinen varaus menee päällekkäin sen kanssa.
SELECT A.id, COUNT(*) - 1
FROM Varaukset A, Varaukset B
WHERE (A.alku BETWEEN B.alku AND B.loppu) OR
(A.loppu BETWEEN B.alku AND B.loppu) OR
(B.alku BETWEEN A.alku AND A.loppu) OR
(B.loppu BETWEEN A.alku AND A.loppu)
GROUP BY A.id;

-- Tehtävä 99: Jokaisesta varauksesta on tiedossa alkupäivä ja loppupäivä. Mitkään kaksi varausta eivät ole päällekkäin. Ilmoita, mikä on suurin määrä tyhjiä päiviä kahden peräkkäisen varauksen välillä.
SELECT MAX(tyhjat)
FROM (
SELECT alku_B - loppu_A - 1 tyhjat
FROM (
SELECT
A.alku alku_A, A.loppu loppu_A,
B.alku alku_B, B.loppu loppu_B
FROM Varaukset A, Varaukset B
ORDER BY A.alku, A.loppu, B.alku, B.loppu
)
WHERE alku_A < alku_B AND
loppu_A < loppu_B
GROUP BY alku_A
);

-- Tehtävä 100: Jokaisesta varauksesta on tiedossa alkupäivä ja loppupäivä. Laske, montako varausta on enimmillään päällekkäin samana päivänä.
SELECT MAX(paallekkain)
FROM (
SELECT COUNT(*) paallekkain
FROM Varaukset A, Varaukset B
WHERE (A.alku BETWEEN B.alku AND B.loppu) OR
(A.loppu BETWEEN B.alku AND B.loppu)
GROUP BY A.id
);