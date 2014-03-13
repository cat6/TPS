# Object Test

# Have a list of routes.  Each has a list of stations; because
# Ruby points by reference, they should all point to the same station
# object.  Each station has a list of busses.


class Station
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

class Bus

    $busReliability = 0.95

    def initialize(busName, reliability, busRoute, location)
        @name = busName
        @reliability = reliability
        @busRoute = busRoute.getStops()
        @location = location
    end

    def info()
        puts "Vehicle name: " + @name.to_s + "\n"
        puts "Reliability: " + @reliability.to_s + "\n"
        puts "Route: " + @busRoute.to_s + "\n"
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
        currentIndex = @busRoute.index(@location)
        puts "Current Index: " + currentIndex.to_s + "\n"
        @newLocation = @busRoute[currentIndex + 1]
        puts "\n\nNew Location: " + @newLocation.getName() + "\n"
        return @newLocation
        # Set @location to next stop
    end

    def move() 
        puts "Length: " + @busRoute.length().to_s
        puts "index: " + @busRoute.index(@location).to_s + "\n"
        # If stops remain in the route, go to next stop
        if @busRoute.index(@location) != (@busRoute.length - 1)
            @location = nextStop()
        else
            @location = @busRoute[0]
            puts "\n\nNew Location: " + @location.getName() + "\n"
        end
    end
        
end

class Route

    def initialize(routeNumber, routeStops, type)
        @routeNumber = routeNumber
        @routeStops = routeStops
        @type = type    # 0 means a loop (1, 2, 3, 1, 2, 3), whereas 1 means out-and-back-again (1, 2, 3, 2, 1, 2, 3)
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
end

class Person

    def initialize(name, balance, location)
        @personName = name
        @personBalance = balance
        @personLocation = location
    end

    def info()
        puts "Name: " + @personName + "\n"
        puts "Balance: " + @personBalance.to_s + "\n"
        puts "Location: " + @personLocation.getName() + "\n\n"
    end

    def getName()
        return @personName
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

    myStops = [$stationUnion, $stationMimico, $stationUnionville]

    # Define a Route
    myRoute = Route.new(1, myStops, 1)


    # Define a bus
    myBus = Bus.new("bus1", 0.95, myRoute, $stationUnion)

    # Create a person
    myPerson = Person.new("Alice", 100, myBus)

    routes = [myRoute]
    people = [myPerson]
    $fleet = [myBus]

    puts "ROUTES\n"
    for route in routes 
        route.info()
    end

    puts "FLEET\n"
    for vehicle in $fleet
        puts "Vehicle:\n"
        vehicle.info()
    end

    puts "PEOPLE\n"
    for person in people
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


