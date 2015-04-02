require 'colorize'

class Board


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
