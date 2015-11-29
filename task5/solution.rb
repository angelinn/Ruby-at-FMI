module TurtleGraphics
  class Point
    attr_accessor :x
    attr_accessor :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def next(direction)
      case direction
        when :up    then Point.new(@x - 1, @y)
        when :right then Point.new(@x, @y + 1)
        when :down  then Point.new(@x + 1, @y)
        when :left  then Point.new(@x, @y - 1)
      end
    end
  end


  class Turtle
    DIRECTIONS = [:up, :right, :down, :left]

    attr_reader :canvas

    def initialize(rows, columns)
      @rows = rows
      @columns = columns
      @spawned = false

      init_canvas
      look(:right)
    end

    def init_canvas
      @canvas = []
      @rows.times { @canvas << Array.new(@columns, 0) }
    end

    def draw(drawer = nil, &block)
      instance_eval &block

      return @canvas unless drawer
      drawer.to_canvas(@canvas)
    end

    def move
      spawn_at(0, 0) unless @spawned

      next_position = @position.next(@looks_at)
      next_position.x %= @rows
      next_position.y %= @columns

      spawn_at(next_position.x, next_position.y)
    end

    def turn_left
      look(DIRECTIONS[DIRECTIONS.index(@looks_at) - 1])
    end

    def turn_right
      look(DIRECTIONS[(DIRECTIONS.index(@looks_at) + 1) % DIRECTIONS.size])
    end

    def spawn_at(row, column)
      @spawned = true
      @position = Point.new(row, column)
      @canvas[row][column] += 1
    end

    def look(orientation)
      unless (DIRECTIONS.include? orientation)
        raise ArgumentError, "'#{orientation}' is not a valid direction."
      end

      @looks_at = orientation
    end
  end

  module Canvas
    class ASCII
      def initialize(symbols)
        @symbols = symbols
      end

      def to_canvas(canvas)
        asci = ""
        canvas.each do |row|
          row.each { |cell| asci += drawer.symbols[cell] }
          asci += "\n"
        end

        asci
      end
    end

    class HTML
      HEADER = '<!DOCTYPE html><html><head>' \
               '<title>Turtle graphics</title>%s</head>'

      CSS    = '<style>table {border-spacing: 0;} tr{padding: 0;}' \
               'td {width: %spx;height: %spx;background-color: black;' \
               'padding: 0;}</style>'

      ENTRY  = '<td style="opacity: %s"></td>'


      def initialize(td_size)
        @document = HEADER % (CSS % [td_size, td_size])
      end

      def to_canvas(canvas)
        @document += '<body><table>'

        canvas.each do |row|
          @document += '<tr>'

          row.each do |cell|
            opacity = calculate_opacity(cell, row.max)
            @document += ENTRY % format('%.2f', opacity)
          end
          @document += '</tr>'
        end

        @document += '</table></body></html>'
      end

      def calculate_opacity(cell, max)
        max == 0 ? max : cell.to_f / max
      end
    end
  end
end

# html_canvas = TurtleGraphics::Canvas::HTML.new(5)
# html = TurtleGraphics::Turtle.new(3, 3).draw(html_canvas) do
#   move
#   turn_right
#   move
#   turn_left
#   move
# end

# p html

# canvas = TurtleGraphics::Canvas::HTML.new(5)
# html = TurtleGraphics::Turtle.new(200, 200).draw(canvas) do
#   spawn_at 100, 100

#   step = 0

#   4300.times do
#     is_left = (((step & -step) << 1) & step) != 0

#     if is_left
#       turn_left
#     else
#       turn_right
#     end
#     step += 1

#     move
#   end
# end

# File.write("dragon.html", html)
