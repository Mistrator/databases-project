/*
	Standarditunnus on tällä hetkellä 10- tai 13-merkkinen ISBN-merkkijono.
	Kenttään on jätetty laajennusvaraa mahdollisille tuleville tunnisteille.
*/
CREATE TABLE Teos (
	standardiTunnus VARCHAR(32) NOT NULL,
	nimi VARCHAR(256),
	julkaisuvuosi INT,
	genre VARCHAR(256),
	kieli VARCHAR(256),
	PRIMARY KEY (standardiTunnus)
);

/*
	Standarditunnus vastaa Teos-taulun standarditunnusta.
	Kappaletunnus yksilöi teoksen kappaleen ja voi olla esimerkiksi juokseva
	numerointi.
	MaxLainausaika on ajanjakso, esimerkiksi '1 month'.

	Teoksen ja kotitoimipisteen, joihin kappale viittaa, on oltava olemassa.
*/
CREATE TABLE Kappale (
	standardiTunnus VARCHAR(32),
	kappaleTunnus INT NOT NULL,
	varattavissa BOOLEAN,
	lainattavissa BOOLEAN,
	maxLainausaika DATE NOT NULL,
	kotitoimipiste VARCHAR(256),
	PRIMARY KEY (standardiTunnus, kappaleTunnus),
	FOREIGN KEY (standardiTunnus) REFERENCES Teos(standardiTunnus),
	FOREIGN KEY (kotitoimipiste) REFERENCES Toimipiste(nimi)
);

/*
	Kirjan sivumäärä ei voi olla negatiivinen.
*/
CREATE TABLE Kirja (
	standardiTunnus VARCHAR(32) NOT NULL,
	tekija VARCHAR(256),
	kustantaja VARCHAR(256),
	sivumaara INT CHECK (sivumaara >= 0),
	PRIMARY KEY (standardiTunnus),
	FOREIGN KEY (standardiTunnus) REFERENCES Teos(standardiTunnus)
);

/*
	Vuosikerta on juokseva numerointi.
	Lehden numero on merkkijono, koska lehdet voivat julkaista erikoisnumeroita.
*/
CREATE TABLE Lehti (
	standardiTunnus VARCHAR(32) NOT NULL,
	julkaisija VARCHAR(256),
	vuosikerta INT,
	numero VARCHAR(256),
	PRIMARY KEY (standardiTunnus),
	FOREIGN KEY (standardiTunnus) REFERENCES Teos(standardiTunnus)
);

/*
	CD:n kappalemäärä ei voi olla negatiivinen.
*/
CREATE TABLE CD (
	standardiTunnus VARCHAR(32) NOT NULL,
	artisti VARCHAR(256),
	kappaleMaara INT CHECK (kappaleMaara >= 0),
	levyYhtio VARCHAR(256),
	PRIMARY KEY (standardiTunnus),
	FOREIGN KEY (standardiTunnus) REFERENCES Teos(standardiTunnus)
);

/*
	DVD:n kesto on ajanjakso, esim '2 hours'.
*/
CREATE TABLE DVD (
	standardiTunnus VARCHAR(32) NOT NULL,
	julkaisija VARCHAR(256),
	kesto DATE,
	PRIMARY KEY (standardiTunnus),
	FOREIGN KEY (standardiTunnus) REFERENCES Teos(standardiTunnus)
);

CREATE TABLE Asiakas (
	asiakasNro INT NOT NULL,
	nimi VARCHAR(256),
	osoite VARCHAR(256),
	email VARCHAR(256),
	PRIMARY KEY (asiakasNro)
);

/*
	Kun asiakas tekee varauksen, se kohdistuu teokseen, muttei vielä
	mihinkään kappaleeseen, joten kappaleTunnus on NULL. Saapumisajankohtaa
	ei myöskään tiedetä vielä, joten sekin on NULL.

	Kun varatun teoksen kappale saapuu johonkin toimipisteeseen, yhdistetään varaus
	kyseiseen kappaleeseen ja kappaleTunnus ja saapumisAjankohta saavat arvonsa.
*/
CREATE TABLE Varaus (
	tunniste INT NOT NULL,
	teosStandardiTunnus VARCHAR(32),
	teosKappaleTunnus INT DEFAULT NULL,
	varausAjankohta DATE,
	saapumisAjankohta DATE DEFAULT NULL,
	varaajaAsiakasNro INT,
	noutoToimipiste VARCHAR(256),
	PRIMARY KEY (tunniste),
	FOREIGN KEY (teosStandardiTunnus, teosKappaleTunnus) REFERENCES Kappale(standardiTunnus, kappaleTunnus),
	FOREIGN KEY (varaajaAsiakasNro) REFERENCES Asiakas(asiakasNro),
	FOREIGN KEY (noutoToimipiste) REFERENCES Toimipiste(nimi)
);

