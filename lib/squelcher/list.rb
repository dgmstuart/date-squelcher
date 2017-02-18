module Squelcher
  class List
    def initialize(date_formatter = DateFormatter.new, dates_parser = DatesParser.new)
      @date_formatter = date_formatter
      @dates_parser = dates_parser
    end

    def squelch(input)
      format_dates(parse_input(input))
    end

    private

    def format_dates(date_array)
      @date_formatter.format(date_array)
    end

    def parse_input(input)
      @dates_parser.parse(input)
    end
  end
end
