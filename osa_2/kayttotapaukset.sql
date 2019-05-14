/*
	Kirjastosta voidaan lainata yksittäisiä teoksen kappaleita ja tapahtuma on rekisteröitävä tietokannan tarvittaviin relaatiohin.
	Asiakas lainaa teoksen kappaleen toimipisteestä, jolloin Lainassa-relaatioon lisätään uusi monikko joka sisältää lainauksen tiedot.
	Oletetaan, että kappale on toimipisteessä ja asiakas voi lainata sen, eli
	se on lainattavissa eikä ole varattuna kenellekään muulle.
	Lainausajaksi asetetaan lainaushetki ja erääntymisajaksi 
	lainaushetki + kappaleen max lainausaika.
	Koska lainaushetkellä asiakas ottaa teoksen jostakin toimipisteestä, 
	poistetaan tämän jälkeen kappale toimipisteessa-relaatiosta, jossa se oli.
	Poistetaan myös käyttäjän mahdolliset teokseen kohdistuneet varaukset Varaus-relaatiosta.

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
	Lainattuja teoksia on voitava palauttaa, jolloin palautustapahtuman tiedot kirjataan tietokantaan.
	Palautushistoria tallentuu Palautus-relaatioon, sillä sen sisältämiä monikoita ei poisteta.
	Asiakas palauttaa teoksen kappaleen johonkin toimipisteeseen, jolloin kappale lisätään takaisin Toimipisteessa-relaatioon.
	Tämän jälkeen tallennetaan tieto palautustapahtumasta Palautus-relaatioon ja poistetaan kappale Lainassa-relaatiosta.

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
	Kirjaston tietokannasta halutaan selvittää, missä toimipisteissä on saatavana tietyn teoksen kappale.
	Tämä tapahtuu kysymällä Toimipisteessa-relaatiosta niitä monikoita, joiden standarditunnus täsmää halutun teoksen standarditunnukseen.

	Etsitään kaikki toimipisteet joissa on vapaana Kalevala.
*/
SELECT DISTINCT toimipisteNimi
FROM Toimipisteessa
WHERE standardiTunnus = '978-951-1-23676-4';

/*
	Halutaan selvittää, mitä teoksia yksittäisellä asiakkaalla on lainassa tällä hetkellä ja mitkä ovat lainojen erääntymispäivät
	Tämä tapahtuu tekemällä kysely Lainassa- ja Teos -relaatioiden luonnolliseen liitokseen ja suodattamalla tuloksesta vain halutun asiakasnumeron omaavat monikot.

	Kysytään, mitä lainoja Matti Meikäläisellä on tällä hetkellä.
*/
SELECT standardiTunnus, nimi, eraantymisAika
FROM Lainassa NATURAL JOIN Teos
WHERE asiakasNro = 123;

/*
	Kirjaston on voitava selvittää aikajärjestyksessä, kenellä teoksen kappale on aiemmin ollut lainassa
	ja milloin se on palautettu.
	Tehdään kysely Palautus- ja Asiakas -relaatioiden luonnolliseen liitokseen ja suodatetaan tuloksesta vain haluttua teoksen kappaletta koskevat monikot.
	Tulos järjestetään vielä lopuksi aikajärjestykseen, uusin palautus ensin.

	Kysytään Kalevalan palautushistoria.
*/
SELECT asiakasNro, nimi, osoite, email, palautusAjankohta
FROM Palautus NATURAL JOIN Asiakas
WHERE standardiTunnus = '978-951-1-23676-4' AND kappaleTunnus = 0
ORDER BY palautusAjankohta DESC;

/*
	Kirjaston teoksista halutaan tehdä varauksia, jotta asiakas voi noutaa teoksen lähimmästä toimipisteestään.
	Tehdään uusi teokseen kohdistuva varaus lisäämällä uusi monikko Varaus-relaatioon.

	Matti Meikäläinen varaa kappaleen Kalevalaa toimitettavaksi Oodiin.
*/
INSERT INTO Varaus (tunniste, teosStandardiTunnus, varausAjankohta, varaajaAsiakasNro, noutoToimipiste)
VALUES (12345678, '978-951-1-23676-4', datetime('now'), 123, 'Oodi');

/*
	Halutaan selvittää, mitkä lainat ovat myöhässä ja kysytään lainaajien henkilötiedot.
	Tehdään Lainassa-, Asiakas- ja Teos- relaatioiden luonnolliseen liitokseen kysely, josta suodatetaan näytettäväksi vain ne lainat, joiden erääntymisaika on ennen nykyhetkeä.
	Lasketaan myös, montako päivää laina on myöhässä viimeisestä palautuspäivästä ja näytetään tieto omana sarakkeena.
*/
SELECT asiakasNro, Asiakas.nimi AS asiakasNimi, osoite, email, standardiTunnus, Teos.nimi AS teosNimi, eraantymisAika, julianday(datetime('now'))-julianday(eraantymisAika) AS pvMyohassa
FROM (Lainassa NATURAL JOIN Asiakas) JOIN Teos ON Lainassa.standardiTunnus = Teos.standardiTunnus
WHERE eraantymisAika < datetime('now');

/*
	Tietokantaan voidaan lisätä uusia maksuja asiakkaille. Tälläisiä voivat olla esimerkiksi myöhästymis- ja varausmaksut.
	Lisätään uusi monikko Maksu-relaatioon.

	Lisätään Matti Meikäläiselle 3.50e suuruinen myöhästymismaksu.
*/
INSERT INTO Maksu (tunniste, summa, tyyppi, asiakasNro)
VALUES (3456, 350, 'myohastyminen', 123);

