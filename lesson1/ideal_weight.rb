=begin
Идеальный вес. Программа запрашивает у пользователя имя и рост и выводит идеальный вес по формуле (<рост> - 110) * 1.15, 
после чего выводит результат пользователю на экран с обращением по имени. Если идеальный вес получается отрицательным, то 
выводится строка "Ваш вес уже оптимальный"    
=end

print "Введите ваше имя: "
user_name = gets.chomp
user_name.capitalize!
print "Введите ваш рост: "
user_height = gets.chomp

ideal_weight = (user_height.to_i - 110) * 1.15

if ideal_weight <0
  puts "Ваш вес уже оптимальный" if ideal_weight < 0
else
  puts "#{user_name}, ваш идеальный вес: #{ideal_weight} килограмм"
end
