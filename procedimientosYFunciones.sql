-- Ejercicios sobre procedimientos y funciones

-- 1. Crear una función que calcule el total de puntos en un partido tomando como entrada el resultado en formato  ‘xxx-xxx’.
DELIMITER $$

DROP FUNCTION IF EXISTS Ej1TotalPuntos$$
CREATE FUNCTION Ej1TotalPuntos(resultado VARCHAR(7))
RETURNS INT
DETERMINISTIC NO SQL
BEGIN
    DECLARE puntos1 INT; -- Para declarar variables locales
    DECLARE puntos2 INT;
    SET puntos1 = CAST(SUBSTRING_INDEX(resultado, '-', 1) AS UNSIGNED); -- El cast nos permite convertir un valor de un tipo a otro
    SET puntos2 = CAST(SUBSTRING_INDEX(resultado, '-', -1) AS UNSIGNED); -- Mientras substring_index nos permite extraer una parte de una cadena para dividirla
    -- AS UNSIGNED se utiliza junto con CAST para convertir un valor a un numero sin signo, es decir, que no puede ser decimal o negativo
    -- En definitiva, lo que hace esto es: 1 con el substring coge lo que hay antes o despues del signo, cast convierte ese valor a un numero sin signo
    RETURN puntos1 + puntos2;
END$$

DELIMITER ;
SELECT Ej1TotalPuntos('100-98') AS Ej1TotalPuntos; -- Este ejercicio se me complicó y me ayudó la IA

-- 2. Crear una función que devuelva el mayor de 3 números pasados como parámetros.
DELIMITER $$

DROP FUNCTION IF EXISTS Ej2MayorDeTres$$
CREATE FUNCTION Ej2MayorDeTres(num1 INT, num2 INT, num3 INT)
RETURNS INT
DETERMINISTIC NO SQL
BEGIN
    RETURN GREATEST(num1, num2, num3); -- Devuelve el valor mas grande
END$$

DELIMITER ;
SELECT Ej2MayorDeTres(10, 20, 15) AS Mayor;

-- 3. Crear un procedimiento que diga si una palabra, pasada como parámetro, es palíndroma.
DELIMITER $$

DROP PROCEDURE IF EXISTS Ej3EsPalindroma$$
CREATE PROCEDURE Ej3EsPalindroma(IN palabra VARCHAR(255))
BEGIN
    DECLARE invertida VARCHAR(255);
    SET invertida = REVERSE(palabra); -- Reverse = Invierte los caracteres de un string
    IF palabra = invertida THEN
        SELECT CONCAT(palabra, ' es palíndroma') AS Resultado; -- En caso de que en reverso sea igual, es palíndroma
    ELSE
        SELECT CONCAT(palabra, ' no es palíndroma') AS Resultado; -- En caso de que no lo sea no lo es
    END IF;
END$$

DELIMITER ;
CALL Ej3EsPalindroma('somos');
CALL Ej3EsPalindroma('hola');

-- 4. Crear una función que determine si un número es primo, devolviendo 0 ó 1.
DELIMITER $$

DROP FUNCTION IF EXISTS Ej4EsPrimo$$
CREATE FUNCTION Ej4EsPrimo(num INT)
RETURNS INT -- la función devuelve un entero, concretamente 1 si es primo, 0 si no lo es
DETERMINISTIC -- La función siempre devuelve el mismo resultado para los mismos valores de entrada
BEGIN
    DECLARE i INT DEFAULT 2; -- Variable para probar divisores desde 2
    DECLARE es_primo INT DEFAULT 1; -- Marca si el número es primo (1) o no (0)
    DECLARE limite INT;  

    IF num <= 1 THEN
        RETURN 0; -- No es primo si es menor o igual a 1
    END IF;

    SET limite = FLOOR(SQRT(num)); -- Calcula el límite para verificar divisores

    bucle: WHILE i <= limite DO -- Recorre posibles divisores
        IF MOD(num, i) = 0 THEN 
            SET es_primo = 0; -- No es primo si tiene divisor
            LEAVE bucle; -- Sale del bucle
        END IF;
        SET i = i + 1; -- Prueba el siguiente divisor
    END WHILE;

    RETURN es_primo; -- Devuelve 1 si es primo, 0 si no lo es
