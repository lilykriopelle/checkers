require_relative 'player.rb'

class ComputerPlayer < Player
  attr_reader :color

  def initialize(color, board)
    @color = color
    @board = board
  end

  def take_turn
    jumpers = pieces.select{|p| p.valid_jumps.count > 0}
    move = nil
    if jumpers.any?
      jump(jumpers.sample)
    else
      piece = pieces.sample
      piece.perform_moves([piece.valid_slides.sample])
    end
  end

  def jump(jumper)
    until jumper.valid_jumps.sample.nil?
      jump = jumper.valid_jumps.sample
      jumper.perform_moves([jump])
    end
  end

  def pieces
    @board.pieces(color)
  end

end
