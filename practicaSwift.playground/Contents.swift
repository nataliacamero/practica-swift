import Foundation

//Modelado de estructuras

struct Client {
    let id: Int
    let name: String
    let age: Int
    let height: Int
}

struct Reservation {
    let id: Int
    let hotelName: String
    var guestList: [Client]
    var lengthOfStay: Double
    let price: Double
    let wantsBreakfast: Bool
}


//Enum

enum ReservationError: Error {
    case sameReservationId
    case clientAlreadyExist
    case reservationNotFound
    case reservationNotCreated
}


//Modelado de clases HotelReservationManager

class HotelReservationManager {
    var bookingsList: [Reservation] = []
    var wantsBreakfast: Bool = false
    var guestList: [Client] = []
    var counterToCreateId: Int = 0
    let reservationId: Int = 0
    var totalPrice: Double = 0.0
    let hotelName: String = "Hotel Luchadores"
    var validId: Bool = false
    var validCLient: Bool = false
    var idGuest: Int = 0
    var basePrice: Double = 0.0
    var guestsNumber: Double = 0.0
    var lengthOfStay: Double = 0.0
    var breakfast: Double = 0.0
    var isValid: Bool = false
    var reservationData: [String: Any] = [:]
    var dataToReturn: [Reservation] = []

    init(guestList: [Client], lengthOfStay: Double, wantsBreakfast: Bool) {
            self.guestList = guestList
            self.lengthOfStay = lengthOfStay
            self.wantsBreakfast = wantsBreakfast
    }

    
    /// PriceCalculation():
    /// Calculates the total price of a hotel reservation based on the number of guests, length of stay, and breakfast option.
    /// - Parameters:
    ///   - guestList: An array of clients associated with the reservation.
    ///   - days: The number of days for the reservation.
    ///   - breakfast: A boolean value indicating whether breakfast is included in the reservation.
    /// - Returns: The total price of the reservation.
    func priceCalculation(guestList: [Client], days: Double, breakfast: Bool) -> Double{
        basePrice = Double(20)
        guestsNumber = Double(guestList.count)
        lengthOfStay = days
        self.breakfast = breakfast ? 1.25 : 1.0
        totalPrice = Double(basePrice * guestsNumber * lengthOfStay * self.breakfast)
        print("Precio:", totalPrice)
        return totalPrice
    }
    
    
    /// -Validates the reservation ID and client ID in a list of reservations:
    /// - Parameters:
    ///   - bookingsList: The list of reservations to validate.
    ///   - idToValidate: The reservation ID to validate.
    ///   - guestList: The client list to validate.
    /// - Throws: Throws a `ReservationError` if a duplicate reservation ID is found or if a reservation already exists for the provided client ID.
    /// - Returns: A boolean value indicating whether the reservation and client IDs are valid.
    func dataValidation(bookingsList: [Reservation], idToValidate:Int, guestList: [Client] ) throws -> Bool  {
        assert(idToValidate != 0)
        assert(guestList.count >= 1)
        if bookingsList.count == 0 {
            validId = true
            validCLient = true
        } else {
            for reservation in bookingsList {
                if reservation.id != idToValidate {
                    print("reservationid",reservation.id, "idtovalidate", idToValidate )
                    validId = true
                } else {
                    validId = false
                    print("The ID number \(idToValidate) of this reservation already exist in our database.")
                    throw ReservationError.sameReservationId
                }
            }
            
            for reservation in bookingsList {
                for reservationGuest in reservation.guestList {
                    for guest in guestList {
                        if guest.id != reservationGuest.id {
                            validCLient = true
                            idGuest = reservationGuest.id
                        } else {
                            validCLient = false
                            print("There is a reservation for the customer with id \(guest.id).")
                            throw ReservationError.clientAlreadyExist
                        }
                    }
                    
                    
                }
            }
            
            
        }
        //If validId and valiClient are valid, the function returns true, for continue the addReservation process.
        if validId && validCLient {
            print("Reservation with id: \(idToValidate) and client \(idGuest) is valid.")
            isValid = true
            return isValid
        } else {
            print("Reservation with id: \(idToValidate) and client \(idGuest) is Invalid.")
            isValid = false
            return isValid
        }
    }
    
