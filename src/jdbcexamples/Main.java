package jdbcexamples;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Scanner;




public class Main {
	

	public static void main(String[] args){
		
		
		//Scanner scanner = new Scanner(System.in);
		//String entrada = scanner.nextLine();		
						
		ManageDB manage = new ManageDB();
		manage.establecerConexion(2);
		System.out.println("\nTodas las estancias:");
		manage.consultaAll();
		System.out.println("\n<><><><><><><><><><><><><><><><>");
		
		System.out.println("\nTodos las residencias:");
		manage.consultaJoin();
		System.out.println("\n<><><><><><><><><><><><><><><><>");
		
		System.out.println("\nNombre de estudiante con DNI: 79081856J");
		manage.consultaPreparada("79081856J");
		System.out.println("\n<><><><><><><><><><><><><><><><>");
		
		System.out.println("\nNumero de estancias de una residencia");
		manage.consultaCount(3);
		System.out.println("\n<><><><><><><><><><><><><><><><>");
		
		
		System.out.println("\nInsertar un nuevo estudiante");
		manage.insertar(8, "Moisés", "54052936s", "684063163");
		 System.out.println("\n<><><><><><><><><><><><><><><><>");
		
		System.out.println("Actualizar una residencia");
		manage.actualizar("SegundoDam", 333, 6);
		System.out.println("\n<><><><><><><><><><><><><><><><>");
		
		System.out.println("\nMostrar estancias por DNI:54296710C");		
		manage.procedimientoSelect("54296710C");
		System.out.println("\n<><><><><><><><><><><><><><><><>");
		
		
		System.out.println("\nInsertar residencia por procedimiento");
		manage.procedimientoParamentrosEntradaSalida("Probando consola", "SPA004", 376, false);
		System.out.println("\n<><><><><><><><><><><><><><><><>");
		
		System.out.println("\nComprobar cantidad de residencias y precio menor a ");
		manage.procedureCantidadResidencias("Las Palmas", 900);
		System.out.println("\n<><><><><><><><><><><><><><><><>");
		
		
		System.out.println("Comprobar cuando tiempo se ha hospedado un alumno");
		manage.funcionTiempoHospedado("54296710C");
		System.out.println("\n<><><><><><><><><><><><><><><><>");
		
	}
	
	

}
