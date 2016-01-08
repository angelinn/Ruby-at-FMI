class Spreadsheet
  class Error < StandardError
  end

  attr_accessor :cells

  def initialize(sheet = nil)
    return unless sheet
    @cells = []
    SheetUtilities.parse_sheet(@cells, sheet)
  end

  def empty?
    @cells.empty?
  end

  def cell_at(cell_index)
    cell = get_by_cell_index(cell_index)

    raise Error, "Cell '#{cell_index}' does not exist." unless cell
    cell
  end

  def [](cell_index)
    calculate_expression(cell_at(cell_index))
  end

  def to_s
    tab = ""
    @cells.each do |row|
      row.each { |cell| tab << "#{calculate_expression(cell)}\t" }
      tab.chop!
      tab << "\n"
    end
    tab.chop!
  end

  private

  def calculate_expression(expression)
    return expression if expression[0] != '='
    expression.match(/^=(\w+)\(((\s*[0-9\w]\s*,?)+)+\)$/)

    raise Error, "Invalid expression '#{expression}'" unless $1
    formula = Formulas.get_formula($1)

    args = formula_to_args($2)
    formula.calculate(*args).to_s
  end

  def formula_to_args(arguments)
    arguments.split(',').map do |argument|
      argument = get_by_cell_index(argument) if argument =~ /[A-Z]+[0-9]+/
      argument = argument.strip.to_i
    end
  end

  def get_by_cell_index(cell_index)
    cell_index.scan(/([A-Z]+)([0-9]+)/)
    raise Error, "Invalid index #{cell_index}." unless $1
    col = SheetUtilities.parse_col($1)
    row = $2.to_i - 1

    @cells[row][col] rescue nil
  end
end

class SheetUtilities
  def self.parse_sheet(cells, sheet)
    sheet.strip.split("\n").each do |row|
      next if row.empty?
      delimiter = row.include?("\t") ? "\t" : "  "

      current = []
      row.strip.split(delimiter).each { |cell| current << cell.strip }
      cells << current
    end
  end

  def self.parse_col(col)
    index = 0

    if col.size > 1
      col[0..col.size - 2].each_char do |c|
        index += (c.ord - ('A'.ord - 1)) * ('Z'.ord - 'A'.ord + 1)
      end
    end

    index += col[col.size - 1].ord - ('A'.ord - 1)
    index.to_i - 1
  end

  def self.exists?(cells, row, col)
    return false unless cells[row]
    cells[row][col] != nil
  end
end

module Formulas
  def self.get_formula(formula)
    object = Formulas.const_get(formula.downcase.capitalize).new rescue nil
    raise Spreadsheet::Error, "Unknown formula #{formula}" unless object
    object
  end

  class Formula
    LESS = "Wrong number of arguments for 'FOO': expected at least %s, got %s"
    MORE = "Wrong number of arguments for 'FOO': expected %s, got %s"

    attr_accessor :name
    attr_accessor :arguments_count

    def calculate(*args)
      raise StandardError, 'base class method should not be called'
    end

    def check_arguments(args)
      if args.count < @arguments_count
        raise Spreadsheet::Error, LESS % [@arguments_count, args.count]
      end

      if args.count > @arguments_count
        raise Spreadsheet::Error, MORE % [@arguments_count, args.count]
      end
    end
  end

  class Add < Formula
    def initialize
      @name = 'ADD'
      @arguments_count = 0
    end

    def calculate(*args)
      p args
      args.reduce { |a, b| a + b }
    end
  end

  class Multiply < Formula
    def initialize
      @name = 'MULTIPLY'
      @arguments_count = 0
    end

    def calculate(*args)
      args.reduce { |a, b| a * b }
    end
  end

  class Subtract < Formula
    def initialize
      @name = 'SUBTRACT'
      @arguments_count = 2
    end

    def calculate(*args)
      check_arguments(args)
      args.first - args.last
    end
  end

  class Divide < Formula
    def initialize
      @name = 'DIVIDE'
      @arguments_count = 2
    end

    def calculate(*args)
      check_arguments(args)
      args.first.to_f / args.last
    end
  end

  class Mod < Formula
    def initialize
      @name = 'MOD'
      @arguments_count = 2
    end

    def calculate(*args)
      check_arguments(args)
      args.first % args.last
    end
  end
end
