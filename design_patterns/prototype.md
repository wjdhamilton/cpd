*Prototype Pattern*

The Prototype Pattern is an object creation pattern that can be used to replace the Factory pattern and the need for explicit subclassing of classes. Essentially, objects with a given behaviour are created and stored within the application. When an instance of an object is required that has that behaviour then a new instance in cloned from the prototype instance. A prototype does not have to be an instance of any subclass. They could all be instances of the same class that have different values. For instance:

```ruby
class BrokerInterface

  REGISTERED_BROKER = {
    interactive_brokers: BrokerInterface.new("http:/ig.com/trade", "Interactive Brokers"),
    schroders: BrokerInterface.new("http://schroders.com/buy", "Schroders")
  }
  
  attr_reader :url, :name, :trades
  attr_accessor :trades

  def initialize(url, name, trades=[])
    @url = url
    @name = name
    @trades = []
  end

  def clone
    self.class.new(url, name, trades)
  end

  def self.interface_for(broker)
    REGISTERED_BROKERS[broker]
  end

  def trade
    copy = self.clone
    # ...logic to do with placing a trade...
    copy.add_trade(trade)
  end

  protected

    def add_trade(trade)
      trades << trade
    end
end
```

Essentially, this is akin to currying. A new object is created with a set of variables which define the behaviour of that object, but the behaviour is still determined by the same mechanism as the prototype object. Essesntially certain parameters have been fixed by the cloning process. It is important to note that this is a very good example of the benefits of immutability and information hiding. Using immutable objects greatly reduces the risk of the prototype being changed by copies where there may be shared references within those objects. Information hiding allows key parameters to be set without any possibility of the client altering them and thereby changing its behaviour from the contract that was entered into when `#interface_for` was called. 
