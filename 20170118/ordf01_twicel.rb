#!/bin/env ruby
# File: ordf01_twicel.rb - last edit:
# yoshitake 20-Jan-2017

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
DATA.each_line do |line|
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

# Log
# 19-Jan-2017 yoshitake Created.
# 20-Jan-2017 yoshitake Refactor
__END__
0 dc/bc/a7/59/03/d5/d4/ea 2,3
1 ff/ff/ff/ff/ff/ff/ff/ff 0,0
2 00/00/00/00/00/00/00/00 0,0
3 cc/33/cc/33/cc/33/cc/33 16,16
4 aa/aa/55/55/aa/aa/55/55 16,16
5 ac/a3/5c/53/ca/3a/c5/35 8,8
6 db/00/db/00/db/00/aa/aa 0,13
7 24/24/db/24/24/db/24/24 0,12
8 d7/d7/e9/f1/f7/de/60/56 3,2
9 17/7d/64/9b/a5/39/53/a6 2,2
10 bb/8f/18/fb/89/c2/c7/35 1,2
11 6d/63/20/08/54/cd/32/4f 2,2
12 a9/ca/cd/46/99/e6/f0/30 2,2
13 5b/70/fd/45/e2/a1/ab/9a 1,2
14 24/e4/a8/12/e1/a6/3f/f3 2,1
15 79/32/2e/07/d5/10/e7/9d 2,2
16 60/bc/ab/ec/1f/eb/63/2c 4,2
17 a5/dd/92/4e/67/c6/dc/34 6,1
18 aa/96/6d/67/d2/a8/ac/90 3,2
19 95/72/7d/5c/47/dc/ef/99 4,0
20 17/d6/6a/27/1f/25/26/b8 2,1
21 f0/f3/76/c5/31/ca/6b/ae 1,2
22 01/59/26/fa/8c/70/12/cd 1,4
23 1a/c3/1f/0b/83/b6/81/0d 0,5
24 4c/49/05/cf/54/bb/1f/da 1,2
25 eb/7c/d5/09/2a/c2/14/6b 0,7
26 b4/d3/4c/c4/ed/19/e8/63 1,3
27 bd/bc/6d/60/9b/00/9a/32 2,4
28 94/97/3f/e3/c7/06/15/c0 2,2
29 5f/1d/67/16/b8/f7/0a/2a 2,2
30 df/e6/f9/4f/59/e9/1f/ee 3,0
31 5a/53/9a/9a/73/b4/37/07 3,2
32 bd/87/7c/e7/c0/37/82/da 2,3
33 3d/c0/13/ac/57/3d/15/78 2,2
34 63/64/54/3a/40/28/4e/4e 0,3
35 f6/81/c9/15/00/4c/a0/a8 1,4
36 19/41/df/f8/e3/74/6b/9b 4,2
37 d5/0b/dd/35/3b/d2/0b/6b 1,5
38 08/b7/91/f3/6e/3c/74/a0 0,0
39 b8/a8/b4/a6/93/2c/94/3f 0,0
40 88/22/21/ee/dc/19/43/01 0,0
41 e1/ee/35/bc/fc/00/8e/fe 0,0
42 3c/42/63/5f/27/47/07/90 0,0
