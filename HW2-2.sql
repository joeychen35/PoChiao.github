-- Preliminaries
DROP   DATABASE IF EXISTS db_companyx;
CREATE DATABASE db_companyx;
USE    db_companyx;

-- Creating the Entities (Tables)
CREATE TABLE provider(
  id              	INT unsigned NOT NULL AUTO_INCREMENT, # Unique ID for the record
  NAME            	VARCHAR(100) NOT NULL,                
  ADDRESS         	VARCHAR(100) NOT NULL,               
  PHONE				INT NOT NULL,                 			
  WEBSITE			VARCHAR(100) NOT NULL, 
  PRIMARY KEY     	(id)                                  # Make the id the primary key
);


CREATE TABLE customer(
  ID_CUSTOMER      	INT unsigned NOT NULL AUTO_INCREMENT, # Unique ID for the record                        
  NAME   			VARCHAR(100) NOT NULL,                # NAME OF the country                
  USERNAME		  	VARCHAR(100) NOT NULL,
  PASSWORD_CUS		VARCHAR(100) NOT NULL,
  DESCRIPTION     	VARCHAR(100) NOT NULL,                                #                                                                      
  PRIMARY KEY     	(ID_CUSTOMER)                          #                            
);
drop table transactions;

CREATE TABLE transactions(
  ID_TRANSACTIONS   INT unsigned NOT NULL AUTO_INCREMENT, #                          
  SALE_DATE 		DATE,                #                 
  CUSTOMER         	INT unsigned NOT NULL,                                  #                  
  DISCOUNT			INT NOT NULL,      
  AMT_PAID			INT NOT NULL, 
  UNITS				INT unsigned NOT NULL,
  SALES_PRICE		INT NOT NULL,
  PRIMARY KEY     (ID_TRANSACTIONS)                             #                  
);

drop table product;

CREATE TABLE product(
  ID_PRODUCT        INT unsigned NOT NULL AUTO_INCREMENT, # 
  name            	VARCHAR(100) NOT NULL,                # 
  STCOK            	INT NOT NULL,
  PROVIDER_ID 		INT unsigned NOT NULL,
  CATEGORY_ID		INT unsigned NOT NULL,
  PRIMARY KEY     	(ID_PRODUCT)                                  # 
);

CREATE TABLE category(
ID_CATEGORY			INT unsigned NOT NULL AUTO_INCREMENT,
REPORT				VARCHAR(100) NOT NULL,
YEAR				INT NOT NULL,
PRIMARY KEY 		(ID_CATEGORY)
);

CREATE TABLE phone(
ID_PHONE			INT unsigned NOT NULL AUTO_INCREMENT,
PHONE_NUMBER		VARCHAR(100) NOT NULL,
CUSTOMER_ID			INT unsigned NOT NULL,
PRIMARY KEY 		(ID_PHONE)
);

CREATE TABLE ADDRESS(
ID_ADDRESS			INT unsigned NOT NULL AUTO_INCREMENT,
ADDRESS				VARCHAR(100) NOT NULL,
CUSTOMER_ID			INT unsigned NOT NULL,
PRIMARY KEY 		(ID_ADDRESS)
);

CREATE TABLE price(
ID_PRICE			INT unsigned NOT NULL AUTO_INCREMENT,
DATES				VARCHAR(100) NOT NULL,
PRODUCT_ID			INT unsigned NOT NULL,
PRIMARY KEY 		(ID_PRICE)
);


-- Adding Foreign keys
ALTER TABLE product   ADD CONSTRAINT FK_productProvider  FOREIGN KEY (PROVIDER_ID) REFERENCES provider(id);
ALTER TABLE product   ADD CONSTRAINT FK_productCategory      FOREIGN KEY (CATEGORY_ID)    REFERENCES category(ID_CATEGORY);
ALTER TABLE transactions   ADD CONSTRAINT FK_transactionsProduct   FOREIGN KEY (UNITS)    REFERENCES product(ID_PRODUCT); 
ALTER TABLE transactions   ADD CONSTRAINT FK_transactionsCustomer   FOREIGN KEY (customer)    REFERENCES customer(ID_CUSTOMER); 
ALTER TABLE phone	ADD CONSTRAINT FK_phoneCustomer  FOREIGN KEY (CUSTOMER_ID) REFERENCES customer(ID_CUSTOMER);
ALTER TABLE address	ADD CONSTRAINT FK_addressCustomer  FOREIGN KEY (CUSTOMER_ID) REFERENCES customer(ID_CUSTOMER);
ALTER TABLE price	ADD CONSTRAINT FK_priceProduct  FOREIGN KEY (PRODUCT_ID) REFERENCES product(ID_PRODUCT);

