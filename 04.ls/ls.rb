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

def option_a_process(filenames, options)
  if !options[:a]
    filenames.reject { |fname| fname.start_with?('.') } unless options[:a]
  else
    filenames
  end
end

def option_r_process(filenames, options)
  if options[:r]
    filenames.reverse
  else
    filenames
  end
end

def ls(args = ARGV)
  parsed_args, options = parse_args_option(args)
  filepath = parsed_args[0] || '.'
  filenames = Dir.entries(filepath).sort
  option_a_processed_fnames = option_a_process(filenames, options)
  option_r_processed_fnames = option_r_process(option_a_processed_fnames, options)
  "#{format_output_strings(option_r_processed_fnames).join("\n")}\n" unless option_r_processed_fnames.empty?
end

print ls(ARGV) if __FILE__ == $PROGRAM_NAME
