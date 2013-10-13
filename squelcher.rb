require "chronic"

class Squelcher
  SEPARATORS = /[\n,]/
  def self.squelch(input)
    date_strings = input.split(SEPARATORS).map{ |s| s.strip }
    date_strings.map{ |date_string| Chronic.parse(date_string, :endian_precedence => :little).strftime("%d/%m/%Y") }
  end
end

# TODO: separate out the output format - restructure the tests to some new context blocks : "when the output format is X"   