require './modules/manufacturer'
require './modules/instance_counter'

class Train
  include Manufacturer
  include InstanceCounter

  attr_accessor :number, :route, :carriages

  attr_reader :type

  NUMBER_FORMAT = /^[а-яa-z0-9]{3}-?[а-яa-z0-9]{2}$/i

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number, type)
    @number = number
    @type = type.downcase

    validate!

    @carriages = []
    @speed = 0
    @station_index = 0
    @route = []
    @@trains[number] = self
    register_instance
  end

  def stop
    self.speed = 0
  end

  def add_carriage(carriage)
    if self.speed == 0
      self.carriages << carriage
    else
      raise "Поезд движется. Остановите поезд для добавления вагона."
    end
  end

  def remove_carriage(carriage)
    if self.speed == 0
      if self.carriages.size > 0
        self.carriages.delete(carriage)
      else
        raise "Нельзя убрать вагон, т.к. у поезда нет прицепленных вагонов."
      end
    else
      raise "Поезд движется. Остановите поезд для отцепки вагона."
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
      raise "Вы на конечной станции."
    end
  end

  def move_backward
    if station_index > 0
      @route.stations.at(@station_index).send_train(self)
      self.station_index -= 1
      @route.stations.at(@station_index).receive_train(self)
    else
      raise "Вы в начале пути. На предыдущую станцию нельзя вернуться."
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

  def valid?
    valididate!
    true
  rescue
    false
  end

  protected 
  attr_accessor :station_index, :speed

  def validate!
    raise "Номер отсутствует" if @number.nil?
    raise "Неверная длина номера" if @number.length < 4 || @number.length > 7
    raise "Номер не соответствует формату" unless @number =~ NUMBER_FORMAT
    raise "Неверный тип поезда." unless @type == "грузовой" || @type == "пассажирский"
  end
end 
