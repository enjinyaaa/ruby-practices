# frozen_string_literal: true

score = 0
frame = 1
round_point = 0
first_shot = false
first_add_times = 0
second_add_times = 0

def str2point(str)
  if str == 'X'
    10
  else
    str.to_i
  end
end

def point_calc(point, first_add_times, second_add_times)
  retval = point
  if first_add_times
    retval += point * first_add_times
    first_add_times = second_add_times
    second_add_times = 0
  end
  [retval, first_add_times, second_add_times]
end

ARGV[0].split(',').each do |p_str|
  point = str2point(p_str)

  point_val, first_add_times, second_add_times = point_calc(point, first_add_times, second_add_times)
  score += point_val

  if p_str == 'X' && point == 10
    if frame != 10
      first_add_times += 1
      second_add_times = 1
      frame += 1
    end
  elsif !first_shot
    round_point = point
    first_shot = true
  else
    first_shot = false
    round_point += point
    first_add_times = if round_point == 10 && frame != 10
                        1
                      else
                        0
                      end
    second_add_times = 0
    round_point = 0
    frame += 1
  end
end
puts score
