module WarOfCards
  class Player
    attr_accessor :hand

    def initialize(hand: Set.new)
      @hand = Set.new(hand || [])
    end

    def draw_cards(batch_count: 1)
      cards = Set.new(
        hand.to_a[0..batch_count - 1]
      )

      # return entire hand if player does not have enough cards
      if hand.size <= batch_count
        hand = @hand
        @hand = Set.new
        return hand
      end

      # remove cards from hand
      @hand -= [cards]

      cards
    end

    def merge_winning(cards:)
      hand.merge(Set.new(cards))
    end
  end
end
