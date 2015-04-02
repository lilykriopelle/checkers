require_relative 'board.rb'
require_relative 'human_player.rb'
require_relative 'computer_player.rb'


class Checkers

  def initialize()
    @board = Board.new
    @players = players = [ComputerPlayer.new(:white, @board), ComputerPlayer.new(:black, @board)]
    play
  end

  def play

    loser = nil

    @players.cycle do |player|
      if @board.loss?(player.color)
        loser = player.color
        break
      end

      begin
        @board.display
        player.take_turn
      rescue IOError => e
        puts "#{e.message}  Try again."
        retry
      rescue InvalidMoveError => e
        puts "#{e.message}  Try again."
        retry
      rescue ForcedJumpError => e
        puts "#{e.message}  Try again."
        retry
      end
    end

    display_outcome(loser)
  end

  def display_outcome(loser)
    @board.display
    puts "\n#{loser.to_s.capitalize} loses!"
  end

end

if __FILE__ == $PROGRAM_NAME
  Checkers.new
end
