module TurtleGraphics
  class Point
    attr_accessor :x
    attr_accessor :y

    def initialize(x, y)
      set(x, y)
    end

    def set(x, y)
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
      @position = Point.new(0, 0)

      init_canvas()
      spawn_at(0, 0)
      look(:right)
    end

    def init_canvas()
      @canvas = []
      @rows.times { @canvas << Array.new(@columns, 0) }
    end

    def draw(drawer = nil, &block)
      instance_eval &block

      return @canvas unless drawer

      str = ""
      @canvas.each do |row|
        row.each { |cell| str += drawer.symbols[cell] }
        str += "\n"
      end

      str
    end

    def move()
      @position = @position.next @looks_at
      spawn_at(@position.x, @position.y)
    end

    def turn_left()
      look(DIRECTIONS[DIRECTIONS.index(@looks_at) - 1])
    end

    def turn_right()
      look(DIRECTIONS[(DIRECTIONS.index(@looks_at) + 1) % DIRECTIONS.size])
    end

    def spawn_at(row, column)
      @canvas[row][column] += 1
    end

    def look(orientation)
      unless (DIRECTIONS.include? orientation)
        raise ArgumentError, "#{orientation} is not a valid direction."
      end

      @looks_at = orientation
    end
  end

  module Canvas
    class ASCII
      attr_reader :symbols

      def initialize(symbols)
        @symbols = symbols
      end
    end

    class HTML
      def initialize(size)
      end
    end
  end
end

ascii_canvas = TurtleGraphics::Canvas::ASCII.new([' ', '-', '=', '#'])
ascii = TurtleGraphics::Turtle.new(2, 2).draw(ascii_canvas) do
  move
  turn_right
  move
  2.times { turn_right }
  move
  turn_left
  move
  turn_left
  move
  2.times { turn_right }
  move
end

puts ascii
