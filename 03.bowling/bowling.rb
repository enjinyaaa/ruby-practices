# frozen_string_literal: true

def point_calc(point, first_add_times, second_add_times)
  retval = point * (first_add_times + 1)
  first_add_times = second_add_times
  second_add_times = 0
  [retval, first_add_times, second_add_times]
end

score = 0
frame = 1
round_point = 0
first_shot = false
first_add_times = 0
second_add_times = 0
ARGV[0].split(',').each do |p_str|
  point = p_str == 'X' ? 10 : p_str.to_i
  point_val, first_add_times, second_add_times = point_calc(point, first_add_times, second_add_times)
  score += point_val

  if p_str == 'X'
    if frame != 10
      first_add_times += 1
      second_add_times = 1
      frame += 1
    end
    next
  end

  if !first_shot
    round_point = point
    first_shot = true
  else
    first_shot = false
    round_point += point
    first_add_times = round_point == 10 && frame != 10 ? 1 : 0
    second_add_times = 0
    round_point = 0
    frame += 1
  end
end
puts score
