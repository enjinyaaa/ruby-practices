require "optparse"
require "date"

class Cal

  CHARNUM_OF_WEEK = ("11 " * 7).length - 1
  DAY_OF_WEEK_STRING = "日 月 火 水 木 金 土"

  def initialize
    @year = Date.today.year
    @month = Date.today.month
  end

  def usage
    puts "cal.rb [-m month] [-y year]"
    puts "-m: month (1-12)"
    puts "  ex) -m 12"
    puts "-y: year (1970-2100) (This option also need month option)"
    puts "  ex) -y 2023 -m 12"
  end

  def usage_exit
    usage
    exit false
  end

  def parse_arguments
    begin
      options = ARGV.getopts('y:', 'm:')
    rescue OptionParser::MissingArgument
      usage_exit
    end
    usage_exit if options["y"] && options["m"].nil? # If not found parameter values, exit.
    if options["y"]
      year = options["y"].to_i
      usage_exit if year < 1970 || year > 2100 # Year range is 1970-2100
      @year = year
    end
    if options["m"]
      month = options["m"].to_i
      usage_exit if month < 1 || month > 12 # Month range is 1-12
      @month = month
    end
  end

  def prepare_display
    @firstday = Date.new(@year,@month,1)
    @lastday = Date.new(@year,@month,-1)
  end

  def display
    prepare_display
    puts "#{@month}月 #{@year}".center(CHARNUM_OF_WEEK)
    puts DAY_OF_WEEK_STRING
    week_array = []
    (@firstday..@lastday).each do |each_day|
      week_array.push(each_day.day.to_s.rjust(2))
      if each_day.saturday?
        puts week_array.join(" ").rjust(CHARNUM_OF_WEEK)
        week_array.clear
      elsif each_day == @lastday
        puts week_array.join(" ")
      end
    end
  end
end

cal = Cal.new
cal.parse_arguments
cal.display
