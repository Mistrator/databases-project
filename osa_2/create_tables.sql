CREATE TABLE Teos (
	standardiTunnus VARCHAR(32) NOT NULL,
	nimi VARCHAR(256),
	julkaisuvuosi INT,
	genre VARCHAR(256),
	kieli VARCHAR(256),
	PRIMARY KEY (standardiTunnus)
);

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

CREATE TABLE Kirja (
	standardiTunnus VARCHAR(32) NOT NULL,
	tekija VARCHAR(256),
	kustantaja VARCHAR(256),
	sivumaara INT CHECK (sivumaara >= 0),
	PRIMARY KEY (standardiTunnus),
	FOREIGN KEY (standardiTunnus) REFERENCES Teos(standardiTunnus)
);

CREATE TABLE Lehti (
	standardiTunnus VARCHAR(32) NOT NULL,
	julkaisija VARCHAR(256),
	vuosikerta INT,
	numero VARCHAR(256),
	PRIMARY KEY (standardiTunnus),
	FOREIGN KEY (standardiTunnus) REFERENCES Teos(standardiTunnus)
);

CREATE TABLE CD (
	standardiTunnus VARCHAR(32) NOT NULL,
	artisti VARCHAR(256),
	kappaleMaara INT CHECK (kappaleMaara >= 0),
	levyYhtio VARCHAR(256),
	PRIMARY KEY (standardiTunnus),
	FOREIGN KEY (standardiTunnus) REFERENCES Teos(standardiTunnus)
);

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

CREATE TABLE Varaus (
	tunniste INT NOT NULL,
	teosStandardiTunnus VARCHAR(32),
	teosKappaleTunnus INT,
	varausAjankohta DATE,
	saapumisAjankohta DATE CHECK (varausAjankohta <= saapumisAjankohta),
	varaajaAsiakasNro INT,
	noutoToimipiste VARCHAR(256),
	PRIMARY KEY (tunniste),
	FOREIGN KEY (teosStandardiTunnus, teosKappaleTunnus) REFERENCES Kappale(standardiTunnus, kappaleTunnus),
	FOREIGN KEY (varaajaAsiakasNro) REFERENCES Asiakas(asiakasNro),
	FOREIGN KEY (noutoToimipiste) REFERENCES Toimipiste(nimi)
);

CREATE TABLE Palautus (
	standardiTunnus VARCHAR(32),
	kappaleTunnus INT,
	palautusAjankohta DATE,
	asiakasNro INT,
	PRIMARY KEY (standardiTunnus, kappaleTunnus, palautusAjankohta, asiakasNro),
	FOREIGN KEY (standardiTunnus, kappaleTunnus) REFERENCES Kappale(standardiTunnus, kappaleTunnus),
	FOREIGN KEY (asiakasNro) REFERENCES Asiakas(asiakasNro)
);

CREATE TABLE Maksu (
	tunniste INT NOT NULL,
	summa INT, -- sentteja
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

CREATE TABLE Kuljetus (
	kuljetusID INT NOT NULL,
	lahtoaika DATE,
	lahtoToimipiste VARCHAR(256),
	paateToimipiste VARCHAR(256),
	PRIMARY KEY (kuljetusID),
	FOREIGN KEY (lahtoToimipiste) REFERENCES Toimipiste(nimi),
	FOREIGN KEY (paateToimipiste) REFERENCES Toimipiste(nimi)
);

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

CREATE TABLE Toimipisteessa (
	standardiTunnus VARCHAR(32),
	kappaleTunnus INT,
	toimipisteNimi VARCHAR(256),
	PRIMARY KEY (standardiTunnus, kappaleTunnus),
	FOREIGN KEY (standardiTunnus, kappaleTunnus) REFERENCES Kappale(standardiTunnus, kappaleTunnus),
	FOREIGN KEY (toimipisteNimi) REFERENCES Toimipiste(nimi)
);

CREATE TABLE Kuljetettavana (
	standardiTunnus VARCHAR(32),
	kappaleTunnus INT,
	kuljetusID INT,
	PRIMARY KEY (standardiTunnus, kappaleTunnus),
	FOREIGN KEY (standardiTunnus, kappaleTunnus) REFERENCES Kappale(standardiTunnus, kappaleTunnus),
	FOREIGN KEY (kuljetusID) REFERENCES Kuljetus(kuljetusID)
);