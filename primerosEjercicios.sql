-- Ej. 1

DELIMITER $$ 
DROP PROCEDURE IF EXISTS hola_mundo$$ 
CREATE PROCEDURE test.hola_mundo() 
BEGIN  
SELECT ‘hola mundo’; 
END$$ 

-- Ejemplo 2 
DELIMITER $$ 
DROP FUNCTION IF EXISTS fecha$$
CREATE PROCEDURE fecha () 
LANGUAGE SQL 
NOT DETERMINISTIC 
COMMENT "A PROCEDURE" 
SELECT CURDATE(), RAND() $$ 

-- Ejemplo 3 
DELIMITER $$ 
DROP FUNCTION IF EXISTS colores$$ 
CREATE FUNCTION colores(a CHAR) 
RETURNS VARCHAR(20)  
DETERMINISTIC NO SQL 
BEGIN 
DECLARE color VARCHAR(20); 
IF a="A" THEN 
SET color="azul"; 
ELSEIF a="V" THEN 
SET color="verde"; 
ELSEIF a="R" THEN 
SET color="rojo"; 
ELSE  
SET color = "Nada"; 
END IF; 
RETURN color; 
END$$

SELECT colores('A'), colores('R'),colores('V'), colores('J'); 
SELECT colores(valor); 

-- Ejemplo 4
DELIMITER $$ 
CREATE FUNCTION esimpar (numero int) 
RETURNS int 
DETERMINISTIC NO SQL 
BEGIN 
DECLARE impar int; 
IF MOD(numero,2)=0 THEN SET impar=0; 
else SET impar=1; 
END IF; 
RETURN impar; 
END;$$ 
SELECT esimpar(7);

-- Ejemplo 5
DELIMITER $$ 
DROP PROCEDURE IF EXISTS muestra_estado$$ 
CREATE PROCEDURE muestra_estado(in numero int) 
BEGIN 
IF (esimpar(numero)) THEN 
SELECT CONCAT(numero," esimpar"); 
ELSE 
SELECT CONCAT(numero," es par"); 
END IF; 
END;$$ 

CALL muestra_estado(117);

-- Ejemplo 6

DELIMITER $$ 
DROP PROCEDURE IF EXISTS proc1 $$ 
CREATE PROCEDURE proc1  
(IN parametro1 INT)  
BEGIN            
DECLARE variable1 INT;  
DECLARE variable2 INT;  
IF parametro1=17 THEN 
SET variable1=parametro1; 
SET variable2=10; 
ELSE 
SET variable1=10; 
SET variable2=30; 
END IF; 
INSERT INTO t (a,b) VALUES  
(variable1,variable2);  
END$$ 

DECLARE a,b INT DEFAULT 5; 

-- Alcance de las variables

DELIMITER $$ 
CREATE PROCEDURE proc5 () 
BEGIN 
DECLARE x1 char(6) DEFAULT "fuera"; 
BEGIN 
DECLARE x1 CHAR(6) DEFAULT "dentro"; 
SELECT x1; 
END; 
SELECT x1; 
END;$$ 

CALL proc5();

-- Ejercicios 
/* 2. Sobre el esquema de pruebas test crea un procedimiento para mostrar el año 
actual. */ 
DELIMITER $$

DROP PROCEDURE IF EXISTS Ej2$$
CREATE PROCEDURE Ej2()
BEGIN
    SELECT YEAR(CURDATE()) AS AñoActual;
END$$
DELIMITER;
CALL Ej2();

/* 3. Crea un procedimiento que muestre las tres primeras letras de una cadena 
pasada como parámetro en mayúsculas. Usa las funciones UPPER para pasar 
a mayúsculas (LOWER pasa a minúsculas) y LEFT(cadena,n) para quedarse 
con los n primeros caracteres de la izquierda. */ 
DELIMITER $$
DROP PROCEDURE IF EXISTS Ej3$$
CREATE PROCEDURE Ej3(IN cadena VARCHAR(255))
BEGIN
    SELECT UPPER(LEFT(cadena, 3)) AS TresPrimerasLetras;
END$$
DELIMITER;
CALL Ej3('cadenaEjemplo');

/* 4. Crea un procedimiento que muestre dos cadenas pasadas como parámetros 
concatenadas y en mayúsculas. Quiero que si una de las cadenas es nula, 
aparezca la otra. Que cuando las dos son nulas, que aparezca cadena vacía. */

DELIMITER $$
DROP PROCEDURE IF EXISTS Ej4$$
CREATE PROCEDURE Ej4(IN cadena1 VARCHAR(255), IN cadena2 VARCHAR(255))
BEGIN
    SELECT UPPER(CONCAT(IFNULL(cadena1, ''), IFNULL(cadena2, ''))) AS Cadena;
END$$
DELIMITER;
CALL Ej4('Hola', NULL);

/* 5. Crea una función que devuelva el valor de la hipotenusa de un triángulo a 
partir de los valores de sus lados. Busca las funciones que hacen referencia a 
la raíz cuadrada y a la elevación al cuadrado en el manual de MySQL (pow, 
sqrt). */

