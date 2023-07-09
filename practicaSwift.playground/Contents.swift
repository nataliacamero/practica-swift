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
    var counterToCreateId: Int = 0010
    let reservationId: Int = 0
    var totalPrice: Double = 0.0
    let hotelName: String = "El Gran Hotel"
    var validId: Bool = false
    var validCLient: Bool = false
    var basePrice: Double = 0.0
    var guestsNumber: Double = 0.0
    var lengthOfStay: Double = 0.0
    var breakfast: Double = 0.0
    var isValid: Bool = false
    var reservationData: [String: Any] = [:]
    var newReservation: [Reservation] = []
    var printGuestsInfo: String = ""
    var dataToReturn: [Reservation] = []

    init(guestList: [Client], lengthOfStay: Double, wantsBreakfast: Bool) {
            self.guestList = guestList
            self.lengthOfStay = lengthOfStay
            self.wantsBreakfast = wantsBreakfast
    }
   
    deinit {
        print("Desinicializando")
    }
    
    /// PriceCalculation()
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
        print("Guest number",guestsNumber,"BasePrice", basePrice, "lengthOfStay", lengthOfStay, "breakfast", self.breakfast )
        totalPrice = Double(basePrice * guestsNumber * lengthOfStay * self.breakfast)
        return totalPrice
    }
    
    
    /// Validates the reservation ID and client ID in a list of reservations.
    /// - Parameters:
    ///   - bookingsList: The list of reservations to validate.
    ///   - idToValidate: The reservation ID to validate.
    ///   - guestList: The client list to validate.
    /// - Throws: Throws a `ReservationError` if a duplicate reservation ID is found or if a reservation already exists for the provided client ID.
    /// - Returns: A boolean value indicating whether the reservation and client IDs are valid.
    func dataValidation(bookingsList: [Reservation], idToValidate:Int, guestList: [Client] ) throws -> Bool  {
        assert(idToValidate != 0)
        assert(guestList.count >= 1)
     print("Entre")
        print("validando booking list", bookingsList.count == 0)
        
        if bookingsList.count == 0 {
            validId = true
            validCLient = true
        } else {
            print("Entre else validar 98")
            for reservation in bookingsList {
                if reservation.id != idToValidate {
                    print("reservationid",reservation.id, "idtovalidate", idToValidate )
                    validId = true
                    
                } else {
                    validId = false
                    print("The ID number \(idToValidate)of this reservation already exist in our database.")
                    throw ReservationError.sameReservationId
                }
            }
            
            for reservation in bookingsList {
                for reservationGuest in reservation.guestList {
                    for guest in guestList {
                        print("ENtre validate id guest113")
                        if guest.id != reservationGuest.id {
                            validCLient = true
                        } else {
                            validCLient = false
                            print("There is a reservation for the customer with id \(guest.id).")
                            throw ReservationError.clientAlreadyExist
                        }
                    }
                    
                    
                }
            }
            
            
        }
        
        print("ValidID", validId, "VALIDCLIENT", validCLient )
        print("Valid && valid", validId && validCLient )
        if validId && validCLient {
           
            for guest in guestList {
                printGuestsInfo += "\(guest.id) "
            }
            print("Reservation with id: \(idToValidate) and client/s \(printGuestsInfo) is valid.")
            isValid = true
            print("Isvalid", isValid)
            return isValid
        } else {
            print("Reservation with id: \(idToValidate) and client/s \(printGuestsInfo) is Invalid.")
            isValid = false
            return isValid
        }
    }
    
    
    
    
    /// Adds a new reservation to the booking list.
    ///
    /// - Parameters:
    ///   - guestList: An array of `Client` objects representing the guests associated with the reservation.
    ///   - lengthOfStay: The length of stay for the reservation in days.
    ///   - wantsBreakfast: A boolean value indicating whether the reservation includes breakfast.
    /// - Throws: Throws a `ReservationError` if the reservation fails to meet validation criteria.
    /// - Returns: An array containing the reservation ID, total price, guest list, length of stay, and breakfast preference.
    func addReservation(guestList: [Client], lengthOfStay: Double, wantsBreakfast: Bool ) throws -> Any {
        assert(guestList.count >= 1)
        assert(lengthOfStay != 0)
        counterToCreateId += 1
        print("ID: ",counterToCreateId)
        totalPrice = priceCalculation(guestList: guestList, days: lengthOfStay, breakfast: wantsBreakfast)
        print("Datavalidationfunction", try dataValidation(bookingsList: bookingsList, idToValidate: counterToCreateId, guestList:guestList))
        if try dataValidation(bookingsList: bookingsList, idToValidate: counterToCreateId, guestList:guestList) {
            print("Entre if add validation")
            newReservation = [Reservation(id: counterToCreateId, hotelName: hotelName, guestList: guestList, lengthOfStay :lengthOfStay, price: totalPrice, wantsBreakfast: wantsBreakfast)]
            bookingsList += newReservation
            return [reservationId, totalPrice, guestList, lengthOfStay, wantsBreakfast] as [Any]
        } else {
            print("Reservation does not created")
            throw ReservationError.reservationNotCreated
        }
        
    }
    
    /// Cancel a reservation to the booking list.
    ///
    /// - Parameters:
    ///   - bookingsList: The list of reservations to validate.
    ///   - BookingId: The reservation ID to search.
    /// - Throws: Throws a `ReservationError` if the reservation fails to meet validation criteria.
    /// - Returns: Void.
    func cancelBooking(bookingsList: [Reservation], BookingId: Int) throws -> Void {
        assert(bookingsList.count >= 1)
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
            "Print how many reservatins",bookingsList.count
        )
        for reservation in bookingsList {
            print("\(reservation)\n\n")
        }
       return bookingsList
    }

}

