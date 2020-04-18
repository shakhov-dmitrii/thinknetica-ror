class Station
  attr_reader :name
  attr_reader :trains

  def initialize(name) 
    @name = name
    @trains = []
  end

  def receive_train(train) 
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def trains_list_by_type(type)
    if @trains.any?
      res = @trains.select {|t| t.type == type}
    else
      puts "Поездов нет"
    end
  end
end
