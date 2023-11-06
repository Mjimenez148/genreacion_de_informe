import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import controlP5.*;
import processing.core.PApplet;
PImage imagen;

Textfield productosInput;
Connection dbConnection;
ControlP5 cp5;
String jdbcUrl = "jdbc:mysql://localhost:3306/grupal_10";
String username = "root";
String password = "Monicale200478@";
String data = "";

void setup() {
  size(900, 900);
  background(#FCB2E3); // Fondo celeste
  cp5 = new ControlP5(this);
  imagen = loadImage("astronauta.png");

  int inputWidth = 400;
  int inputHeight = 60;
  int inputY = 50; 

  productosInput = cp5.addTextfield("")
    .setPosition(width/2 - inputWidth/2, inputY)
    .setSize(inputWidth, inputHeight)
    .setFont(createFont("Arial", 32))
    .setColorBackground(color(#FCB2E3)) 
    .setColorForeground(color(255)) 
    .setColorActive(color(0)); // Color de selección negro;


  cp5.addButton("Cargar Datos")
    .setPosition(350, 150)
    .setSize(200, 80)
    .setFont(createFont("Arial", 24))
    .setColorBackground(color(0)) 
    .setColorForeground(color(255)) 
    .setColorActive(color(128)); 

  try {
 
    Class.forName("com.mysql.cj.jdbc.Driver");

  
    dbConnection = DriverManager.getConnection(jdbcUrl, username, password);

   
  } catch (ClassNotFoundException e) {
    println("Error al cargar el controlador JDBC: " + e.getMessage());
  } catch (SQLException e) {
    println("Error al conectar a la base de datos: " + e.getMessage());
  }
}

void draw() {
  background(#FCB2E3); 
  cp5.draw(); 
  image(imagen, 700, 0);


  textSize(18); 
  text(data, 50, 250);
}

void controlEvent(ControlEvent event) {
  if (event.isController()) {
    if (event.getController().getName().equals("Cargar Datos")) {
      String productos = productosInput.getText();
      cargarDatosDeTabla(productos);
    }
  }
}

void cargarDatosDeTabla(String productos) {
  try {
    String consulta = "SELECT * FROM " + productos;
    ResultSet resultSet = dbConnection.createStatement().executeQuery(consulta);
    data = "";

    while (resultSet.next()) {
      for (int i = 1; i <= resultSet.getMetaData().getColumnCount(); i++) {
        String columnName = resultSet.getMetaData().getColumnName(i);
        String value = resultSet.getString(i);
        data += columnName + ": " + value + "\n";
      }
      data += "------------------------\n";
    }
  } catch (SQLException e) {
    println("Error al cargar datos de la tabla: " + e.getMessage());
  }
}

void keyPressed() {
  if (key == 'q' || key == 'Q') {
    try {
      if (dbConnection != null) {
        dbConnection.close();
        println("Conexión cerrada.");
      }
    } catch (SQLException e) {
      println("Error al cerrar la conexión: " + e.getMessage());
    }
    exit();
  }
}
