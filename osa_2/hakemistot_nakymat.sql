/*
	Luodaan näkymä, joka yhdistää yksittäisen kappaleen tiedot
	teoksen yleisiin tietoihin.
*/
CREATE VIEW KappaleTiedot AS
	SELECT *
	FROM Teos NATURAL JOIN Kappale


/*
	Luodaan hakemistot eri teostyyppien standarditunnuksien perusteella, koska
	tauluista haetaan usein yksittäisen teoksen tietoja standarditunnuksen
	avulla.
*/
CREATE INDEX TeosIndex ON Teos(standardiTunnus);
CREATE INDEX KirjaIndex ON Kirja(standardiTunnus);
CREATE INDEX LehtiIndex ON Lehti(standardiTunnus);
CREATE INDEX CDIndex ON CD(standardiTunnus);
CREATE INDEX DVDIndex ON DVD(standardiTunnus);

/*
	Luodaan hakemisto kappaleen standarditunnuksen ja kappaletunnuksen perusteella,
	koska taulusta haetaan usein yksittäisen kappaleen tietoja (standardiTunnus,
	kappaleTunnus) -parin perusteella.
*/
CREATE INDEX KappaleIndex ON Kappale(standardiTunnus, kappaleTunnus);

/*
	Luodaan hakemistot standarditunnuksen ja kappaletunnuksen perusteella, jotta
	kappaleen olinpaikka voidaan selvittää tehokkaasti.
*/
CREATE INDEX ToimipisteessaIndex ON Toimipisteessa(standardiTunnus, kappaleTunnus);
CREATE INDEX LainassaIndex ON Lainassa(standardiTunnus, kappaleTunnus);
CREATE INDEX KuljetettavanaIndex ON Kuljetettavana(standardiTunnus, kappaleTunnus);


/*
	Luodaan hakemisto asiakkaan asiakasnumeron perusteella, koska yksittäisen asiakkaan
	henkilötietoja kysytään usein.
*/
CREATE INDEX AsiakasIndex ON Asiakas(asiakasNro);
