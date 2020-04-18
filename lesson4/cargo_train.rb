class CargoTrain < Train
  def initialize(number)
    super(number, "грузовой")
  end

  def add_carriage(carriage)
    if carriage.is_a?(CargoCarriage)
      super(carriage)
    else
      puts "Неподходящий тип вагона."
    end
  end
end
