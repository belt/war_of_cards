module WarOfCards
  class Player
    attr_accessor :hand, :status

    VALID_STATUSII = %i[registered sitting lost].freeze

    def initialize(hand: Set.new, status: :registered)
      @hand = Set.new(hand || [])
      @status = status
      handle_invalid_status
    end

    # TODO: s/batch_count/draw_count/g
    def draw_cards(batch_count: 1)
      cards = Set.new(
        hand.to_a[0..batch_count - 1]
      )

      # remove cards from hand
      @hand = hand.to_set.subtract(cards)

      # player has lost if they have no more cards
      @status = :lost if @hand.size < 1

      cards
    end

    def merge_winning(cards:)
      hand.merge(Set.new(cards))
    end

    def valid_status?
      VALID_STATUSII.include?(status)
    end

    def handle_invalid_status
      return if valid_status?

      # TODO: I18n.t invalid status
      raise Error.new(
        [
          "invalid status: #{status.inspect}",
          "valid status are: #{VALID_STATUSII.join(", ")}"
        ].join(" ")
      )
    end
  end
end
