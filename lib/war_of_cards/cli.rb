require "active_support/core_ext/string"
require "optparse"
require "pastel"

module WarOfCards
  class CLI
    attr_reader :options, :pastel

    def initialize
      @options = {}
      @pastel = Pastel.new
    end

    def self.start(args)
      new.run(args)
    end

    def run(args)
      parse_options(args)

      if options[:help]
        puts usage
        exit 0
      end

      if options[:rules]
        puts rules
        exit 0
      end

      start_game
    end

    private

    def parse_options(args)
      OptionParser.new do |opts|
        opts.banner = "Usage: game_of_war [options]"

        opts.on("-p", "--players NUMBER", Integer, "Number of players (2 or 4)") do |n|
          @options[:players] = n
        end

        opts.on("-r", "--rules", "Show game rules") do
          @options[:rules] = true
        end

        opts.on("-h", "--help", "Show this help message") do
          @options[:help] = true
        end
      end.parse!(args)
    end

    def usage
      <<~USAGE.strip_heredoc
        #{pastel.bold("Usage:")} #{$0.gsub(".*/", "")} [-h] [-p] [-r]
      USAGE
    end

    def rules
      <<~RULES.strip_heredoc
        #{pastel.bold("War Card Game Rules:")}

        1. A standard 52-card deck is divided evenly among 2-4 players
        2. Each round:
           - Players play their top card face up
           - Highest card wins all cards in play
           - Ace is highest, then King, Queen, Jack, 10, 9, etc.
           - Suits do not matter
        3. If the highest cards tie:
           - Tied players place 3 cards face down, then play a card face up
           - Repeat until there are no tie
        4. Players lose when they have no more cards
        5. Game continues until one player has all cards
      RULES
    end

    def start_game
      player_count = options[:players] || 2
      game = Game.new(player_count: player_count)

      # TODO: Implement game loop
      # - Start new round
      # - Show cards played
      # - Handle war situations
      # - Show round winner
      until game.game_over?
        raise "TODO: write me"
      end

      show_winner(game)
    end

    def show_winner(game)
      winner = game.players.find { |player| player.status == :sitting }
      puts pastel.green("\nGame Over! Player #{winner.id} wins!")
    end
  end
end
