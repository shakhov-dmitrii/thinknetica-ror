=begin
Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1)
=end

vowels = "aeiouy".chars
result = {}

("a".."z").each.with_index(1) do |char, index|
  result[char] = index if vowels.include?(char)
end

puts result.inspect
