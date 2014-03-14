


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

    def board(vehicle)
        # Check if on vehicle (if type(@location) == vehicle) already and if so, return -1

        # Else, 
    end

    def unBoard()
        # Check if on vehicle already, and if NOT, return -1

        # Else, transfer location from the present vehicle to station the vehicle is in

    end

end


#classes = [ ['Warrior', { strength: 8, intelligence: 2 }], ['Mage', { strength: 1, intelligence: 9 }] ]

classes = [ ['Homebody', { name: 'Alice', balance: 100, location: 'home'}], ['Worker', {name: 'Bob', balance: 200, location: 'work'}] ]

classes.each do | Person, properties|
  # Create a new class
  klass = Class.new(Person) # class_name

  # Inject the information from our properties hash into the class by exposing instance methods.
  properties.each do |name, value|

    # define_method works like def, only we can specify the name of the method at run time
    klass.define_method name do
      value
    end
  end

  # Expose the class we just created to the outside world by sticking it in the global namespace. Object is the container for all top level constants.
  Object.send :const_set, Person, klass
end