/*
	Asiakasnumeron ei tarvitse olla avainattribuuttina, koska kaksi asiakasta ei
	voi palauttaa samaa kappaletta samalla hetkellä. Sama asiakas voi palauttaa saman
	teoksen useasti, koska palautusAjankohta on avainattribuutti.

	Taulu säilyttää lainaushistoriaa, eikä sen monikkoja ole normaalisti tarkoitus poistaa.
*/
CREATE TABLE Palautus (
	standardiTunnus VARCHAR(32),
	kappaleTunnus INT,
	palautusAjankohta DATE,
	asiakasNro INT,
	PRIMARY KEY (standardiTunnus, kappaleTunnus, palautusAjankohta),
	FOREIGN KEY (standardiTunnus, kappaleTunnus) REFERENCES Kappale(standardiTunnus, kappaleTunnus),
	FOREIGN KEY (asiakasNro) REFERENCES Asiakas(asiakasNro)
);

/*
	Maksun tunniste voi olla esimerkiksi juokseva numerointi.
	Summa annetaan sentteinä.
*/
CREATE TABLE Maksu (
	tunniste INT NOT NULL,
	summa INT,
	tyyppi VARCHAR(256),
	maksettu BOOLEAN DEFAULT FALSE,
	asiakasNro INT,
	PRIMARY KEY (tunniste),
	FOREIGN KEY (asiakasNro) REFERENCES Asiakas(asiakasNro)
);

CREATE TABLE Toimipiste (
	nimi VARCHAR(256) NOT NULL,
	osoite VARCHAR(256),
	PRIMARY KEY (nimi)
);

/*
	KuljetusID voi olla esim. juokseva numerointi.
*/
CREATE TABLE Kuljetus (
	kuljetusID INT NOT NULL,
	lahtoaika DATE,
	lahtoToimipiste VARCHAR(256),
	paateToimipiste VARCHAR(256),
	PRIMARY KEY (kuljetusID),
	FOREIGN KEY (lahtoToimipiste) REFERENCES Toimipiste(nimi),
	FOREIGN KEY (paateToimipiste) REFERENCES Toimipiste(nimi)
);

/*
	Taulu kertoo, mitkä kappaleet ovat tällä hetkellä lainassa. Kun kappale palautetaan, poistetaan se taulusta. Asiakas voi lainata saman teoksen useasti, koska tieto aiemmasta lainauksesta poistetaan taulusta, kun laina palautetaan.
	Lainaushistoria säilyy Palautus-taulussa.

	Laina ei voi erääntyä ennen sen alkamista.
*/
CREATE TABLE Lainassa (
	standardiTunnus VARCHAR(32),
	kappaleTunnus INT,
	lainausAika DATE NOT NULL,
	eraantymisAika DATE NOT NULL CHECK (lainausAika <= eraantymisAika),
	asiakasNro INT,
	PRIMARY KEY (standardiTunnus, kappaleTunnus),
	FOREIGN KEY (standardiTunnus, kappaleTunnus) REFERENCES Kappale(standardiTunnus, kappaleTunnus),
	FOREIGN KEY (asiakasNro) REFERENCES Asiakas(asiakasNro)
);

/*
	Taulu kertoo, mitkä kappaleet ovat tällä hetkellä missäkin toimipisteessä. Kun kappale poistuu toimipisteestä, poistetaan monikko taulusta.
*/
CREATE TABLE Toimipisteessa (
	standardiTunnus VARCHAR(32),
	kappaleTunnus INT,
	toimipisteNimi VARCHAR(256),
	PRIMARY KEY (standardiTunnus, kappaleTunnus),
	FOREIGN KEY (standardiTunnus, kappaleTunnus) REFERENCES Kappale(standardiTunnus, kappaleTunnus),
	FOREIGN KEY (toimipisteNimi) REFERENCES Toimipiste(nimi)
);

/*
	Taulu kertoo, mitkä kappaleet ovat tällä hetkellä kuljetettavana ja
	minkä kuljetuksen kyydissä ne ovat. Kun kappale poistuu kuljetuksesta,
	poistetaan monikko taulusta.
*/
CREATE TABLE Kuljetettavana (
	standardiTunnus VARCHAR(32),
	kappaleTunnus INT,
	kuljetusID INT,
	PRIMARY KEY (standardiTunnus, kappaleTunnus),
	FOREIGN KEY (standardiTunnus, kappaleTunnus) REFERENCES Kappale(standardiTunnus, kappaleTunnus),
	FOREIGN KEY (kuljetusID) REFERENCES Kuljetus(kuljetusID)
);
