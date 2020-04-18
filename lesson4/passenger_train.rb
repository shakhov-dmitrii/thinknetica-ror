class PassengerTrain < Train
  def initialize(number)
    super(number, "пассажирский")
  end

  def add_carriage(carriage)
    if carriage.is_a?(PassengerCarriage)
      super(carriage)
    else
      puts "Неподходящий тип вагона."
    end
  end
end
