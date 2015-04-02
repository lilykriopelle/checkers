# coding: utf-8
require_relative 'utilities.rb'

class InvalidMoveError < StandardError; end

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
    board[[row,col]] = self
  end

  def perform_moves(moves)
    if valid_move_seq?(moves)
      perform_moves!(moves)
    else
      raise InvalidMoveError.new "Invalid move."
    end
  end

  def valid_move_seq?(sequence)
    piece_clone = board.dup[position]
    begin
      piece_clone.perform_moves!(sequence)
    rescue
      return false
    else
      return true
    end
  end

  def perform_moves!(sequence)
    sequence = sequence
    num_moves = sequence.size
    target = sequence.shift

    if num_moves == 1

      unless (perform_slide(target) || perform_jump(target))
        raise InvalidMoveError.new "Invalid move"
      end
    else
      until target.nil?
        raise InvalidMoveError.new "Invalid move" unless perform_jump(target)
        target = sequence.shift
      end
    end
  end

  def perform_slide(target)
    is_valid_move = valid_slides.include?(target)
    if is_valid_move
      report_new_pos_to_board(target)
    end
    maybe_promote

    is_valid_move
  end

  def perform_jump(target)
    is_valid_move = valid_jumps.include?(target)
    if is_valid_move
      remove_jumped_piece(target)
      report_new_pos_to_board(target)
    end
    maybe_promote

    is_valid_move
  end

  def king?
    @king
  end

  def remove_jumped_piece(jump)
    self.board[[row + (jump.first - row)/2, col + (jump.last - col)/2]] = nil
  end

  def report_new_pos_to_board(new_pos)
    old_pos = position
    self.position = new_pos
    self.board[old_pos] = nil
    self.board[position] = self
  end

  def valid_slides
    diffs = get_slide_diffs #(color == :white ? SLIDES_DOWN : SLIDES_UP)
    diffs.map{ |d_row, d_col| [row + d_row, col + d_col] }
         .select{|new_pos| board.in_bounds?(new_pos)}
         .reject{|new_pos| !board[new_pos].nil?}
  end

  def valid_jumps
    reachable_jumps.select{|jump| board[jump].nil?}
  end

  def reachable_jumps
    diffs = get_jump_diffs #(color == :white ? JUMPS_DOWN : JUMPS_UP)
    diffs.reject{|dir| adjacent_square_not_occupied_by_evemy(dir) }
         .map { |(d_row, d_col)| [row+d_row, col+d_col] }
         .select {|new_pos| board.in_bounds?(new_pos)}
  end

  def adjacent_square_not_occupied_by_evemy(dir)
    board[adjacent_square(dir)].nil? || !enemy?(board[adjacent_square(dir)])
  end

  def adjacent_square(dir)
    [row + (dir.first / 2), col + (dir.last / 2)]
  end

  def get_jump_diffs
    if king?
      diffs = JUMPS_DOWN + JUMPS_UP
    else
      diffs = (color == :white ? JUMPS_DOWN : JUMPS_UP)
    end
  end

  def get_slide_diffs
    if king?
      diffs = SLIDES_DOWN + SLIDES_UP
    else
      diffs = (color == :white ? SLIDES_DOWN : SLIDES_UP)
    end
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

  def enemy?(other)
    color != other.color
  end

  def maybe_promote
    king = true if at_last_row?
  end

  def at_last_row?
    color == :white && row == 7 || color == :black && row == 0
  end

  def row
    position.first
  end

  def col
    position.last
  end
end
