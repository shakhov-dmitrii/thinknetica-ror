# frozen_string_literal: true

require './Train'
require './Station'
require './Route'
require './Carriage'
require './cargo_train'
require './passenger_train'
require './cargo_carriage'
require './passenger_carriage'

class Interface
  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def run
    loop do
      puts 'Введите 1 для создания станции'
      puts 'Введите 2 для создания поезда'
      puts 'Введите 3 для создания и редактирования маршрутов'
      puts 'Введите 4 для назначения маршрута поезду'
      puts 'Введите 5 для добавления вагона поезду'
      puts 'Введите 6 для удаления вагона поезду'
      puts 'Введите 7 для перемещения поезда по маршруту'
      puts 'Введите 8 для загрузки вагона'
      puts 'Введите 9 для для просмотра списка станций и поездов на станциях'
      puts 'Введите 0 для выхода'

      user_input = gets.chomp.to_i

      case user_input
      when 1 then create_station
      when 2 then create_train
      when 3 then route_control
      when 4 then set_route
      when 5 then add_carriage
      when 6 then remove_cariage
      when 7 then move_train
      when 8 then load_train
      when 9 then show_stat
      when 0 then break
      end
    end
  end

  private

  def print_stations
    puts 'Доступные станции'
    @stations.each_with_index { |s, i| print "[#{i}: #{s.name}] " }
  end

  def print_trains
    puts 'Выберите поезд'
    @trains.each_with_index { |t, i| print "[#{i}: #{t.type} №#{t.number}] " }
  end

  def print_routes
    puts 'Выберите маршрут'
    @routes.each_with_index { |r, i| puts "[#{i}: #{r.stations}] " }
  end

  def add_route
    print_stations
    print 'Введите станцию отправления: '
    from = gets.chomp.to_i
    print 'Введите конечную станцию: '
    to = gets.chomp.to_i
    @routes << Route.new(@stations[from], @stations[to])
    puts 'Маршрут создан.'
  rescue RuntimeError => e
    puts e.message.to_s
    retry
  end

  def add_station_to_route(route)
    puts 'Выберите станцию для добавления в маршрут'
    print_stations
    user_input = gets.chomp.to_i
    route.add_station(@stations[user_input])
    puts 'Станция добавлена в маршрут.'
  end

  def remove_station_from_route(route)
    if !@routes.empty?
      puts 'Введите номер станции в маршруте для удаления'
      route.stations.each_with_index { |s, i| print "[#{i}: #{s.name}] " }
      user_input = gets.chomp.to_i
      station_to_delete = route.stations[user_input]
      route.delete_station(station_to_delete)
      puts "Маршрут #{route.stations} обновлен."
    else
      puts 'Нельзя удалить начальную или конечную станцию из маршрута.'
    end
  end

  def edit_route
    puts 'Введите номер маршрута для редактирования'
    print_routes
    user_input = gets.chomp.to_i
    selected_route = @routes[user_input]
    puts 'Введите 1 для добавления станции в маршрут, 2 для удаления.'
    user_input = gets.chomp.to_i
    add_station_to_route(selected_route) if user_input == 1
    remove_station_from_route(selected_route) if user_input == 2
  end

  def select_train
    print_trains
    user_input = gets.chomp.to_i
    @trains[user_input]
  end

  def create_station
    print 'Введите название станции: '
    station_name = gets.chomp
    @stations << Station.new(station_name)
  rescue RuntimeError => e
    puts e.message.to_s
    retry
  end

  def create_train
    print 'Введите тип поезда (грузовой или пассажирский): '
    type = gets.chomp
    print 'Введите номер маршрута: '
    number = gets.chomp
    @trains << CargoTrain.new(number) if type == 'грузовой'
    @trains << PassengerTrain.new(number) if type == 'пассажирский'
  rescue RuntimeError => e
    puts e.message.to_s
    retry
  end

  def route_control
    raise 'Недостаточно станций для маршрута' unless @stations.size > 1

    puts 'Введите 1 для создания маршрута, 2 для редактирования'
    user_input = gets.chomp.to_i
    raise 'Команда не распознана' unless [1, 2].include?(user_input)

    add_route if user_input == 1
    raise 'Нужно создать хотя бы один маршрут.' unless @routes.any?

    edit_route if user_input == 2
  rescue RuntimeError => e
    puts e.to_s
  end

  def set_route
    raise 'Необходимо создать поезд.' unless @trains.any?
    raise 'Необходимо создать маршрут.' unless @routes.any?

    print_trains
    user_input = gets.chomp.to_i
    selected_train = @trains[user_input]
    print_routes
    user_input = gets.chomp.to_i
    selected_train.add_route(@routes[user_input])
  rescue RuntimeError => e
    puts e.to_s
  end

  def add_passenger_carriage(train)
    puts 'Введите количество пассажирских мест: '
    places = gets.chomp.to_i
    train.add_carriage(PassengerCarriage.new(train.carriages.size, places))
    puts 'Добавлен пассажирский вагон.'
  end

  def add_cargo_carriage(train)
    puts 'Введите объем вагона: '
    volume = gets.chomp.to_i
    train.add_carriage(CargoCarriage.new(train.carriages.size, volume))
    puts 'Добавлен грузовой вагон.'
  end

  def add_carriage
    raise 'Нужно создать хотя бы один поезд.' unless @trains.any?

    selected_train = select_train
    if selected_train.is_a?(PassengerTrain)
      add_passenger_carriage(selected_train)
    elsif selected_train.is_a?(CargoTrain)
      add_cargo_carriage(selected_train)
    end
  rescue RuntimeError => e
    puts e.to_s
  end

  def remove_cariage
    raise 'Нужно создать хотя бы один поезд' unless @trains.any?

    selected_train = select_train
    if selected_train.carriages.any?
      selected_train.remove_carriage(selected_train.carriages.last)
      puts 'Вагон удален.'
    else
      puts 'У поезда нет вагонов.'
    end
  rescue RuntimeError => e
    puts e.to_s
  end

  def move_train
    raise 'Нет маршрута или поезда.' unless @trains.any? && @routes.any?

    selected_train = select_train
    print 'Для перемещения вперед введите 1, назад введите 2: '
    user_input = gets.chomp.to_i
    raise 'Нет маршрута для перемещения.' if selected_train.route.nil?

    selected_train.move_forward if user_input == 1
    selected_train.move_backward if user_input == 2
  rescue RuntimeError => e
    puts e.message.to_s
  end

  def carriage_load(carriage)
    if carriage.is_a?(CargoCarriage)
      puts 'Введите загружаемый объем'
      user_input = gets.chomp.to_i
      carriage.reserve_volume(user_input)
    elsif carriage.is_a?(PassengerCarriage)
      carriage.reserve_place
      puts 'Пассажир сел в вагон.'
    end
  end

  def select_carriage(train)
    puts 'Выберите вагон'
    train.carriages.each_with_index do |c, i|
      print "[#{i}: #{c.number}] "
    end
    gets.chomp.to_i
  end

  def load_train
    selected_train = select_train
    raise 'У поезда отсутствуют вагоны' if selected_train.carriages.empty?

    user_input = select_carriage(selected_train)
    selected_carriage = selected_train.carriages[user_input]
    carriage_load(selected_carriage)
  rescue RuntimeError => e
    puts e.message.to_s
  end

  def show_carriages_stat(train)
    if train.is_a?(PassengerTrain)
      train.carriages_block do |c|
        puts "#{c.number} #{c.type}, #{c.free_places}, #{c.reserved_places}"
      end
    elsif train.is_a?(CargoTrain)
      train.carriages_block do |c|
        puts "#{c.number} #{c.type}, #{c.free_volume}, #{c.reserved_volume}"
      end
    end
  end

  def show_stat
    @stations.each do |station|
      puts '---------------------'
      puts "Станция #{station.name}. Поезда на станции:"
      station.trains_block do |train|
        puts "Поезд: #{train.number}, #{train.type}, #{train.carriages.size}"
        puts 'Выгоны (номер, тип, свобоно, занято):'
        show_carriages_stat(train)
      end
    end
  end
end
