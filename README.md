# War Card Game

A command-line implementation of the classic War card game (in Ruby).

## How to Run

```bash
./bin/game_of_war.rb
```

## Game Rules

- 2-4 players with a standard 52-card deck divided evenly
- Players reveal their top card each round
- Highest rank wins all cards in play (aces high)
- In case of ties, tied players reveal 3 face-down cards and 1 face-up card
- If a player runs out of cards, they play their last card face-up
- Game ends when one player has all 52 cards

## Features

- Only 1 external dependencies required (for the deck of cards)
- 2-4 players war card game
- Automatic war resolution
  - [Coming soon]: face-down/face-up card handling
- [Coming soon]: CLI