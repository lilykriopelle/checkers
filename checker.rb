'encoding utf-8'

class Checker
  attr_accessor :color, :position, :board, :king

  SLIDES_DOWN = [[1,-1], [1,1]]
  SLIDES_UP =   [[-1,-1], [-1,1]]
  JUMPS_DOWN =  [[2,-2], [2,2]]
  JUMPS_UP =    [[-2,-2], [-2,2]]

  def initialize(board, color, position, king = false)
    @board = board
    @color = color
    @position = position
    @king = king
  end

  def slide(target)
    slides.include?(target)
  end

  def jump(target)
    jumps.include?(target)
  end

  # TO DO: reject if spot is occupied
  def valid_slides
    diffs = (color == :white ? SLIDES_DOWN : SLIDES_UP)
    diffs.map { |d_row, d_col| [row+d_row, col+d_col] }
         .select {|new_pos| board.in_bounds(new_pos)}
         .select{|jump| board[jump].nil?}
  end

  def valid_jumps
    reachable_jumps.select{|jump| board[jump].nil?}
  end


  # TO DO - reject jumps if space one away isn't occupied
  def reachable_jumps
    diffs = (color == :white ? JUMPS_DOWN : JUMPS_UP)
    diffs.map { |d_row, d_col| [row+d_row, col+d_col] }
         .select {|new_pos| board.in_bounds(new_pos)}
  end

  # TO DO: render kings
  def render
    color == :white ? "w" : "b"
    #symbols[color]
  end

  def symbols
    {white: "\u26C0", black: "\u26C2"} unless king
    {white: "\u26C1", black: "\u26C3"}
  end

  def occupied?(pos)
    !board[pos].nil?
  end

  def enemy?(other)
    color != other.color
  end

  def friend?(other)
    color == other.color
  end

  def maybe_promote
    king = true if at_last_row
  end

  def at_last_row
    color == :white && row == 7 || color == :black && row == 0
  end

  def row
    position.first
  end

  def col
    position.last
  end

end
