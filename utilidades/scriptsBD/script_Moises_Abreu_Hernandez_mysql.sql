


CREATE DATABASE bdResidenciasEscolares;

USE bdResidenciasEscolares;


CREATE TABLE universidades(
    codUniversidad VARCHAR(30), 
    nomUniversidad VARCHAR(20) DEFAULT 'La Laguna',
    CONSTRAINT pk_universidades PRIMARY KEY(codUniversidad)
    );
    
	
	
CREATE TABLE residencias(
    codResidencia INT  AUTO_INCREMENT,
    nomResidencia VARCHAR(30), 
    codUniversidad VARCHAR(30), 
    precioMensual INT NOT NULL DEFAULT 900,
    comedor BOOLEAN NOT NULL DEFAULT 0,
    CONSTRAINT pk_residencia PRIMARY KEY(codResidencia), 
    CONSTRAINT fk_residencia FOREIGN KEY (codUniversidad) REFERENCES universidades(codUniversidad)
	);
	
	
CREATE TABLE estudiantes(
	codEstudiante INT,
	nomEstudiante VARCHAR(50),
	dni VARCHAR(9) UNIQUE,
	telefono VARCHAR(9) UNIQUE,
	CONSTRAINT estudiantes_pk PRIMARY KEY (codEstudiante)
	);
	
	
CREATE TABLE estancias(
	codEstudiante INT,
	codResidencia INT,
	fechaInicio DATE,
	fechaFin DATE,
	precioPagado INT,
	CONSTRAINT estancias_pk PRIMARY KEY(codEstudiante, codResidencia, fechaInicio),
	CONSTRAINT fk_estancias_estudiantes FOREIGN KEY (codEstudiante) REFERENCES estudiantes (codEstudiante),
	CONSTRAINT fk_estancias_residencias FOREIGN KEY (codResidencia) REFERENCES residencias(codResidencia)
	);
	
	
	
	
INSERT INTO universidades(codUniversidad, nomUniversidad) VALUES("SPA001", "Las Palmas");
INSERT INTO universidades(codUniversidad, nomUniversidad) VALUES("SPA002", "Sevilla");
INSERT INTO universidades(codUniversidad, nomUniversidad) VALUES("SPA003", "Malaga");
INSERT INTO universidades(codUniversidad, nomUniversidad) VALUES("SPA004", "Granada");
INSERT INTO universidades(codUniversidad, nomUniversidad) VALUES("SPA005", "Ceuta");
INSERT INTO universidades(codUniversidad) VALUES("SPA006");



INSERT INTO residencias(nomResidencia, codUniversidad, precioMensual, comedor) VALUES("Las Monjas golosas", "SPA001", 200, 1);
INSERT INTO residencias(nomResidencia, codUniversidad, precioMensual, comedor) VALUES("Duerme calentito", "SPA002", 240, 1);
INSERT INTO residencias(nomResidencia, codUniversidad, precioMensual, comedor) VALUES("Residencia de Malaga", "SPA003", 180, 1);
INSERT INTO residencias(nomResidencia, codUniversidad, precioMensual, comedor) VALUES("Residencia Escolar de Granada", "SPA004", 232, 1);
INSERT INTO residencias(nomResidencia, codUniversidad, precioMensual, comedor) VALUES("Residencia multicultural", "SPA005", 158, 0);
INSERT INTO residencias(nomResidencia, codUniversidad, precioMensual, comedor) VALUES("Residencia La Laboral", "SPA006", 250, 1);


