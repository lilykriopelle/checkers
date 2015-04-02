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

    #return true if sliding to target is valid, false otherwise
  end

  def jump(target)
    #return true if sliding to target is valid, false otherwise
  end


  # MOVE TO BOARD
  def in_bounds(pos)
    pos.first.between?(0,7) && pos.last.between?(0,7)
  end

  def slides
    diffs = (color == :white ? SLIDES_DOWN : SLIDES_UP)
    diffs.map { |d_row, d_col| [row+d_row, col+d_col] }
         .select {|new_pos| in_bounds(new_pos)}
  end

  # reject jumps if space one away isn't occupied
  # reject jumping onto occupied spaces
  def jumps
    diffs = (color == :white ? JUMPS_DOWN : JUMPS_UP)
    diffs.map { |d_row, d_col| [row+d_row, col+d_col] }
         .select {|new_pos| in_bounds(new_pos)}
  end

  def occupied?(pos)
  end

  def maybe_promote

  end

  def row
    position.first
  end

  def col
    position.last
  end

end
