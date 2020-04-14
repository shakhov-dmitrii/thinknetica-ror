=begin
Заполнить массив числами фибоначчи до 100
=end

MAX_NUMBER = 100

def fibonacci(n)
  return n if n <= 1
  fibonacci(n - 1) + fibonacci(n - 2)
end

result = []
counter = 1
tmp = fibonacci(counter)

while tmp < MAX_NUMBER
  result << tmp
  counter += 1
  tmp = fibonacci(counter)
end

puts result.inspect
