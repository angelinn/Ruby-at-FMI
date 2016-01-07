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
    coordinates = get_row_col(cell_index)
    row, col = coordinates[:row], coordinates[:col]

    raise Error, "Cell #{cell_index} does not exist." unless @cells[row][col]
    @cells[row][col]
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
    expression
  end

  def get_row_col(cell_index)
    scanned = cell_index.scan(/([A-Z]+)([0-9]+)/)
    raise Error, "Invalid index #{cell_index}." if scanned.empty?

    { :row => SheetUtilities.parse_row(scanned.first.first),
      :col => scanned.first.last.to_i - 1 }
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

  def self.parse_row(row)
    index = 0

    if row.size > 1
      row[0..row.size - 2].each_char do |c|
        index += (c.ord - ('A'.ord - 1)) * ('Z'.ord - 'A'.ord + 1)
      end
    end

    index += row[row.size - 1].ord - ('A'.ord - 1)
    index.to_i - 1
  end
end

class Formula
  LESS = "Wrong number of arguments for 'FOO': expected at least %s, got %s"
  MORE = "Wrong number of arguments for 'FOO': expected %s, got %s"
  attr_accessor :name
  attr_accessor :arguments_count

  def calculate(*args)
    raise StandardError, 'base class method should not be called'
  end

  def check_arguments
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
    check_arguments
    args.first - args.last
  end
end

class Divide < Formula
  def initialize
    @name = 'DIVIDE'
    @arguments_count = 2
  end

  def calculate(*args)
    check_arguments
    args.first / args.last
  end
end

class Mod < Formula
  def initialize
    @name = 'MOD'
    @arguments_count = 2
  end

  def calculate(*args)
    check_arguments
    args.first % args.last
  end
end

string = "\ncell1\tcell2\tcell3\n\nanother1  another2"
a = Spreadsheet.new(string)
p a.cell_at('A1')
p a['B2']
p a.to_s
