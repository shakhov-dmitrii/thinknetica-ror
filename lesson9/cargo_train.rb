# frozen_string_literal: true

class CargoTrain < Train
  validate :number, :presence
  validate :number, :format, Train::NUMBER_FORMAT

  def initialize(number)
    super(number, 'cargo')
  end

  def add_carriage(carriage)
    if carriage.is_a?(CargoCarriage)
      super(carriage)
    else
      puts 'Неподходящий тип вагона.'
    end
  end
end
