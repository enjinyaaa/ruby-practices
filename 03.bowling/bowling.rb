# frozen_string_literal: true

def point_calc(point, first_add_times, second_add_times)
  [point * (first_add_times + 1), second_add_times, 0]
end

def judge_add_times_strike(frame_points, first_add_times)
  return [first_add_times + 1, 1] if frame_points.first == 10

  [first_add_times, 0]
end

def judge_add_times_spare(frame_points)
  [frame_points.sum == 10 ? 1 : 0, 0]
end

def arrays_clear(frame_points, frame_calc_array)
  frame_points.clear
  frame_calc_array.clear
end

def score_calc
  first_add_times = second_add_times = 0
  frame_points = []
  frame_calc_array = []
  game_points = []
  ARGV[0].split(',').each do |p_str|
    point = p_str == 'X' ? 10 : p_str.to_i
    frame_points << point
    calc_point, first_add_times, second_add_times = point_calc(point, first_add_times, second_add_times)
    frame_calc_array << calc_point
    next if game_points.size + 1 == 10

    first_add_times, second_add_times = judge_add_times_strike(frame_points, first_add_times)
    if frame_points.first == 10
      game_points << frame_calc_array.dup
      arrays_clear(frame_points, frame_calc_array)
      next
    end

    next if frame_points.size < 2

    first_add_times, second_add_times = judge_add_times_spare(frame_points)
    game_points << frame_calc_array.dup
    arrays_clear(frame_points, frame_calc_array)
  end
  game_points << frame_calc_array.dup
  puts game_points.flatten.sum
end

score_calc
