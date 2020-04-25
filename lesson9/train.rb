# frozen_string_literal: true

require './modules/manufacturer'
require './modules/instance_counter'
require './modules/validation'
require './modules/accessors'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation
  include Accessors

  NUMBER_FORMAT = /^[а-яa-z0-9]{3}-?[а-яa-z0-9]{2}$/i.freeze

  attr_accessor :number, :route, :carriages

  attr_reader :type

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

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
    unless speed.zero?
      raise 'Поезд движется. Остановите поезд для добавления вагона.'
    end

    carriages << carriage
  end

  def remove_carriage(carriage)
    unless speed.zero?
      raise 'Поезд движется. Остановите поезд для отцепки вагона.'
    end
    if carriages.empty?
      raise 'Нельзя убрать вагон, т.к. у поезда нет прицепленных вагонов.'
    end

    carriages.delete(carriage)
  end

  def add_route(route)
    route.stations[0].receive_train(self)
    self.route = route
  end

  def move_forward
    unless station_index < @route.stations.size - 1
      raise 'Вы на конечной станции.'
    end

    @route.stations.at(@station_index).send_train(self)
    self.station_index += 1
    @route.stations.at(@station_index).receive_train(self)
  end

  def move_backward
    unless station_index.positive?
      raise 'Вы в начале пути. На предыдущую станцию нельзя вернуться.'
    end

    @route.stations.at(@station_index).send_train(self)
    self.station_index -= 1
    @route.stations.at(@station_index).receive_train(self)
  end

  def show_stations(type)
    route.stations[@station_index - 1] if type == 'previous'
    route.stations[@station_index] if type == 'current'
    route.stations[@station_index + 1] if type == 'next'
  end

  def carriages_block
    @carriages.each { |carriage| yield(carriage) }
  end

  protected

  attr_accessor :station_index
  attr_accessor_with_history :speed
end
