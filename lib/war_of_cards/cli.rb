module WarOfCards
  class CLI
    def rules
      rules <<~RULES.squish.strip_heredoc
        War Card Game Rules:

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
        5. GOTO step 2 until one player has all cards
      RULES
    end

  end
end
