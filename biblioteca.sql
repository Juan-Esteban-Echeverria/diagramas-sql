-- 1. Crear el modelo en una base de datos llamada biblioteca, considerando las tablas definidas y sus atributos.

    CREATE DATABASE biblioteca
        WITH 
        OWNER = postgres
        ENCODING = 'UTF8'
        CONNECTION LIMIT = -1;


    CREATE TABLE public.socios
    (
        rut character varying(10),
        nombre character varying(25),
        apellido character varying(25),
        direccion character varying(30),
        telefono integer,
        PRIMARY KEY (rut)
    );


    CREATE TABLE public.autor
    (
        codigo_autor integer,
        nombre_autor character varying(25),
        apellido_autor character varying(25),
        nacimiento date,
        muerte date,
        tipo_autor character varying(10),
        PRIMARY KEY (codigo_autor)
    );


    CREATE TABLE public.libros
    (
        isbn character varying(15),
        titulo character varying(30),
        paginas integer,
        PRIMARY KEY (isbn)
    );


    CREATE TABLE public.libros_autor
    (
        isbn character varying(15),
        codigo_autor integer,
        CONSTRAINT isbn FOREIGN KEY (isbn)
            REFERENCES public.libros (isbn) MATCH SIMPLE
            ON UPDATE NO ACTION
            ON DELETE NO ACTION
            NOT VALID,
        CONSTRAINT codigo_autor FOREIGN KEY (codigo_autor)
            REFERENCES public.autor (codigo_autor) MATCH SIMPLE
            ON UPDATE NO ACTION
            ON DELETE NO ACTION
            NOT VALID
    );


    CREATE TABLE public.historial_de_prestamos
    (
        prestamo_id serial,
        socio character varying(25),
        libro character varying(25),
        fecha_del_prestamo date,
        fecha_de_la_devolucion date,
        PRIMARY KEY (prestamo_id),
        CONSTRAINT socio FOREIGN KEY (socio)
            REFERENCES public.socios (rut) MATCH SIMPLE
            ON UPDATE NO ACTION
            ON DELETE NO ACTION
            NOT VALID,
        CONSTRAINT libro FOREIGN KEY (libro)
            REFERENCES public.libros (isbn) MATCH SIMPLE
            ON UPDATE NO ACTION
            ON DELETE NO ACTION
            NOT VALID
    );

--------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. Se deben insertar los registros en las tablas correspondientes

    INSERT INTO public.socios(
        rut, nombre, apellido, direccion, telefono)
        VALUES 
        ('1111111-1', 'JUAN', 'SOTO', 'AVENIDA 1, SANTIAGO', 911111111),
        ('2222222-2', 'ANA', 'PÉREZ', 'PASAJE 2, SANTIAGO', 922222222),
        ('3333333-3', 'SANDRA', 'AGUILAR', 'AVENIDA 2, SANTIAGO', 933333333),
        ('4444444-4', 'ESTEBAN', 'JEREZ', 'AVENIDA 3, SANTIAGO', 944444444),
        ('5555555-5', 'SILVANA', 'MUÑOZ', 'PASAJE 3, SANTIAGO', 955555555);


    INSERT INTO public.libros(
        isbn, titulo, paginas)
        VALUES 
        ('111-1111111-111', 'CUENTOS DE TERROR', 344),
        ('222-2222222-222', 'POESÍAS CONTEMPORANEAS', 167),
        ('333-3333333-333', 'HISTORIA DE ASIA', 511),
        ('444-4444444-444', 'MANUAL DE MECÁNICA', 298);


    INSERT INTO public.autor(
        codigo_autor, nombre_autor, apellido_autor, nacimiento, muerte, tipo_autor)
        VALUES 
        (1, 'ANDRÉS', 'ULLOA', '01-01-1982', null, 'PRINCIPAL'),
        (2, 'SERGIO', 'MARDONES', '01-01-1950', '01-01-2012', 'PRINCIPAL'),
        (3, 'JOSE', 'SALGADO', '01-01-1968', '01-01-2020', 'PRINCIPAL'),
        (4, 'ANA', 'SALGADO', '01-01-1972', null, 'COAUTOR'),
        (5, 'MARTIN', 'PORTA', '01-01-1976', null, 'PRINCIPAL');


    INSERT INTO public.libros_autor(
        isbn, codigo_autor)
        VALUES 
        ('111-1111111-111', 3),
        ('111-1111111-111', 4),
        ('222-2222222-222', 1),
        ('333-3333333-333', 2),
        ('444-4444444-444', 5);


    INSERT INTO public.historial_de_prestamos(
        socio, libro, fecha_del_prestamo, fecha_de_la_devolucion)
        VALUES 
        ('1111111-1', '111-1111111-111', '20-01-2020', '27-01-2020'),
        ('5555555-5', '222-2222222-222', '20-01-2020', '30-01-2020'),
        ('3333333-3', '333-3333333-333', '22-01-2020', '30-01-2020'),
        ('4444444-4', '444-4444444-444', '23-01-2020', '30-01-2020'),
        ('2222222-2', '111-1111111-111', '27-01-2020', '04-02-2020'),
        ('1111111-1', '444-4444444-444', '31-01-2020', '12-02-2020'),
        ('3333333-3', '222-2222222-222', '31-01-2020', '12-02-2020');

--------------------------------------------------------------------------------------------------------------------------------------------------

-- 3. Realizar las siguientes consultas:

-- a. Mostrar todos los libros que posean menos de 300 páginas.
    select * from libros where paginas < 300;

-- b. Mostrar todos los autores que hayan nacido después del 01-01-1970.
    select * from autor where nacimiento > '01-01-1970';

-- c. ¿Cuál es el libro más solicitado? 
    SELECT titulo, COUNT( libro ) AS numero_solicitues
    FROM historial_de_prestamos
    INNER JOIN libros
        ON libro = isbn
        GROUP BY titulo
    ORDER BY numero_solicitues DESC;

-- d. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto debería pagar cada usuario que entregue el préstamo después de 7 días.
    SELECT nombre,apellido,(fecha_de_la_devolucion - fecha_del_prestamo - 7) * 100 as multa
    FROM historial_de_prestamos
        INNER JOIN socios
            ON socio = rut;



