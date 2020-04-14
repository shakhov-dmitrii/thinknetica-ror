=begin
Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1)
=end

vowels = "aeiouy".chars
result = Hash.new

("a".."z").each_with_index do |char, index|
  result[char] = index + 1 if vowels.include?(char)
end

puts result.inspect
