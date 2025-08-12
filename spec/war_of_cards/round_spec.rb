require "spec_helper"

RSpec.describe WarOfCards::Round do
  subject(:round) { described_class.new(players: game.players) }

  let(:game) { WarOfCards::Game.new }
  let(:winning_player) { round.players.to_a.sample }
  let(:loosing_player) { (round.players - [winning_player]).to_a.sample }

  before do
    allow(game).to receive(:players).and_return(Set.new(
      [winning_player, loosing_player]
    ))
    allow(game).to receive(:current_round).and_return(round)
  end

  describe "a standard round" do
    context "when playing a round" do
      it "has all players from the game" do
        expect(round.players.size).to eq(game.players.size)
      end

      it "drawing cards removes cards from hands", :aggregate_failures do
        round.cards_in_play.each do |player_hand|
          expect(
            round.cards_in_play.map { |play| play[:player] }.map(&:hand) & player_hand[:card]
          ).to be_empty
        end
      end
    end
  end
end