//Funciones para testear el codigo
/*
func testAddReservation (bookingId, clientList) {
    return reservationData(clientList, lengthOfStay, wantsBreakfast )
}

func testCancelReservation(bookingId) {
    cancelBooking(bookingId)
    bookingsList<Buscar este idBooking>
    if noEstaEnElListado {
        print(“Pasa test de cancelation de reserva”)
    }

    cancelBooking(mismo bookingId)
    bookingsList<Buscar este idBooking>
    if no permite cancelar con mismo id{
        print(“Pasa test de cancelation con mismo id”)
    }

    cancelBooking(errado o no existente bookingId)
        bookingsList<Buscar este idBooking>
        if no permite cancelar con id errado {
        print(“Pasa test de cancelation con id errado.”)
    } else {
        asertionFailure(“No debe ocurrir”)
    }
}

Func testReservationPrice(clientArray, days, breakfast){
    let price = priceCalculation(clientArray, days, breakfast)

    if price == 150 {
        print(“Correct price test”)
    }  else {
        print(“Incorrect price test”)
    }
}
 */


// Programa de reservas

func printInitialLines() {
  
    let line1 = "*********************************************"
    let line2 = "*                                           *"
    let line3 = "*      Welcome to Reservations Program      *"
    let line4 = "* 🚨🚨🚨🚨   H A P P Y   P A T H   🚨🚨🚨🚨 *"
    let line5 = "*                                           *"
    let line6 = "*********************************************"
    let line7 = ""
    let line8 = "  📅 🏨 😌 Let's prepare your stay 😌 🏨 📅   "
    let line9 = ""

    let lines = [line1, line2, line3, line4, line5, line6, line7, line8, line9]

    for line in lines {
        print(line)
    }
}

printInitialLines()


var guestList: [Client] = []
var breakfast: Bool = false
var bookingDays: Double = 0.0
var wantsAddOther: Bool = false

