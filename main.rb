#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './lib/board'
require_relative './lib/game'
require_relative './lib/player'

# TicTacToe Module
module TicTacToe
  def self.start(player1, player2)
    game = Game.new([player1, player2])
    game.play
    print "\nGo Again? (y/n) > "
    choice = gets.chomp
    return if choice == 'n'

    start(player1, player2)
  end
end

player1 = TicTacToe::Player.new
print "\nEnter Player 1 Name > "
player1.name = gets.chomp.capitalize
print 'Enter Player 1 Choice (O/X) > '
player1.choice = gets.chomp.upcase

player2 = TicTacToe::Player.new
print "\nEnter Player 2 Name > "
player2.name = gets.chomp.capitalize
player2.choice = case player1.choice
                 when 'O'
                   'X'
                 when 'X'
                   'O'
                 else
                   player1.choice = 'O'
                   'X'
                 end

TicTacToe.start(player1, player2)
