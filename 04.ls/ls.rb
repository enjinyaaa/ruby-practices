# frozen_string_literal: true

require 'optparse'

COLUMN_MAX = 3
SPACE_NUM = 2

def filelist_to_columns(filename_array, rows_num)
  columns = []
  filename_array.each.with_index do |filename, index|
    if columns[index / rows_num].nil?
      columns[index / rows_num] = Array.new(1, filename)
    else
      columns[index / rows_num] << filename
    end
  end
  columns
end

def format_output_strings(filename_array)
  rows_num = filename_array.length / COLUMN_MAX
  rows_num += 1 if filename_array.length % COLUMN_MAX != 0
  columns = filelist_to_columns(filename_array, rows_num)
  columns_max_str_length = columns.each.map { |ary| ary.max_by(&:length).length }
  rows = []
  rows_num.times do |row_index|
    row = []
    columns.each.with_index do |column, column_index|
      row << column[row_index].ljust(columns_max_str_length[column_index]) unless column[row_index].nil?
    end
    rows << row.join(' ' * SPACE_NUM).rstrip
  end
  rows
end

def ls
  opt = OptionParser.new
  params = {}
  opt.parse!(ARGV, into: params)
  filepath = ARGV[0].nil? ? '.' : ARGV[0]
  filenames = Dir.glob("#{filepath}/*").map { |path| File.basename(path) }
  puts format_output_strings(filenames)
end

ls if __FILE__ == $PROGRAM_NAME
