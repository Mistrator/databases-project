/*
	Tietokantaan täytyy pystyä luomaan uusia toimipisteitä.
	Lisätään uusia monikkoja Toimipiste-relaatioon.
*/

INSERT INTO Toimipiste
VALUES ('Oodi', 'Töölönlahdenkatu 4');

INSERT INTO Toimipiste
VALUES ('Kallio', 'Kalliontie 3');

INSERT INTO Toimipiste
VALUES ('Itäskeskus', 'Itäkatu 4');

INSERT INTO Toimipiste
VALUES ('Vuosaari', 'Vuotie 14');

/*
	Tietokantaan täytyy pystyä lisäämään uusia asiakkaita.
	Lisätään uusi monikko Asiakas-relaatioon.
*/

INSERT INTO Asiakas
VALUES (982, 'Tero Teekkari', 'Maarintie 3', 'teetero@hotmail.com');

INSERT INTO Asiakas
VALUES (111, 'Minni Meikäläinen', 'Vuotie 22', 'minni.meikalainen@hotmail.com');

INSERT INTO Asiakas
VALUES (123, 'Matti Meikäläinen', 'Otakaari 20', 'matti.meikalainen@gmail.com');

/*
	Tietokantaan täytyy pystyä lisäämään erilaisia teoksia ja niiden kappaleita.
	Lisätään uusi kirja ja yksittäinen kirjan kappale.

	Ensin lisätään kirjan yleiset tiedot Teos-relaatioon, jonka jälkeen lisätään yksittäisen kappaleen tiedot Kappale-relaatioon. 
	Koska teos on kirja, täytyy teoksen tyypille ominaiset tiedot vielä lisätä Kirja-relaatioon.
	Tämän jälkeen asetetaan kappale johonkin toimipisteeseen lisäämällä se Toimipisteessa-relaatioon.
*/

-- Lisätään teos Kalevala

INSERT INTO Teos
VALUES ('978-951-1-23676-4', 'Kalevala', 2009, 'Kaunokirjallisuus', 'suomi');

INSERT INTO Kirja
VALUES ('978-951-1-23676-4', 'Elias Lönnrot', 'Otava', 475);

-- Lisätään teos Matrix Algebra

INSERT INTO Teos
VALUES ('111-951-1-23676-4', 'Matrix Algebra', 2019, 'Tietokirjallisuus', 'englanti');

INSERT INTO Kirja
VALUES ('111-951-1-23676-4', 'Pekka Professori', 'Sanoma', 4175);

-- Lisätään kolme kappaletta Kalevalaa

INSERT INTO Kappale
VALUES ('978-951-1-23676-4', 0, TRUE, TRUE, '+30 days', 'Oodi');

INSERT INTO Toimipisteessa
VALUES ('978-951-1-23676-4', 0, 'Oodi');

INSERT INTO Kappale
VALUES ('978-951-1-23676-4', 1, TRUE, TRUE, '+30 days', 'Oodi');

INSERT INTO Toimipisteessa
VALUES ('978-951-1-23676-4', 1, 'Oodi');

INSERT INTO Kappale
VALUES ('978-951-1-23676-4', 2, TRUE, TRUE, '+14 days', 'Oodi');

INSERT INTO Toimipisteessa
VALUES ('978-951-1-23676-4', 2, 'Oodi');


-- Lisätään kaksi kappaletta Matrix Algebraa
INSERT INTO Kappale
VALUES ('111-951-1-23676-4', 0, TRUE, TRUE, '+30 days', 'Vuosaari');

INSERT INTO Toimipisteessa
VALUES ('111-951-1-23676-4', 0, 'Vuosaari');

INSERT INTO Kappale
VALUES ('111-951-1-23676-4', 1, TRUE, TRUE, '+30 days', 'Vuosaari');

INSERT INTO Toimipisteessa
VALUES ('111-951-1-23676-4', 1, 'Vuosaari');

/*
	Tietokantaan voidaan lisätä uusia maksuja asiakkaille. Tälläisiä voivat olla esimerkiksi myöhästymis- ja varausmaksut.
	Lisätään uusi monikko Maksu-relaatioon.

	Lisätään Matti Meikäläiselle 3.50e suuruinen myöhästymismaksu ja 1.00e suuruinen varausmaksu.
*/
INSERT INTO Maksu (tunniste, summa, tyyppi, asiakasNro)
VALUES (3456, 350, 'myohastyminen', 123);

INSERT INTO Maksu (tunniste, summa, tyyppi, asiakasNro)
VALUES (3457, 100, 'varaus', 123);

INSERT INTO Maksu (tunniste, summa, tyyppi, asiakasNro)
VALUES (3456, 350, 'myohastyminen', 111);

-- Lisätään tietokantaan myös maksu, joka on jo maksettu
