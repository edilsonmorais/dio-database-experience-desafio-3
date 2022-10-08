-- criação do banco de dados para o cenário de E-commerce
create database ecommerce;
use ecommerce;

-- criar tabela cliente
create table clients(
	idCliente int auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(30),
    constraint unique_cpf_client unique(CPF)    
);
desc clients;

alter table clients auto_increment=1;

-- inserindo dados
insert into clients (Fname, Minit, Lname, CPF, Address)
	values('Maria','M', 'Silva', 123456789, 'R Sil 29 Cara Cid das flores'),
		  ('Matheus','O', 'Pimentel', 116656789, 'R S 29, Car Cid das flores'),
          ('Ricardo','F', 'Silva', 659856789, 'Av Al 55, Cent Cid das flores'),
          ('Julia','S', 'Franca', 445856789, 'R Pr 55, Tara Cid das flores'),
          ('Roberta','G', 'Assis', 9873456789, 'R Ar 9, Caat Cid das flores'),
          ('Isabela','M', 'Cruz', 655456789, 'Av Kel 90, Ce - Cid das flores');


-- criar tabela produt
-- size = dimensao do produto
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(10) not null,
    classification_kids bool default false,
    category enum("Eletronico","Vestimenta","Brinquedos","Alimentos") not null,
    CPF char(11) not null,
    avaliacao float default 0,
    size varchar(10)      
);

-- inserindo dados na tabela produto
insert into product(Pname, classification_kids, category, CPF, avaliacao, size) values
	('Fon ouvido', false, 'Eletronico','12345678900','4',null),
    ('Barbie El', true, 'Brinquedos','12345678900','3',null),
    ('Bod Cartes', true, 'Vestimenta','12345678900','5',null),
    ('Pippos', false, 'Alimentos','12345678900','4',null),
    ('Sofá retrá', false, 'Eletronico','3','12345678900','3x57x80');
    
select * from clients;
select * from product;

-- para ser continuado ao desafio: termine de implementar a tabela e crie a conexao com as tabelas necessárias
-- além disso, reflita essa modificação no diagrama de esquema relacional
-- criar constraint relacionadas ao pagamento

-- create table payments(
--	idClient int,
--  idPayment int,
--    typePayment enum("Boleto","Cartão","Dois cartções"),
--    limitAvailable float,
--    paygamentCash bool default false,
--    primary key(idCliente, idPayment)
-- );

-- criar a tabela pedido
drop table orders;
create table orders(
	idOrder int auto_increment primary key,
	idOrderClient int,
    orderStatus enum("Cancelado","Confirmado","Em processamento") default "Em processamento",
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash boolean default false,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idCliente)
);
desc orders;

-- inserindo dados na tabela pedido
insert into orders(idOrderClient,orderStatus,orderDescription,sendValue,paymentCash) values
	(1, null, 'compra via aplicativo',null,1),
    (2, null, 'compra via aplicativo',50,0),
    (3, 'confirmado', null,null,1),
    (4, null, 'compra via web site',150,0);
    
select * from orders;

-- criar tabela estoque
create table productStorage(
	idProdStorage int auto_increment primary key,
	storageLocation varchar(255),    
    quantity int default 0   
);

-- criar tabela fornecedor
create table supplier (
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);
desc supplier;

-- criar tabela vendedor
create table seller (
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(11),
    localtion varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

-- tabela produto vendedor
create table productSeller (
	idPseller int,
    idProduct int,
    prodQuantity int default 1,
    primary key(idPseller, idProduct),
    constraint fk_product_seller foreign key(idPseller) references seller(idSeller),
    constraint fk_product_product foreign key(idProduct) references product(idProduct)    
);
desc productSeller;

create table productOrder (
	idPOproduct int,
    idPOorder int,
    prodQuantity int default 1,
    poStatus enum("Disponível", "Sem estoque") default "Disponível",
    primary key(idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key(idPOproduct) references product(idProduct),
    constraint fk_productorder_product foreign key(idPOorder) references orders(idOrder)    
);
desc productOrder;


-- inserindo dados
insert into productOrder(idPOproduct,idPOorder,prodQuantity,poStatus) values
	(1,5,2,null),
    (2,5,1,null),
    (3,6,1,null);

create table storageLocation (
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,    
    primary key(idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key(idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key(idLstorage) references productStorage(idProdStorage)    
);

create table productSupplier (
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key(idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key(idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key(idPsProduct) references product(idProduct)
);
desc productSupplier;

use information_schema;
show tables;

desc table_constraints;
desc referential_constraints;

-- ver todas as constraints
select * from referential_constraints where constraint_schema = 'ecommerce';
