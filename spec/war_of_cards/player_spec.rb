require "spec_helper"

RSpec.describe WarOfCards::Player do
  describe "player has deck" do
    subject(:player) { described_class.new }

    context "when initializing with defaults" do
      it "has a deck" do
        expect(player.deck).to be_a(Set)
      end
    end
  end
end
