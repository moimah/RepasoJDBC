package jdbcexamples;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;

import com.mysql.cj.xdevapi.Type;



public class ManageDB {
	
	private int typeConnex; 	
	private Connection connection;
	
public void establecerConexion(int typeConnex) {
		
		this.typeConnex = typeConnex;
		
		try {
			
			switch (typeConnex) {
			case 1: //Conexion en mysql 				
				Class.forName("com.mysql.cj.jdbc.Driver");								
				this.connection = DriverManager.getConnection("jdbc:mysql://localhost:/bdresidenciasescolares".concat("?serverTimezone=GMT"),"root", "");	
				break;

			case 2: //Conexion SQL server
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
				this.connection = DriverManager.getConnection("jdbc:sqlserver://" + "DESKTOP-Q6V791E\\SQLEXPRESS;databaseName=bdResidenciasEscolares" + ";user=user" + ";password=" + "user");
				
				break;
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
	}
	
	public void consultaAll() {
									
		try {			
			if(connection.isClosed()) {
				establecerConexion(this.typeConnex);
			}
			
			String sql = "SELECT * FROM estancias";
			Statement statement = connection.createStatement();
			ResultSet result = statement.executeQuery(sql);
			while(result.next()) {
				System.out.println("--------------------------------------------------------"); //Linea separadora
				System.out.println("CodEstudiante: " + result.getInt(1));
				System.out.println("CodResidencia: " + result.getInt(2));
				System.out.println("Fecha inicio: "+ result.getDate(3));
				System.out.println("Fecha fin: "+ result.getDate(4));
				System.out.println("Precio pagado: " + result.getInt(5));				
			}
			//Liberamos recursos
			result.close();
			statement.close();
			connection.close();
			
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public void consultaJoin() {
		
		try {			
			if(connection.isClosed()) {
				establecerConexion(this.typeConnex);
			}
			
			String sql = "SELECT t1.codResidencia, t1.codUniversidad,  t2.nomUniversidad, t1.nomResidencia, t1.precioMensual, t1.comedor FROM residencias AS t1 INNER JOIN universidades AS t2 ON t1.codUniversidad = t2.codUniversidad ORDER BY t1.codResidencia";
			Statement statement = connection.createStatement();
			ResultSet result = statement.executeQuery(sql);
			while(result.next()) {
				System.out.println("--------------------------------------------------------"); //Linea separadora
				System.out.println("CodResidencia: " + result.getInt(1));
				System.out.println("CodUniversidad: " + result.getString(2));
				System.out.println("Nombre universidad: "+ result.getString(3));
				System.out.println("Nombre residencia: "+ result.getString(4));
				System.out.println("Precio mensual: " + result.getInt(5));
				System.out.println("Comedor: " + result.getBoolean(6));
			}
			//Liberamos recursos
			result.close();
			statement.close();
			connection.close();		
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public void consultaPreparada(String dni) {
		
		try {
			if(connection.isClosed()) {
				establecerConexion(this.typeConnex);
			}
			
			String sql = "SELECT nomEstudiante FROM estudiantes WHERE dni = ?";
			PreparedStatement preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1,dni);
			ResultSet result = preparedStatement.executeQuery();
			
			while(result.next()) { //No necesario en esta consulta ya que solo devuelve un valor
				//System.out.println("--------------------------------------------------------"); //Linea separadora
				System.out.println(result.getString(1));
			}
			
			result.close();
			preparedStatement.close();
			connection.close();
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
	}
	
	public void consultaCount(int codResidencia) {
		
		try {
			
			if(connection.isClosed()) {
				establecerConexion(this.typeConnex);
			}
			
			String sql = "SELECT COUNT(*) FROM estancias WHERE codResidencia = ?";
			PreparedStatement preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setInt(1, codResidencia);
			ResultSet result = preparedStatement.executeQuery();
			while(result.next()) {
				System.out.println("La residencia  " + codResidencia + " tiene un total de " + result.getInt(1) + " estancias");
			}
			result.close();
			preparedStatement.close();
			connection.close();
			
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Problema el select");
		}
		
		
	}
	
	
	public void insertar(int codEstudiante, String nomEstudiante, String dni, String telefono) {
		
		try {
			
		if(connection.isClosed()) {
			establecerConexion(this.typeConnex);
		}
			
			String sql = "INSERT INTO estudiantes VALUES(?, ?, ?, ?)";
			PreparedStatement preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setInt(1, codEstudiante);
			preparedStatement.setString(2, nomEstudiante);
			preparedStatement.setString(3, dni);
			preparedStatement.setString(4, telefono);
			int n = preparedStatement.executeUpdate();
			preparedStatement.close();
			connection.close();
			
			System.out.println("Se han insertado: "+  n + " registros");
			
		} catch (Exception e) {
			//e.printStackTrace();
			System.out.println("Error al insertar");
		}
		
	}
	
	public void actualizar(String nomResidencia, int precioMensual, int codResidencia) {
		
		try {
			if(connection.isClosed()) {
				establecerConexion(typeConnex);
			}
			
			String sql = "UPDATE residencias SET nomResidencia = ?, precioMensual = ? WHERE codResidencia = ? ";
			PreparedStatement preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, nomResidencia);
			preparedStatement.setInt(2, precioMensual);
			preparedStatement.setInt(3, codResidencia);
			
			int n = preparedStatement.executeUpdate();
			System.out.println("Se han actualizado: "+  n + " registros");
			
			
		} catch (Exception e) {
			e.printStackTrace();
			//System.out.println("Error en el update");
		}
		
	}
	
	
	/**
	 * PROCEDURE listarEstancias
	 * @param dni
	 */
	public void procedimientoSelect(String dni) {
		
		try {
			
			if(connection.isClosed()) {
				establecerConexion(this.typeConnex);
			}
			
			String sql = "";
			
			switch (this.typeConnex) {
									
			case 1: //Mysql				
				sql = "Call listarEstancias (?)";			
				break;
			case 2: //SQL server
				sql = "exec listarEstancias ?";		
				break;
			}
			
			//Aqui se ejecuta el procedimiento//
			CallableStatement callableStatement = connection.prepareCall(sql);
			callableStatement.setString(1, dni);	
			ResultSet result = callableStatement.executeQuery(); //Porque devuelve un SELECT y se ha de recoger
			while(result.next()) { 				
				System.out.println("--------------------------------------------------------"); //Linea separadora
				System.out.println("Nombre residencia: " + result.getString(1));
				System.out.println("Nombre universidad: " + result.getString(2));
				System.out.println("Fecha inicio: " + result.getDate(3));
				System.out.println("Fecha fin: " + result.getDate(4));
				System.out.println("Precio pagado: " + result.getInt(5));
				
			}
			result.close();
			callableStatement.close();
			connection.close();
												
			
		} catch (Exception e) {
			//e.printStackTrace();
			System.out.println("Problema al ejecutar el procedimiento");			
		}
		
	}
	
	/**
	 * PROCEDURE insertarResidencia
	 * @param nombreResidencia
	 * @param codUniversidad
	 * @param precioMensual
	 * @param comedor
	 */
	
	public void procedimientoParamentrosEntradaSalida(String nombreResidencia, String codUniversidad, int precioMensual, boolean comedor) {
		
		try {
			
			if(connection.isClosed()) {
				establecerConexion(this.typeConnex);
			}
			
			String sql = "";
			
			switch (typeConnex) {
			case 1:
				sql = "CALL insertarResidencia (?, ?, ?, ?, ?, ?)";								
				break;
			case 2:
				sql = "EXEC insertarResidencia ?, ?, ?, ?, ?, ?";
				break;				
			}
						
			//Aqui ejecutar procedimiento
			CallableStatement callableStatement = connection.prepareCall(sql);
			callableStatement.setString(1, nombreResidencia);
			callableStatement.setString(2, codUniversidad);
			callableStatement.setInt(3, precioMensual);
			callableStatement.setBoolean(4, comedor);
			callableStatement.registerOutParameter(5, Types.INTEGER);
			callableStatement.registerOutParameter(6, Types.INTEGER);
			callableStatement.execute();
			
			System.out.println("Existe:" + callableStatement.getInt(5));
			System.out.println("Insertar:" + callableStatement.getInt(6));
			
			callableStatement.close();
			connection.close();
			
			
			
		} catch (Exception e) {
			//e.printStackTrace();
			System.out.println("Error al ejecutar el procedimiento");
		}
			
		
	}
	
	//CREATE PROCEDURE cantidadResidencias
	
	public void procedureCantidadResidencias(String nomUniversidad, int precioMensual) {
		try {
			if(connection.isClosed()) {
				establecerConexion(typeConnex);
			}
			String sql = "";
						
			switch (typeConnex) {
			case 1:
				sql =  "CALL cantidadResidencias (?, ?, ?, ?)";
				break;
			case 2:
				sql = "exec cantidadResidencias ?, ?, ?, ?";
				break;
			}
			
			//Aqui se ejecuta el procedimiento
			CallableStatement callableStatement = connection.prepareCall(sql);
			callableStatement.setString(1, nomUniversidad);
			callableStatement.setInt(2, precioMensual);			
			callableStatement.registerOutParameter(3, Types.BIGINT);
			callableStatement.registerOutParameter(4, Types.BIGINT);
			callableStatement.execute();
			
			System.out.println("La unversidad " + nomUniversidad + "tiene " + callableStatement.getInt(3) +" residencias");
			System.out.println("La unversidad " + nomUniversidad + "tiene " + callableStatement.getInt(4) +" residencias a un precio menor a " +precioMensual);
			
			callableStatement.close();
			connection.close();
			
			
		} catch (Exception e) {
			//e.printStackTrace();
			System.out.println("Error al ejecutar el procedimiento");
		}
		
	}
	
	//FUNCION tiempoHospedado
	
	public void funcionTiempoHospedado(String dni) {
		try {
			if(connection.isClosed()) {
				establecerConexion(typeConnex);
			}
			
			String sql = "";
			
			switch (typeConnex) {
			case 1:
				sql = "SELECT tiempoHospedado (?)";				
				break;

			case 2:
				sql = "SELECT dbo.tiempoHospedado (?)";				
				break;
			}
			
			//Aqui se ejecuta el procedimiento
			PreparedStatement preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, dni);			
			ResultSet result = preparedStatement.executeQuery();
			while(result.next()) { // No es absolutamente necesario que este en un while ya que solo devuelve un registro
				System.out.println("El alumno con dni " + dni + " se ha hospedado " + result.getInt(1) + " meses");				
			}
			
			
			
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Error al ejecutar el procedimiento");
		}
		
		
	}
	
	
	public void funcion() {
		
	}


}
