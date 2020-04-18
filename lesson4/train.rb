class Train
  attr_accessor :number, :route, :carriages

  attr_reader :type

  def initialize(number, type)
    @number = number
    @type = type
    @carriages = []
    @speed = 0
    @station_index = 0
    @route = []
  end

  def stop
    self.speed = 0
  end

  def add_carriage(carriage)
    if self.speed == 0
      self.carriages << carriage
    else
      puts "Поезд движется. Остановите поезд для добавления вагона."
    end
  end

  def remove_carriage(carriage)
    if self.speed == 0
      if self.carriages.size > 0
        self.carriages.delete(carriage)
      else
        puts "Нельзя убрать вагон, т.к. у поезда нет прицепленных вагонов."
      end
    else
      puts "Поезд движется. Остановите поезд для отцепки вагона."
    end
  end

  def set_route(route)
    route.stations[0].receive_train(self)
    self.route = route
  end

  def move_forward
    if station_index < @route.stations.size - 1
      @route.stations.at(@station_index).send_train(self)
      self.station_index += 1
      @route.stations.at(@station_index).receive_train(self)
    else
      puts "Вы на конечной станции."
    end
  end

  def move_backward
    if station_index > 0
      @route.stations.at(@station_index).send_train(self)
      self.station_index -= 1
      @route.stations.at(@station_index).receive_train(self)
    else
      puts "Вы в начале пути. На предыдущую станцию нельзя вернуться."
    end
  end

  def show_stations(type)
    if type == "previous"
      self.route.stations[station_index - 1] if station_index != 0
    elsif type == "current"
      self.route.stations[station_index]
    elsif type == "next"
      self.route.stations[station_index + 1] if station_index < self.route.stations.size - 1
    end
  end

  private 
  attr_accessor :station_index, :speed
end 
