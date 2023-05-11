# frozen_string_literal: true

require 'optparse'

COLUMN_MAX = 3

def join_strings_by_row(rows, max_lengths_by_col)
  rows.map do |row|
    tmp_row = row.filter_map.with_index do |filename, index|
      filename&.ljust(max_lengths_by_col[index])
    end
    tmp_row.join('  ').rstrip
  end
end

def format_output_strings(filenames)
  rows_num = (filenames.length.to_f / COLUMN_MAX).ceil
  return nil if rows_num.zero?

  columns = filenames.each_slice(rows_num).map { |a| a }
  max_lengths_by_col = columns.map { |ary| ary.max_by(&:length)&.length }
  rows = columns.map { |a| a + Array.new(rows_num - a.size, nil) }.transpose
  join_strings_by_row(rows, max_lengths_by_col)
end

def ls(args = ARGV)
  filepath = args[0] || '.'
  filenames = Dir.glob(File.join(filepath, '*')).map { |path| File.basename(path) }
  output_strings = format_output_strings(filenames)
  puts output_strings unless output_strings.nil?
end

ls if __FILE__ == $PROGRAM_NAME
