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

def parse_args_option(args)
  opt = OptionParser.new
  opt.on('-a')
  opt.on('-r')
  options = {}
  args = opt.parse(args, into: options)
  [args, options]
end

def ls(args = ARGV)
  parsed_args, options = parse_args_option(args)
  filepath = parsed_args[0] || '.'
  filenames = Dir.entries(filepath).sort
  checked_filenames_by_option_a = options[:a] ? filenames : filenames.reject { |fname| fname.start_with?('.') }
  checked_filenames_by_option_r = options[:r] ? checked_filenames_by_option_a.reverse : checked_filenames_by_option_a
  "#{format_output_strings(checked_filenames_by_option_r).join("\n")}\n" unless checked_filenames_by_option_r.empty?
end

print ls(ARGV) if __FILE__ == $PROGRAM_NAME
