#!/usr/bin/env ruby
# frozen_string_literal: true

module TicTacToe
  # Board Class
  class Board
    attr_accessor :board

    def initialize
      @board = Array.new(3) { Array.new(3, ' ') }
    end

    def print_board
      temp_board = board.clone.map(&:clone)
      line = "\n\t\e[36m+---+---+---+\e[0m\n"
      pipe = "\e[36m|\e[0m"

      printable_board = temp_board.map do |row|
        row[0] = "\t#{pipe} #{row[0]}"
        row[-1] += " #{pipe}"
        row.join(" #{pipe} ")
      end.join(line)

      puts "\nBoard State: \n\n#{line}#{printable_board}#{line}"
    end

    def update_cell(row, column, value)
      board[row - 1][column - 1] = value
    end

    def valid_move?(row, column)
      board[row - 1][column - 1] == ' '
    end

    def game_over
      return :winner if winner?
      return :draw if draw?

      false
    end

    private

    def draw?
      board.flatten.none?(' ')
    end

    def winner?
      winning_positions.each do |winning_position|
        next if winning_position.all?(' ')
        return true if winning_position.all? { |value| value == winning_position[0] }
      end
      false
    end

    def winning_positions
      board + board.transpose + diagonals
    end

    def diagonals
      [
        [board[0][0], board[1][1], board[2][2]],
        [board[0][2], board[1][1], board[2][0]]
      ]
    end
  end
end
