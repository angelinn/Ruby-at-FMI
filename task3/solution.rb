
class Card
  SUITS = [:diamonds, :spades, :clubs, :hearts].freeze
  RANKS = Hash[((2..10).to_a + [:jack, :queen, :king, :ace])
              .map.with_index.to_a]

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
    @cards.sort! do |a, b|
      [b.suit, Card::RANKS[b.rank]] <=> [a.suit, Card::RANKS[a.rank]]
    end
  end

  def to_s()
    @cards.each { |card| puts card }
  end

  def deal()
    hand = []
    hand_size().times { hand << draw_top_card }

    hand_class.new(hand)
  end

  def each()
    @cards.each { |card| yield card }
  end

  def generate_all_cards()
    cards = []
    Card::SUITS.each do |suit|
      Card::RANKS.keys.each { |rank| cards << Card.new(rank, suit) }
    end

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

  def hand_size()
    HAND_SIZE
  end

  def hand_class()
    WarHand
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

  def tierce?()
    n_in_a_row(3)
  end

  def quarte?()
    n_in_a_row(4)
  end

  def quint?()
    n_in_a_row(5)
  end

  def carre_of_jacks?()
    carre_of_x?(:jack)
  end

  def carre_of_nines?()
    carre_of_x?(9)
  end

  def carre_of_aces?()
    carre_of_x?(:ace)
  end

  private
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

  def carre_of_x?(rank)
    @cards.select { |card| card.rank == rank }.size == 4
  end
end

class BeloteDeck < Deck
  HAND_SIZE = 8
  TOTAL_CARDS = 32

  def hand_size()
    HAND_SIZE
  end

  def hand_class()
    BeloteHand
  end
end

class SixtySixHand < Hand
  def twenty?(trump_suit)
    kings_and_queens?(trump_suit) { |one, other| one != other }
  end

  def forty?(trump_suit)
    kings_and_queens?(trump_suit) { |one, other| one == other }
  end

  private
  def kings_and_queens?(trump_suit)
    kings = @cards.select { |c| c.rank == :king and yield c.suit, trump_suit }
    kings.each do |king|
      return true if kings.select do |card|
        card.rank == :queen and card.suit == king.suit
      end
    end

    false
  end
end

class SixtySixDeck < Deck
  TOTAL_CARDS = 24

  def hand_size()
    6
  end

  def hand_class()
    SixtySixHand
  end
end

deck = WarDeck.new()
puts deck.sort
