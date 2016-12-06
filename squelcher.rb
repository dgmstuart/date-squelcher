require "chronic"
require "pry"

class Squelcher
  class ParseError < StandardError; end

  SEPARATORS = /[\n,]/
  DAYNAMES = Date::DAYNAMES + ["Mon", "Tues", "Tue", "Weds", "Wed", "Thurs", "Thur", "Thu", "Fri", "Sat", "Sun"]

  def self.squelch(input)
    dates = parse_input(input)
    dates.map { |date| date.strftime("%d/%m/%Y") }
  end

  def self.parse_input(input)
    input = strip_daynames(input)
    date_strings = input.split(SEPARATORS).map{ |s| s.strip }
    parse_dates(date_strings)
  end

  def self.parse_dates(date_strings)
    date_strings.map do |date_string|
      Chronic.parse(date_string, :endian_precedence => :little).tap do |date|
        raise ParseError, "Failed to parse \"#{date_string}\" as a date" if date.nil?
      end
    end
  end

  def self.strip_daynames(input)
    output = input
    DAYNAMES.each { |day| output = output.gsub(/#{day}/, '') }
    output
  end
end

# TODO: separate out the output format - restructure the tests to some new context blocks : "when the output format is X"