    /// -Adds a new reservation to the booking list:
    ///
    /// - Parameters:
    ///   - guestList: An array of `Client` objects representing the guests associated with the reservation.
    ///   - lengthOfStay: The length of stay for the reservation in days.
    ///   - wantsBreakfast: A boolean value indicating whether the reservation includes breakfast.
    /// - Throws: Throws a `ReservationError` if the reservation fails to meet validation criteria.
    /// - Returns: An array containing the reservation ID, total price, guest list, length of stay, and breakfast preference.
    func addReservation(guestList: [Client], lengthOfStay: Double, wantsBreakfast: Bool ) throws -> Reservation {
        assert(guestList.count >= 1)
        assert(lengthOfStay != 0)
        counterToCreateId += 1
        totalPrice = priceCalculation(guestList: guestList, days: lengthOfStay, breakfast: wantsBreakfast)
        if try dataValidation(bookingsList: bookingsList, idToValidate: counterToCreateId, guestList:guestList) {
            let newReservation = Reservation(id: counterToCreateId, hotelName: hotelName, guestList: guestList, lengthOfStay :lengthOfStay, price: totalPrice, wantsBreakfast: wantsBreakfast)
            bookingsList.append(newReservation)
            return newReservation
        } else {
            print("Reservation does not created")
            throw ReservationError.reservationNotCreated
        }
        
    }
    
    /// - Cancel a reservation to the booking list:
    ///
    /// - Parameters:
    ///   - bookingsList: The list of reservations to validate.
    ///   - BookingId: The reservation ID to search.
    /// - Throws: Throws a `ReservationError` if the reservation fails to meet validation criteria.
    /// - Returns: Void.
    func cancelBooking(bookingsList: [Reservation], BookingId: Int) throws -> Void {
        guard bookingsList.count >= 1 else {
            throw ReservationError.reservationNotFound
        }
        for index in stride(from: bookingsList.count - 1, through: 0, by: -1){
            if bookingsList[index].id == BookingId {
                self.bookingsList.remove(at: index)
                print("The reservation number \(BookingId) was cancelled")
            } else {
                print("The id provided is invalid or does not exist.")
                throw  ReservationError.reservationNotFound
            }
        }
    }
    
    

    /// getAllReservations(_:)
    ///
    /// Retrieves all reservations from the provided list and returns them in an array.
    ///
    /// - Parameter bookingsList: The list of reservations to retrieve.
    /// - Returns: An array containing all the reservations from the `bookingsList`.
    ///
    /// This function iterates over the `bookingsList`, adds each reservation to the `dataToReturn` array, and prints the reservation. It then returns the `dataToReturn` array containing all the reservations.
    func getAllReservations() -> [Reservation] {
        print(
            "Print how many reservations",bookingsList.count
        )
        for reservation in bookingsList {
            print("Impresion de reservaciones: \n","\(reservation)\n\n")
        }
       return bookingsList
    }

}



func testAddReservation() throws {
 var clientList: [Client] = []
 let daysOfStay: Double = 15.0
 let withBreakfast: Bool = true

 //Add new client
 let clientData = Client(id: 1234, name: "Daniel Illescas", age: 30, height: 180)
 clientList.append(clientData)

    //Test for add new reservation
    //The new reservation is generated successfully,
    let manager = HotelReservationManager(guestList: clientList, lengthOfStay: daysOfStay, wantsBreakfast: withBreakfast)
    let reservationData = try manager.addReservation(guestList:clientList, lengthOfStay: daysOfStay, wantsBreakfast: withBreakfast )
    let dataMock = Reservation(id: 1,
                             hotelName: "Hotel Luchadores",
                             guestList: [
                                Client(id: 1234, name: "Daniel Illescas", age: 30, height: 180),
                             ],
                             lengthOfStay: 15,
                             price: 375,
                             wantsBreakfast: true)
    
    assert(reservationData.id == dataMock.id, "Error: \(reservationData.id) != \(dataMock.id) ")
    assert(reservationData.hotelName == dataMock.hotelName, "Error: \(reservationData.hotelName) != \(dataMock.hotelName) ")
    assert(reservationData.guestList.count == dataMock.guestList.count, "Error: \(reservationData.guestList.count) != \(dataMock.guestList.count) ")
    assert(reservationData.lengthOfStay == dataMock.lengthOfStay, "Error: \(reservationData.lengthOfStay) != \(dataMock.lengthOfStay) ")
    assert(reservationData.price == dataMock.price, "Error: \(reservationData.price) != \(dataMock.price) ")
    assert(reservationData.wantsBreakfast == dataMock.wantsBreakfast, "Error: \(reservationData.wantsBreakfast) != \(dataMock.wantsBreakfast) ")
    print("1. Test testAddReservation - New reservation - *** Passed ***")
    
    //Test for a reservation with the same id and same client id. ID is automatically generated.
    //If the reservation should be made, the test NO passed.
    do {
        let reservationDataTwo = try manager.addReservation(guestList:clientList, lengthOfStay: daysOfStay, wantsBreakfast: withBreakfast )
        print("reservationDataTwo", reservationDataTwo)
    } catch {
        print("Error in test reservation with the same id: Error: \(error).")
        assert(error as! ReservationError == ReservationError.clientAlreadyExist, "Error: \(ReservationError.self) != \(ReservationError.clientAlreadyExist)")
        print("2. Test testAddReservation - The reservation whith the same ID, should not be made - *** Passed ***")
    }
}


