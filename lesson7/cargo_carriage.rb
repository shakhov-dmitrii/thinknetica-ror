class CargoCarriage < Carriage
  attr_reader :volume, :free_volume

  def initialize(number, volume)
    @volume = volume
    @free_volume = volume
    super(number)
  end

  def reserve_volume(volume)
    raise "Недостаточно объема." if @free_volume < volume
    @free_volume -= volume
  end

  def reserved_volume
    @volume - @free_volume
  end

end