func getInicialData() {
    wantsAddOther = false
    
    repeat {
        let line1 = "Please enter the information of the guest(s): "
        let line2 = ""
        let line3 = ""
        let lines = [line1, line2, line3]

        for line in lines {
            print(line)
        }
        
        print("Enter the guest identification (only numbers): 🔢 🆔 📋")
        let getID: String? = readLine()
        let id = Int(getID ?? "") ?? 0
        print("ID: \(id)")
        print("")
        print("*********************************************")
        print("")
        
        print("Enter the guest name: 🏷️ 💁‍♀️ 💁‍♂️ 🔠 📋")
        let getName: String? = readLine()
        let name = getName ?? ""
        print("Name: \(name)")
        print("")
        print("*********************************************")
        print("")
        
        print("Enter the guest age: 🎂 👴 👵 🎈")
        let getAge: String? = readLine()
        let age = Int(getAge ?? "") ?? 0
        print("Age: \(age)")
        print("")
        print("*********************************************")
        print("")
        
        print("Enter the guest height: 📏 📐 ⬆️")
        let getHeight: String? = readLine()
        let height = Int(getHeight ?? "") ?? 0
        print("Height: \(height)")
        print("")
        print("*********************************************")
        print("")

        let guest = Client(id: id, name: name, age: age, height: height)
        if guestList.contains(where: { $0.id == guest.id }) {
            print("🚨🚨Error: Client with ID \(guest.id) already exists in the current reservation.🚨🚨")
        } else {
            // Add client to the list client
            guestList.append(guest)
        }
        
        print("Would you like to add another guest? (y/n)")
        let questionGuest: String? = readLine()
        wantsAddOther = questionGuest?.lowercased() == "y"

    } while wantsAddOther == true
    
    let line1 = ""
    let line2 = "Please provide other information about your stay: "
    let line3 = ""
    let lines = [line1, line2, line3]

    for line in lines {
        print(line)
    }
    
    print("length of stay: (only numbers).  📆 🏨 🛏️")
    let daysOfStay: String? = readLine()
    let numberDays = Double(daysOfStay ?? "") ?? 0.0
    bookingDays = numberDays
    print("Length of stay: \(bookingDays)")
    print("")
    print("*********************************************")
    print("")
    
    print("Do you want breakfast: y/n  🍳 🥐 ☕️ 🥞")
    let withBreakfast: String? = readLine()
    breakfast = withBreakfast?.lowercased() == "y"
    print("With breakfast: \(breakfast ? "Yes" : "No")")
    print("")
    print("*********************************************")
    print("")
    print("")
    
    
}



print(breakfast, bookingDays)

for list in guestList {
    print(list)
}

//---------------------Main Program----------------------


let reservationManager = HotelReservationManager(guestList: guestList, lengthOfStay: bookingDays, wantsBreakfast: breakfast)
var wantsAddReservation: Bool = true

while wantsAddReservation {
    print("Ente while")
    do {
        getInicialData()
        try reservationManager.addReservation(guestList: guestList, lengthOfStay: bookingDays, wantsBreakfast: breakfast)
    } catch {
        print("Invalid input. Please try again.")
    }
    
    // Ask if wants to add another reservation
    print("Add another reservation? (y/n)")
    let answer = readLine()?.lowercased()
    wantsAddReservation = (answer == "y")
}

//Listing all reservations
print(reservationManager.getAllReservations())

// Print all reservations
print("All Reservations:")

for (index, reservation) in reservationManager.bookingsList.enumerated() {
    print("Reservation \(index + 1):")
    print("Reservation ID: \(reservation.id)")
    print("Hotel Name: \(reservation.hotelName)")
    print("Guests:")
    
    for (guestIndex, guest) in reservation.guestList.enumerated() {
        print("  Guest \(guestIndex + 1):")
        print("  Guest ID: \(guest.id)")
        print("  Guest Name: \(guest.name)")
        print("  Guest Age: \(guest.age)")
        print("  Guest Height: \(guest.height)")
    }
    
    print("Length of Stay: \(reservation.lengthOfStay) days")
    print("Price: \(reservation.price)")
    print("Wants Breakfast: \(reservation.wantsBreakfast ? "Yes" : "No")")
    print("---")
}






