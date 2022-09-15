-- Criação de um bando de dados para um cenário de e-cormmece
CREATE DATABASE ECORMMECE;
-- drop database ECORMMECE;
USE ECORMMECE;
-- EXPLORATÓRIO
-- show table status;
-- show tables;
-- show databases;
-- use information_schema;
-- show tables;
-- desc REFERENTIAL_CONSTRAINTS;
-- select * from REFERENTIAL_CONSTRAINTS where CONSTRAINT_SCHEMA = 'ecormmece';

-- Recuperando dados 
select * from productSeller ;
desc clients;
select count(*) from clients;
select * from clients, request where clients.idClient = request.idRequestClient;
select distinct * from request r, pay p ,clients c where c.idClient = r.idRequestClient and c.idClient = p.idClient;
select count(*) from pay;
select * from pay;
delete from pay where idPay >= 13;
select concat(Fname," ",Mint," ",Lname) as full_name from clients;
-- eu querio recuperar dados com o cocat full_name
	desc product;
SELECT  concat(Fname," ",Mint," ",Lname)as Full_name, StatePay,idRequestClient, Pname
	FROM  clients c, request r, pay p,requestproduct rp,product prod 
    WHERE( 
		c.idClient = r.idRequestClient and c.idClient = p.idClient and rp.id_RP_request = r.idRequest 
        and prod.idProduct = rp.id_RP_product)order by StatePay;

SELECT  count(*)as qnt, StatePay,idRequestClient, Pname
	FROM  clients c, request r, pay p,requestproduct rp,product prod 
    WHERE( 
		c.idClient = r.idRequestClient and c.idClient = p.idClient and rp.id_RP_request = r.idRequest 
        and prod.idProduct = rp.id_RP_product)group by StatePay   ;

	
	 
select*from pay;


-- CRIAR TABELA CLIENTE

create table clients(
	idClient int auto_increment primary key ,
    Fname varchar(10),
    Mint char(3),
    Lname varchar(20),
    CPF char(11) not null,
    constraint unique_cpf_client unique(CPF),
    Address varchar(45),
    City varchar(20),
    State char(2),
    district varchar (20)
);
alter table clients auto_increment =1; 

-- CRIANDO VALORES TABLE CLIENT
INSERT into clients(Fname,Mint,Lname,CPF,Address,City,State,district)
	values('Abigail','M','Gallani','123456789','rua 1','cosmopolis','SP','Bairro jesus'),
	('Carlos','O','Gallani','987654321','rua 1','cosmopolis','SP','Bairro jesus'),
    ('Hadassa','C','Gallani','112233445','rua 2','angra','RJ','Bairro alegria'),
    ('Edivania','M','Carvalho','223344556','rua 2','angra','RJ','Bairro alegria'),
    ('Gerson','J','Gallani','998877665','rua 3','brasília','DF','Bairro corrupto'),
    ('Francisco','R','Jesus','887766554','rua 4','agua doce','SP','Bairro todo poderoso');

-- CRIAR TABELA PRODUTO	
-- size equivale a dimenção do produto

create table product(
	idProduct int auto_increment,
    primary key(idProduct),
    Pname varchar(10),
    classification_kids bool,
    Categoria enum('Eletrônico','Vestuário','Brinquedo','Alimento','Moveís') default 'Eletrônico' not null,
    Review float default 0,
    Size varchar(10)
);
alter table product auto_increment =1; 
desc product; 
select count(*) from product;  
 
 -- CRIANDO VALORES TABLE PRODUCT
 
 INSERT into product(Pname,classification_kids,Categoria,Review,Size)
 values('placa mãe',false,'Eletrônico', 5,'atx'),
		('RTX3060ti',false,'Eletrônico', 5,'30cm'),
        ('mesa kid',true,'Brinquedo', 4,'60cm_x50cm');
insert into product(Pname,classification_kids,Categoria,Size)
values('Camiseta',false,'Vestuário','GG'),
        ('Cama',false,'Moveís','3M_X2M');
 
    -- CRIAR TABELA VENDEDOR-TERCEIRO
    
create table thirdSeller(
	idSeller int auto_increment primary key,
    socialReaseon varchar(30),
    cnpj varchar(20) not null,
    fantasyName varchar(30),
    contact varchar(15),
    Address varchar(20),
    city varchar(15),
    State char(2),
    district varchar(20),
    quantity int default 0,
    constraint unique_cnpf_seller unique(cnpj)
    
);
alter table thirdSeller auto_increment =1;
INSERT into thirdSeller(socialReaseon,cnpj,fantasyName,contact,Address,city,State,district,quantity)
values('BalaNaAgula',15717117117,'Bala na Agulha','(19)99999-9119','rua da bocada','crazy city','SP','biqueira',18),
		('RuimDeSereviço',15717117110,'Ruim de Serviço','(19)99999-9118','rua dos lezados','tartaruga','SP','ventania',default) ,
        ('VendeMuito',10055117117,'Vende Muito','(19)88999-9177','rua da bocada','crazy city','SP','Burguesia',300) ,
        ('MeiaBoca',20718555147,'Meia Boca ','(21)77777-4451','esquina acelerados','manaus','am','vila do macaco',150) ,
        ('JaNaoAguentoMais',88717457657,'Ja não aguento Mais','(15)86969-2114','rua fim da linha','Toxica','PI','bairro dos lascados',2) ,
        ('FodaSe',00000000007,'Foda SE','(18)99999-9999','rua ñ te interessa','chernobil','ES','não sei',default) ;

