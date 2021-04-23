create database CatalogoVuelos;
use CatalogoVuelos;

create user 'microservice'@'%' identified with mysql_native_password by 'p$jnBAup6rqv';
grant all privileges on CatalogoVuelos.* to 'microservice'@'%';

drop view if exists OfertaDeVuelosDetallada;
drop table if exists OfertaDeVuelos;
drop table if exists TipoDeAsiento;
drop table if exists Vuelos;
drop table if exists Aerolineas;
drop table if exists Lugares;
drop table if exists Paises;

create table Paises(
  codigo varchar(3),
  nombre varchar(20) not null,
  bandera_url varchar(200) not null,
  primary key (codigo)
);

insert into Paises values
('CRC', 'Costa Rica', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Flag_of_Costa_Rica.svg/1200px-Flag_of_Costa_Rica.svg.png'),
('USA', 'Estados Unidos', 'https://upload.wikimedia.org/wikipedia/en/thumb/a/a4/Flag_of_the_United_States.svg/1200px-Flag_of_the_United_States.svg.png'),
('MEX', 'México', 'https://upload.wikimedia.org/wikipedia/commons/1/17/Flag_of_Mexico.png'),
('COL', 'Colombia', 'https://www.countryflags.com/wp-content/uploads/colombia-flag-png-large.png'),
('ARG', 'Argentina', 'https://cdn.britannica.com/69/5869-004-7D75CD05/Flag-Argentina.jpg'),
('VEN', 'Venezuela', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/Flag_of_Venezuela.svg/1024px-Flag_of_Venezuela.svg.png'),
('URY', 'Uruguay', 'https://www.countryflags.com/wp-content/uploads/uruguay-flag-png-large.png'),
('CHL', 'Chile', 'https://www.countryflags.com/wp-content/uploads/chile-flag-png-large.png'),
('CAN', 'Canadá', 'https://w7.pngwing.com/pngs/867/611/png-transparent-flag-of-canada-flag-of-canada-maple-leaf-great-canadian-flag-debate-canada-flag-love-flag-leaf.png'),
('PAN', 'Panamá', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Flag_of_Panama.svg/640px-Flag_of_Panama.svg.png'),
('PER', 'Perú', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/df/Flag_of_Peru_%28state%29.svg/1280px-Flag_of_Peru_%28state%29.svg.png'),
('BRA', 'Brasil', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Flag_of_Brazil.svg/1200px-Flag_of_Brazil.svg.png');


create table Lugares(
	id int,
    codigo_pais varchar(3) not null,
    nombre varchar(50) not null,
    foto_url varchar(200) not null,
    primary key (id),
    foreign key (codigo_pais) references Paises(codigo)
);

insert into Lugares values 
(1, 'CRC', 'San José', 'https://5241e237e8ca89f68ae3-93af0715f0ee41f3c44620e30f2e5f01.ssl.cf1.rackcdn.com/properties/photos/15734154647775893.png'),
(2, 'USA', 'New York', 'https://i.pinimg.com/originals/61/aa/b7/61aab7aca7e99b3c6d0b5f0afa37f3a0.jpg'),
(3, 'USA', 'San Francisco', 'https://ep01.epimg.net/elviajero/imagenes/2017/10/03/videos/1507052878_337128_1507052970_noticia_normal_recorte1.jpg'),
(4, 'USA', 'Austin', 'https://www.brodynt.com/wp-content/uploads/2019/03/iStock-902743010.jpg'),
(5, 'MEX', 'Ciudad de México', 'https://www.avianca.com/content/dam/avianca_new/destinos/mex/mx_mex_08_2880_1620.jpg'),
(6, 'COL', 'Bogotá', 'https://i2.wp.com/wheelchairtravel.org/wp-content/uploads/2020/01/bogota-v2020-header.jpg'),
(7, 'ARG', 'Buenos Aires', 'https://s3.amazonaws.com/arc-wordpress-client-uploads/infobae-wp/wp-content/uploads/2019/07/03201757/Ciudades-mas-caras-de-America-Latina-Buenos-Aires.jpg'),
(8, 'VEN', 'Caracas', 'https://havanatimesenespanol.org/wp-content/uploads/2020/06/11-6-caracas-view-e1591906873935.jpg'),
(9, 'URY', 'Montevideo', 'https://d500.epimg.net/cincodias/imagenes/2019/09/19/fortunas/1568914638_483661_1568915058_noticia_normal.jpg'),
(10, 'CHL', 'Santiago', 'https://southjets.com/wp-content/uploads/2019/04/Blog_Post_Chile.jpg'),
(11, 'CAN', 'Toronto', 'https://blog.rgsystem.com/medias/org-131/shared/article-blog-toronto-rgsystem.jpg'),
(12, 'PAN', 'Ciudad de Panamá', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/Ciudad_de_Panam%C3%A1_-_Panam%C3%A1.jpg/800px-Ciudad_de_Panam%C3%A1_-_Panam%C3%A1.jpg'),
(13, 'PER', 'Lima', 'https://www.globeguide.ca/wp-content/uploads/2014/02/Peru-Lima-Miraflores.jpg'),
(14, 'BRA', 'Sāo Paulo', 'https://www.dwih-saopaulo.org/files/2019/03/iStock-483342613_1600x907.jpg'),
(15, 'BRA', 'Recife', 'https://www.flytap.com/-/media/Flytap/new-tap-pages/destinations/south-america/brazil/recife/recife-og-image-1200x630.jpg');


create table Aerolineas(
	id int,
    nombre varchar(50) not null,
    telefono varchar(20) not null,
    correo varchar(50) not null,
    logo_url varchar(200) not null,
    primary key (id)
);

insert into Aerolineas values
(1, 'Avianca', '+506 2253 9232', 'contact@avianca.com', 'http://1000marcas.net/wp-content/uploads/2020/11/Avianca-logo.png'),
(2, 'Copa Airlines', '+506 2223 2672', 'contact@copaairlines.com', 'https://i.pinimg.com/originals/36/2e/f1/362ef1504c88832dafac7d03d05f419a.jpg'),
(3, 'Volaris', '+506 4002 7462', 'contact@volaris.com', 'https://www.transporte.mx/wp-content/uploads/2015/02/Volaris.jpg'),
(4, 'American Airlines', '+1 800-433-7300', 'contact@americanairlines.com', 'https://1000marcas.net/wp-content/uploads/2020/11/American-Airlines-logo.png'),
(5, 'United Airlines', '+1 1-800-864-8331', 'contact@unitedairlines.com', 'https://1000logos.net/wp-content/uploads/2017/06/United-logo.jpg');


create table Vuelos(
	id int,
    aerolinea_id int not null,
    origen_id int not null,
    destino_id int not null,
    primary key(id),
    foreign key (aerolinea_id) references Aerolineas(id),
    foreign key (origen_id) references Lugares(id),
    foreign key (destino_id) references Lugares(id)
);

insert into Vuelos values 
-- American Airlines
(1, 4, 11, 2), -- Toronto - New York
(2, 4, 2, 11), -- New York - Toronto
(3, 4, 4, 2),  -- Austin - New York
(4, 4, 2, 4),  -- New York - Austin
(5, 4, 4, 11), -- Austin - Toronto
(6, 4, 11, 4), -- Toronto - Austin
(7, 4, 3, 4),  -- San Francisco - Austin
(8, 4, 4, 3),  -- Austin - San Francisco
(9, 4, 2, 3),  -- New York - San Francisco
(10, 4, 3, 2), -- San Francisco - New York

-- United Airlines
(11, 5, 5, 4), -- Ciudad de México - Austin
(12, 5, 4, 5), -- Austin - Ciudad de México
(13, 5, 5, 2), -- Ciudad de México - New York
(14, 5, 2, 5), -- New York - Ciudad de México
(15, 5, 5, 3), -- Ciudad de México - San Francisco
(16, 5, 3, 5), -- San Francisco - Ciudad de México
(17, 5, 1, 3), -- San José - Austin
(18, 5, 3, 1), -- Austin - San José
(19, 5, 12, 3), -- Ciudad de Panamá - Austin
(20, 5, 3, 12), -- Austin - Ciudad de Panamá

-- Volaris Airlines
(21, 3, 1, 5), -- San José - Ciudad de México
(22, 3, 5, 1), -- Ciudad de México - San José
(23, 3, 1, 12), -- San José - Ciudad de Panamá
(24, 3, 12, 1), -- Ciudad de Panamá - San José
(25, 3, 1, 6), -- San José - Bogotá
(26, 3, 6, 1), -- Bogotá - San José
(27, 3, 1, 8), -- San José - Caracas
(28, 3, 8, 1), -- Caracas - San José
(29, 3, 1, 13), -- San José - Lima
(30, 3, 13, 1), -- Lima - San José
(31, 3, 12, 5), -- Ciudad de Panamá - Ciudad de México
(32, 3, 5, 12), -- Ciudad de México - Ciudad de Panamá
(33, 3, 12, 6), -- Ciudad de Panamá - Bogotá
(34, 3, 6, 12), -- Bogotá - Ciudad de Panamá
(35, 3, 12, 8), -- Ciudad de Panamá - Caracas
(36, 3, 8, 12), -- Caracas - Ciudad de Panamá
(37, 3, 12, 13), -- Ciudad de Panamá - Lima
(38, 3, 13, 12), -- Lima - Ciudad de Panamá
(39, 3, 6, 8), -- Bogotá - Caracas
(40, 3, 8, 6), -- Caracas - Bogotá 
(41, 3, 6, 13), -- Bogotá - Lima
(42, 3, 13, 6), -- Lima - Bogotá 

-- Copa Airlines
(43, 2, 5, 6), -- Ciudad de México - Bogotá
(44, 2, 6, 5), -- Bogotá - Ciudad de México
(45, 2, 5, 8), -- Ciudad de México - Caracas
(46, 2, 8, 5), -- Caracas - Ciudad de México
(47, 2, 5, 13), -- Ciudad de México - Lima
(48, 2, 13, 5), -- Lima - Ciudad de México
(49, 2, 12, 10), -- Ciudad de Panamá - Santiago
(50, 2, 10, 12), -- Santiago - Ciudad de Panamá
(51, 2, 6, 10), -- Bogotá - Santiago
(52, 2, 10, 6), -- Santiago - Bogotá 
(53, 2, 6, 7), -- Bogotá - Buenos Aires
(54, 2, 7, 6), -- Buenos Aires - Bogotá 
(55, 2, 6, 15), -- Bogotá - Recife
(56, 2, 15, 6), -- Recife - Bogotá 
(57, 2, 8, 9), -- Caracas - Montevideo
(58, 2, 9, 8), -- Montevideo - Caracas
(59, 2, 13, 10), -- Lima - Santiago
(60, 2, 10, 13), -- Santiago - Lima
(61, 2, 13, 9), -- Lima - Montevideo
(62, 2, 9, 13), -- Montevideo - Lima
(63, 2, 13, 14), -- Lima - Sāo Paulo
(64, 2, 14, 13), -- Sāo Paulo - Lima
(65, 2, 13, 7), -- Lima - Buenos Aires
(66, 2, 7, 13), -- Buenos Aires - Lima

-- Avianca
(69, 1, 7, 14), -- Buenos Aires - Saõ Paolo
(70, 1, 14, 7), -- Saõ Paolo - Buenos Aires
(71, 1, 7, 9), -- Buenos Aires - Montevideo
(72, 1, 9, 7), -- Montevideo - Buenos Aires
(73, 1, 7, 15), -- Buenos Aires - Recife
(74, 1, 15, 7), -- Recife - Buenos Aires
(75, 1, 9, 14), -- Montevideo - Saõ Paolo
(76, 1, 14, 9), -- Saõ Paolo - Montevideo
(77, 1, 9, 15), -- Montevideo - Recife
(78, 1, 15, 9), -- Recife - Montevideo
(79, 1, 10, 7), -- Santiago - Buenos Aires
(80, 1, 7, 10), -- Buenos Aires - Santiago
(81, 1, 10, 9), -- Santiago - Montevideo
(82, 1, 9, 10), -- Montevideo - Santiago
(83, 1, 10, 14), -- Santiago - Saõ Paolo
(84, 1, 14, 10), -- Saõ Paolo - Santiago
(85, 1, 14, 15), -- Saõ Paolo - Recife
(86, 1, 15, 14), -- Recife - Saõ Paolo
(87, 1, 8, 15), -- Caracas - Recife
(88, 1, 15, 8), -- Recife - Caracas
(89, 1, 8, 14), -- Caracas - Sāo Paulo
(90, 1, 14, 8); -- Sāo Paulo - Caracas


create table TipoDeAsiento(
	id int,
    nombre varchar(20),
    primary key (id)
);

insert into TipoDeAsiento values 
(1, 'Primera Clase'),
(2, 'Clase Ejecutiva'),
(3, 'Clase Turística');


create table OfertaDeVuelos(
	id int auto_increment,
    vuelo_id int,
    tipo_de_asiento_id int,
    disponible int not null,
    bloqueados int not null,
    precio decimal not null,
    fecha_hora_salida datetime not null,
    fecha_hora_llegada datetime not null,
    primary key (id),
    foreign key (vuelo_id) references Vuelos(id),
    foreign key (tipo_de_asiento_id) references TipoDeAsiento(id)
);

 -- EL SIGUIENTE CODIGO ES PARA GENERAR OFERTAS DE VUELOS
DELIMITER $$
drop procedure if exists generar_oferta_de_vuelos $$
create procedure generar_oferta_de_vuelos () 
    begin
		declare _completado int default 0;
        declare _vuelo_id int;
        declare _aerolinea_id int;
		declare _vuelos cursor for select id, aerolinea_id from Vuelos;
		declare continue handler for not found set _completado = 1;
		open _vuelos;
		repeat
		   fetch _vuelos into _vuelo_id, _aerolinea_id;
           if _aerolinea_id = 1 then
					insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 1, 30, 0, 600, '2021-04-26 8:00:00', '2021-04-26 11:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 2, 40, 0, 600, '2021-04-26 8:00:00', '2021-04-26 11:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 3, 60, 0, 600, '2021-04-26 8:00:00', '2021-04-26 11:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 1, 30, 0, 600, '2021-04-26 12:00:00', '2021-04-26 15:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 2, 40, 0, 600, '2021-04-26 12:00:00', '2021-04-26 15:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 3, 60, 0, 600, '2021-04-26 12:00:00', '2021-04-26 15:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 1, 30, 0, 600, '2021-04-26 17:00:00', '2021-04-26 20:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 2, 40, 0, 600, '2021-04-26 17:00:00', '2021-04-26 20:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 3, 60, 0, 600, '2021-04-26 17:00:00', '2021-04-26 20:00:00');
            elseif _aerolinea_id = 2 then
					insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 1, 40, 0, 580, '2021-04-26 8:30:00', '2021-04-26 11:30:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 2, 60, 0, 580, '2021-04-26 8:30:00', '2021-04-26 11:30:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 3, 90, 0, 580, '2021-04-26 8:30:00', '2021-04-26 11:30:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 1, 40, 0, 580, '2021-04-26 12:30:00', '2021-04-26 15:30:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 2, 60, 0, 580, '2021-04-26 12:30:00', '2021-04-26 15:30:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 3, 90, 0, 580, '2021-04-26 12:30:00', '2021-04-26 15:30:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 1, 40, 0, 580, '2021-04-26 17:30:00', '2021-04-26 20:30:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 2, 60, 0, 580, '2021-04-26 17:30:00', '2021-04-26 20:30:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 3, 90, 0, 580, '2021-04-26 17:30:00', '2021-04-26 20:30:00');
            elseif _aerolinea_id = 3 then
					insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 1, 20, 0, 460, '2021-04-26 8:30:00', '2021-04-26 10:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 2, 45, 0, 460, '2021-04-26 8:30:00', '2021-04-26 10:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 3, 95, 0, 460, '2021-04-26 8:30:00', '2021-04-26 10:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 1, 20, 0, 460, '2021-04-26 13:00:00', '2021-04-26 14:30:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 2, 45, 0, 460, '2021-04-26 13:00:00', '2021-04-26 14:30:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 3, 95, 0, 460, '2021-04-26 13:00:00', '2021-04-26 14:30:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 1, 20, 0, 460, '2021-04-26 16:00:00', '2021-04-26 17:30:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 2, 45, 0, 460, '2021-04-26 16:00:00', '2021-04-26 17:30:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 3, 95, 0, 460, '2021-04-26 16:00:00', '2021-04-26 17:30:00');
            elseif _aerolinea_id = 4 then
					insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 1, 40, 0, 610, '2021-04-26 8:00:00', '2021-04-26 11:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 2, 50, 0, 610, '2021-04-26 8:00:00', '2021-04-26 11:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 3, 80, 0, 610, '2021-04-26 8:00:00', '2021-04-26 11:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 1, 40, 0, 610, '2021-04-26 12:00:00', '2021-04-26 15:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 2, 50, 0, 610, '2021-04-26 12:00:00', '2021-04-26 15:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 3, 80, 0, 610, '2021-04-26 12:00:00', '2021-04-26 15:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 1, 40, 0, 610, '2021-04-26 17:00:00', '2021-04-26 20:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 2, 50, 0, 610, '2021-04-26 17:00:00', '2021-04-26 20:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 3, 80, 0, 610, '2021-04-26 17:00:00', '2021-04-26 20:00:00');
            elseif _aerolinea_id = 5 then
					insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 1, 30, 0, 315, '2021-04-26 8:00:00', '2021-04-26 10:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 2, 40, 0, 315, '2021-04-26 8:00:00', '2021-04-26 10:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 3, 60, 0, 315, '2021-04-26 8:00:00', '2021-04-26 10:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 1, 30, 0, 315, '2021-04-26 12:00:00', '2021-04-26 14:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 2, 40, 0, 315, '2021-04-26 12:00:00', '2021-04-26 14:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 3, 60, 0, 315, '2021-04-26 12:00:00', '2021-04-26 14:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 1, 30, 0, 315, '2021-04-26 18:00:00', '2021-04-26 20:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 2, 40, 0, 315, '2021-04-26 18:00:00', '2021-04-26 20:00:00');
                    insert into OfertaDeVuelos (vuelo_id, tipo_de_asiento_id, disponible, bloqueados, precio, fecha_hora_salida, fecha_hora_llegada) 
                    values (_vuelo_id, 3, 60, 0, 315, '2021-04-26 18:00:00', '2021-04-26 20:00:00');
            end if;
       until _completado end repeat;
	   close _vuelos;
    end $$
DELIMITER ;
call generar_oferta_de_vuelos();
-- FIN DEL CODIGO ES PARA GENERAR OFERTAS DE VUELOS

create view OfertaDeVuelosDetallada as
select
	ov.id as oferta_id,
    ov.vuelo_id as vuelo_id,
    ov.disponible as oferta_disponible,
    ov.bloqueados as oferta_bloqueados,
    ov.precio as oferta_precio,
    ov.fecha_hora_salida as oferta_fecha_hora_salida,
    ov.fecha_hora_llegada as oferta_fecha_hora_llegada,
    ta.nombre as tipo_de_asiento,
    a.id as aerolinea_id,
    a.nombre as aerolinea_nombre,
    a.logo_url as aerolinea_logo_url,
    po.codigo as origen_pais_codigo,
    po.nombre as origen_pais_nombre,
    po.bandera_url as origen_pais_bandera_url,
	lo.id as origen_lugar_id,
    lo.nombre as origen_lugar_nombre,
    lo.foto_url as origen_lugar_foto_url,
    pd.codigo as destino_pais_codigo,
    pd.nombre as destino_pais_nombre,
    pd.bandera_url as destino_pais_bandera_url,
    ld.id as destino_lugar_id,
    ld.nombre as destino_lugar_nombre,
    ld.foto_url as destino_lugar_foto_url
from OfertaDeVuelos as ov
join Vuelos as v
on ov.vuelo_id = v.id
join Aerolineas as a
on v.aerolinea_id = a.id
join TipoDeAsiento as ta
on ov.tipo_de_asiento_id = ta.id
join Lugares as lo
on v.origen_id = lo.id
join Lugares as ld
on v.destino_id = ld.id
join Paises as po
on lo.codigo_pais = po.codigo
join Paises as pd
on ld.codigo_pais = pd.codigo;

drop procedure if exists FiltraOfertasDeVuelos;
DELIMITER $$
create procedure FiltraOfertasDeVuelos(
	in pagina_numero int, 
    in pagina_cantidad int,
    in busqueda_origen varchar(50),
    in busqueda_destino varchar(50),
    in aerolinea_nombre varchar(50)
)
begin
	declare offset_value int;
    set offset_value = (pagina_numero - 1) * pagina_cantidad;    
	select * from OfertaDeVuelosDetallada
    where
		lower(origen_lugar_nombre) like concat('%', lower(busqueda_origen), '%') and
		lower(destino_lugar_nombre) like concat('%', lower(busqueda_destino), '%') and
        lower(aerolinea_nombre) like concat('%', lower(aerolinea_nombre), '%')
    order by
		oferta_fecha_hora_salida asc, 
        oferta_id desc
    limit pagina_cantidad 
    offset offset_value;
end $$
DELIMITER ;

drop procedure if exists PaginasFiltraOfertasDeVuelos;
DELIMITER $$
create procedure PaginasFiltraOfertasDeVuelos(
    in pagina_cantidad int,
	in busqueda_origen varchar(50),
    in busqueda_destino varchar(50),
    in aerolinea_nombre varchar(50)
)
begin
	declare paginas_disponibles double;
    declare cantidad_de_elementos int;
	select count(*) into cantidad_de_elementos from OfertaDeVuelosDetallada
    where lower(origen_lugar_nombre) like concat('%', lower(busqueda_origen), '%') and lower(destino_lugar_nombre) like concat('%', lower(busqueda_destino), '%') and lower(aerolinea_nombre) like concat('%', lower(aerolinea_nombre), '%');
    set paginas_disponibles = cantidad_de_elementos / pagina_cantidad;
    select ceil(paginas_disponibles) as paginas_disponibles, cantidad_de_elementos;
end $$
DELIMITER ;

drop procedure if exists ObtenerDetalleOferta;
DELIMITER $$
create procedure ObtenerDetalleOferta(
    in _oferta_id int
)
begin
	select * from OfertaDeVuelosDetallada
    where oferta_id = _oferta_id;
end $$
DELIMITER ;

drop procedure if exists ObtenerPrecioOferta;
DELIMITER $$
create procedure ObtenerPrecioOferta(in oferta_id int)
begin
    declare _precio decimal;
    select precio into _precio from OfertaDeVuelos where id = oferta_id;
    if _precio is null then
		select 'No se encontró la oferta solicitada' as error;
    else
		select _precio as precio;
    end if;
end $$
DELIMITER ;

drop procedure if exists BloquearOferta;
DELIMITER $$
create procedure BloquearOferta(in oferta_id int, in cantidad int)
begin
	declare _bloqueados int;
    declare _disponible int;
    select bloqueados, disponible into _bloqueados, _disponible from OfertaDeVuelos where id = oferta_id;
    if _bloqueados is null then
		select 'No se encontró la oferta solicitada' as error;
    elseif _disponible = 0 or _disponible < cantidad then
		select 'No hay suficientes campos disponibles' as error;
    else
		update OfertaDeVuelos
        set 
			bloqueados = _bloqueados + cantidad,
			disponible = _disponible - cantidad
        where id = oferta_id;
        select id, bloqueados, disponible from OfertaDeVuelos where id = oferta_id;
    end if;
end $$
DELIMITER ;

drop procedure if exists DesbloquearOferta;
DELIMITER $$
create procedure DesbloquearOferta(in oferta_id int, in cantidad int)
begin
	declare _bloqueados int;
    declare _disponible int;
    select bloqueados, disponible into _bloqueados, _disponible from OfertaDeVuelos where id = oferta_id;
    if _bloqueados is null then
		select 'No se encontró la oferta solicitada' as error;
    elseif _bloqueados = 0 or _bloqueados < cantidad then
		select 'No hay suficientes campos' as error;
    else
		update OfertaDeVuelos
        set 
			bloqueados = _bloqueados - cantidad,
			disponible = _disponible + cantidad
        where id = oferta_id;
        select id, bloqueados, disponible from OfertaDeVuelos where id = oferta_id;
    end if;
end $$
DELIMITER ;

drop procedure if exists DisminuirOferta;
DELIMITER $$
create procedure DisminuirOferta(in oferta_id int, in cantidad int)
begin
	declare _bloqueados int;
    declare _disponible int;
    select bloqueados, disponible into _bloqueados, _disponible from OfertaDeVuelos where id = oferta_id;
    if _bloqueados is null then
		select 'No se encontró la oferta solicitada' as error;
    elseif _bloqueados = 0 or _bloqueados < cantidad then
		select 'No hay suficientes campos reservados' as error;
    else
		update OfertaDeVuelos
        set 
			bloqueados = _bloqueados - cantidad
        where id = oferta_id;
        select id, bloqueados, disponible from OfertaDeVuelos where id = oferta_id;
    end if;
end $$
DELIMITER ;
