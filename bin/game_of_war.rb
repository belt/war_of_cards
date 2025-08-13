#!/usr/bin/env ruby

require_relative '../lib/war_of_cards'
require "pry-byebug"

WarOfCards::CLI.start(ARGV)
