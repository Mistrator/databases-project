/*
	Lisätään uusi toimipiste.
*/
INSERT INTO Toimipiste
VALUES ('Oodi', 'Töölönlahdenkatu 4')


/*
	Lisätään uusi kirja ja yksittäinen kirjan kappale.
	Ensin lisätään kirjan yleiset tiedot, jonka jälkeen lisätään yksittäisen kappaleen tiedot.
*/
INSERT INTO Teos
VALUES ('978-951-1-23676-4', 'Kalevala', 2009, 'Kaunokirjallisuus', 'suomi');

INSERT INTO Kirja
VALUES ('978-951-1-23676-4', 'Elias Lönnrot', 'Otava', 475);

INSERT INTO Kappale
VALUES ('978-951-1-23676-4', 0, TRUE, TRUE, '+30 days', 'Oodi');


/*
	Lisätään uusi asiakas.
*/
INSERT INTO Asiakas
VALUES (123, 'Matti Meikäläinen', 'Otakaari 20', 'matti.meikalainen@gmail.com')


/*
	Asiakas lainaa teoksen kappaleen toimipisteestä.
	Oletetaan, että kappale on toimipisteessä.
	Lainausajaksi asetetaan lainaushetki ja erääntymisajaksi 
	lainaushetki + kappaleen max lainausaika.
*/
INSERT INTO Lainassa
VALUES ('978-951-1-23676-4', 0, datetime('now'), datetime('now', 
	(SELECT maxLainausaika 
	FROM Kappale 
	WHERE standardiTunnus = '978-951-1-23676-4' AND kappaleTunnus = 0))
, 123)
