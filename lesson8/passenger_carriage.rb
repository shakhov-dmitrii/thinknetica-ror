# frozen_string_literal: true

class PassengerCarriage < Carriage
  attr_reader :places, :free_places

  def initialize(number, places)
    @places = places
    @free_places = places
    super(number, 'пассажирский')
  end

  def reserve_place
    raise 'Нет свободных мест.' if @free_places.zero?

    @free_places -= 1
  end

  def reserved_places
    @places - @free_places
  end
end
