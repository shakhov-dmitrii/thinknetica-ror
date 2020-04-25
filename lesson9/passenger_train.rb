# frozen_string_literal: true

class PassengerTrain < Train
  validate :number, :presence
  validate :number, :format, Train::NUMBER_FORMAT

  def initialize(number)
    super(number, 'passenger')
  end

  def add_carriage(carriage)
    if carriage.is_a?(PassengerCarriage)
      super(carriage)
    else
      puts 'Неподходящий тип вагона.'
    end
  end
end
