require "spec_helper"

RSpec.describe WarOfCards::Round do
  subject(:loosing_player) { (round.players - [winning_player]).sample }

  let(:game) { WarOfCards::Game.new }

  let(:round) { described_class.new(players: game.players) }

  let(:winning_player) { round.players.sample }

  before do
    allow(game).to receive(:current_round).and_return(round)
  end

  describe "a standard round" do
    context "when playing a round" do
      it "has all players from the game" do
        expect(round.players.size).to eq(game.players.size)
      end

      it "players draw cards from respective hands", skip: "TODO" do
      end
    end
  end
end
