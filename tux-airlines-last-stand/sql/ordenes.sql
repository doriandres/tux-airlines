create database OrdenesVuelos;
use OrdenesVuelos;

create user 'cajero'@'%' identified with mysql_native_password by '6rp$jnqvBAup';
grant all privileges on OrdenesVuelos.* to 'cajero'@'%';

drop table if exists Facturas;
drop table if exists Pagos;
drop table if exists Ordenes;

create table Ordenes(
	id int auto_increment,
    oferta_id int not null,
    cantidad int not null,
    fecha datetime not null,
    primary key (id)
);

drop table if exists TipoDePago;
create table TipoDePago(
	id int,
    nombre varchar(20) not null,
    primary key (id)
);

insert into TipoDePago values
(1, 'Efectivo'),
(2, 'Tarjeta de Crédito'),
(3, 'Transferencia');

create table Pagos(
	id int auto_increment,
    tipo_id int not null,
    fecha datetime not null,
    pago_id varchar(25) not null,
    primary key (id),
    foreign key (tipo_id) references TipoDePago(id)
);

create table Facturas(
	id int auto_increment,
    titular varchar(20) not null,
    identificacion varchar(15) not null,
    orden_id int not null,
    pago_id int not null,
    total decimal not null,
    fecha datetime not null,
    primary key (id),
    foreign key (orden_id) references Ordenes(id),
    foreign key (pago_id) references Pagos(id)
);

drop procedure if exists RegistrarCompra;
DELIMITER $$
create procedure RegistrarCompra(
	in _oferta_id int,
    in _cantidad int,
    in _tipo_de_pago_id int, 
    in _detalle_pago_id varchar(25),
    in _titular varchar(20),
    in _identificacion varchar(15),
    in _total decimal
)
begin
	declare _orden_id int;
    declare _pago_id int;
    declare _factura_id int;
	declare _abortar bool default 0;
    declare continue handler for SQLEXCEPTION set _abortar = 1;
    set autocommit = off;
	start transaction;
	insert into Ordenes (oferta_id, cantidad, fecha) 
		values (_oferta_id, _cantidad, NOW());
    select last_insert_id() into _orden_id;
	insert into Pagos (tipo_id, fecha, pago_id) 
		values (_tipo_de_pago_id, NOW(), _detalle_pago_id);
    select last_insert_id() into _pago_id;
    insert into Facturas (titular, identificacion, orden_id, pago_id, total, fecha)
		values (_titular, _identificacion, _orden_id, _pago_id, _total, NOW());
    select last_insert_id() into _factura_id;

    if _abortar then
		rollback;
        select 'Ocurrio un error no se pudo registrar la compra' as 'error';
	else
		commit;
        select * from DetalleFacturas where factura_id = _factura_id;
    end if;
end $$
DELIMITER ;

create view DetalleFacturas as select 
	f.id as factura_id,
    f.titular as titular,
    f.identificacion as identificacion,
    f.fecha as fecha,
    f.total as total,
    p.id as pago_id,
    p.pago_id as pago_ref_id,
    p.tipo_id as pago_tipo_id,
    tp.nombre as pago_tipo_nombre,
    o.id as orden_id,
    o.oferta_id as orden_oferta_id,
    o.cantidad as orden_cantidad
from Facturas f
join Pagos p on f.pago_id = p.id
join TipoDePago tp on p.tipo_id = tp.id
join Ordenes o on f.orden_id = o.id;

drop procedure if exists ObtenerFacturas;
DELIMITER $$
create procedure ObtenerFacturas()
begin
	select * from DetalleFacturas;
end $$
DELIMITER ;