func testCancelReservation() throws {
    var clientList: [Client] = []
    let daysOfStay: Double = 15.0
    let withBreakfast: Bool = true

    //Add new client
    let clientData = Client(id: 1234, name: "Daniel Illescas", age: 30, height: 180)
    clientList.append(clientData)
        
    //Add a new reservation
    let manager = HotelReservationManager(guestList: clientList, lengthOfStay: daysOfStay, wantsBreakfast: withBreakfast)
    let reservationData = try manager.addReservation(guestList:clientList, lengthOfStay: daysOfStay, wantsBreakfast: withBreakfast )
    
    //Test to cancel a reservation.
    //The cancel must be made successfully.
    do {
        try manager.cancelBooking(bookingsList: manager.bookingsList, BookingId: 1)
        assert(manager.bookingsList.count == 0, "Error: The cancellation of the reservation was not made.")
        print("3. Test testCancelReservation - The existing reservation should be cancelled - *** Passed ***")
    } catch {
        print("Error in cancel test: \(error)")
        print("Test testCancelReservation - The reservation should be cancelled - *** No Passed ***")
    }
    
    
    //Test to cancel a reservation non-existent.
    //The cancel should not be made successfully.
    do {
        try manager.cancelBooking(bookingsList: manager.bookingsList, BookingId: 1)
        print("Test testCancelReservation - The reservation was be cancelled - *** No Passed ***")
    } catch {
        print("Error in cancel a reservation non-existent test: \(error)")
        assert(error as! ReservationError == ReservationError.reservationNotFound,"Error: Is not the same error as we expected.")
        print("4. Test testCancelReservation - Try to cancel a non-exixtent reservation - *** Passed ***")
    }
    
}

func testReservationPrice() throws {
    var clientList: [Client] = []
    let daysOfStay: Double = 15.0
    let withBreakfast: Bool = true
    var clientListTwo: [Client] = []
    let daysOfStayTwo: Double = 15.0
    let withBreakfasTwo: Bool = true

    //Add new clients
    let clientOneData = Client(id: 1234, name: "Daniel Illescas", age: 30, height: 180)
    clientList.append(clientOneData)
    
    let clientTwoData = Client(id: 2345, name: "Jose", age: 45, height: 180)
    clientList.append(clientTwoData)
        
    //Add a new reservation with two clients
    let manager = HotelReservationManager(guestList: clientList, lengthOfStay: daysOfStay, wantsBreakfast: withBreakfast)
    let reservationData = try manager.addReservation(guestList:clientList, lengthOfStay: daysOfStay, wantsBreakfast: withBreakfast )
    let dataMock = Reservation(id: 1,
                               hotelName: "Hotel Luchadores",
                               guestList: [
                                  Client(id: 1234, name: "Daniel Illescas", age: 30, height: 180),
                                  Client(id: 2345, name: "Jose", age: 45, height: 180)
                               ],
                               lengthOfStay: 15,
                               price: 750,
                               wantsBreakfast: true)
    
    //We compare a new reservation with the data provide, and must be the same price, if do not, trigger the assert.
    assert(reservationData.price == dataMock.price, "Error: \(reservationData.price) != \(dataMock.price) ")
    print("5. Test testPriceReservation - Test the price of a reservation, it must be the same as we expected - *** Passed  ***")
  
    
    //Add nother id and name clients, with the same data.
    let clientThreeData = Client(id: 6545, name: "Maria Nacim", age: 30, height: 180)
    clientListTwo.append(clientThreeData)
    
    let clientFourData = Client(id: 2345, name: "Julio Iglesias", age: 45, height: 180)
    clientListTwo.append(clientFourData)
        
    //Add a new reservation with two clients
    let managerTwo = HotelReservationManager(guestList: clientListTwo, lengthOfStay: daysOfStayTwo, wantsBreakfast: withBreakfasTwo)
    let reservationDataTwo = try managerTwo.addReservation(guestList: clientListTwo, lengthOfStay: daysOfStayTwo, wantsBreakfast: withBreakfasTwo )
    let dataMockTwo = Reservation(id: 1,
                               hotelName: "Hotel Luchadores",
                               guestList: [
                                  Client(id: 6545, name: "Maria Nacim", age: 30, height: 180),
                                  Client(id: 2345, name: "Julio Iglesias", age: 45, height: 180)
                               ],
                               lengthOfStay: 15,
                               price: 750,
                               wantsBreakfast: true)
    
    //We compare a new reservation with the data provide, and must be the same price, if do not, trigger the assert.
    assert(reservationDataTwo.price == dataMockTwo.price, "Error: \(reservationData.price) != \(dataMock.price) ")
    print("6. Test testPriceReservation - Test the price of ANOTHER reservation, it must be the same as we expected - *** Passed ***")
}


//Executing the tests:
try testAddReservation()
try testCancelReservation()
try testReservationPrice()

