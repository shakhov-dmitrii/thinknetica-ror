# frozen_string_literal: true

require './modules/manufacturer'

class Carriage
  include Manufacturer

  attr_reader :number, :type

  def initialize(number, type)
    @number = number
    @type = type
  end
end
