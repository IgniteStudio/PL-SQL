
DROP TABLE baseoption;
DROP TABLE servwork;
DROP TABLE invoption;
DROP TABLE saleinv;
DROP TABLE employee;
DROP TABLE servinv;
DROP TABLE prospect;
DROP TABLE options;
DROP TABLE car;
DROP TABLE customer;

CREATE TABLE customer(
    cname CHAR(20) NOT NULL,
    cstreet CHAR(20) NOT NULL,
    ccity CHAR(20) NOT NULL,
    cprov CHAR(20) NOT NULL,
    cpostal CHAR(10),
    chphone CHAR(13),
    cbphone CHAR(13),
    
    CONSTRAINT cname_pk PRIMARY KEY (cname)
);

CREATE TABLE car(
    serial CHAR(8) NOT NULL,
    cname CHAR(20),
    make CHAR(10),
    model CHAR(8) NOT NULL,
    cyear CHAR(4) NOT NULL,
    color CHAR(12) NOT NULL,
    trim CHAR(16) NOT NULL,
    enginetype CHAR(10) NOT NULL,
    purchinv CHAR(6),
    purchdate DATE,
    purchfrom CHAR(20),
    purchcost NUMERIC(9,2),
    freightcost NUMERIC(9,2),
    totalcost NUMERIC(9,2) AS (purchcost + freightcost),
    listprice NUMERIC(9,2),
    
    CONSTRAINT serial_pk PRIMARY KEY (serial),
    CONSTRAINT cname_car_fk FOREIGN KEY (cname) REFERENCES customer(cname)
);

CREATE TABLE options(
    ocode CHAR(4) NOT NULL,
    odesc CHAR(30),
    olist NUMERIC(7,2),
    ocost NUMERIC(7,2),
    
    CONSTRAINT ocode_pk PRIMARY KEY (ocode) 
);

CREATE TABLE prospect(
    cname CHAR(20) NOT NULL,
    make CHAR(10) CONSTRAINT prospect_make_nn NOT NULL CHECK (make IN ('ACURA','MERCEDES','LAND ROVER','JAGUAR')),
    model CHAR(8),
    cyear CHAR(4),
    color CHAR(12),
    trim CHAR(16),
    ocode CHAR(4) NOT NULL,  
            
    CONSTRAINT cname_prospect_fk FOREIGN KEY (cname) REFERENCES customer(cname),
    CONSTRAINT ocode_prospect_fk FOREIGN KEY (ocode) REFERENCES options(ocode),
    CONSTRAINT prospect_unique UNIQUE (cname, make, model, cyear, color, trim, ocode)
);


CREATE TABLE servinv(
    servinv CHAR(5) NOT NULL,
    serdate date NOT NULL,
    cname CHAR(20) NOT NULL,
    serial CHAR(8) NOT NULL,
    partscost NUMERIC(7,2),
    labourcost NUMERIC(7,2),
    tax NUMERIC(8,2) AS ((partscost + labourcost) * 0.13),
    totalcost NUMERIC(8,2) AS (partscost + labourcost + ((partscost + labourcost) * 0.13)),
    
    CONSTRAINT servinv_pk PRIMARY KEY (servinv),
    CONSTRAINT cname_servinv_fk FOREIGN KEY (cname) REFERENCES customer(cname),
    CONSTRAINT serial_servinv_fk FOREIGN KEY (serial) REFERENCES car(serial)
);


CREATE TABLE employee(
    empname CHAR(20) NOT NULL,
    startdate DATE NOT NULL,
    manager CHAR(20) REFERENCES employee(empname),
    commissionrate NUMERIC(2,0),
    title CHAR(26),
    
    CONSTRAINT empname_pk PRIMARY KEY (empname)  
    
);

CREATE TABLE saleinv(
    saleinv CHAR(6) NOT NULL,
    cname CHAR(20) NOT NULL,
    salesman CHAR(20) NOT NULL,
    saledate DATE CONSTRAINT salesinv_saledate_nn NOT NULL CHECK (saledate > TO_DATE('01-JAN-1990','DD-MON-YYYY')),
    serial CHAR(8) NOT NULL,
    totalprice NUMERIC(9,2),
    discount NUMERIC(8,2),
    net NUMERIC(9,2) AS (totalprice - discount - tradeallow),
    tax NUMERIC(8,2) AS ((totalprice - discount - tradeallow) * 0.13),
    licfee NUMERIC(6,2),
    commission NUMERIC(8,2) INVISIBLE,
    tradeserial CHAR(8),
    tradeallow NUMERIC(9,2),
    fire CHAR(1) CHECK (fire IN ('Y','N')),
    collision CHAR(1) CHECK (collision IN ('Y','N')),
    liability CHAR(1) CHECK (liability IN ('Y','N')),
    property CHAR(1) CHECK (property IN ('Y','N')),
    
    CONSTRAINT saleinv_pk PRIMARY KEY (saleinv),
    CONSTRAINT cname_saleinv_fk FOREIGN KEY (cname) REFERENCES customer(cname),
    CONSTRAINT serial_saleinv_fk FOREIGN KEY (serial) REFERENCES car(serial),
    CONSTRAINT tradeserial_fk FOREIGN KEY (tradeserial) REFERENCES car(serial)
      
);

CREATE SEQUENCE saleinv_seq;
CREATE SEQUENCE servinv_seq;

CREATE TABLE invoption(
    saleinv CHAR(6) NOT NULL,
    ocode CHAR(4) NOT NULL,
    saleprice NUMERIC(7,2) NOT NULL,
    
    CONSTRAINT invoption_unique unique (saleinv, ocode),
    CONSTRAINT saleinv_invoption_fk FOREIGN KEY (saleinv) REFERENCES saleinv(saleinv),
    CONSTRAINT ocode_invoption_fk FOREIGN KEY (ocode) REFERENCES options(ocode)
);

CREATE TABLE servwork(
    workdesc CHAR(80) NOT NULL,
    servinv CHAR(5) NOT NULL,
        
    
    CONSTRAINT servinv_servwork_fk FOREIGN KEY (servinv) REFERENCES servinv(servinv),
    PRIMARY KEY (workdesc, servinv)
);


CREATE TABLE baseoption(
    serial CHAR(8) NOT NULL,
    ocode CHAR(4) NOT NULL,
    
    PRIMARY KEY (serial, ocode),
    CONSTRAINT serial_baseoption_fk FOREIGN KEY (serial) REFERENCES car(serial)
);