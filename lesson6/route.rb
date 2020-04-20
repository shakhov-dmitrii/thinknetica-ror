require './modules/instance_counter'

class Route
  include InstanceCounter

  attr_reader :stations

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

  def valid?
    validate!
    true
  rescue
    false
  end

  protected
  def validate!
    raise "Отсутствует первая станция." if @stations.first.nil?
    raise "Отсутствует конечная станция." if @stations.last.nil?
    raise "Первая и конечная станции не должны совпадать." if @stations.first == @stations.last
  end
end
