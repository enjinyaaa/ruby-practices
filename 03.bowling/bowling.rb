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

def frame_end_process(frame)
  [frame + 1, []]
end

def score_calc
  score = first_add_times = second_add_times = 0
  frame = 1
  frame_points = []
  ARGV[0].split(',').each do |p_str|
    point = p_str == 'X' ? 10 : p_str.to_i
    frame_points << point
    calc_point, first_add_times, second_add_times = point_calc(point, first_add_times, second_add_times)
    score += calc_point
    next if frame == 10

    first_add_times, second_add_times = judge_add_times_strike(frame_points, first_add_times)
    if frame_points.first == 10
      frame, frame_points = frame_end_process(frame)
      next
    end

    next if frame_points.size < 2

    first_add_times, second_add_times = judge_add_times_spare(frame_points)
    frame, frame_points = frame_end_process(frame)
  end
  puts score
end

score_calc
