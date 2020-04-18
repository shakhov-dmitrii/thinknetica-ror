require './Train'
require './Station'
require './Route'
require './Carriage'
require './cargo_train'
require './passenger_train'
require './cargo_carriage'
require './passenger_carriage'

@stations = []
@trains = []
@routes = []

def print_stations
  @stations.each_with_index {|s, i| print "[#{i}: #{s.name}] "}
end

def print_trains
  @trains.each_with_index {|t, i| print "[#{i}: #{t.type} №#{t.number}] "}
end

def print_routes
  @routes.each_with_index {|r, i| puts "[#{i}: #{r.stations}] "}
end

def create_station
  print "Введите название станции: "
  station_name = gets.chomp
  @stations << Station.new(station_name)
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
    puts "Нет такого типа поездов."
  end
end

def route_control
  if @stations.size > 1
    puts "Введите 1 для создания маршрута"
    puts "Введите 2 для редактирования маршрута"
    user_input = gets.chomp.to_i
    if user_input == 1
      puts "Доступные станции"
      print_stations
      print "Введите станцию отправления: "
      user_input = gets.chomp.to_i
      from = @stations[user_input]
      print "Введите конечную станцию: "
      user_input = gets.chomp.to_i
      to = @stations[user_input]
      @routes << Route.new(from, to)
      puts "Маршрут создан."
    elsif user_input == 2
      if @routes.any?
        puts "Введите номер маршрута для редактирования"
        print_routes
        user_input = gets.chomp.to_i
        selected_route = @routes[user_input]
        puts "Введите 1 для добавления станции в маршрут"
        puts "Введите 2 для удаления станции из маршрута"
        user_input = gets.chomp.to_i
        if user_input == 1
          puts "Выберите станцию для добавления в маршрут"
          print_stations
          user_input = gets.chomp.to_i
          selected_route.add_station(@stations[user_input])
          puts "Станция добавлена в маршрут."
        elsif user_input == 2
          if @routes.size > 0
            puts "Введите номер станции в маршруте для удаления"
            selected_route.stations.each_with_index {|s, i| print "[#{i}: #{s}] "}
            user_input = gets.chomp.to_i
            station_to_delete = selected_route.stations[user_input]
            selected_route.delete_station(station_to_delete)
            puts "Маршрут #{selected_route.stations} обновлен."
          else
            puts "Нельзя удалить начальную или конечную станцию из маршрута."
          end
        end
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
    puts "Выберите поезд для добавления вагона"
    print_trains
    user_input = gets.chomp.to_i
    selected_train = @trains[user_input]
    if selected_train.is_a?(PassengerTrain)
      selected_train.add_carriage(PassengerCarriage.new)
      puts "Добавлен пассажирский вагон."
    elsif selected_train.is_a?(CargoTrain)
      selected_train.add_carriage(CargoCarriage.new)
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
    puts "Выберите поезд для удаления вагона"
    print_trains
    user_input = gets.chomp.to_i
    selected_train = @trains[user_input]
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
    puts "Выберите поезд для перемещения"
    print_trains
    user_input = gets.chomp.to_i
    selected_train = @trains[user_input]
    print "Для перемещения вперед введите 1, для перемещения назад введите 2: "
    user_input = gets.chomp.to_i
    if selected_train.route != nil
      selected_train.move_forward if user_input == 1
      selected_train.move_backward if user_input == 2
    else
      puts "Нет маршрута для перемещения."
    end
  else
    puts "Нет маршрута или поезда. Перемещение поезда невохможно."
  end
end

def show_stat
  @stations.each do |station|
    puts "---------------------"
    puts "Станция #{station.name}. Поезда на станции: "
    
    station.trains.each { |train| puts "#{train.type} №#{train.number}"} if station.trains.any?
  end
end

loop do
  puts 'Введите 1 для создания станции'
  puts 'Введите 2 для создания поезда'
  puts 'Введите 3 для создания и редактирования маршрутов'
  puts 'Введите 4 для назначения маршрута поезду'
  puts 'Введите 5 для добавления вагона поезду'
  puts 'Введите 6 для удаления вагона поезду'
  puts 'Введите 7 для перемещения поезда по маршруту'
  puts 'Введите 8 для для просмотра списка станций и поездов на станциях'
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
    when 8 then show_stat
    when 0 then break
  end
end