DELIMITER $$
DROP FUNCTION IF EXISTS Ej5$$
CREATE FUNCTION Ej5(lado1 DOUBLE, lado2 DOUBLE)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    RETURN SQRT(POW(lado1, 2) + POW(lado2, 2));
END$$
DELIMITER;
SELECT Ej5(3, 4) AS Hipotenusa;

-- Ejemplo 7  
DELIMITER $$ 
CREATE function nummayor(num int) 
returnsvarchar(5) 
DETERMINISTIC NO SQL 
BEGIN 
DECLARE textomayor varchar(5); 
If num>5 then 
Set textomayor="MAYOR"; 
ELSE 
Set textomayor="MENOR"; 
END IF; 
RETURN textomayor; 
END$$ 

-- Ejercicios 
/* 6. Crea una función que pida dos números y devuelva 1 si el primer número es 
divisible por el segundo y 0 en caso contrario. */
DELIMITER $$
CREATE FUNCTION Ej6(num1 INT, num2 INT)
RETURNS INT
DETERMINISTIC NO SQL 
BEGIN 
    RETURN IF(MOD(num1, num2) = 0, 1, 0);
END$$

DELIMITER;
SELECT Ej6(10, 2) AS Resultado; 

/* 7. Usa las estructuras condicionales para mostrar el día de la semana según un 
valor de entrada numérico, 1 para lunes, 2 martes…. Dentro de una función. */

DELIMITER $$
CREATE FUNCTION Ej7(num INT)
RETURNS VARCHAR(10)
DETERMINISTIC NO SQL
BEGIN
    DECLARE dia VARCHAR(10);
    SET dia = CASE
        WHEN num = 1 THEN 'Lunes'
        WHEN num = 2 THEN 'Martes'
        WHEN num = 3 THEN 'Miercoles'
        WHEN num = 4 THEN 'Jueves'
        WHEN num = 5 THEN 'Viernes'
        WHEN num = 6 THEN 'Sabado'
        WHEN num = 7 THEN 'Domingo'
        ELSE 'Error'
    END;
    RETURN dia;
END$$
DELIMITER;
SELECT Ej7(2) AS DiaSemana;

-- Ejemplo 8 
DELIMITER $$ 
CREATE PROCEDURE pcrear () 
BEGIN 
DECLARE cont INT; 
SET cont=1; 
BUCLE1: LOOP 
INSERT INTO NUEVA VALUES (cont); 
SET cont=cont+1; 
IF cont>10 THEN 
LEAVE BUCLE1; 
END IF; 
END LOOP BUCLE1; 
END;$$ 
CALL pcrear();

-- Ejemplo 9 
DELIMITER $$ 
DROP FUNCTION IF EXISTS numerosimpares$$
CREATE PROCEDURE `numerosimpares`() 
BEGIN 
DECLARE a int; 
SET a=0; 
REPEAT 
SET a=a+1; 
if MOD(a,2)<>0 THEN 
SELECT CONCAT(a," esimpar"); 
END IF; 
UNTIL a>=10 
END REPEAT;      
END;$$ 

-- Ejemplo 10 
DELIMITER $$ 
CREATE  PROCEDURE pares() 
BEGIN 
DECLARE I int; 
SET i=1; 
B3: WHILE i<=10 DO 
IF MOD(i,2)=0 THEN 
SELECT CONCAT("El número ",i," es par") as 
RESULTADO; 
END IF; 
SET i=i+1; 
END WHILE B3; 
END 
CALL pares();

DELIMITER $$ 
DROP PROCEDURE IF EXISTS pares$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pares`() 
BEGIN 
DECLARE i int; 
SET i=1; 
B3: WHILE i<=10 DO 
IF MOD(i,2)=0 THEN 
SELECT CONCAT("El número ",i," es par") as 
RESULTADO; 
insert into prueba values (concat("el numero ",i,"es 
par")); 
END IF; 
SET i=i+1; 
END WHILE B3; 
END 

-- Ejercicios 
/* 8. Sobre el esquema test, crea un procedimiento que muestre la suma de los 
primeros n números enteros, siendo n un parámetro de entrada. */
DELIMITER $$
DROP PROCEDURE IF EXISTS Ej8$$
CREATE PROCEDURE Ej8(IN n INT)
BEGIN
    DECLARE suma INT DEFAULT 0;
    DECLARE i INT DEFAULT 1;
    WHILE i <= n DO
        SET suma = suma + i;
        SET i = i + 1;
    END WHILE;
    SELECT suma AS SumaPrimerosN;
END$$
DELIMITER;
CALL Ej8(10);


/* 9. Haz un procedimiento que muestre la suma de los términos 1/n con n entre 
1 y m, es decir, ½+1/3+…+1/m, siendo m el parámetro de entrada. Ten en 
cuenta que m no puede ser 0, en cuyo caso, se deberá validar y mostrar el 
error correspondiente. */
