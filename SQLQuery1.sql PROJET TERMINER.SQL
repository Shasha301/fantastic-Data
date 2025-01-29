-- SQL * FIRST PROJECT 
--- TABLE DESIGN & CREATION ABOUT ALCOHOLIC DRINKS 

USE MASTER
GO
if exists (select * from sysdatabases where name = 'A_DRINK2')
		drop database A_DRINK2
GO
CREATE DATABASE A_DRINK2
GO
USE A_DRINK2
GO
--A little history about the people who discovered alcohol
CREATE TABLE History
(historyID INT, 
name_inventor VARCHAR(30) NOT NULL,
release_date DATE NULL, 
region_inventor VARCHAR(30) NULL,
city_inventor VARCHAR(30) NULL
CONSTRAINT inven_id_pk PRIMARY KEY(historyID))
GO
--And now.. a little knowledge about alcoholic beverages
CREATE TABLE Drinks
(drinksID INT,
alcohol_name VARCHAR(40) NOT NULL, 
type_ingredient VARCHAR(40) NOT NULL, 
alcohol_level VARCHAR(20) NOT NULL,
type_creation VARCHAR(40) NULL, 
CONSTRAINT drin_id_pk PRIMARY KEY(drinksid),
historyID INT CONSTRAINT drin_hist_fk FOREIGN KEY REFERENCES history(historyID))
GO
--Their varieties of alcoholic beverage brands and its production in the world
CREATE TABLE Brands
(brandsID INT,
popular_name VARCHAR(40) NOT NULL, 
sell_the_most VARCHAR(40) NOT NULL,
country_production VARCHAR(40) NULL,
CONSTRAINT bran_id_pk PRIMARY KEY(brandsID),
drinksID INT CONSTRAINT bran_drin_fk FOREIGN KEY REFERENCES drinks(drinksID))
GO
--What can i make with alcohol?... COCKTAILS but never drink on an empty stomach so let's enjoy Apéritif like French people!
CREATE TABLE cocktails
(cocktailsID INT,
cocktails_name VARCHAR(40) NOT NULL,
creator_name VARCHAR(40) NULL,
creation_city VARCHAR(40) NULL,
aperitif_name VARCHAR(40) NULL,
CONSTRAINT cock_id_pk PRIMARY KEY(cocktailsid),
CONSTRAINT cock_ckname_UK UNIQUE(cocktails_name),
drinksID INT CONSTRAINT cock_drin_fk FOREIGN KEY REFERENCES drinks(drinksID))
GO
--Who's loves it?
CREATE TABLE customers
(customerID INT,
customer_name VARCHAR(40) NOT NULL,
customer_age INT NOT NULL,
customer_gender VARCHAR(20) NOT NULL,
country_name VARCHAR(20) NOT NULL,
CONSTRAINT cust_id_pk PRIMARY KEY(customerid), 
CONSTRAINT cust_age_ck CHECK(country_name ='Europe' AND customer_age >= 18 OR country_name ='Usa' AND customer_age >= 21))
GO
--Let's talk about what everyone cares about.. food? NO, MONEY!
CREATE TABLE sales
(salesid INT,
employee_name VARCHAR(40),
date_sales DATE NOT NULL,
price_sales INT NOT NULL,
quantity_sales INT NULL, 
name_stores VARCHAR(20) NULL,
adress_stores VARCHAR(50) NULL,
CONSTRAINT sale_id_pk PRIMARY KEY(salesid),
drinksID INT CONSTRAINT sales_drin_fk FOREIGN KEY REFERENCES drinks(drinksID),
customerID INT CONSTRAINT sales_cust_fk FOREIGN KEY REFERENCES customers(customerID))
GO
--Thanks to these people who make moments better 
CREATE TABLE suppliers
(supplierID INT,
company_name VARCHAR(40) NOT NULL,
contact_name VARCHAR(40) NOT NULL, 
email VARCHAR(40) NOT NULL,
country_name VARCHAR(40) NOT NULL,
CONSTRAINT supp_id_pk PRIMARY KEY(supplierid),
CONSTRAINT supp_companyname_UK UNIQUE(company_name),
drinksID INT CONSTRAINT supp_drin_fk FOREIGN KEY REFERENCES drinks(drinksID))
GO
INSERT INTO History
VALUES(1,'Dmitri Mendeleev', '1865-01-31', 'Russia', 'Poland'),
(2,'Richard Ligon', '1640-08-01', 'America', 'Barbados'),
(3,'Major Dubied', '1798-02-17', 'Europe', 'Swiss'),
(4,'Abbeys', '1040-11-03', 'Europe', 'Germany'),
(5,'Lord of Segonzac', '1610-05-22', 'Europe', 'Cognac'),
(6,'Knight the brown cross', '1700-07-23', 'Europe', 'Cognac'),
(7,'Philip Duff', '1495-09-16', 'Europe', 'The Netherlands'),
(8,'Paul Ricard', '1932-06-26', 'Europe', 'France'),
(9,'Fernao de Noronha', '1504-03-12', 'America', 'Brazil'),
(10,'Jose Maria Guadalupe de Cuervo', '1795-04-14', 'America', 'Mexico'),
(11,'Abbeys', '1405-10-15', 'Europe', 'Ireland'),
(12,'Abbeys', '1098-11-20', 'Europe', 'France'),
(13,'Joseph Dubonnet', '1846-12-30', 'Europe', 'France'),
(14,'Pierre Perignon', '1695-09-08', 'Europe', 'France')
GO
INSERT INTO Drinks
VALUES(1,'Vodka','potatoes', '37%','distillation',1),
(2,'Rhum','sugar cane', '37%','distillation',2),
(3,'Absinthe','plants', '60%','maceration',3),
(4,'Beer', 'malt', '4%','distillation',4),
(5,'Cognac', 'raisin', '72%','fermentation',5),
(6,'Brandy', 'fruits', '36%','distillation',6),
(7,'Gin', 'barley', '10%','distillation',7),
(8,'Pastis', 'anise', '45%','distillation',8),
(9,'Cachaca', 'sugar cane', '38%','distillation',9),
(10,'Tequila', 'blue agave', '35%','fermentation',10),
(11,'Whiskey', 'barley', '40%','distillation',11),
(12,'Wine', 'raisin', '16%','fermentation',12),
(13,'Aperitif', 'herbs', '19%','distillation',13),
(14,'Champagne', 'raisin', '12%','fermentation',14)
GO
INSERT INTO Brands
VALUES(1,'Absolut', 'Grey Goose', 'France',1),
(2,'Bacardi', 'Tanduay', 'Philippines',2),
(3,'Mansithe', 'La fee Parisienne', 'France',3),
(4,'Heineken', 'Corona', 'Mexico',4),
(5,'Remy Martin', 'Hennessy', 'France',5),
(6,'Hennessy', 'Mansion House Brandy', 'France',6),
(7,'Gordon s', 'Gin Bombay Sapphire', 'England',7),
(8,'Pastis 51', 'Ricard', 'France',8),
(9,'Soledade', 'Abelha', 'Brazil',9),
(10,'Patron', 'Don Julio', 'Mexico',10),
(11,'Jack Daniel s', 'Johnnie Walker', 'Scotland',11),
(12,'Torres' , 'Barefoot', ' California',12),
(13,'Campari', 'Ricard', 'France',13),
(14,'Dom Perignon', 'Moet', 'France',14)
GO
INSERT INTO cocktails
VALUES(1,'Cosmopolitan', 'Neal Murray', 'San Francisco', 'raw fish',1),
(2,'Mojito', 'Francis Drake', 'Cuba', 'foie gras',2),
(3,'Corpse Revivers', 'Harry Craddock', 'London', 'raw fish',3),
(4,'Monaco', 'George Booth', 'Paris', 'red meat',4),
(5,'Sidecar', 'Frank Meier', 'London', 'smoked herring',5),
(6,'Sazerac', 'Antoine Amédée Peychaud', 'New Orleans', 'nuts',6),
(7,'Gin tonic', 'British soldiers', 'India', 'seafood',7), 
(8,'Mauresca', 'French soldiers', 'South of France', 'red fruits',8),
(9,'Caipirinha', 'Peasants', 'Brazil', 'seafood',9),
(10,'Margarita', 'Carlos Herrera', 'Tijuana', 'Grilled Seafood',10),
(11,'Manhattan', 'Ian Marshal', 'New-York', 'cheese',11),
(12,'Sangria', 'Peasants', 'Spain', 'cheese',12),
(13,'Negroni', 'Count Camillo Negroni', 'Florence', 'seafood',13),
(14,'Mimosa', 'Frank Meier', 'Paris', 'scrambled eggs',14)
GO
INSERT INTO customers
VALUES(1,'Vladimir Pokov', 30,'male','Usa'),
(2,'Sharon Stone', 62,'female','Usa'),
(3,'Donna Silver', 23,'female','Europe'),
(4,'Petra Kreiner', 18,'female','Europe'),
(5,'Fabricio Rene', 29,'male','Europe'),
(6,'Samuel Leto', 32,'male','Usa'),
(7,'Arthur Brank', 21,'male','Europe'),
(8,'Richard Dubois', 47, 'male','Europe'),
(9,'Adriana Karembeu', 36,'female','Usa'),
(10,'Juan San Jose', 27,'male','Usa'),
(11,'James Dylan', 39,'male','Usa'),
(12,'Catherine Dupont', 30,'female','Europe'),
(13,'Dennis Lombard', 18,'male','Europe'),
(14,'Victoria Daniel', 33,'female','Europe')
GO
INSERT INTO sales
VALUES(1,'Jean-Francois', '2012-12-03', 5000, 3,'Vodkaplaisure','13 street Labruyere France',1,1),
(2,'Xavier Lancheau', '2014-08-12', 325, 1, 'Drinkshop', '35 street Lvene France',2,2),
(3,'Pamela Croft', '2000-11-30', 7435, 4, 'Dreamalcohol', '722 blvd Floride',3,3),
(4,'Alex Drey', '2010-02-19', 12000, 7, 'Lostisland', '28 street California',4,4),
(5,'Louise Gauchon', '2012-12-25', 3400, 2, 'Eiffellove', 'blvd Elysee Paris', 5,5),
(6,'Sylvie Charles', '2000-07-05', 8900, 5, 'Drinkflavors', '48 Pierre Koening France', 6,6),
(7,'Daniel Kein', '2014-05-31', 6200, 4, 'Ginlife', '123 street Baker London', 7,7),
(8,'Allan Miller', '2010-01-07', 9280, 6, 'Pastisso', '82 street Mustermann Germany', 8,8),
(9,'Rosa Cipre', '2003-04-09', 2500, 1, 'Sol', '5 street Paulista Brazil', 9,9),
(10,'Juan Perez', '2002-10-16', 360, 1, 'TequilaSun', '90 street Puerta Lisbon', 10,10),
(11,'Charles St-Pierre', '2001-12-30', 10000, 3, 'Tresor', 'Bastille Square France', 11,11),
(12,'Antoine Genieve', '2003-06-14', 5500, 5, 'Bellisimo', '20 street Giovanni Rossi Italy', 12,12),
(13,'Carla Bruni', '2002-09-20', 800, 1, 'Momento', 'Sagrada street Spain', 13,13),
(14,'Marcelle Gedj', '1999-01-28', 1500, 1, 'Petillante', 'blvd triumphal arch Paris',14,14)
GO
INSERT INTO suppliers
VALUES(1,'Diageo', 'Audrey Levi', 'Audreydiag@mail.com', 'United Kingdom',1),
(2,'Bacardi', 'Joseph Cruz', 'Joseybac@mail.com', 'Bermuda',2),
(3,'Marteau Absinthe', 'Samuel Hampton', 'Samumumart@gmail.com', 'Usa',3),
(4,'Heineken', 'David Greg', 'Davhein@gmail.com', 'The Netherlands',4),
(5,'Hennessy', 'Charles Lupin', 'Charleshenn@gmail.com', 'France', 5),
(6,'Torres Brandy', 'John Band', 'Johnytorr@gmail.com', 'Spain', 6), 
(7,'William Grant', 'Goerge Camp', 'Goergewill@gmail.com', 'Scotland',7),
(8,'Metaxa', 'Ilan Grand', 'Ilanmet@gmail.com', 'Greece',8),
(9,'Cachaca51', 'Juana verdez', 'Juancac@gmail.com', 'Brazil', 9),
(10,'Jose Cuervo', 'Victoria Lunez', 'Vicjose@gmail.com', 'Mexico',10),
(11,'Beam Santory', 'Dan Lock', 'Danbeam@gmail.com', 'Usa',11),
(12,'Louis Viutton H', 'Bruno Lelouche', 'Brunolouis@gmail.com', 'France',12),
(13,'Baileys', 'Alexandre Connor', 'Alexbail@gmail.com', 'United Kingdom',13),
(14,'Taittinger', 'Laurent Jean', 'Laurtai@gmail.com', 'France',14)

select *
from sales