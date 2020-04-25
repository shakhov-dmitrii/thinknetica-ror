# frozen_string_literal: true

require './modules/instance_counter'
require './modules/validation'

class Route
  include InstanceCounter
  include Validation

  attr_reader :stations

  validate :stations, :presence

  def initialize(from, to)
    @stations = [from, to]
    validate!
    register_instance
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station)
  end
end