INSERT INTO estudiantes(codEstudiante, nomEstudiante, dni, telefono) VALUES (001, "Omar Molina", "54294890C", "673920481"); 
INSERT INTO estudiantes(codEstudiante, nomEstudiante, dni, telefono) VALUES (002, "Mario Mora", "36171890C", "603918439"); 
INSERT INTO estudiantes(codEstudiante, nomEstudiante, dni, telefono) VALUES (003, "MarĂ­a Suarez", "54267890C", "673920221"); 
INSERT INTO estudiantes(codEstudiante, nomEstudiante, dni, telefono) VALUES (004, "Ariana Morales", "79081856J", "681372819"); 
INSERT INTO estudiantes(codEstudiante, nomEstudiante, dni, telefono) VALUES (005, "Oscar Cabrera", "54296710C", "618374271"); 
INSERT INTO estudiantes(codEstudiante, nomEstudiante, dni, telefono) VALUES (006, "Dolores Fernandez", "56389690C", "699192381"); 


INSERT INTO estancias (codEstudiante, codResidencia, fechaInicio, fechaFin, precioPagado) VALUES (001, 1, '2019-12-10', '2019-12-19', 67);
INSERT INTO estancias (codEstudiante, codResidencia, fechaInicio, fechaFin, precioPagado) VALUES (002, 1, '2019-05-10', '2019-05-10', 200);
INSERT INTO estancias (codEstudiante, codResidencia, fechaInicio, fechaFin, precioPagado) VALUES (003, 2, '2019-04-01', '2019-04-08', 56);
INSERT INTO estancias (codEstudiante, codResidencia, fechaInicio, fechaFin, precioPagado) VALUES (003, 2, '2019-02-19', '2019-02-27', 56);
INSERT INTO estancias (codEstudiante, codResidencia, fechaInicio, fechaFin, precioPagado) VALUES (004, 6, '2019-01-01', '2019-01-31', 250);
INSERT INTO estancias (codEstudiante, codResidencia, fechaInicio, fechaFin, precioPagado) VALUES (004, 2, '2019-04-01', '2019-04-08', 56);
INSERT INTO estancias (codEstudiante, codResidencia, fechaInicio, fechaFin, precioPagado) VALUES (005, 3, '2019-05-05', '2019-06-05', 180);
INSERT INTO estancias (codEstudiante, codResidencia, fechaInicio, fechaFin, precioPagado) VALUES (005, 3, '2019-11-01', '2019-11-08', 56);
INSERT INTO estancias (codEstudiante, codResidencia, fechaInicio, fechaFin, precioPagado) VALUES (006, 4, '2019-01-01', '2019-02-01', 232);
INSERT INTO estancias (codEstudiante, codResidencia, fechaInicio, fechaFin, precioPagado) VALUES (006, 5, '2018-12-24', '2018-12-31', 54);
INSERT INTO estancias (codEstudiante, codResidencia, fechaInicio, fechaFin, precioPagado) VALUES (006, 2, '2018-10-01', '2019-01-01', 480);






delimiter // 

CREATE PROCEDURE listarEstancias(
IN v_dniAlumno VARCHAR(9)
) 
BEGIN

SELECT t1.nomResidencia, t2.nomUniversidad, t3.fechaInicio, t3.fechaFin, t3.precioPagado FROM  residencias AS t1
INNER JOIN  universidades AS t2 ON
t1.codUniversidad = t2.codUniversidad
INNER JOIN estancias AS t3  ON
t1.codResidencia=t3.codResidencia 
INNER JOIN estudiantes AS t4 ON
t3.codEstudiante=t4.codEstudiante
WHERE t4.codEstudiante IN(
    SELECT codEstudiante FROM estudiantes WHERE dni=v_dniAlumno)
	ORDER BY t3.fechaInicio;

 
 END
 
 //
 
 delimiter ; 
 



delimiter // 

CREATE PROCEDURE insertarResidencia(
	IN v_nombreResidencia VARCHAR(30),
	IN v_codUniversidad CHAR(6),
	IN v_precioMensual INT,
	IN v_comedor BOOLEAN,
	OUT v_existe INT,
	OUT v_insertar INT
	)

