/*
	Lisätään uusi toimipiste.
*/
INSERT INTO Toimipiste
VALUES ('Oodi', 'Töölönlahdenkatu 4');


/*
	Lisätään uusi kirja ja yksittäinen kirjan kappale.

	Ensin lisätään kirjan yleiset tiedot, jonka jälkeen lisätään yksittäisen kappaleen tiedot. Tämän jälkeen lisätään kappale johonkin toimipisteeseen.
*/
INSERT INTO Teos
VALUES ('978-951-1-23676-4', 'Kalevala', 2009, 'Kaunokirjallisuus', 'suomi');

INSERT INTO Kirja
VALUES ('978-951-1-23676-4', 'Elias Lönnrot', 'Otava', 475);

INSERT INTO Kappale
VALUES ('978-951-1-23676-4', 0, TRUE, TRUE, '+30 days', 'Oodi');

INSERT INTO Toimipisteessa
VALUES ('978-951-1-23676-4', 0, 'Oodi');


/*
	Lisätään uusi asiakas.
*/
INSERT INTO Asiakas
VALUES (123, 'Matti Meikäläinen', 'Otakaari 20', 'matti.meikalainen@gmail.com');


/*
	Asiakas lainaa teoksen kappaleen toimipisteestä.
	Oletetaan, että kappale on toimipisteessä ja asiakas voi lainata sen, eli
	se on lainattavissa eikä ole varattuna kenellekään muulle.
	Lainausajaksi asetetaan lainaushetki ja erääntymisajaksi 
	lainaushetki + kappaleen max lainausaika.
	Poistetaan tämän jälkeen kappale toimipisteestä, jossa se oli.
	Poistetaan myös käyttäjän mahdolliset teokseen kohdistuneet varaukset.

	Matti Meikäläinen lainaa yhden kappaleen Kalevalaa.
*/
INSERT INTO Lainassa
VALUES ('978-951-1-23676-4', 0, datetime('now'), datetime('now', 
	(SELECT maxLainausaika 
	FROM Kappale 
	WHERE standardiTunnus = '978-951-1-23676-4' AND kappaleTunnus = 0))
, 123);

DELETE FROM Toimipisteessa
WHERE standardiTunnus = '978-951-1-23676-4' AND kappaleTunnus = 0;

DELETE FROM Varaus
WHERE teosStandardiTunnus = '978-951-1-23676-4' AND varaajaAsiakasNro = 123;

/*
	Asiakas palauttaa teoksen kappaleen johonkin toimipisteeseen.
	Lisätään kappale palautustoimipisteeseen, poistetaan kappale Lainassa-relaatiosta ja tallennetaan tieto palautustapahtumasta.

	Matti Meikäläinen palauttaa lainatun Kalevalan kappaleen Oodiin.
*/
INSERT INTO Toimipisteessa
VALUES ('978-951-1-23676-4', 0, 'Oodi');

INSERT INTO Palautus
VALUES ('978-951-1-23676-4', 0, datetime('now'), (SELECT asiakasNro 
	FROM Lainassa 
	WHERE standardiTunnus = '978-951-1-23676-4' AND kappaleTunnus = 0));

DELETE FROM Lainassa
WHERE standardiTunnus = '978-951-1-23676-4' AND kappaleTunnus = 0;

/*
	Selvitetään, missä toimipisteissä on vapaana tietyn teoksen kappale.

	Kysytään, missä toimipisteissä on Kalevalan kappale.
*/
SELECT DISTINCT toimipisteNimi
FROM Toimipisteessa
WHERE standardiTunnus = '978-951-1-23676-4';

/*
	Selvitetään, mitä teoksia asiakkaalla on lainassa tällä hetkellä ja mitkä ovat lainojen erääntymispäivät.

	Kysytään, mitä lainoja Matti Meikäläisellä on tällä hetkellä.
*/
SELECT standardiTunnus, nimi, eraantymisAika
FROM Lainassa NATURAL JOIN Teos
WHERE asiakasNro = 123;

/*
	Selvitetään aikajärjestyksessä, kenellä teoksen kappale on aiemmin ollut lainassa
	ja milloin se on palautettu.

	Kysytään Kalevalan palautushistoria.
*/
SELECT asiakasNro, nimi, osoite, email, palautusAjankohta
FROM Palautus NATURAL JOIN Asiakas
WHERE standardiTunnus = '978-951-1-23676-4' AND kappaleTunnus = 0
ORDER BY palautusAjankohta DESC;

/*
	Tehdään uusi teokseen kohdistuva varaus.

	Matti Meikäläinen varaa kappaleen Kalevalaa toimitettavaksi Oodiin.
*/
INSERT INTO Varaus (tunniste, teosStandardiTunnus, varausAjankohta, varaajaAsiakasNro, noutoToimipiste)
VALUES (12345678, '978-951-1-23676-4', datetime('now'), 123, 'Oodi')

