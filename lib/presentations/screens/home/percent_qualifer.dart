void main() {
  // Calificaciones individuales (por ejemplo, 5 calificaciones)
  List<double> calificaciones = [5.0, 5.0, 5.0, 5.0, 5.0];
  
  // Puntaje máximo por calificación
  double puntajeMaximoPorCalificacion = 5.0;
  
  // Número de calificaciones
  int numeroDeCalificaciones = calificaciones.length;
  
  // Puntaje máximo posible
  double puntajeMaximoPosible = puntajeMaximoPorCalificacion * numeroDeCalificaciones;
  
  // Suma de las calificaciones actuales
  double sumaCalificacionesActuales = calificaciones.reduce((a, b) => a + b);
  
  // Porcentaje de calificación
  double porcentajeCalificacion = (sumaCalificacionesActuales / puntajeMaximoPosible) * 100;
  
  print('El porcentaje total de calificaciones es: $porcentajeCalificacion%');
}