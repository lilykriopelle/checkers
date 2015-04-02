require 'colorize'
require_relative 'checker.rb'

class Board

  def initialize(set_up = true)
    @grid = Array.new(8){Array.new(8)}
    place_pieces if set_up
  end

  def place_pieces
    (0..2).each do |row|
      alternate_pieces(row, :white)
    end

    (5..7).each do |row|
      alternate_pieces(row, :black)
    end
  end

  def alternate_pieces(row, color)
    (0..7).each do |col|
      if (row.even? && col.odd?) || (row.odd? && col.even?)
        Checker.new(self, color, [row,col])
      end
    end
  end

  def [] (pos)
    @grid[pos.first][pos.last]
  end

  def []=(pos, piece)
    @grid[pos.first][pos.last] = piece
  end

  def display
    puts render
  end

  def win?(color)
    @grid.flatten.compact.none?{|piece| piece.color == other_color(color)}
  end

  def other_color(color)
    color == :white ? :black : :white
  end

  def inspect
    render
  end

  def in_bounds?(pos)
    pos.first.between?(0,7) && pos.last.between?(0,7)
  end

  def dup
    new_board = Board.new(false)
    @grid.flatten.compact.each do |piece|
      Checker.new(new_board, piece.color, piece.position, piece.king)
    end

    new_board
  end

  def render
     background = :gray
     nums = ("1".."8").to_a

     "   " + ('a'..'h').to_a.join("  ") + "\n" +
     @grid.map do |row|
       background == :white ? background = :gray : background = :white

       (nums.shift + " ") + row.map do |piece|
         background == :white ? background = :gray : background = :white

         if piece.nil?
           ("   ").colorize(:background => background)
         else
           (' ' + piece.render + ' ').colorize(:background => background)
         end

       end.join("")
     end.join("\n")
   end

end
