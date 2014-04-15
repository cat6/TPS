#!/usr/bin/env ruby -w

# Basic System

class System
    # Defines a Transit System.  Stations, routes, and vehicles can have the System object as a data member.
    # Params:
    # +systemName+:: The transit system's name
    # +systemDescription+:: A description of the transit system
    def initialize(name, description)
        @systemName = name
        @systemDescription = description
    end

    def info()
        puts "Transit System Name: " + @systemName.to_s + "\n"
        puts "Description:\n"
        puts @description.to_s + "\n"
    end
end

class Station
    # Defines a station
    # Params:
    # +stationName+::  The station's name
    # +vehicleTypes+::  The types of vehicle the station can accept
    def initialize(stationName, vehicleTypes)
        @stationName = stationName
        @vehicleTypes = vehicleTypes
    end

    def info()
        puts "\n\n"
        puts "Station Name: " + @stationName.to_s + "\n"
        puts "Vehicle Types: " + @vehicleTypes.to_s + "\n\n"
    end

    def getName()
        return @stationName.to_s
    end
end

class Vehicle

    def initialize(vehicleName, reliability, vehicleRoute, location)
        @name = vehicleName
        @reliability = reliability
        @vehicleRoute = vehicleRoute.getStops()
        @vehicleRouteCosts = vehicleRoute.getStopCosts()
        @location = location
    end

    def info()
        puts "Vehicle name: " + @name.to_s + "\n"
        puts "Reliability: " + @reliability.to_s + "\n"
        puts "Route: " + @vehicleRoute.to_s + "\n"
        puts "Location: " + @location.getName() + "\n\n"
    end

    def getLocation()
        return @location.getName()
    end

    def getName()
        return @name
    end

    def nextStop()
        # find the stop on @busRoute after @location
        currentIndex = @vehicleRoute.index(@location)
        puts "Current Index: " + currentIndex.to_s + "\n"
        @newLocation = @vehicleRoute[currentIndex + 1]
        puts "\n\nNew Location: " + @newLocation.getName() + "\n"
        return @newLocation
        # Set @location to next stop
    end

    def move() 
        puts "\ncosts: " + @vehicleRouteCosts.to_s + "\n"
        #puts "Length: " + @vehicleRoute.length().to_s + "\n"
        routeIndex = @vehicleRoute.index(@location)
        puts "index: " + routeIndex.to_s + "\n"
        # If stops remain in the route, go to next stop
        #puts "stop cost: " + @vehicleRouteCosts[routeIndex]
        if @vehicleRoute.index(@location) != (@vehicleRoute.length - 1)
            @location = nextStop()
            chargePassengers()
        else
            @location = @vehicleRoute[0]
            puts "\n\nNew Location: " + @location.getName() + "\n"
            chargePassengers()
        end
    end

    def getPassengers()
        passengersOnVehicle = []
        puts "Passengers: \n"
        for person in $people
            #puts person.getName() + "\n"
            if person.getLocation() == getName()
                passengersOnVehicle.push(person)
            end
        end
        return passengersOnVehicle
    end

    def chargePassengers()
        puts "Charging Passengers\n"
        for person in getPassengers()
            chargeValue = 1     # Modify later.  Use fixed for now.
            print person.getName()
            puts "\nCharging " + person.getName() + " " + chargeValue.to_s   #getStopCharge()
            person.chargeFare(chargeValue)
            puts "New Balance: " + person.getCardBalance().to_s
        end
    end

    def chargeFare(person, chargeValue)
        # Charge person's card amount chargeValue
        person.car
    end

    def getStopCharge()
        return 1
    end

end

class Bus < Vehicle
    # Defines a Bus
    @@reliability = 0.90 
end

class Train < Vehicle
    # Defines a Train
    @@reliability = 0.98
end

class Route
    # Defines a route
    def initialize(routeNumber, routeStops, type, stopCosts)
        @routeNumber = routeNumber
        @routeStops = routeStops
        @type = type    # 0 means a loop (1, 2, 3, 1, 2, 3), whereas 1 means out-and-back-again (1, 2, 3, 2, 1, 2, 3)
        @stopCosts
    end

    def info()
        puts "Route Number: " + @routeNumber.to_s + "\n\n" 
        puts "Stops:\n"
        for stop in @routeStops
            puts "\t" + stop.getName() + "\n"
            # if a bus is in this stop, print out the bus name/number
            # variables with $ are global
            for vehicle in $fleet
                if vehicle.getLocation() == stop
                    print "Vehicle at stop: " + vehicle.getName() + "\n"
                end

            end
        end

        puts "\n"
    end

    def getName()
        return @routeNumber
    end

    def getStops()
        return @routeStops
    end

    def getStopCosts()
        return @stopCosts
    end
