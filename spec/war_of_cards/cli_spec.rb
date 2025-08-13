require "spec_helper"

RSpec.describe WarOfCards::CLI do
  let(:cli) { described_class.new }

  describe "#parse_options" do
    it "sets default options" do
      cli.send(:parse_options, [])
      expect(cli.options).to be_empty
    end

    it "sets number of players" do
      cli.send(:parse_options, ["-p", "4"])
      expect(cli.options[:players]).to eq(4)
    end

    it "sets rules flag" do
      cli.send(:parse_options, ["-r"])
      expect(cli.options[:rules]).to be true
    end

    it "sets help flag" do
      cli.send(:parse_options, ["-h"])
      expect(cli.options[:help]).to be true
    end
  end

  describe "#rules" do
    it "outputs formatted rules text" do
      expect {
        puts cli.send(:rules)
      }.to output(/War Card Game Rules:.*standard 52-card deck/m).to_stdout
    end
  end

  describe "#run" do
    context "with --help flag" do
      it "shows usage and exits" do
        expect {
          cli.run(["--help"])
        }.to output(/Usage:/).to_stdout.and raise_error(SystemExit)
      end
    end

    context "with --rules flag" do
      it "shows rules and exits" do
        expect {
          cli.run(["--rules"])
        }.to output(/War Card Game Rules:/).to_stdout.and raise_error(SystemExit)
      end
    end
  end
end
