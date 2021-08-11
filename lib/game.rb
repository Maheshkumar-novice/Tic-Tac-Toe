#!/usr/bin/env ruby
# frozen_string_literal: true

module TicTacToe
  # Game Class
  class Game
    attr_reader :current_player, :other_player, :board

    def initialize(players, board = Board.new)
      @board = board
      @players = players
      @current_player, @other_player = players.shuffle
    end

    def play
      give_intro
      loop do
        puts "\n#{current_player.name} '#{current_player.choice}': "

        row = get_value
        column = get_value('Column')

        move_status = make_move(row, column, current_player.choice)

        unless move_status
          print_error
          redo
        end

        break if check_winner(current_player)

        switch_players
      end
    end

    private

    def make_move(row, column, value)
      return false if row <= 0 || row > 3 || column <= 0 || column > 3
      return false unless board.valid_move?(row, column)
      return false unless %w[X O].include?(value)

      board.update_cell(row, column, value)
      board.print_board

      true
    end

    def switch_players
      @current_player, @other_player = @other_player, @current_player
    end

    def check_winner(player)
      result = board.game_over
      return false unless result

      if result == :draw
        announce_draw
      else
        announce_winner(player)
      end
      true
    end

    def get_value(value = 'Row')
      print "Enter #{value} > "
      gets.chomp.to_i
    end

    def give_intro
      board.print_board
      print_instructions
      puts "\n#{current_player.name} => #{current_player.choice}\t#{other_player.name} => #{other_player.choice}"
    end

    def announce_draw
      puts "\n\n\e[33m Oops! Draw!\e[0m"
    end

    def announce_winner(player)
      puts "\n\n\e[32m#{player.name} (#{player.choice}) Won!\e[0m"
    end

    def print_instructions
      puts
      puts 'Rows    => 1, 2, 3'
      puts 'Columns => 1, 2, 3'
      puts 'Enter Respective Row and Column value to make a move.'
      puts "\nLet's Begin!\n"
    end

    def print_error
      puts "\e[31mSorry, that is an invalid move. Please, try again.\e[0m"
    end
  end
end