/*
	Tietokannasta voidaan selvittää asiakkaan maksamatta olevat maksut
	Tämä tapahtuu tekemällä Maksu-relaatioon kysely, jossa ehtona on, että maksua ei ole maksettu ja monikon asiakasnumero täsmää.

	Kysytään, mitä maksuja Matti Meikäläisellä on maksamatta.
*/
SELECT summa, tyyppi
FROM Maksu
WHERE asiakasNro = 123 AND maksettu = FALSE;

/*
	Halutaan selvittää asiakkaat, joilla on varauksia tiettyyn teokseen.
	Tämä voidaan selvittää tekemällä kysely Varaus- ja Asiakas- relaatioiden liitokseen määrittämällä ehdoksi, että teoksen standarditunnuksen on
	täsmättävä haettuun teokseen.
	Järjestetään lopuksi monikot varausajankohdan mukaan.

	Kysytään, ketkä ovat varanneet Kalevalan.
*/
SELECT asiakasNro, nimi, varausAjankohta
FROM Varaus JOIN Asiakas ON varaajaAsiakasNro = asiakasNro
WHERE teosStandardiTunnus = '978-951-1-23676-4'
ORDER BY varausAjankohta ASC;

/*
	Selvitetään, missä toimipisteissä teoksen kappaleita on ja kuinka monta.
	Tehdään kysely Toimipisteessa-relaatioon ja määritetään kyselyn ehdoksi, että teoksen standarditunnuksen on täsmättävä haetun teoksen kanssa.
	Ryhmitellään monikot toimipisteen nimen mukaan, jotta saadaan selville haluttu lukumäärä.

	Kysytään, kuinka monta kappaletta Kalevalaa on kussakin toimipisteessä.
*/
SELECT toimipisteNimi, COUNT(*) AS lukumaara
FROM Toimipisteessa
WHERE standardiTunnus = '978-951-1-23676-4'
GROUP BY toimipisteNimi;

/*
	Selvitetään, missä kuljetuksissa tietyn teoksen kappaleita on kyydissä.
	Tehdään kysely Kuljetettavana- ja Kuljetus-relaatioiden luonnolliseen liitokseen ja määritellään ehdoksi, että stardarditunnuksen tulee täsmätä haetun teoksen kanssa.
*/
SELECT lahtoToimipiste, paateToimipiste, lahtoaika
FROM Kuljetettavana NATURAL JOIN Kuljetus
WHERE standardiTunnus = '978-951-1-23676-4';

/*
	Tietokannasta voidaan hakea teoksia eri hakuehtojen mukaan.
	Haut voidaan kohdistaa aina Teos- ja Kirja- relaatioiden luonnolliseen liitokseen.
	Kysytään esimerkiksi, mitä kirjoja Elias Lönnrotilta on.
*/
SELECT nimi, julkaisuvuosi
FROM Teos NATURAL JOIN Kirja
WHERE tekija = 'Elias Lönnrot';

/*
	Teoksen kappaleiden olinpaikan selvitys voidaan toteuttaa etsimällä kappaleita Lainassa-, Kuljetettavana- ja Toimipisteessa- relaatioista.
	Kysytään esimerkiksi, mitkä yksittäiset Kalevalan kappaleet eivät ole kotitoimipisteessä, vaan toisessa toimipisteessa, kuljetuksessa tai lainassa.
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
			Kappale.kappaleTunnus = Toimipisteessa.kappaleTunnus);


/*
	Selvitetään jokaiselle asiakkaalle viimeisen vuoden aikana
	palautettujen lainojen määrä tekemällä kysely Palautus- ja Asiakas- relaatioiden luonnolliseen liitokseen ja asettamalla ehdoksi, että palautusajankohta on ollut vuoden sisällä nykyhetkestä.
	Ryhmitellään monikot asiakasnumeron mukaan jotta saadaan haluttu lukumäärä laskettua, ja järjestetään lopuksi monikot nimen mukaan aakkosjärjestykseen.
*/
SELECT asiakasNro, nimi, COUNT(*) AS palautuksia
FROM Palautus NATURAL JOIN Asiakas
WHERE palautusAjankohta > (datetime('now', '-1 year'))
GROUP BY asiakasNro
ORDER BY nimi;


/*
	Selvitetään jokaiselle asiakkaalle maksettujen maksujen kokonaissumma tekemällä kysely Maksu- ja Asiakas- relaatioiden luonnolliseen liitokseen ja asettamalla ehdoksi, että maksu on maksettu.
	Ryhmitellään monikot asiakasnumeron mukaan jotta saadaan haluttu summa laskettua, ja järjestetään lopuksi monikot nimen mukaan aakkosjärjestykseen.
*/
SELECT asiakasNro, nimi, SUM(summa) AS maksettuYhteensa
FROM Maksu NATURAL JOIN Asiakas
WHERE maksettu = TRUE
GROUP BY asiakasNro
ORDER BY nimi;

/*
	Selvitetään viime kuun 10 suosituinta teosta palautusten määrän perusteella tekemällä kysely Palautus- ja Teos- relaatioiden luonnolliseen liitokseen 
	ja asettamalla ehdoksi, että palautusajankohta on kuukauden sisällä nykyhetkestä.
	Ryhmitellään monikot standarditunnuksen mukaan jotta saadaan haluttu lukumäärä laskettua, ja järjestetään lopuksi monikot lukumäärän mukaan laskevaan järjestykseen.
	Rajoitetaan haettavien monikkojen määrä kymmeneen.
*/
SELECT nimi, julkaisuvuosi, genre, COUNT(*) AS palautuksia
FROM Palautus NATURAL JOIN Teos
WHERE palautusAjankohta > (datetime('now', '-1 month'))
GROUP BY standardiTunnus
ORDER BY palautuksia DESC
LIMIT 10;
