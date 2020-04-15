=begin
Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя). Найти порядковый номер даты, 
начиная отсчет с начала года. Учесть, что год может быть високосным. (Запрещено использовать встроенные в ruby методы 
для этого вроде Date#yday или Date#leap?) Алгоритм опредления високосного года: www.adm.yar.ru
=end

months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

def is_leap_year?(year) 
  year % 4 == 0 && year % 100 != 0 || year % 400 == 0
end

puts "Введите число месяц и год"
day = gets.chomp.to_i
month = gets.chomp.to_i
year = gets.chomp.to_i

months[1] = 29 if is_leap_year?(year)

if month >= 1 && month <= 12 && months[month - 1] >= day
  result = 0
  result += months.take(month - 1).sum if month > 1
  result += day
  puts "Порядковый номер даты: #{result}"
else
  puts "Такой даты не существует"
end
