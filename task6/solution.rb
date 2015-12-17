module LazyMode
  def create_file(name, &block)
    file = File.new(name)
    file.instance_eval &block
    file
  end

  class Date
    YEAR_COUNT = 4
    MONTH_COUNT = 2
    DAY_COUNT = 2

    attr_reader :year
    attr_reader :month
    attr_reader :day

    def initialize(date_string)
      unless date_string =~ /^\d+-\d+-\d+$/
        raise ArgumentError, 'invalid date format'
      end

      splitted = date_string.split('-')

      @year = '0' * (YEAR_COUNT - splitted[0].size) + splitted[0]
      @month = '0' * (MONTH_COUNT - splitted[1].size) + splitted[1]
      @day = '0' * (DAY_COUNT - splitted[2].size) + splitted[2]
    end

    def to_s
      "%s-%s-%s" % [@year, @month, @day]
    end
  end

  class Note < File
    attr_reader :header
    attr_reader :file_name
    attr_reader :tags

    attr_accessor :body
    attr_accessor :status


    def initialize(header, file_name, *tags)
      @header = header
      @file_name = file_name
      @tags = tags
    end
  end

  class File
    attr_reader :name
    attr_reader :notes

    def initialize(name)
      @name = name
      @notes = []
    end

    def note(header, &block)
      @notes << Note.new(header, @name)
      @notes.last.instance_eval &block
    end

  end
end

a = LazyMode::Date.new('1994-5-6')
puts "Day: #{a.day} Month: #{a.month} Year: #{a.year}"
puts a.to_s
