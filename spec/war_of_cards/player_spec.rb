require "spec_helper"

RSpec.describe WarOfCards::Player do
  describe "player has hand" do
    subject(:player) { described_class.new }

    context "when initializing with defaults" do
      it "has a hand" do
        expect(player.hand).to be_a(Set)
      end
    end

    describe "#draw_cards" do
      subject(:player) { described_class.new(hand: cards) }

      let(:cards) do
        [
          WarOfCards::Game::Card.new("A", "hearts"),
          WarOfCards::Game::Card.new("K", "spades")
        ]
      end
      let(:cards_to_draw) { 1 }
      let(:cards_drawn) { player.draw_cards(batch_count: cards_to_draw) }

      before do
        player.hand = cards.dup
      end

      it "draws specified number of cards" do
        expect(cards_drawn).to eq([cards.first])
      end

      context "when count is higher" do
        let(:cards_to_draw) { 5 }

        it "draws all remaining cards" do
          expect(cards_drawn).to eq(cards)
        end
      end
    end
  end
end