END$$

DELIMITER ;
SELECT Ej4EsPrimo(7) AS Ej4EsPrimo;   
SELECT Ej4EsPrimo(10) AS Ej4EsPrimo;  

-- 5. Usando la función anterior crear otra que calcule la suma de los primeros  “m”  números primos empezando en el 1.
DELIMITER $$

DROP FUNCTION IF EXISTS Ej5SumaPrimos$$
CREATE FUNCTION Ej5SumaPrimos(m INT)
RETURNS INT
DETERMINISTIC NO SQL
BEGIN
    DECLARE suma INT DEFAULT 0; -- Variable para almacenar la suma de los números primos
    DECLARE contador INT DEFAULT 0; -- Contador para llevar la cuenta de cuántos números primos se han sumado
    DECLARE num INT DEFAULT 2; -- Para probar números, comenzando desde el 2
    WHILE contador < m DO -- Bucle que se ejecuta mientras se hayan sumado m números impares
        IF EsPrimo(num) THEN -- Verifica si el número actual es primo usando la función esprimo
            SET suma = suma + num; -- En caso de que sea primo lo sumara a la variable de "suma"
            SET contador = contador + 1; -- y añadirá 1 al contador de números primos encontrados
        END IF;
        SET num = num + 1;
    END WHILE;
    RETURN suma;
END$$

DELIMITER ;
SELECT Ej5SumaPrimos(5) AS Ej5SumaPrimos;

-- 6. Crear la tabla T_Primos con dos columnas (id y numero) e ir almacenando los  “n” primeros números primos, siendo  “n” un parámetro de entrad. Usar la función del ejercicio 4.-- FUNCIÓN DEL EJERCICIO 4: Ej4EsPrimo
DELIMITER $$

DROP FUNCTION IF EXISTS Ej4EsPrimo$$
CREATE FUNCTION Ej4EsPrimo(num INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 2;
    DECLARE es_primo INT DEFAULT 1;
    DECLARE limite INT;

    IF num <= 1 THEN
        RETURN 0;
    END IF;

    SET limite = FLOOR(SQRT(num)); -- Establece el límite hasta comprobar los divisores

    etiqueta: BEGIN -- Comienza el bucle para comprobar si el número tiene divisores
        WHILE i <= limite DO
            IF MOD(num, i) = 0 THEN
                SET es_primo = 0;
                LEAVE etiqueta;
            END IF;
            SET i = i + 1;
        END WHILE;
    END;

    RETURN es_primo;
END$$

DELIMITER ;

-- Table T_Primos
DROP TABLE IF EXISTS T_Primos;

CREATE TABLE T_Primos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL
);

-- PROCEDIMIENTO PARA ALMACENAR N PRIMOS
DELIMITER $$

DROP PROCEDURE IF EXISTS Ej6AlmacenarPrimos$$
CREATE PROCEDURE Ej6AlmacenarPrimos(IN n INT)
BEGIN
    DECLARE contador INT DEFAULT 0;
    DECLARE num INT DEFAULT 2;
    TRUNCATE TABLE T_Primos; -- Truncate sirve para limpiar la tabla antes de insertar nuevos datos

    WHILE contador < n DO
        IF Ej4EsPrimo(num) = 1 THEN
            INSERT INTO T_Primos (numero) VALUES (num);
            SET contador = contador + 1;
        END IF;
        SET num = num + 1;
    END WHILE;
END$$

DELIMITER ;

-- LLAMADA AL PROCEDIMIENTO (EJEMPLO)
CALL Ej6AlmacenarPrimos(10);
SELECT * FROM T_Primos;