
class Card
  attr_reader :rank
  attr_reader :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s()
    "#{@rank} of #{@suit}"
  end

  def ==(other)
    @rank == other.rank and @suit == other.suit
  end
end

a = Card.new(:Ace, :Spades)
b = Card.new(:Ace, :Spades)
c = Card.new(:Ace, :Jewels)

puts a == b
puts a == c


