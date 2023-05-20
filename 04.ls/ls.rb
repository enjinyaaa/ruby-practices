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

def args_option_parse(args)
  opt = OptionParser.new
  opt.on('-a')
  opt.on('-r')
  options = {}
  args = opt.parse(args, into: options)
  [args, options]
end

def ls(args = ARGV)
  parsed_args, options = args_option_parse(args)
  filepath = parsed_args[0] || '.'
  filenames = Dir.entries(filepath).sort
  reversed_filenames = filenames.reverse
  rejected_filenames = filenames.reject { |fname| fname.start_with?('.') }
  reversed_and_rejected_filenames = rejected_filenames.reverse
  return format_output_strings(reversed_and_rejected_filenames).join("\n") + "\n" if options[:r] && !options[:a]
  return format_output_strings(reversed_filenames).join("\n") + "\n" if options[:r]
  return format_output_strings(filenames).join("\n") + "\n" if options[:a]

  format_output_strings(rejected_filenames).join("\n") + "\n" unless rejected_filenames.empty?
end

def ls_main(args = ARGV)
  output_strings = ls(args)
  print output_strings unless output_strings.nil?
end

ls_main if __FILE__ == $PROGRAM_NAME
