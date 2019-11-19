CREATE DATABASE bdResidenciasEscolares;

GO


USE bdResidenciasEscolares;

GO

CREATE TABLE universidades(
    codUniversidad VARCHAR(30), 
    nomUniversidad VARCHAR(20) DEFAULT 'La Laguna',
    CONSTRAINT pk_universidades PRIMARY KEY(codUniversidad)
    );
    
GO
	
CREATE TABLE residencias(
    codResidencia INT  IDENTITY PRIMARY KEY,
    nomResidencia VARCHAR(30), 
    codUniversidad VARCHAR(30), 
    precioMensual INT  DEFAULT 900,
    comedor BIT NOT NULL DEFAULT 0,    
    CONSTRAINT fk_residencia FOREIGN KEY (codUniversidad) REFERENCES universidades(codUniversidad)
	);
GO	
	
CREATE TABLE estudiantes(
	codEstudiante INT,
	nomEstudiante VARCHAR(50),
	dni VARCHAR(9) UNIQUE,
	telefono VARCHAR(9) UNIQUE,
	CONSTRAINT estudiantes_pk PRIMARY KEY (codEstudiante)
	);
	
GO
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
	
	
GO
	
INSERT INTO universidades(codUniversidad, nomUniversidad) VALUES('SPA001', 'Las Palmas');
INSERT INTO universidades(codUniversidad, nomUniversidad) VALUES('SPA002', 'Sevilla');
INSERT INTO universidades(codUniversidad, nomUniversidad) VALUES('SPA003', 'Malaga');
INSERT INTO universidades(codUniversidad, nomUniversidad) VALUES('SPA004', 'Granada');
INSERT INTO universidades(codUniversidad, nomUniversidad) VALUES('SPA005', 'Ceuta');
INSERT INTO universidades(codUniversidad) VALUES('SPA006');

GO

INSERT INTO residencias(nomResidencia, codUniversidad, precioMensual, comedor) VALUES('Las Monjas golosas', 'SPA001', 200, 1);
INSERT INTO residencias(nomResidencia, codUniversidad, precioMensual, comedor) VALUES('Duerme calentito', 'SPA002', 240, 1);
INSERT INTO residencias(nomResidencia, codUniversidad, precioMensual, comedor) VALUES('Residencia de Malaga', 'SPA003', 180, 1);
INSERT INTO residencias(nomResidencia, codUniversidad, precioMensual, comedor) VALUES('Residencia Escolar de Granada', 'SPA004', 232, 1);
INSERT INTO residencias(nomResidencia, codUniversidad, precioMensual, comedor) VALUES('Residencia multicultural', 'SPA005', 158, 0);
INSERT INTO residencias(nomResidencia, codUniversidad, precioMensual, comedor) VALUES('Residencia La Laboral', 'SPA006', 250, 1);

GO

INSERT INTO estudiantes(codEstudiante, nomEstudiante, dni, telefono) VALUES (001, 'Omar Molina', '54294890C', '673920481'); 
INSERT INTO estudiantes(codEstudiante, nomEstudiante, dni, telefono) VALUES (002, 'Mario Mora', '36171890C', '603918439'); 
INSERT INTO estudiantes(codEstudiante, nomEstudiante, dni, telefono) VALUES (003, 'MarĂ­a Suarez', '54267890C', '673920221'); 
INSERT INTO estudiantes(codEstudiante, nomEstudiante, dni, telefono) VALUES (004, 'Ariana Morales', '79081856J', '681372819'); 
INSERT INTO estudiantes(codEstudiante, nomEstudiante, dni, telefono) VALUES (005, 'Oscar Cabrera', '54296710C', '618374271'); 
INSERT INTO estudiantes(codEstudiante, nomEstudiante, dni, telefono) VALUES (006, 'Dolores Fernandez', '56389690C', '699192381'); 

GO

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

GO

CREATE PROCEDURE listarEstancias
 @v_dniAlumno VARCHAR(9)
 
AS
BEGIN


