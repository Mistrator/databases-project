CREATE TABLE Teos (
	standardiTunnus VARCHAR(32),
	nimi VARCHAR(256),
	julkaisuvuosi INT,
	genre VARCHAR(256),
	kieli VARCHAR(256)
);

CREATE TABLE Kappale (
	standardiTunnus VARCHAR(32),
	kappaleTunnus INT,
	varattavissa BOOLEAN,
	lainattavissa BOOLEAN,
	maxLainausaika INT, -- seconds
	kotitoimipiste VARCHAR(256)
);

CREATE TABLE Kirja (
	standardiTunnus VARCHAR(32),
	tekija VARCHAR(256),
	kustantaja VARCHAR(256),
	sivumaara INT
);

CREATE TABLE Lehti (
	standardiTunnus VARCHAR(32),
	julkaisija VARCHAR(256),
	vuosikerta INT,
	numero INT
);

CREATE TABLE CD (
	standardiTunnus VARCHAR(32),
	artisti VARCHAR(256),
	kappaleMaara INT,
	levyYhtio VARCHAR(256)
);

CREATE TABLE DVD (
	standardiTunnus VARCHAR(32),
	julkaisija VARCHAR(256),
	kesto INT --seconds
);

CREATE TABLE Asiakas (
	asiakasNro INT,
	nimi VARCHAR(256),
	osoite VARCHAR(256),
	email VARCHAR(256)
);

CREATE TABLE Varaus (
	tunniste INT,
	teosStandardiTunnus VARCHAR(32),
	teosKappaleTunnus INT,
	varausAjankohta DATE,
	saapumisAjankohta DATE,
	varaajaAsiakasNro INT,
	noutoToimipiste VARCHAR(256)
);

