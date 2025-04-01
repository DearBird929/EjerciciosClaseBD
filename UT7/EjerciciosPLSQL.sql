DELIMITER $$
DROP PROCEDURE IF EXISTS fecha$$
CREATE PROCEDURE fecha ()
LANGUAGE SQL
NOT DETERMINISTIC
COMMENT "Esta función da la fecha del día y un número aleatorio."
BEGIN
	SELECT CURDATE(), RAND()*10;
END$$
DELIMITER ;
CALL fecha();


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

SELECT colores('A'), colores('R'),colores('V'), colores('J')$$

CREATE FUNCTION esimpar (numero int)
RETURNS int
DETERMINISTIC NO SQL
BEGIN
DECLARE impar int;
    IF MOD(numero,2)=0 THEN SET impar=0;
	else SET impar=1;
    END IF;
RETURN impar;
END$$

SELECT esimpar(5), esimpar(10), esimpar(123456)$$
SELECT Name, Population, esimpar(Population) as EsImpar
FROM City
WHERE CountryCode = 'SPA'$$

CREATE FUNCTION esimparV2 (numero int)
RETURNS VARCHAR(5)
DETERMINISTIC NO SQL
BEGIN
	DECLARE impar VARCHAR(5);
	IF MOD(numero,2)=0 THEN SET impar="PAR";
	ELSE SET impar="IMPAR";
	END IF;
RETURN impar;
END$$
SELECT esimparV2(1234), esimparV2(54321)$$

DROP FUNCTION IF EXISTS esimparV3$$
CREATE FUNCTION esimparV3 (numero int)
RETURNS BOOLEAN
DETERMINISTIC NO SQL
BEGIN
	DECLARE impar BOOLEAN;
	IF MOD(numero,2)=0 THEN SET impar=false;
	ELSE SET impar=true;
	END IF;
RETURN impar;
END$$
SELECT esimparV3(1234), esimparV3(54321)$$


DROP PROCEDURE IF EXISTS muestra_estado$$
CREATE PROCEDURE muestra_estado(in numero int)
DETERMINISTIC
BEGIN
	IF (esimpar(numero)) THEN
		SELECT CONCAT(numero," es impar") as Resultado;
	ELSE
		SELECT CONCAT(numero," es par") as Resultado;
	END IF;
END$$
CALL muestra_estado(34)$$
CALL muestra_estado(45)$$

DELIMITER ;
CREATE DATABASE test;
USE test;
CREATE TABLE t (
	a INT,
	b INT
);

DELIMITER $$
DROP PROCEDURE IF EXISTS proc1 $$
CREATE PROCEDURE proc1 (IN parametro1 INT) 
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
	INSERT INTO t (a,b) VALUES (variable1,variable2); 
END$$
CALL proc1(18)$$
CALL proc1(17)$$
CALL proc1(25)$$
CALL proc1(32)$$
SELECT * FROM t;

DELIMITER $$
CREATE PROCEDURE proc3 (OUT p INT) 
BEGIN
	SET p=-5;
END$$


CALL proc3(@x)$$

SELECT @patata, esimpar(@x), esimpar(@patata)$$

DELIMITER $$
CREATE PROCEDURE proc3b (OUT p INT, IN x INT) 
BEGIN
	SET p=x-5;
END$$

CALL proc3b(@pepe, 45)$$
SELECT @pepe$$
CALL proc3b(@pepe, 10)$$
SELECT @pepe$$
CALL proc3b(@pepe, 33)$$
SELECT @pepe$$


DELIMITER $$
CREATE PROCEDURE proc4(INOUT p INT) 
BEGIN
	SET p=p-5;
END$$

DELIMITER ;
SET @heidi = 67;
CALL proc4(@heidi);
CALL proc4(@heidi);
CALL proc4(@heidi);

SELECT @heidi;


DELIMITER $$
CREATE PROCEDURE proc5()
BEGIN
	DECLARE x1 char(6) DEFAULT "fuera";
	BEGIN
		DECLARE x1 CHAR(6) DEFAULT "dentro";
		SELECT x1;
	END;
	SELECT x1;
END$$
CALL proc5();

DELIMITER $$
DROP PROCEDURE IF EXISTS año_actual$$
CREATE PROCEDURE año_actual()
BEGIN
	DECLARE año INT;
    SET año = year(current_date());
    SELECT año;
    SELECT left(current_date(),4) as usandoLeft;
