class RationalSequence
  def initialize(count)
    @count = count
  end

  def build_sequence()

  end
end

class PrimeSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    current, total = 2, 0

    while total < @limit
      if isPrime(current)
        yield current
        total += 1
      end

      current += 1
    end
  end

  def isPrime(number)
    return true if number == 2
    return false if number < 2 or number % 2 == 0

    (3..number - 1).step(2) { |current| return false if number % current == 0 }
    true
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(limit, first: 1, second: 0)
    @limit = limit
    @first = first
    @second = second
  end

  def each
    current, previous = @first, @second
    total = 0

    while total < @limit
      yield current
      current, previous = current + previous, current
      total += 1
    end
  end
end

sequence = PrimeSequence.new(5)
puts sequence.to_a.join(', ') # => [2, 3, 5, 7, 11]

sequence = FibonacciSequence.new(5)
puts sequence.to_a.join(', ') # => [1, 1, 2, 3, 5]

sequence = FibonacciSequence.new(5, first: 0, second: 1)
puts sequence.to_a.join(', ') # => [0, 1, 1, 2, 3]