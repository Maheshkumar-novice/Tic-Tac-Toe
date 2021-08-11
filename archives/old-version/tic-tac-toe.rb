#!/usr/bin/env ruby
# frozen_string_literal: true

# Board Class
class Board
  attr_reader :rows, :columns
  attr_accessor :moves

  def initialize
    @rows = 3
    @columns = 3
    @moves = 0
    init_board
  end

  def print_board
    puts "\nBoard State: \n\n"
    print @bar
    @board.each do |_key, value|
      value.each do |val|
        print val + @bar
      end
    end
    puts
  end

  def update_board(row, column, value)
    @moves += 1
    @board[row][column - 1] = value
  end

  def valid_move?(row, column)
    @board[row][column - 1] == ' '
  end

  def check_winner
    create_row_parts
    create_col_parts
    create_dia_parts
    result = row_winner
    result ||= col_winner
    result ||= dia_winner
    result
  end

  def reset_board
    @board = {
      1 => [@empty, @empty, @empty, "\n#{@line}\n"],
      2 => [@empty, @empty, @empty, "\n#{@line}\n"],
      3 => [@empty, @empty, @empty]
    }
  end

  private

  def row_winner
    return @row1 if @row1.all?('X') || @row1.all?('O')
    return @row2 if @row2.all?('X') || @row2.all?('O')
    return @row3 if @row3.all?('X') || @row3.all?('O')

    false
  end

  def col_winner
    return @col1 if @col1.all?('X') || @col1.all?('O')
    return @col2 if @col2.all?('X') || @col2.all?('O')
    return @col3 if @col3.all?('X') || @col3.all?('O')

    false
  end

  def dia_winner
    return @diagonal1 if @diagonal1.all?('X') || @diagonal1.all?('O')
    return @diagonal2 if @diagonal2.all?('X') || @diagonal2.all?('O')

    false
  end

  def create_row_parts
    @row1 = @board[1][0...-1]
    @row2 = @board[2][0...-1]
    @row3 = @board[3][0..-1]
  end

  def create_col_parts
    @col1 = [@board[1][0], @board[2][0], @board[3][0]]
    @col2 = [@board[1][1], @board[2][1], @board[3][1]]
    @col3 = [@board[1][2], @board[2][2], @board[3][2]]
  end

  def create_dia_parts
    @diagonal1 = [@board[1][0], @board[2][1], @board[3][2]]
    @diagonal2 = [@board[1][2], @board[2][1], @board[3][0]]
  end

  def create_board_parts
    create_row_parts
    create_dia_parts
    create_col_parts
  end

  def init_board
    @bar = ' | '
    @line = '---------------'
    @empty = ' '
    @board = {
      1 => [@empty, @empty, @empty, "\n#{@line}\n"],
      2 => [@empty, @empty, @empty, "\n#{@line}\n"],
      3 => [@empty, @empty, @empty]
    }
  end
end

# Game Class
class Game
  attr_accessor :players

  def initialize
    @board = Board.new
    @players = {}
    give_intro
  end

  def store_player(player)
    @players[player.choice] = player.name
  end

  def make_move(row, column, value)
    return false if row <= 0 || row > 3 || column <= 0 || column > 3
    return false unless @board.valid_move?(row, column)
    return false unless %w[X O].include?(value)

    @board.update_board(row, column, value)
    @board.print_board

    true
  end

  def check_winner
    winner = @board.check_winner
    return announce_result if @board.moves == 9 && !winner
    return false unless winner

    announce_result(winner[0])
  end

  private
  def reset_board
    @board.moves = 0
    @board.reset_board
  end

  def announce_result(result = 'draw')
    puts "\n\n"
    case result
    when 'X'
      puts "\e[32m#{players['X']} ('X') Won!\e[0m"
    when 'O'
      puts "\e[32m#{players['O']} ('O') Won!\e[0m"
    else
      puts "\e[33m Oops! Draw!\e[0m"
    end
    reset_board
    true
  end

  def print_instructions
    puts
    puts 'Rows    => 1, 2, 3'
    puts 'Columns => 1, 2, 3'
    puts 'Enter Respective Row and Column value to make a move.'
    puts "\nLet's Begin!"
  end

  def give_intro
    @board.print_board
    print_instructions
  end
end

# Player Class
class Player
  attr_accessor :name, :choice

  def initialize(name, choice)
    @name = name
    @choice = choice
  end
end

# game object
game = Game.new

# player 1 data
puts
print 'Enter Player 1 Name > '
p1_name = gets.chomp.capitalize
print 'Enter Player 1 Choice (O/X) > '
p1_choice = gets.chomp.upcase

# player 2 data
puts
print 'Enter Player 2 Name > '
p2_name = gets.chomp.capitalize
p2_choice = case p1_choice
            when 'O'
              'X'
            when 'X'
              'O'
            else
              p1_choice = 'O'
              'X'
            end

player1 = Player.new(p1_name, p1_choice)
player2 = Player.new(p2_name, p2_choice)
game.store_player(player1)
game.store_player(player2)

print "\n#{player1.name} => #{player1.choice}"
print "\t\t#{player2.name} => #{player2.choice}\n"
puts "\n#{game.players['X'].capitalize} ('X') is first....\n"

# game
current = 'X'
loop do
  loop do
    break if game.check_winner

    puts "\n#{game.players[current].capitalize} (#{current}): "

    print 'Enter Row > '
    row = gets.chomp.to_i

    print 'Enter Column > '
    column = gets.chomp.to_i

    move_status = game.make_move(row, column, current)
    unless move_status
      puts "\e[31mSorry, that is an invalid move. Please, try again.\e[0m"
      redo
    end

    winner_status = game.check_winner
    break if winner_status

    current = if current == 'O'
                'X'
              else
                'O'
              end
  end
  puts
  print 'Go Again? (y/n) > '
  choice = gets.chomp

  break if choice == 'n'

  p1_choice, p2_choice = p2_choice, p1_choice
  player1 = Player.new(p1_name, p1_choice)
  player2 = Player.new(p2_name, p2_choice)
  game.store_player(player1)
  game.store_player(player2)

  print "\n#{player1.name} => #{player1.choice}"
  print "\t\t#{player2.name} => #{player2.choice}\n"
  puts "\n#{game.players['X'].capitalize} ('X') is first....\n"
end