END$$
CALL año_actual()$$

DROP PROCEDURE IF EXISTS tresprimeras$$
CREATE PROCEDURE tresprimeras (IN cadena VARCHAR(100))
BEGIN
	SELECT UCASE(LEFT(cadena,3));
    SELECT LEFT(UCASE(cadena),3); -- menos eficiente
END$$
CALL tresprimeras("Pues no luuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuo se")$$

DROP PROCEDURE IF EXISTS unirymayusculas$$
CREATE PROCEDURE unirymayusculas (IN c1 VARCHAR(100), IN c2 VARCHAR(100))
BEGIN
	IF c1 is null THEN
		SET c1 = "";
	END IF;
    IF c2 IS NULL THEN
		SET c2 = "";
	END IF;    
    SELECT UPPER(CONCAT(c1,c2));
END$$
CALL unirymayusculas("sergio","yasin")$$
CALL unirymayusculas(null,"marian")$$
CALL unirymayusculas("adrián",null)$$
CALL unirymayusculas(null,null)$$

CREATE FUNCTION hipotenusa(cateto1 FLOAT, cateto2 FLOAT)
RETURNS FLOAT
DETERMINISTIC NO SQL
BEGIN
	DECLARE hipotenusa FLOAT;
    SET hipotenusa = SQRT(POW(cateto1,2)+POW(cateto2,2));
    RETURN hipotenusa;    
END$$
SELECT hipotenusa(3,4), hipotenusa(6,8), hipotenusa(10,12)$$

DELIMITER $$
CREATE function nummayor(num int)
returns varchar(5)
deterministic NO SQL
BEGIN
	DECLARE textomayor varchar(5);
	If num>5 then
		Set textomayor="MAYOR";
    ELSE
		Set textomayor="MENOR";
    END IF;
	RETURN textomayor;
END$$
SELECT nummayor(5),nummayor(0),nummayor(15)$$

DROP FUNCTION esDivisible$$
CREATE FUNCTION esDivisible(num1 INT, num2 INT)
RETURNS INT
DETERMINISTIC NO SQL
BEGIN 
	DECLARE resultado INT;
	IF num1%num2=0 THEN 
		SET resultado = 1;
	ELSE
		SET resultado = 0;
    END IF;
	RETURN resultado;
END$$


DROP FUNCTION diaSemana$$
CREATE FUNCTION diaSemana (dia INT)
RETURNS VARCHAR(9)
DETERMINISTIC NO SQL
BEGIN
	DECLARE resultado VARCHAR(9);
    CASE dia
    WHEN 1 THEN
		SET resultado = "lunes";
    WHEN 2 THEN
		SET resultado = "martes";
    WHEN 3 THEN
		SET resultado = "miércoles";
    WHEN 4 THEN
		SET resultado = "jueves";
	WHEN 5 THEN
		SET resultado = "viernes";
	WHEN 6 THEN
		SET resultado = "sábado";
	WHEN 7 THEN
		SET resultado = "domingo";
	ELSE 
		SET resultado = "error";
    END CASE;
	RETURN resultado;
END$$
SELECT diaSemana(1),diaSemana(3),diaSemana(4),diaSemana(7),diaSemana(23)$$

CREATE TABLE NUEVA (
 cont int
)$$

DROP PROCEDURE IF EXISTS pcrear$$
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
CALL pcrear()$$

DROP PROCEDURE numerosimpares$$
CREATE PROCEDURE numerosimpares(in limite int, inout contador int)
BEGIN
    DECLARE a int;
    SET a=0;
    -- SET contador = 0;
	REPEAT
		SET a=a+1;
		IF a%2 != 0 THEN
			SELECT CONCAT(a," es impar");
            SET contador = contador + 1;
		END IF;
	 UNTIL a>=limite
	 END REPEAT;     
END;$$

SET @c = 0$$
CALL numerosimpares(7,@c)$$
CALL numerosimpares(3,@c)$$
CALL numerosimpares(5,@c)$$
SELECT @c;
-- MODIFICA LA FUNCIÓN PARA QUE SE MUESTREN LOS IMPARES HASTA EL 
-- NÚMERO QUE TÚ QUIERAS. TAMBIÉN QUIERO OBTENER EL NÚMERO DE
-- IMPARES QUE SE HAN DETECTADO COMO SALIDA DEL PROCEDIMIENTO.




