# frozen_string_literal: true

def point_calc(point, first_add_times, second_add_times)
  retval = point * (first_add_times + 1)
  first_add_times = second_add_times
  second_add_times = 0
  [retval, first_add_times, second_add_times]
end

def judge_add_times_strike(first_add_times)
  tmp_first_add_times = first_add_times + 1
  [tmp_first_add_times, 1]
end

def judge_add_times(frame_points, frame)
  tmp_first_add_times = frame_points.sum == 10 && frame != 10 ? 1 : 0
  tmp_second_add_times = 0
  tmp_frame = frame + 1
  [tmp_first_add_times, tmp_second_add_times, [], tmp_frame]
end

def score_calc
  score = first_add_times = second_add_times = 0
  frame = 1
  frame_points = []
  ARGV[0].split(',').each do |p_str|
    point = p_str == 'X' ? 10 : p_str.to_i
    point_val, first_add_times, second_add_times = point_calc(point, first_add_times, second_add_times)
    score += point_val

    if p_str == 'X'
      if frame != 10
        first_add_times, second_add_times = judge_add_times_strike(first_add_times)
        frame += 1
      end
      next
    end
    frame_points << point
    next unless frame_points.size == 2

    first_add_times, second_add_times, frame_points, frame = judge_add_times(frame_points, frame)
  end
  puts score
end

score_calc