BEGIN
	DECLARE v_codigo varchar(20);
       SET v_codigo = NULL;
	
	SELECT codUniversidad  INTO v_codigo FROM universidades WHERE codUniversidad=v_codUniversidad;
	

	IF v_codigo IS NOT NULL THEN	 
		 
		SET v_existe=1;
		
	INSERT INTO residencias (nomResidencia, codUniversidad, precioMensual, comedor)
	VALUES(v_nombreResidencia, v_codUniversidad, v_precioMensual, comedor);

	SET v_insertar = 1;

	
	 ELSE

	 
	 SET v_existe=0;
	 SET v_insertar=0;
	 
	 END IF;
	 END;
 
	
//
 
 delimiter ;
 
  
 

 
delimiter // 
	
	CREATE PROCEDURE cantidadResidencias(
	IN v_nomUniversidad VARCHAR(30),
	IN  v_precioMensual INT,
	OUT v_numResidencias BIGINT,
	OUT v_precioInferior BIGINT)
	BEGIN
	SELECT COUNT(nomResidencia) INTO v_numResidencias
		FROM residencias 
		  WHERE codUniversidad IN (
			SELECT codUniversidad FROM universidades WHERE nomUniversidad=v_nomUniversidad);
	
		SELECT COUNT(precioMensual) AS precioMensual INTO v_precioInferior
		FROM residencias 
		  WHERE precioMensual<v_precioMensual AND codUniversidad IN(
	SELECT codUniversidad FROM universidades WHERE nomUniversidad=v_nomUniversidad);

	
		
	
	END;
	
		//
 
 delimiter ; 
 
 
 


	delimiter // 
	
	CREATE FUNCTION tiempoHospedado(
	v_dni VARCHAR(9)
	)
	RETURNS INT		
	BEGIN
	DECLARE 
	v_numeroMeses INT;
	
	SELECT SUM(TIMESTAMPDIFF(MONTH,fechaInicio,fechaFin)) INTO v_numeroMeses FROM estancias
	WHERE codEstudiante IN (SELECT codEstudiante FROM estudiantes WHERE dni=v_dni);	
	RETURN v_numeroMeses;	
	END;
	
		//
 
 delimiter ;
 
 
 
 
delimiter // 
	
	CREATE TRIGGER cambiar_fecha_update  
	BEFORE UPDATE ON estancias 
    FOR EACH ROW 
    BEGIN	 
    DECLARE v_inicio DATE;  
    DECLARE v_fin DATE;
	IF NEW.fechaInicio>NEW.fechaFin THEN	 
      SET v_inicio=NEW.fechaFin;
	  SET v_fin=NEW.fechaInicio;
	  SET NEW.fechaInicio = v_inicio;
	  SET NEW.fechaFin = v_fin;
	END IF;	
	END;
	
		//
 
 delimiter ;
 
 
 
 delimiter // 
	
	CREATE TRIGGER cambiar_fecha_insert   
	BEFORE INSERT ON estancias 
    FOR EACH ROW 
    BEGIN	 
    DECLARE v_inicio DATE;  
    DECLARE v_fin DATE;
	IF NEW.fechaInicio>NEW.fechaFin THEN	 
      SET v_inicio=NEW.fechaFin;
	  SET v_fin=NEW.fechaInicio;
	  SET NEW.fechaInicio = v_inicio;
	  SET NEW.fechaFin = v_fin;
	END IF;	
	END;
	
		//
 
 delimiter ;




delimiter // 
	
	CREATE TRIGGER precio_incorrecto    
	BEFORE INSERT ON residencias
    FOR EACH ROW 
    BEGIN	 
    DECLARE fallo CONDITION FOR SQLSTATE '45000';    	
	IF NEW.precioMensual>900 THEN
	 SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'No se puede insertar, precio mayor a 900';
	END IF;	
	END;
	
		//
 
 delimiter ;




	delimiter // 
	
	CREATE TRIGGER borrar_universidad
	BEFORE DELETE ON universidades
	FOR EACH ROW
	BEGIN	 
    DECLARE error CONDITION FOR SQLSTATE '45001'; 
	 SIGNAL SQLSTATE '45001'
      SET MESSAGE_TEXT = 'No está permitido borrar universidades';
	  END;
	  
		//
 
 delimiter ;