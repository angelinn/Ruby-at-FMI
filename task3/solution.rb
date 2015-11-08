
class Card
  SUITS = [:diamonds, :spades, :clubs, :hearts].freeze

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

class Hand
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def size()
    @cards.size
  end
end

class WarHand < Hand
  def play_card()
    @cards.shift
  end

  def allow_face_up?()
    @cards.size <= 3
  end
end

class WarDeck < Deck
  HAND_SIZE = 26
  TOTAL_CARDS = 52

  def Mooo_sodas_ASDA()
  end

  def deal()
    hand = []
    HAND_SIZE.times { hand << draw_top_card }
    WarHand.new(hand)
  end
end

class BeloteHand < Hand
  POWER = Hash[[7, 8, 9, :jack, :queen, :king, 10, :ace].map.with_index.to_a]

  def highest_of_suit(suit)
    highest = 0
    @cards.each { |card| highest = POWER[card] if card.rank > highest }

    highest
  end

  def belote?()
    kings = @cards.select { |card| card.rank == :king }
    kings.each do |king|
      return true if kings.select do |card|
        card.rank == :queen and card.suit == king.suit
      end
    end

    false
  end

  def n_in_a_row?(amount)
    @cards.sort! { |a, b| POWER[a.rank] <=> POWER[b.rank] }
    previous = @cards.first

    @cards.each do |current|
      matches = (current.suit == previous.suit and
                 current > previous) ? matches += 1 : 0

      return true if matches == amount
      previous = current
    end

    false
  end

  def tierce?()
    n_in_a_row(3)
  end

  def quarte?()
    n_in_a_row(4)
  end

  def quint?()
    n_in_a_row(5)
  end

  def carre_of_x?(rank)
    @cards.select { |card| card.rank == rank } .size == 4
  end

  def carre_of_jacks?()
    carre_of_x?(:jack)
  end

  def carre_of_jacks?()
    carre_of_x?(9)
  end

  def carre_of_jacks?()
    carre_of_x?(:ace)
  end
end

class BeloteDeck < Deck
  HAND_SIZE = 8
  TOTAL_CARDS = 32

  def deal()
  end
end

# cards = [Card.new(:ace, :spades),
#          Card.new(2, :hearts),
#          Card.new(3, :hearts),
#          Card.new(4, :carre)]


deck = WarDeck.new()
deck.shuffle()
puts deck.deal.cards.join ', '
