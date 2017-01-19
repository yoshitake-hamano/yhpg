
class Ordf01Twicel
  def initialize(problem)
    data  = problem.split(/\//)
    @data = data.map { |x| x.to_i(16) }
  end

  def black?(x, y)
    (@data[x] & 0x01 << y) != 0
  end

  def white?(x, y)
    !black?(x, y)
  end

  def same_color?(x, y, is_black)
    is_black ? black?(x, y): white?(x, y)
  end

  def count_same_color_in_surrounds(x, y)
    is_black = black?(x, y)
    count = 0
    count += 1 if x != 7 && same_color?(x+1, y, is_black)
    count += 1 if x != 0 && same_color?(x-1, y, is_black)
    count += 1 if y != 7 && same_color?(x, y+1, is_black)
    count += 1 if y != 0 && same_color?(x, y-1, is_black)
    count
  end

  def same_color_position(x, y)
    is_black = black?(x, y)
    return x+1, y if x != 7 && same_color?(x+1, y, is_black)
    return x-1, y if x != 0 && same_color?(x-1, y, is_black)
    return x, y+1 if y != 7 && same_color?(x, y+1, is_black)
    return x, y-1 if y != 0 && same_color?(x, y-1, is_black)
  end

  def two_size_region?(x, y)
    is_black = black?(x, y)
    count = count_same_color_in_surrounds(x, y)
    return false if count != 1

    next_x, next_y = same_color_position(x, y)
    count = count_same_color_in_surrounds(next_x, next_y)
    return false if count != 1

    return true
  end

  def solve
    black_count = 0
    white_count = 0

    for x in 0..7
      for y in 0..7
        next unless two_size_region?(x, y)
        black_count +=1 if black?(x, y)
        white_count +=1 if white?(x, y)
      end
    end
    black_count /= 2
    white_count /= 2
    "#{white_count},#{black_count}"
  end

  def to_s
    @data.join(",")
    str = "----------\n"
    @data.each_with_index do |elem, i|
      str += "|"
      str += (black?(i, 7) ? "X" : " ")
      str += (black?(i, 6) ? "X" : " ")
      str += (black?(i, 5) ? "X" : " ")
      str += (black?(i, 4) ? "X" : " ")
      str += (black?(i, 3) ? "X" : " ")
      str += (black?(i, 2) ? "X" : " ")
      str += (black?(i, 1) ? "X" : " ")
      str += (black?(i, 0) ? "X" : " ")
      str += "|\n"
    end
    str += "----------\n"
    str
  end
end

ok_count = 0
ng_count = 0
$stdin.each_line do |line|
  splitted_line = line.split(/ /)
  id       = splitted_line[0]
  problem  = splitted_line[1]
  expected = splitted_line[2].chomp

  ordf01 = Ordf01Twicel.new(problem)
  actual = ordf01.solve
  if expected == actual
    ok_count += 1
    puts "OK : #{id} #{problem} #{expected} #{actual}"
  else
    ng_count += 1
    puts "NG : #{id} #{problem} #{expected} #{actual}"
  end
  puts ordf01
end

puts "ok_count : #{ok_count}"
puts "ng_count : #{ng_count}"

exit(ng_count == 0? 0: 1)
