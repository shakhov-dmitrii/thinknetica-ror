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
    @stations.each_with_index {|s, i| print "[#{i}: #{s.name}] "}
  end
  
  def print_trains
    @trains.each_with_index {|t, i| print "[#{i}: #{t.type} №#{t.number}] "}
  end
  
  def print_routes
    @routes.each_with_index {|r, i| puts "[#{i}: #{r.stations}] "}
  end
  
  def add_route
    puts "Доступные станции"
    print_stations
    print "Введите станцию отправления: "
    user_input = gets.chomp.to_i
    from = @stations[user_input]
    print "Введите конечную станцию: "
    user_input = gets.chomp.to_i
    to = @stations[user_input]
    @routes << Route.new(from, to)
  rescue RuntimeError => error
    puts "#{error.message}"
    retry
  ensure
    puts "Маршрут создан."
  end
  
  def add_station_to_route(route)
    puts "Выберите станцию для добавления в маршрут"
    print_stations
    user_input = gets.chomp.to_i
    route.add_station(@stations[user_input])
    puts "Станция добавлена в маршрут."
  end
  
  def remove_station_from_route(route)
    if @routes.size > 0
      puts "Введите номер станции в маршруте для удаления"
      route.stations.each_with_index {|s, i| print "[#{i}: #{s.name}] "}
      user_input = gets.chomp.to_i
      station_to_delete = route.stations[user_input]
      route.delete_station(station_to_delete)
      puts "Маршрут #{route.stations} обновлен."
    else
      puts "Нельзя удалить начальную или конечную станцию из маршрута."
    end
  end
  
  def edit_route
    puts "Введите номер маршрута для редактирования"
    print_routes
    user_input = gets.chomp.to_i
    selected_route = @routes[user_input]
    puts "Введите 1 для добавления станции в маршрут"
    puts "Введите 2 для удаления станции из маршрута"
    user_input = gets.chomp.to_i
    if user_input == 1
      add_station_to_route(selected_route)
    elsif user_input == 2
      remove_station_from_route(selected_route)
    end
  end
  
  def select_train
    puts "Выберите поезд:"
    print_trains
    user_input = gets.chomp.to_i
    @trains[user_input]
  end

  def create_station
    print "Введите название станции: "
    station_name = gets.chomp
    @stations << Station.new(station_name)
  rescue RuntimeError => error
    puts "#{error.message}"
    retry
  end
  
  def create_train
    print "Введите тип поезда (грузовой или пассажирский): "
    type = gets.chomp
    print "Введите номер маршрута: "
    number = gets.chomp
    if type == 'грузовой'
      @trains << CargoTrain.new(number)
    elsif type == 'пассажирский'
      @trains << PassengerTrain.new(number)
    else
      raise "Нет такого типа поездов."
    end
  rescue RuntimeError => error
    puts "#{error.message}"
    retry
  end
  
  def route_control
    if @stations.size > 1
      puts "Введите 1 для создания маршрута"
      puts "Введите 2 для редактирования маршрута"
      user_input = gets.chomp.to_i
      if user_input == 1
        add_route
      elsif user_input == 2
        if @routes.any?
          edit_route
        else
          puts "Маршрутов нет. Для редактирования маршрута нужно создать хотя бы один маршрут."
        end
      else
        puts "Ваша команда не распознана"
      end
    else
      puts "Недостаточно станций для маршрута"
    end
  end
  
  def set_route
    if @trains.any?
      if @routes.any?
        puts "Выберите поезд"
        print_trains
        user_input = gets.chomp.to_i
        selected_train = @trains[user_input]
        puts "Выберите маршрут"
        print_routes
        user_input = gets.chomp.to_i
        selected_train.set_route(@routes[user_input])
        puts "Задан новый маршрут для поезда #{selected_train}"
      else
        puts "Для задания маршрута поезду необходимо создать маршрут."
      end
    else
      puts "Для задания маршрута необходимо создать поезда."
    end
  end
  
  def add_carriage
    if @trains.any?
      selected_train = select_train
      if selected_train.is_a?(PassengerTrain)
        print "Введите количество пассажирских мест: "
        places = gets.chomp.to_i
        selected_train.add_carriage(PassengerCarriage.new(selected_train.carriages.size, places))
        puts "Добавлен пассажирский вагон."
      elsif selected_train.is_a?(CargoTrain)
        print "Введите объем вагона: "
        volume = gets.chomp.to_i
        selected_train.add_carriage(CargoCarriage.new(selected_train.carriages.size, volume))
        puts "Добавлен грузовой вагон."
      else
        puts "Для данного типа поездов нет вагонов."
      end
    else
      puts "Нужно создать хотя бы один поезд для добавления вагона."
    end
  end
  
  def remove_cariage
    if @trains.any?
      selected_train = select_train
      if selected_train.carriages.any?
        selected_train.remove_carriage(selected_train.carriages.last)
        puts "Вагон удален."
      else
        puts "У поезда нет вагонов."
      end
    else
      puts "Нужно создать хотя бы один поезд для удаления вагона."
    end
  end
  
  def move_train
    if @trains.any? && @routes.any?
      selected_train = select_train
      print "Для перемещения вперед введите 1, для перемещения назад введите 2: "
      user_input = gets.chomp.to_i
      if selected_train.route != nil
        selected_train.move_forward if user_input == 1
        selected_train.move_backward if user_input == 2
      else
        raise "Нет маршрута для перемещения."
      end
    else
      raise "Нет маршрута или поезда. Перемещение поезда невохможно."
    end  
  rescue RuntimeError => error
    puts "#{error.message}"
  end
  
  def load_train
    selected_train = select_train
    raise "У поезда отсутствуют вагоны" if selected_train.carriages.empty?
    puts "Выберите вагон"
    selected_train.carriages.each_with_index {|c, i| print "[#{i}: #{c.number}] "}
    user_input = gets.chomp.to_i
    selected_carriage = selected_train.carriages[user_input]
    if selected_carriage.is_a?(CargoCarriage)
      puts "Введите загружаемый объем"
      user_input = gets.chomp.to_i
      selected_carriage.reserve_volume(user_input)
    elsif selected_carriage.is_a?(PassengerCarriage)
      selected_carriage.reserve_place
      puts "Пассажир сел в вагон."
    end
  rescue RuntimeError => error
    puts "#{error.message}"
  end
  
  def show_stat
    @stations.each do |station|
      puts "---------------------"
      puts "Станция #{station.name}. Поезда на станции:"
      station.trains_block do |train|
        puts "Поезд: #{train.number}, #{train.type}, #{train.carriages.size}"
        puts "Выгоны: "
        if train.is_a?(PassengerTrain)
          train.carriages_block {|c| puts "#{c.number} пассажирский, #{c.free_places} свободно, #{c.reserved_places} занято"}
        elsif train.is_a?(CargoTrain)
          train.carriages_block {|c| puts "#{c.number} грузовой, #{c.free_volume} свободно, #{c.reserved_volume} занято"}
        end
      end
    end
  end
end
