require './modules/instance_counter'

class Station
  include InstanceCounter

  attr_reader :name
  attr_reader :trains

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name) 
    @name = name
    validate!
    @trains = []
    @@stations << self
    register_instance
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
      raise "Поездов нет"
    end
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  protected
  def validate!
    raise "Имя отсутствует" if @name.nil?
    raise "Имя слишком короткое" if @name.length < 3
  end
end
