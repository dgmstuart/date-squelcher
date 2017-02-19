require "chronic"

module Squelcher
  class DatesParser
    SEPARATORS = /[\n,]/
    DAYNAMES = Date::DAYNAMES + ["Mon", "Tues", "Tue", "Weds", "Wed", "Thurs", "Thur", "Thu", "Fri", "Sat", "Sun"]

    def parse(input)
      date_strings = strip_daynames(input)
        .split(SEPARATORS)
        .map{ |s| s.strip }
        .reject(&:empty?)
      date_strings = handle_ampersands(date_strings)
      parse_dates(date_strings)
    end

    private

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

    # "1st & 2nd February" => ["1st February", "2nd February"]
    def handle_ampersands(date_strings)
      date_strings.inject([]) do |array, date_string|
        if date_string.include?('&')
          partial_date, full_date = date_string.split('&')
          array << full_date.gsub(/\d+/, partial_date[/\d+/])
          array << full_date
        else
          array << date_string
        end
      end
    end
  end
end
