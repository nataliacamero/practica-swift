# Hotel Reservation Manager
Este proyecto es una implementación básica de un sistema de gestión de reservaciones de hotel en Swift. Permite agregar reservaciones, cancelarlas, calcular el precio total y mostrar todas las reservaciones existentes.

##Estructuras
- Client: Representa la información de un cliente con propiedades como id, name, age y height.
- Reservation: Contiene los detalles de una reservación, como id, hotelName, guestList, lengthOfStay, price y wantsBreakfast.

##Enumeraciones
 - ReservationError: Define los posibles errores que pueden ocurrir al realizar una reservación, como sameReservationId, clientAlreadyExist, reservationNotFound y reservationNotCreated.
 
##Clase HotelReservationManager
Esta clase se encarga de gestionar las reservaciones de hotel. Algunas de sus funcionalidades son:

- addReservation(guestList: [Client], lengthOfStay: Double, wantsBreakfast: Bool) throws -> Reservation: Agrega una nueva reservación a la lista de reservaciones existentes. Realiza validaciones y cálculos de precios antes de agregar la reservación.
- cancelBooking(bookingsList: [Reservation], BookingId: Int) throws -> Void: Cancela una reservación existente según el ID proporcionado.
- priceCalculation(guestList: [Client], days: Double, breakfast: Bool) -> Double: Calcula el precio total de una reservación basado en la lista de clientes, la duración de la estadía y la opción de desayuno.
- dataValidation(bookingsList: [Reservation], idToValidate: Int, guestList: [Client]) throws -> Bool: Valida el ID de la reservación y la lista de clientes para evitar duplicados.
- getAllReservations() -> [Reservation]: Obtiene todas las reservaciones existentes en forma de una lista.

##Ejecución de pruebas
- El código también incluye algunas funciones de prueba (testAddReservation, testCancelReservation, testReservationPrice) que demuestran el uso de las funcionalidades de HotelReservationManager y realizan pruebas de aserción para verificar su correcto funcionamiento.

- Para ejecutar las pruebas, simplemente llama a las funciones try testAddReservation(), try testCancelReservation() y try testReservationPrice().


