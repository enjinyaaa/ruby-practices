# frozen_string_literal: true

def point_calc(point, first_add_times, second_add_times)
  [point * (first_add_times + 1), second_add_times, 0]
end

def judge_add_times_strike(p_str, first_add_times)
  return [first_add_times + 1, 1] if p_str == 'X'

  [first_add_times, 0]
end

def judge_add_times_spare(frame_points)
  [frame_points.sum == 10 ? 1 : 0, 0]
end

def score_calc
  score = first_add_times = second_add_times = 0
  frame = 1
  frame_points = []
  ARGV[0].split(',').each do |p_str|
    point = p_str == 'X' ? 10 : p_str.to_i
    point_val, first_add_times, second_add_times = point_calc(point, first_add_times, second_add_times)
    score += point_val
    next if frame == 10

    first_add_times, second_add_times = judge_add_times_strike(p_str, first_add_times)
    if second_add_times == 1
      frame += 1
      next
    end

    frame_points << point
    next unless frame_points.size == 2

    first_add_times, second_add_times = judge_add_times_spare(frame_points)
    frame_points.clear
    frame += 1
  end
  puts score
end

score_calc