end

class Person
    # Defines a Person
    # +personName+::  The Person's name
    # +personBankBalance+::  The balance of the Person's bank account.  Funds are transfered from here to their transit card.  When the person is created they must transfer funds to their transit card in order to travel.
    # +personCardBalance+::  The balance of the Person's transit card.  Funds are transfered from here to their bank account, or decremented as they ride the transit system.
    # +personLocation+::  The person's location.  Either a station or a vehicle.  
    def initialize(name, balance, location)
        @personName = name
        @personBankBalance = balance
        @personCardBalance = 0
        @personLocation = location
    end

    def info()
        puts "Name: " + @personName + "\n"
        puts "Bank Balance: " + @personBankBalance.to_s + "\n"
        puts "Card Balance: " + @personCardBalance.to_s + "\n"
        puts "Location: " + @personLocation.getName() + "\n\n"
    end

    def getName()
        return @personName
    end

    def getLocation()
        return @personLocation.getName()
    end

    def getCardBalance()
        return @personCardBalance
    end

    def depositToBank(amount)
        ##### How to handle this transaction safely?  What if there's a system crash and the balance data are lost? 
        @personBankBalance = @personBankBalance + amount
    end

    def transferToCard(amount)
        ##### How to handle this transaction safely?  What if there's a system crash and the balance data are lost?  
        if @personBankBalance >= amount
            @personBankBalance = @personBankBalance - amount
            @personCardBalance = @personCardBalance + amount
        else
            return -1
        end
    end

    def transferToBank(amount)
        ##### How to handle this transaction safely?  What if there's a system crash and the balance data are lost? 
        if @personCardBalance >= amount
            @personCardBalance = @personCardBalance - amount
            @personBankBalance = @personBankBalance + amount
        else
            return -1
        end

    end

    def withdrawFromBank(amount)
        ##### How to handle this transaction safely?  What if there's a system crash and the balance data are lost? 
        if @personBankBalance >= amount
            @personBankBalance = @personBankBalance - amount
            @personCardBalance = @personCardBalance + amount
        else
            return -1
        end
    end

    def chargeFare(amount)
        @personCardBalance -= amount
    end

    def board(vehicle)
        # Check if on vehicle (if type(@location) == vehicle) already and if so, return -1

        # Else, 
    end

    def unBoard()
        # Check if on vehicle already, and if NOT, return -1

        # Else, transfer location from the present vehicle to station the vehicle is in

    end

end

if __FILE__ == $PROGRAM_NAME

    # Count the number of stations
    $stationCount = 0

    # Define Array inputs
    #myStops = %w(Union Mimico)

    $vehicleTypes = %w(Bus Train)

    # Define an array of stations
    allStations = []

    # Define Stations
    #stations = {'Union' => vehicleTypes, 'Mimico' => vehicleTypes}

    def makeStations()
        # Returns an array of station objects.  Takes in a hash of station names / vehicle type arrays.
        $stationUnion = Station.new("Union", $vehicleTypes)
        $stationMimico = Station.new("Mimico", $vehicleTypes)
        $stationUnionville = Station.new("Unionville", $vehicleTypes)
    end

    makeStations()

    #myStops = [$stationUnion, $stationMimico, $stationUnionville]   # A loop route
    #myStopCosts = [1, 1, 2]                                         # Costs twice as much to go back 2 stops

    myStops = [$stationUnion, $stationMimico, $stationUnionville]   # A loop route

    myStopCosts = [1, 1, 2]

    # Define a Route
    myRoute = Route.new(1, myStops, 1, myStopCosts)


    # Define a bus
    myBus = Bus.new("bus1", 0.95, myRoute, $stationUnion)

    # Create a person
    myPerson = Person.new("Alice", 100, myBus) 
    myPerson.transferToCard(50)

    mySecondPerson = Person.new("Bob", 120, $stationUnion)  
    mySecondPerson.transferToCard(75)


    $routes = [myRoute]
    $people = [myPerson, mySecondPerson]
    $fleet = [myBus]

    puts "ROUTES\n"
    for route in $routes 
        route.info()
    end

    puts "FLEET\n"
    for vehicle in $fleet
        puts "Vehicle:\n"
        vehicle.info()
    end

    puts "PEOPLE\n"
    for person in $people
        puts "Person:\n"
        person.info()
        puts "\n\n"
    end

    puts "Current Stop: " + myBus.getLocation().to_s
    while 1
    #puts "Next stop: " + myBus.nextStop().getName() + "\n"
    puts "Moving...\n"
    #myBus.info()
    sleep(2)
    myBus.move()
    #puts "Current Stop: " + myBus.getLocation().to_s + "\n"
    end
end


