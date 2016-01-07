class Spreadsheet
  class Error < StandardError
  end

  attr_accessor :cells

  def initialize(sheet = nil)
    @cells = []

    return unless sheet
    parse_sheet(sheet)
  end

  def empty?
    @cells.empty?
  end

  def cell_at(cell_index)
    scanned = cell_index.scan(/([A-Z]+)([0-9]+)/)
    raise Error, "Invalid index #{cell_index}." if scanned.empty?

    row, col = parse_row(scanned.first.first), scanned.first.last.to_i - 1

    raise Error, "Cell #{cell_index} does not exist." unless @cells[row][col]
    @cells[row][col]
  end

  private
  def parse_sheet(sheet)
      sheet.strip.split("\n").each do |row|
      next if row.empty?
      delimiter = row.include?("\t") ? "\t" : "  "

      current = []
      row.strip.split(delimiter).each { |cell| current << cell.strip }
      @cells << current
    end
  end

  def parse_row(row)
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


str = "\ncell1\tcell2\tcell3\n\nanother1  another2"
a = Spreadsheet.new(str)
p a.cell_at('A1')
p a.cell_at('B2')

