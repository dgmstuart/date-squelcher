require_relative "squelcher/dates_parser"
require_relative "squelcher/date_formatter"
require_relative "squelcher/list"
require_relative "squelcher/range"
require "pry"

module Squelcher
  class ParseError < StandardError; end
end
