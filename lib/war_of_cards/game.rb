module WarOfCards
  class Game
    attr_reader :player_count

    def initialize(player_count: 2)
      @player_count = player_count
      handle_bad_player_count unless valid_player_count?
    end

    def valid_player_count?
      return false unless [2, 4].include?(player_count)

      true
    end

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
        (1..player_count).each { |_| acc << Player.new }
      end
    end
  end
end
