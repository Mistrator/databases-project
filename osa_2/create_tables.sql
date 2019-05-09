CREATE TABLE Teos (
	standardiTunnus VARCHAR(32),
	nimi VARCHAR(256),
	julkaisuvuosi INT,
	genre VARCHAR(256),
	kieli VARCHAR(256),
	PRIMARY KEY (standardiTunnus)
);

CREATE TABLE Kappale (
	standardiTunnus VARCHAR(32),
	kappaleTunnus INT,
	varattavissa BOOLEAN,
	lainattavissa BOOLEAN,
	maxLainausaika INT, -- seconds
	kotitoimipiste VARCHAR(256),
	PRIMARY KEY (standardiTunnus, kappaleTunnus)
);

CREATE TABLE Kirja (
	standardiTunnus VARCHAR(32),
	tekija VARCHAR(256),
	kustantaja VARCHAR(256),
	sivumaara INT,
	PRIMARY KEY (standardiTunnus)
);

CREATE TABLE Lehti (
	standardiTunnus VARCHAR(32),
	julkaisija VARCHAR(256),
	vuosikerta INT,
	numero INT,
	PRIMARY KEY (standardiTunnus)
);

CREATE TABLE CD (
	standardiTunnus VARCHAR(32),
	artisti VARCHAR(256),
	kappaleMaara INT,
	levyYhtio VARCHAR(256),
	PRIMARY KEY (standardiTunnus)
);

CREATE TABLE DVD (
	standardiTunnus VARCHAR(32),
	julkaisija VARCHAR(256),
	kesto INT, --seconds
	PRIMARY KEY (standardiTunnus)
);

CREATE TABLE Asiakas (
	asiakasNro INT,
	nimi VARCHAR(256),
	osoite VARCHAR(256),
	email VARCHAR(256)
	PRIMARY KEY (asiakasNro)
);

CREATE TABLE Varaus (
	tunniste INT,
	teosStandardiTunnus VARCHAR(32),
	teosKappaleTunnus INT,
	varausAjankohta DATE,
	saapumisAjankohta DATE,
	varaajaAsiakasNro INT,
	noutoToimipiste VARCHAR(256),
	PRIMARY KEY (tunniste)
);

CREATE TABLE Palautus (
	standardiTunnus VARCHAR(32),
	kappaleTunnus INT,
	palautusAjankohta DATE,
	asiakasNro INT,
	PRIMARY KEY (standardiTunnus, kappaleTunnus, palautusAjankohta, asiakasNro)
);

CREATE TABLE Maksu (
	tunniste INT,
	summa INT, -- sentteja
	tyyppi VARCHAR(256),
	maksettu BOOLEAN,
	asiakasNro INT,
	PRIMARY KEY (tunniste)
);

CREATE TABLE Toimipiste (
	nimi VARCHAR(256),
	osoite VARCHAR(256),
	PRIMARY KEY (nimi)
);

CREATE TABLE Kuljetus (
	kuljetusID INT,
	lahtoaika DATE,
	lahtoToimipiste VARCHAR(256),
	paateToimipiste VARCHAR(256),
	PRIMARY KEY (kuljetusID)
);

CREATE TABLE Lainassa (
	standardiTunnus VARCHAR(32),
	kappaleTunnus INT,
	lainausAika DATE,
	eraantymisAika DATE,
	asiakasNro INT,
	PRIMARY KEY (standardiTunnus, kappaleTunnus, lainausAika)
);

CREATE TABLE Toimipisteessa (
	standardiTunnus VARCHAR(32),
	kappaleTunnus INT,
	toimipisteNimi VARCHAR(256),
	PRIMARY KEY (standardiTunnus, kappaleTunnus)
);

CREATE TABLE Kuljetettavana (
	standardiTunnus VARCHAR(32),
	kappaleTunnus INT,
	kuljetusID INT,
	PRIMARY KEY (standardiTunnus, kappaleTunnus)
);
