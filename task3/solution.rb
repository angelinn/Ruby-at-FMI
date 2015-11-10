
###
### Abstract
###

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
    power = ranks()
    @cards.sort! do |a, b|
      [b.suit, power[b.rank]] <=> [a.suit, power[a.rank]]
    end
  end

  def to_s()
    each { |card| card }
  end

  def deal()
     hand = []
     hand_size().times { hand << draw_top_card unless size() == 0 }

    hand_class.new(hand)
  end

  def each()
    return @cards.each unless block_given?

    @cards.each { |card| yield card }
  end

  def ranks()
    Card::RANKS
  end

  def generate_all_cards()
    ranks().keys.product(Card::SUITS).map { |r, s| Card.new(r, s) }
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

######################

#####
##### War
#####

class WarHand < Hand
  ALLOW_FACE_UP_COUNT = 3

  def play_card()
    @cards.delete(@cards.sample)
  end

  def allow_face_up?()
    @cards.size <= ALLOW_FACE_UP_COUNT
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

  def ranks()
    Card::RANKS
  end
end

##########################

#####
##### Belote
#####

class BeloteHand < Hand
  def highest_of_suit(suit)
    power = BeloteDeck::RANKS
    highest = Card.new(7, :spades)
    @cards.select { |c| c.suit == suit}
          .each   { |c| highest = c if power[c.rank] > power[highest.rank] }

    highest
  end

  def belote?()
    kings = @cards.select { |card| card.rank == :king }
    kings.each do |king|
      match = @cards.select do |card|
        card.rank == :queen and card.suit == king.suit
      end

      return true if match.size != 0
    end

    false
  end

  def tierce?()
    n_in_a_row?(3)
  end

  def quarte?()
    n_in_a_row?(4)
  end

  def quint?()
    n_in_a_row?(5)
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
    power = BeloteDeck::RANKS
    @cards.sort! { |a, b| power[a.rank] <=> power[b.rank] }
    previous, matches = @cards.first, 0

    @cards.each do |current|
      matches = (current.suit == previous.suit and
                 power[current.rank] > power[previous.rank]) ? matches += 1 : 0

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
  RANKS = Hash[[7, 8, 9, :jack, :queen, :king, 10, :ace].map.with_index.to_a]
  HAND_SIZE = 8
  TOTAL_CARDS = 32

  def hand_size()
    HAND_SIZE
  end

  def hand_class()
    BeloteHand
  end

  def ranks()
    RANKS
  end
end

#######################

#####
##### SixtySix
#####

class SixtySixHand < Hand
  def twenty?(trump_suit)
    kings_and_queens?(trump_suit, ->(x, y) { x != y })
  end

  def forty?(trump_suit)
    kings_and_queens?(trump_suit, ->(x, y) { x == y })
  end

  private
  def kings_and_queens?(trump_suit, predicate)
    kings = @cards.select { |c| c.rank == :king and predicate.(c.suit, trump_suit) }

    kings.each do |king|
      return true if kings.select do |card|
        card.rank == :queen and card.suit == king.suit
      end
    end

    false
  end
end

class SixtySixDeck < Deck
  RANKS = Hash[[9, :jack, :queen, :king, 10, :ace].map.with_index.to_a]
  HAND_SIZE = 6
  TOTAL_CARDS = 24

  def hand_size()
    HAND_SIZE
  end

  def hand_class()
    SixtySixHand
  end

  def ranks()
    RANKS
  end
end

deck = WarDeck.new()
deck.shuffle
puts deck.to_a
