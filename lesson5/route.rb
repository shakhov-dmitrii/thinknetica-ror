require './modules/instance_counter'

class Route
  attr_reader :stations

  def initialize(from, to)
    @stations = [from, to]
    register_instance
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station)
  end
end
