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
  columns = filenames.each_slice(rows_num).to_a
  max_lengths_by_col = columns.map { |col| col.max_by(&:length)&.length }
  rows = columns.map { |col| col + Array.new(rows_num - col.size, nil) }.transpose
  join_strings_by_row(rows, max_lengths_by_col)
end

def ls(args = ARGV)
  opt = OptionParser.new
  opt.on('-a')
  options = {}
  opt.parse!(args, into: options)
  glob_flag = options[:a] ? File::FNM_DOTMATCH : 0
  filepath = args[0] || '.'
  filenames = Dir.glob(File.join(filepath, '*'), glob_flag).map { |path| File.basename(path) }
  puts format_output_strings(filenames) unless filenames.empty?
end

ls if __FILE__ == $PROGRAM_NAME