SELECT t1.nomResidencia, t2.nomUniversidad, t3.fechaInicio, t3.fechaFin, t3.precioPagado FROM  residencias AS t1
INNER JOIN  universidades AS t2 ON
t1.codUniversidad = t2.codUniversidad
INNER JOIN estancias AS t3  ON
t1.codResidencia=t3.codResidencia 
INNER JOIN estudiantes AS t4 ON
t3.codEstudiante=t4.codEstudiante
WHERE t4.codEstudiante IN(
    SELECT codEstudiante FROM estudiantes WHERE dni=@v_dniAlumno)
	ORDER BY t3.fechaInicio;

 
 END;

 GO

--------------------------------------------------------------------------------------
--	exec listarEstancias('54296710C');
--------------------------------------------------------------------------------------

CREATE PROCEDURE insertarResidencia
 @v_nombreResidencia VARCHAR(30),
 @v_codUniversidad CHAR(6),
 @v_precioMensual INT,
 @v_comedor BIT,
 @v_existe INT OUT,
 @v_insertar INT OUT
	

AS
BEGIN

	DECLARE @v_codigo varchar(20);
       SET @v_codigo = NULL;
	
	SELECT @v_codigo = codUniversidad  FROM universidades WHERE codUniversidad=@v_codUniversidad;
	

	IF @v_codigo IS NOT NULL BEGIN	 
		 
	SET @v_existe=1;
		
	INSERT INTO residencias (nomResidencia, codUniversidad, precioMensual, comedor)
	VALUES(@v_nombreResidencia, @v_codUniversidad, @v_precioMensual, @v_comedor);

	SET @v_insertar = 1;

	
	 END
 	ELSE BEGIN

	 
	 SET @v_existe=0;
	 SET @v_insertar=0;
	 
	 END 
	 END;
 
 GO

----------------------------------------------------------------
  --	 DECLARE @v_existe INT
  --	 DECLARE @v_insertar INT
  --	exec insertarResidencia 'Nueva residencia', 'SPA001', 300, 1, @v_existe OUTPUT, @v_insertar OUTPUT
  --	 SELECT @v_existe
  --	 SELECT @v_insertar
-----------------------------------------------------------------
 

CREATE PROCEDURE cantidadResidencias
 @v_nomUniversidad VARCHAR(30),
 @v_precioMensual INT,
 @v_numResidencias BIGINT OUT,
 @v_precioInferior BIGINT OUT
	AS
	BEGIN
	SET NOCOUNT ON;
	SELECT @v_numResidencias = COUNT(nomResidencia)
		FROM residencias 
		  WHERE codUniversidad IN (
			SELECT codUniversidad FROM universidades WHERE nomUniversidad=@v_nomUniversidad);
	
		SELECT @v_precioInferior = COUNT(precioMensual) 
		FROM residencias 
		  WHERE precioMensual<@v_precioMensual AND codUniversidad IN(
	SELECT codUniversidad FROM universidades WHERE nomUniversidad=@v_nomUniversidad);		
	
	END;

-------------------------------------------------------------------------------------------------------
   --    DECLARE @v_nomUniversidad VARCHAR(30)  
   --    DECLARE @v_precioMensual INT
   --    exec cantidadResidencias 'Las Palmas', '900',  @v_nomUniversidad OUTPUT, @v_precioMensual OUTPUT
   --    SELECT @v_nomUniversidad
   --    SELECT @v_precioMensual
------------------------------------------------------------------------------------------------------------	
 
 GO
 
CREATE FUNCTION tiempoHospedado(
	@v_dni VARCHAR(9)
	)
	RETURNS INT		
	BEGIN
	DECLARE 
	@v_numeroMeses INT;
	
	SELECT @v_numeroMeses = SUM(datediff(MONTH,fechaInicio,fechaFin)) FROM estancias
	WHERE codEstudiante IN (SELECT codEstudiante FROM estudiantes WHERE dni=@v_dni);	
	RETURN @v_numeroMeses;	
	END;


-----------------------------------------------------------------------------------------------------------
  -- SELECT dbo.tiempoHospedado('54296710C');
-----------------------------------------------------------------------------------------------------------
