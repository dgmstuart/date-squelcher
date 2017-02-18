module Squelcher
  class DateFormatter
    def format(date_array)
      date_array.map { |date| date.strftime("%d/%m/%Y") }
    end
  end
end
