#require 'colorize'

class Board

  def initialize()
    @grid = Array.new(8){Array.new(8)}
    place_pieces
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
        self[[row,col]] = Checker.new(self, color, [row,col])
      end
    end
  end

  def [] (pos)
    @grid[pos.first][pos.last]
  end

  def []=(pos, piece)
    @grid[pos.first][pos.last] = piece
  end

  def render
    @grid.map do |row|
       row.map do |piece|
         if piece.nil?
           " _ "
         else
           " #{piece.render} "
         end
       end.join("")
     end.join("\n")
  end

  def inspect
    render
  end

  # def render
  #    background = :gray
  #    nums = ("1".."8").to_a
  #
  #    "   " + ('a'..'h').to_a.join("  ") + "\n" +
  #    @grid.map do |row|
  #      background == :white ? background = :gray : background = :white
  #
  #      (nums.shift + " ") + row.map do |piece|
  #        background == :white ? background = :gray : background = :white
  #
  #        if piece.nil?
  #          ("   ").colorize(:background => background)
  #        else
  #          (' ' + piece.render + ' ').colorize(:background => background)
  #        end
  #
  #      end.join("")
  #    end.join("\n")
  #  end

end
