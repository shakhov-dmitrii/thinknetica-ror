class Train
  attr_accessor :number, :speed, :route, :carriages, :station_index

  attr_reader :type

  def initialize(number, type, carriages)
    @number = number
    @type = type
    @carriages = carriages
    @speed = 0
    @station_index = 0
    @route = []
  end

  def stop
    self.speed = 0
  end

  def add_carriage
    if self.speed == 0
      self.carriages += 1
    else
      puts "Поезд движется. Остановите поезд для добавления вагона."
    end
  end

  def remove_carriage
    if self.speed == 0
      if self.carriages > 0
        self.carriages -= 1
      else
        puts "Нельзя убрать вагон, т.к. у поезда нет прицепленных вагонов."
      end
    else
      puts "Поезд движется. Остановите поезд для отцепки вагона."
    end
  end

  def set_route(route)
    route.stations_list[0].receive_train(self)
    self.route = route
  end

  def move_forward
    if station_index < @route.stations_list.size - 1
      @route.stations_list.at(@station_index).send_train(self)
      self.station_index += 1
      @route.stations_list.at(@station_index).receive_train(self)
    else
      puts "Вы на конечной станции."
    end
  end

  def move_backward
    if station_index > 0
      @route.stations_list.at(@station_index).send_train(self)
      self.station_index -= 1
      @route.stations_list.at(@station_index).receive_train(self)
    else
      puts "Вы в начале пути. На предыдущую станцию нельзя вернуться."
    end
  end

  def show_stations
    result = []
    result << self.route.stations_list[station_index - 1] if station_index != 0
    result << self.route.stations_list[station_index]
    result << self.route.stations_list[station_index + 1] if station_index < self.route.stations_list.size - 1
    return result
  end
end 
