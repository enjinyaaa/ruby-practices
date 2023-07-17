# frozen_string_literal: true

require 'optparse'
require 'etc'

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

def format_file_stat(filepath, filenames)
  total_of_blocks = 0
  rows = filenames.map do |filename|
    path = File.join(filepath, filename)
    filestat = File.lstat(path)
    total_of_blocks += filestat.blocks
    filestat_mode_str = format('%06o', filestat.mode)
    file_types = { '01' => 'p', '02' => 'c', '04' => 'd', '06' => 'b', '10' => '-', '12' => 'l', '14' => 's' }
    permission_types = { '0' => '---', '1' => '--x', '2' => '-w-', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }
    row = []
    filetype_permissions_str = file_types[filestat_mode_str.slice(0..1)]
    filestat_mode_str.slice(3..5).split('').each do |permission|
      filetype_permissions_str += permission_types[permission]
    end
    row.append(filetype_permissions_str, filestat.nlink.to_s, Etc.getpwuid(filestat.uid).name, Etc.getgrgid(filestat.gid).name,
               filestat.size.to_s, format('%2d月', filestat.mtime.month), filestat.mtime.strftime('%e %k:%M'))
    file_types[filestat_mode_str.slice(0..1)] == 'l' ? row.append("#{filename} -> #{File.readlink(path)}") : row.append(filename)
  end
  [total_of_blocks, rows]
end

def long_format_output_strings(filepath, filenames)
  total_of_blocks, rows = format_file_stat(filepath, filenames)
  max_lengths_by_col = rows.transpose.map { |col| col.max_by(&:length)&.length }
  output_strings = rows.map do |row|
    row.map.with_index do |output_str, index|
      index != max_lengths_by_col.length - 1 ? output_str.rjust(max_lengths_by_col[index]) : output_str
    end.join(' ')
  end
  output_strings.unshift("合計 #{total_of_blocks / 2}")
end

def parse_args_option(args)
  opt = OptionParser.new
  opt.on('-a')
  opt.on('-r')
  opt.on('-l')
  options = {}
  args = opt.parse(args, into: options)
  [args, options]
end

def ls(args = ARGV)
  parsed_args, options = parse_args_option(args)
  filepath = parsed_args[0] || '.'
  filenames = Dir.entries(filepath).sort
  target_filenames = options[:a] ? filenames : filenames.reject { |fname| fname.start_with?('.') }
  sorted_filenames = options[:r] ? target_filenames.reverse : target_filenames
  return nil if sorted_filenames.empty?

  options[:l] ? "#{long_format_output_strings(filepath, sorted_filenames).join("\n")}\n" : "#{format_output_strings(sorted_filenames).join("\n")}\n"
end

print ls(ARGV) if __FILE__ == $PROGRAM_NAME