-- CRIANDO TABELA PAGAMENTO
select count(*)from pay;
delete from pay;
create table pay(
	idPay int auto_increment primary key,
	typerOfPay enum('Card','Pix','Transfer','Boletus'),
	StatePay enum('Approved','Canceled','Denied'),
	idClient int, 
	constraint Fk_client_pay foreign key (idClient) references clients(idClient)
    
);
alter table pay auto_increment =1; 
insert into pay(idClient,typerOfpay,StatePay)
values(1,'Card','Approved'),
		(2,'Card','Canceled'),
        (3,'Boletus','Approved'),
        (4,'Card','Denied'),
        (5,'Pix','Denied'),
        (6,'Pix','Approved');
-- desc pay;

-- CRIAR TABELA PEDIDO

 drop table request;
select count(*) from request;
delete from request ;
desc request;
select *from pay;

create table request(
	idRequest int auto_increment primary key,
    idRequestClient int,
    idRequestPay int,
    requestState enum('In Processing','Processing','Sent','delivered') default 'Processing' ,
    requestDescription varchar(255) ,
    statusPay bool default false,
    Freight float default 10,
    constraint Fk_request_client foreign key (idRequestClient) references clients(idClient)
		on update cascade,
    constraint fk_request_pay foreign key (idRequestPay) references pay(idPay)
		on update cascade
);
-- ^^on update serve para atualizar todos relacionados a fk e on delete deleta todos os valores null (não informados)
alter table request drop constraint Fk_request_client;
alter table request add constraint Fk_request_client foreign key (idRequestClient) references clients(idClient) on update cascade;


insert into request(idRequestClient,idRequestPay,requestState,requestDescription,statusPay,Freight)
values(1,7,'In Processing',null,true,500),
	  (2,8,'In Processing',null,false,default),
      (3,9,'Sent','Ta chegando misera',true,400),
      (4,10,'sent',null,true,50),
      (5,11,'delivered',null,true,100),
      (6,12,default,null,true,default);
      
      -- CRIANTO FORNECEDOR

select count(*) from suppllier;
select*from request;
create table suppllier(
	idSuppllier int auto_increment primary key,
    socialReason varchar(30),
    fantasyName varchar(30),
    cnpj varchar(15) not null,
    constraint unique_cnpj_suppllier unique(cnpj)
);
alter table suppllier auto_increment =1;
insert into suppllier(socialReason,fantasyName,cnpj)
values('Perigo','Perigo',15715715007),
	  ('Sem ideia','Sem ideia',12365454007),
      ('TerrorBr','Aliexpress',65885717707),
      ('China','Shopee',75915919009),
      ('Amazonia ','Amazon',48615615606),
      ('ZeLoko','Ze',35715715608);
      
-- CRIANDO TABELA ESTOQUE

create table inventory(
	idInventory int auto_increment primary key,
    location varchar(45),
    inventoryStatus enum('Full','Empty','with space'),
    identification varchar(25) not null
);
alter table inventory auto_increment =1;
insert into inventory(location,inventoryStatus,identification)
values('deposito_1','with space','dp1'),
	  ('deposito_2','Full','dp2'),
      ('deposito_3','Empty','dp3');


-- CRIANDO TABELA RELACIONAMENTO PRODUTOS VENDEDOR TERCEIRO

create table productSeller(
	idPseller int ,
    idProduct int ,
    quantity int default 1,
    constraint pk_composta_Pseller primary key(idPseller,idProduct),
    constraint fk_Pseller foreign key(idPseller) references thirdSeller(idSeller),
    constraint fk_Product foreign key(idProduct) references product(idProduct)
    
);
-- CRIANDO RELACIONAMENTO FORNECEDOR PRODUTO

create table suppllierProduct(
	id_SP_suppllier int,
    id_SP_product int,
    constraint ps_composta_Sproduct primary key(id_SP_suppllier,id_SP_product),
    constraint fk_supplierProduct_Suppllier foreign key(id_SP_suppllier) references thirdSeller(idSeller),
    constraint fk_suppllierProduct_Product foreign key(id_SP_product) references product(idProduct)
);
-- CORRIGINDO
alter table suppllierProduct
add column Quantaty int not null;
desc suppllierProduct;
alter table suppllierProduct change column Quantaty Quantity int not null;


-- CRIANDO RELACIONAMENTO ESTOQUE PRODUTO

create table inventoryProduct(
	id_IP_inventory int,
	id_IP_Product int,
	constraint pk_composta_InventoryProduct primary key(id_IP_inventory,id_IP_Product),
	constraint fk_inventoryProduct_inventory foreign key(id_IP_inventory) references inventory(idInventory),
	constraint fk_inventoryProduct_product foreign key(id_IP_Product) references product(idProduct)
    );
    
-- CRIANDO RELACIONAMENTO DE PEDIDO E PRODUTO

create table requestProduct(
	id_RP_request int,
    id_RP_product int,
    statusProduct enum('Available','Out of inventory') default 'Available',
    quantidade int,
    constraint pk_composta_requestProduct primary key(id_RP_request,id_RP_product),
    constraint fk_requestProduct_Product foreign key(id_RP_product) references product(idProduct),
    constraint fk_requestProduct_request foreign key(id_RP_request) references request(idRequest)
    
);
insert into requestProduct (id_RP_request,id_RP_product)
values(43,4),
	  (44,5),
      (46,10),
      (47,9),
      (48,6);

select*from requestproduct;
select*from request;
select *from product; 
-- alter table requestProduct drop constraint fk_requestProduct_request;
-- alter table requestProduct 
-- add constraint fk_requestProduct_request foreign key(id_RP_request) references request(idRequest);
-- desc requestProduct;






