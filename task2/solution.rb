class RationalSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
    @rising, @finished = true, true
    @num, @denom = 1, 1
  end

  def each
    current = Rational(@num, @denom)
    total = [current]

    yield current if @limit != 0

    while total.count < @limit
      current = iteration(total)

      unless total.include? current
        yield current
        total << current
      end
    end
  end

  def iteration(total)
      if @rising and @finished
        @num += 1
        @rising = false
      elsif @finished
        @denom += 1
        @rising = true
      end

      if @finished
        @finished = false
        return Rational(@num, @denom)
      end

      @num, @denom = generate_parts()

      @finished = true if @num == 1 or @denom == 1
      Rational(@num, @denom)
    end

  def generate_parts()
    @rising ? [@num + 1, @denom - 1] : [@num - 1, @denom + 1]
  end
end

class Integer
  def prime?
    return true if self == 2
    return false if self % 2 == 0 or self < 2

    (3..self-1).step(2) { |current| return false if self % current == 0 }
    true
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
      if current.prime?
        yield current
        total += 1
      end

      current += 1
    end
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(limit, first: 1, second: 1)
    @limit = limit
    @first = first
    @second = second
  end

  def each
    current, previous = @second, @first
    total = 1

    yield @first

    while total < @limit
      yield current
      current, previous = current + previous, current
      total += 1
    end
  end
end

module DrunkenMathematician
  module_function

  def meaningless(n)
    rationals = RationalSequence.new(n).to_a
    primes = rationals.select { |rat| rat.numerator.prime? or rat.denominator.prime? }
    not_primes = rationals - primes

    primes_sum = primes.reduce { |a, b| a * b }
    primes_sum = 1 if not primes_sum

    primes_sum / not_primes.reduce { |a, b| a * b }
  end

  def aimless(n)
    primes = PrimeSequence.new(n).to_a
    primes = primes.each_slice(2).to_a

    primes[-1] << 1 if primes[-1].count == 1
    rationals = primes.map { |prime| Rational(prime[0], prime[1]) }
    rationals.reduce { |a, b| a + b }
  end

  def worthless(n)
    nth_fibonacci = FibonacciSequence.new(n).to_a[-1]
    rationals = RationalSequence.new(n).to_a

    sum = rationals.reduce { |a, b| a + b }
    while sum > nth_fibonacci
      rationals.pop
      sum = rationals.reduce { |a, b| a + b }
    end

    rationals
  end
end


sequence = PrimeSequence.new(5)
puts sequence.to_a.join(', ') # => [2, 3, 5, 7, 11]

sequence = FibonacciSequence.new(5)
puts sequence.to_a.join(', ') # => [1, 1, 2, 3, 5]

sequence = FibonacciSequence.new(5, first: 0 )
puts sequence.to_a.join(', ') # => [0, 1, 1, 2, 3]

seq = RationalSequence.new(15)
seq.each { |n| puts n }

puts DrunkenMathematician.meaningless(6)

puts DrunkenMathematician.aimless(4)

puts RationalSequence.new(0).to_a.join(', ')

puts DrunkenMathematician.worthless(5)

puts DrunkenMathematician.meaningless(1)