/*
	Selvitetään, mitkä lainat ovat myöhässä ja kysytään lainaajien henkilötiedot.
	Lasketaan, montako päivää laina on myöhässä viimeisestä palautuspäivästä.
*/
SELECT asiakasNro, Asiakas.nimi AS asiakasNimi, osoite, email, standardiTunnus, Teos.nimi AS teosNimi, eraantymisAika, julianday(datetime('now'))-julianday(eraantymisAika) AS pvMyohassa
FROM (Lainassa NATURAL JOIN Asiakas) JOIN Teos ON Lainassa.standardiTunnus = Teos.standardiTunnus
WHERE eraantymisAika < datetime('now')

/*
	Lisätään uusi myöhästymismaksu.

	Lisätään Matti Meikäläiselle 3.50e suuruinen myöhästymismaksu.
*/
INSERT INTO Maksu (tunniste, summa, tyyppi, asiakasNro)
VALUES (3456, 350, 'myohastyminen', 123)

/*
	Selvitetään asiakkaan maksamatta olevat maksut.

	Kysytään, mitä maksuja Matti Meikäläisellä on maksamatta.
*/
SELECT summa, tyyppi
FROM Maksu
WHERE asiakasNro = 123 AND maksettu = FALSE;

/*
	Selvitetään, millä asiakkailla on varauksia tiettyyn teokseen.

	Kysytään, ketkä ovat varanneet Kalevalan.
*/
SELECT asiakasNro, nimi, varausAjankohta
FROM Varaus JOIN Asiakas ON varaajaAsiakasNro = asiakasNro
WHERE teosStandardiTunnus = '978-951-1-23676-4'
ORDER BY varausAjankohta ASC

/*
	Selvitetään, missä toimipisteissä teoksen kappaleita on ja kuinka monta.
*/
SELECT toimipisteNimi, COUNT(*) AS lukumaara
FROM Toimipisteessa
WHERE standardiTunnus = '978-951-1-23676-4'
GROUP BY toimipisteNimi

/*
	Selvitetään, missä kuljetuksissa tietyn teoksen kappaleita on kyydissä.
*/
SELECT lahtoToimipiste, paateToimipiste, lahtoaika
FROM Kuljetettavana NATURAL JOIN Kuljetus
WHERE standardiTunnus = '978-951-1-23676-4'

/*
	Kysytään, mitä kirjoja tietyltä tekijältä on.
*/
SELECT nimi, julkaisuvuosi
FROM Teos NATURAL JOIN Kirja
WHERE tekija = 'Elias Lönnrot'

/*
	Kysytään, mitkä yksittäisen teoksen kappaleet eivät ole kotitoimipisteessä, vaan toisessa toimipisteessa, kuljetuksessa tai lainassa.
*/
SELECT kappaleTunnus
FROM Lainassa
WHERE standardiTunnus = '978-951-1-23676-4'
	UNION
SELECT kappaleTunnus
FROM Kuljetettavana
WHERE standardiTunnus = '978-951-1-23676-4'
	UNION
SELECT kappaleTunnus
FROM Toimipisteessa
WHERE standardiTunnus = '978-951-1-23676-4' AND toimipisteNimi != (
	SELECT kotitoimipiste
	FROM Kappale
	WHERE Kappale.standardiTunnus = Toimipisteessa.standardiTunnus AND
			Kappale.kappaleTunnus = Toimipisteessa.kappaleTunnus)


/*
	Selvitetään jokaiselle asiakkaalle viimeisen vuoden aikana
	palautettujen lainojen määrä.
*/
SELECT asiakasNro, nimi, COUNT(*) AS palautuksia
FROM Palautus NATURAL JOIN Asiakas
WHERE palautusAjankohta > (datetime('now', '-1 year'))
GROUP BY asiakasNro
ORDER BY nimi


/*
	Selvitetään jokaiselle asiakkaalle maksettujen maksujen kokonaissumma.
*/
SELECT asiakasNro, nimi, SUM(summa) AS maksettuYhteensa
FROM Maksu NATURAL JOIN Asiakas
WHERE maksettu = TRUE
GROUP BY asiakasNro
ORDER BY nimi

/*
	Selvitetään viime kuun 10 suosituinta teosta palautusten määrän perusteella.
*/
SELECT nimi, julkaisuvuosi, genre, COUNT(*) AS palautuksia
FROM Palautus NATURAL JOIN Teos
WHERE palautusAjankohta > (datetime('now', '-1 month'))
GROUP BY standardiTunnus
ORDER BY palautuksia DESC
LIMIT 10
