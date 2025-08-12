module WarOfCards
  class Player
    attr_accessor :hand

    def initialize(hand: Set.new)
      @hand = hand || Set.new
    end

    def draw_cards(batch_count: 1)
      return hand.shift(hand.size) if hand.size <= batch_count

      hand.shift(batch_count)
    end
  end
end
