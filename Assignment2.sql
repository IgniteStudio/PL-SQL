--RMDBS Application Development Assignment 2
-- David Agaybi September 25, 2018
-- Professor Sheetal Thakar


-- Delete any previous version of the table and recreate.  This is the customer table.
DELETE FROM customer;
INSERT INTO customer (cname, cstreet, ccity, cprov, cpostal, chphone, cbphone) 
    VALUES ('David Agaybi', '310 Burnhamthorpe', 'Mississauga', 
        'Ontario', 'L5B-4P9', '(416)917-6604', '(416)917-6604');
        
INSERT INTO customer (cname, cstreet, ccity, cprov, cpostal, chphone, cbphone) 
    VALUES ('Peter Jackson', '10 Spadina Ave.', 'Toronto', 
        'Ontario', 'M95-1T2', '(416)555-6104', '(416)687-1234');        

-- Delete any previous version of the table and recreate.  This is the car table.
DELETE FROM car;
INSERT INTO car (serial, cname, make, model, cyear, color, trim, enginetype,
    purchinv, purchdate, purchfrom, purchcost, freightcost, listprice)
    VALUES ('A06BA4N7', 'David Agaybi', 'Audi', 'A4NQ', '2006', 'Blue', 'none', '4-cyl', 
        null, null, null, null, null, null);
        
INSERT INTO car (serial, cname, make, model, cyear, color, trim, enginetype,
    purchinv, purchdate, purchfrom, purchcost, freightcost, listprice)
    VALUES ('F85BTEM2', 'Peter Jackson', 'Ford', 'Tempo', '1985', 'Blue', 'Grey', '4-cyl', 
        null, null, null, null, null, null);        
        
INSERT INTO car (serial, cname, make, model, cyear, color, trim, enginetype,
    purchinv, purchdate, purchfrom, purchcost, freightcost, listprice)
    VALUES ('A18BRLX7', null, 'ACURA', 'RLX', '2018', 'Blue', 'Black', '4-cyl', 
        'SI0011', '2017-09-15', 'Honda Canada', '25000', '1000', '35000');    
        
-- Delete any previous version of the table and recreate.  This is the baseoption table.
DELETE FROM baseoption;
INSERT INTO baseoption (serial, ocode) VALUES ('A18BRLX7', 'CD2');
INSERT INTO baseoption (serial, ocode) VALUES ('A18BRLX7', 'R41');

-- Delete any previous version of the table and recreate.  This is the saleinv table.
DELETE FROM saleinv;
INSERT INTO saleinv (saleinv, cname, salesman, saledate, serial, 
    totalprice, discount, licfee, tradeserial, tradeallow, 
    fire, collision, liability, property, commission)
    VALUES ('I' || TO_CHAR(saleinv_seq.NEXTVAL, 'FM00000'), 'David Agaybi',
    'ADAM ADAMS', '2018-09-25', 'A18BRLX7', 35000, 3000, 200, 
     'A06BA4N7', 1500, 'Y', 'Y', 'Y', 'Y',  (SELECT commissionrate/100 *(Select net from saleinv) 
    from employee where empname = 'ADAM ADAMS'));
     
-- Updateing car table with new info
UPDATE car
SET cname = 'David Agaybi'
WHERE make = 'ACURA';

UPDATE car
SET cname = null
WHERE make = 'Audi';

UPDATE car
SET purchdate = (SELECT saledate FROM saleinv WHERE saleinv.tradeserial = 'A06BA4N7')
WHERE serial = 'A06BA4N7';


UPDATE car
SET purchfrom = (SELECT cname FROM saleinv WHERE saleinv.tradeserial = 'A06BA4N7')
WHERE serial = 'A06BA4N7';


UPDATE car
SET freightcost = 0
WHERE purchfrom = 'David Agaybi';

UPDATE car
SET freightcost = 1000
WHERE cname = 'David Agaybi'; 


UPDATE car
SET purchcost = (SELECT tradeallow FROM saleinv WHERE cname = 'David Agaybi')
WHERE purchfrom = 'David Agaybi';


UPDATE car
SET listprice = totalcost + 1500
WHERE purchfrom = 'David Agaybi';


-- Insert two records into invoption table
INSERT INTO invoption (saleinv, ocode, saleprice)
VALUES ('I' || TO_CHAR(saleinv_seq.CURRVAL, 'FM00000'), 'M24', 285);

INSERT INTO invoption (saleinv, ocode, saleprice)
VALUES ('I' || TO_CHAR(saleinv_seq.CURRVAL, 'FM00000'), 'H35', 145);


-- Insert two records into prospect table
INSERT INTO prospect (cname, make, model, cyear, color, trim, ocode)
VALUES ('David Agaybi', 'JAGUAR', 'XJ25', '2018', 'Silver', 'Black', 'W11');

INSERT INTO prospect (cname, make, model, cyear, color, trim, ocode)
VALUES ('David Agaybi', 'LAND ROVER', 'TREK', '2018', 'Black', NULL, 'S88');

-- Insert two records into servinv table for service work
INSERT INTO servinv (servinv, serdate, cname, serial, partscost, labourcost)
VALUES ('W' || TO_CHAR(servinv_seq.NEXTVAL, 'FM0000'),
    '2018-09-25', 'Peter Jackson', (SELECT serial FROM car WHERE cname = 'Peter Jackson'),
    200, 200);
    
INSERT INTO servinv (servinv, serdate, cname, serial, partscost, labourcost)
VALUES ('W' || TO_CHAR(servinv_seq.NEXTVAL, 'FM0000'),
    '2018-09-25', 'Peter Jackson', (SELECT serial FROM car WHERE cname = 'Peter Jackson'),
    50, 50);    
    
-- Insert two records into servwork table for service work done based on servinv table
INSERT INTO servwork (workdesc, servinv)
VALUES ('Front brake pads needed replacement and cleaning for 4 hours', 
    'W' || TO_CHAR(servinv_seq.CURRVAL, 'FM0000'));


INSERT INTO servwork (workdesc, servinv)
VALUES ('Oil change for 1 hour', 
    'W' || TO_CHAR(servinv_seq.CURRVAL, 'FM0000'));


