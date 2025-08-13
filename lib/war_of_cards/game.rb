module WarOfCards
  class Game
    include RubyCards

    attr_reader :player_count, :rounds

    def initialize(player_count: 2)
      @player_count = player_count
      handle_bad_player_count unless valid_player_count?

      @rounds = []
      deal_cards
    end

    def valid_player_count?
      [2, 4].include?(player_count)
    end

    # TODO: I18n.t bad player count
    def handle_bad_player_count
      raise WarOfCards::Error.new(
        [
          "invalid player_count: #{player_count}", # error
          "valid values include: 2 or 4"           # follow-up
        ].join("\n")
      )
    end

    def players
      @players ||= Set.new.tap do |acc|
        (1..player_count).each { |_| acc << Player.new(status: :sitting) }
      end
    end

    def deck
      return @deck if @deck

      @deck = Deck.new.cards
      @deck.shuffle!
      @deck
    end

    def cards_per_player = 52 / @players.size

    def deal_cards
      players.each_with_index do |player, index|
        start_idx = index * cards_per_player
        end_idx = start_idx + cards_per_player - 1
        player.hand = deck[start_idx..end_idx]
      end
    end

    def current_round
      rounds.last
    end

    def game_over?
      players.count { |player| player.status == :sitting } == 1
    end
  end
end
