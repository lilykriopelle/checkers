require_relative 'player.rb'

class HumanPlayer < Player
  attr_reader :color

  COLS = {
    "a" => 0,
    "b" => 1,
    "c" => 2,
    "d" => 3,
    "e" => 4,
    "f" => 5,
    "g" => 6,
    "h" => 7
  }

  def initialize(color, board)
    @color = color
    @board = board
  end

  def take_turn
    moves = get_sequence
    checker = @board[moves.shift]
    raise IOError.new "That's not your piece." unless checker.color == color

    checker.perform_moves(moves)
  end

  def get_sequence
    puts "\n#{color.to_s.capitalize}'s turn."
    puts "Enter a sequence of moves, starting with the location of the piece you want to move."
    response = gets.chomp.split(" ")
    parse_input(response)
  end

  def parse_input(moves)
    seq = []
    moves.each do |move|
      unless move.chars.size == 2
        raise IOError.new "Moves should be a letter followed by a number"
      end

      row = move.chars.last.to_i
      col = COLS[move.chars.first.downcase]
      seq << [row-1, col]
    end

    seq
  end

end
