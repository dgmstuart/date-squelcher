module Squelcher
  class Range
    def initialize(date_formatter = DateFormatter.new, dates_parser = DatesParser.new)
      @date_formatter = date_formatter
      @dates_parser = dates_parser
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
  end
end
