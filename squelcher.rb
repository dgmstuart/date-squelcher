require "chronic"
require "pry"
class Squelcher
  class ParseError < StandardError; end
  
  SEPARATORS = /[\n,]/
  
  def self.squelch(input)
    input = strip_daynames(input)
    date_strings = input.split(SEPARATORS).map{ |s| s.strip }
    date_strings.map do |date_string| 
      date = Chronic.parse(date_string, :endian_precedence => :little)

      raise ParseError, "Failed to parse \"#{date_string}\" as a date" if date.nil?

      date.strftime("%d/%m/%Y")
    end
  end

  private

  def self.strip_daynames(input)
    output = input
    Date::DAYNAMES.each { |day| output = output.gsub(/#{day}/, '') }
    output
  end 
end

# TODO: separate out the output format - restructure the tests to some new context blocks : "when the output format is X"   
