# frozen_string_literal: true

require './modules/instance_counter'
require './modules/validation'

class Station
  include InstanceCounter
  include Validation

  attr_reader :name
  attr_reader :trains

  validate :name, :presence

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
    raise 'Поездов нет' unless @trains.any?

    @trains.select { |t| t.type == type }
  end

  def trains_block
    @trains.each { |train| yield(train) }
  end
end
