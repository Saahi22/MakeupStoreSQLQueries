-- SQL queries used to build and manipulate a makeup stores data

-- Create a makeup store database to hold relevant information
CREATE DATABASE MakeUpStore;
use MakeUpStore;

-- Create a Stores Table that holds relevant information about a beauty store
# Drop Table Stores;
CREATE TABLE Stores (
    StoreID int(6) NOT NULL,
    StreetAddress varchar(60) NOT NULL,
    City varchar(60),
    State varchar(60),
    StoreSize varchar(1), -- Store Size Options S(mall), M(edium), L(arge)
    PRIMARY KEY (StoreID) -- Store ID's have to be unqiue
);

-- Data Entry to Create 6 Makeup Stores
INSERT INTO Stores VALUES (10001, '111 S.Michigan St', 'Chicago', 'Illinois', 'L');
INSERT INTO Stores VALUES (10002, '10 S.Clinton St', 'Chicago', 'Illinois', 'S');
INSERT INTO Stores VALUES (10003, '100 W.Jackson St', 'Chicago', 'Illinois', 'M');
INSERT INTO Stores VALUES (10004, '213 W.Adams St', 'Chicago', 'Illinois', 'L');
INSERT INTO Stores VALUES (10005, '500 W.Wacker Dr', 'Chicago', 'Illinois', 'S');
INSERT INTO Stores VALUES (10006, '44 W.Madison ST', 'Chicago', 'Illinois', 'M');


-- Create a table to hold what products are available in the stores
# Drop TABLE Inventory;
CREATE TABLE Inventory (
	ProdID int(3),
    StoreID int(6),
	BrandName varchar(35),
    ProductName varchar(40),
    Category varchar(40),
	ShadeName varchar(15) ,
    Price int(3),
	PRIMARY KEY (ProdID),
	FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)
);

-- Enter Data For Products That Will Be Placed In The Stores
	-- Skin Care Data Entries
	INSERT INTO Inventory VALUES (201, 10006, 'Summer Fridays', 'Lip Butter Balm', 'Skin Care', 'Sweet Mint', 23);
	INSERT INTO Inventory VALUES (202, 10001, 'Summer Fridays', 'Lip Butter Balm', 'Skin Care','Sweet Mint', 23);
	INSERT INTO Inventory VALUES (203, 10004, 'Summer Fridays', 'Lip Butter Balm', 'Skin Care', 'Sweet Mint', 23);
	INSERT INTO Inventory VALUES (213, 10004, 'Summer Fridays', 'Lip Butter Balm', 'Skin Care', 'Iced Coffee', 23);
	INSERT INTO Inventory VALUES (204, 10002, 'Rhode', 'Peptide Lip Treatment', 'Skin Care', 'Vanilla', 21);
	
    -- Fragrance Data Entries
	INSERT INTO Inventory VALUES (205, 10003, 'Le Labo', 'Fine Fragrance', 'Fragrance','Another 13', 150);
	INSERT INTO Inventory VALUES (206, 10001, 'Diptyque', 'Fine Fragrance', 'Fragrance','Orpheon', 150);

	-- Makeup Data Entries
	INSERT INTO Inventory VALUES (207, 10001, 'Saie', 'Glowy Super Gel', 'Makeup', 'Starglow', 22);
	INSERT INTO Inventory VALUES (208, 10002, 'Saie', 'Dew Blush', 'Makeup', 'Sweetie', 22);
	INSERT INTO Inventory VALUES (209, 10003, 'Hourglass', 'Ambient Lighting Blush', 'Makeup', 'Sublime Flush', 54);
	INSERT INTO Inventory VALUES (210, 10004, 'Dior', 'Lip Glow', 'Makeup', 'Strawberry 031', 35);
	INSERT INTO Inventory VALUES (211, 10005, 'Kaja', 'Eyeshadow Bento', 'Makeup', 'Orange Blossom', 18);
	INSERT INTO Inventory VALUES (212, 10006, 'Huda Beauty', '#Faux Filter Corrector', 'Makeup', 'Peach', 21);

-- Basic Queries
	select * from Inventory;

	select StreetAddress
	from Stores;

-- How Distinct affects query results
	select BrandName from Inventory; -- All Brand names along with repeated entries show in this query
	select distinct BrandName from Inventory; -- No Repeats in Brand Name so only one occurance is displayed for each brand name


-- Generic Queries with A Where Condition
	Select BrandName, ProductName 
	from Inventory 
	where ShadeName = 'Orpheon';

	Select distinct ShadeName
	from Inventory
	Where BrandName = 'Summer Fridays';
    
-- Group By Clause Query
	select COUNT(ProductName), Category
	from Inventory
	group by Category;

-- Adding an Order By Clause
	Select count(ProductName), Category
	from Inventory
	group by Category
	Order By count(ProductName) ASC;

	Select count(ProductName), Category
	from Inventory
	group by Category
	Order By count(ProductName) DESC;

-- Inner Join Query Shows Us The Products And The Stores Information For Where Those Products Are Currently Sold
		select *
		from Stores
		Inner Join Inventory on Inventory.StoreID = Stores.StoreID;
    
-- Nested Query 
		-- Get the address information for a certain product along with a particular shade
		Select S.BrandName, S.StreetAddress, S.City, S.State 
		from (select Stores.StoreID, Inventory.BrandName, Inventory.ShadeName, Stores.StreetAddress, Stores.City, Stores.State 
		from Stores Inner Join Inventory on Stores.StoreID = Inventory.StoreID) as S
		where S.BrandName = 'Summer Fridays' and S.ShadeName = 'Sweet Mint';
    
    -- Nested Queries with Group By, Order By, SUM(), and Limit
		-- Total Value of All Stores Inventory
        Select S.StreetAddress, SUM(S.Price) 
        From (Select Stores.StreetAddress, Stores.City, Stores.State, Inventory.Price, Inventory.Category 
			from Stores Inner Join Inventory on Inventory.StoreID = Stores.StoreID) as S
		Group By S.StreetAddress
        Order By SUM(S.Price) DESC;
		
        -- Gives me the Address information of the store with the highest inventory cost
		Select S.StreetAddress, S.City, S.State, SUM(S.Price) 
        From (Select Stores.StreetAddress, Stores.City, Stores.State, Inventory.Price, Inventory.Category 
			from Stores Inner Join Inventory on Inventory.StoreID = Stores.StoreID) as S
		Group By S.StreetAddress, S.City, S.State
        Order By SUM(S.Price) DESC
        limit 1;
        
