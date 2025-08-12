module WarOfCards
  class Player
    attr_accessor :hand

    def initialize(hand: Set.new)
      @hand = hand || Set.new
    end
  end
end
