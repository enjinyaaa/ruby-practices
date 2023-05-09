# frozen_string_literal: true

require 'optparse'

COLUMN_MAX = 3

def filenames_to_columns(filenames, rows_num)
  columns = Array.new(COLUMN_MAX) { [] }
  filenames.each.with_index do |filename, index|
    columns[index / rows_num] << filename
  end
  columns
end

def format_output_strings(filenames)
  rows_num = (filenames.length.to_f / COLUMN_MAX).ceil
  columns = filenames_to_columns(filenames, rows_num)
  max_lengths_by_col = columns.map { |ary| ary.max_by(&:length)&.length }
  Array.new(rows_num) do |row_i|
    row = columns.filter_map.with_index do |column, col_i|
      column[row_i]&.ljust(max_lengths_by_col[col_i])
    end
    row.join('  ').rstrip
  end
end

def ls(args = ARGV)
  filepath = args[0].nil? ? '.' : args[0]
  filenames = Dir.glob("#{filepath}/*").map { |path| File.basename(path) }
  puts format_output_strings(filenames)
end

ls if __FILE__ == $PROGRAM_NAME
