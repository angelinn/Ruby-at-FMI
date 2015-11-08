
class Card
  attr_reader :rank
  attr_reader :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s()
    "#{@rank.capitalize rescue @rank} of #{@suit.capitalize}"
  end

  def ==(other)
    @rank == other.rank and @suit == other.suit
  end
end

class Deck
  include Enumerable

  attr_reader :cards

  def initialize(cards = nil)
    @cards = cards ? cards : generate_all_cards()
  end

  def size()
    @cards.size
  end

  def draw_top_card()
    @cards.shift
  end

  def draw_bottom_card()
    @cards.pop
  end

  def top_card()
    @cards.first
  end

  def bottom_card()
    @cards.last
  end

  def shuffle()
    @cards.shuffle!
  end

  def sort()
    @cards.sort! { |a, b| [b.suit, b.rank] <=> [a.suit, a.rank] }
  end

  def to_s()
    @cards.each { |card| puts card }
  end

  def deal()
    nil
  end

  def each()
    @cards.each { |card| yield card }
  end

  def generate_all_cards()
    suits = [:spades, :hearts, :diamons, :clubs]
    ranks = (2..10).to_a + [:jack, :queen, :king, :ace]
    cards = []

    suits.each { |suit| ranks.each { |rank| cards << Card.new(rank, suit) } }
    cards
  end
end

class WarHand
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def play_card()
    @cards.shift
  end

  def allow_face_up?()
    @cards.size <= 3
  end
end

class WarDeck < Deck
  HAND_SIZE = 26

  def deal()
    hand = []
    HAND_SIZE.times { hand << draw_top_card }
    WarHand.new(hand)
  end
end

# cards = [Card.new(:ace, :spades),
#          Card.new(2, :hearts),
#          Card.new(3, :hearts),
#          Card.new(4, :carre)]


deck = WarDeck.new();
deck.shuffle()
puts deck.deal.cards.join ', '
