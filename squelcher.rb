require "chronic"
require "pry"

class Squelcher
  class ParseError < StandardError; end

  def initialize(date_formatter = DateFormatter.new, dates_parser = DatesParser.new)
    @date_formatter = date_formatter
    @dates_parser = dates_parser
  end

  def squelch(input)
    format_dates(parse_input(input))
  end

  def between(input)
    boundary_dates = parse_input(input)
    raise ArgumentError, "need two dates" unless boundary_dates.count == 2

    format_dates(dates_between(boundary_dates.first, boundary_dates.last))
  end

  private

  def dates_between(first_date, last_date)
    d = first_date + 7*60*60*24
    dates = []
    while d < last_date do
      dates << d
      d += 7*60*60*24
    end

    dates
  end

  def format_dates(date_array)
    @date_formatter.format(date_array)
  end

  def parse_input(input)
    @dates_parser.parse(input)
  end

  class DatesParser
    SEPARATORS = /[\n,]/
    DAYNAMES = Date::DAYNAMES + ["Mon", "Tues", "Tue", "Weds", "Wed", "Thurs", "Thur", "Thu", "Fri", "Sat", "Sun"]

    def parse(input)
      date_strings = strip_daynames(input)
        .split(SEPARATORS)
        .map{ |s| s.strip }
        .reject(&:empty?)
      parse_dates(date_strings)
    end

    def parse_dates(date_strings)
      date_strings.map { |date_string| parse_date(date_string) }
    end

    def parse_date(date_string)
      Chronic.parse(date_string, :endian_precedence => :little).tap do |date|
        raise ParseError, "Failed to parse \"#{date_string}\" as a date" if date.nil?
      end
    end

    def strip_daynames(input)
      output = input
      DAYNAMES.each { |day| output = output.gsub(day, '') }
      output
    end
  end

  class DateFormatter
    def format(date_array)
      date_array.map { |date| date.strftime("%d/%m/%Y") }
    end
  end
end
