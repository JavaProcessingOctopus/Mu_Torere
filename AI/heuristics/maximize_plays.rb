#encoding: UTF-8

require_relative "../../board"

class Maximize_Plays
        def self.calculate_value(board, player)
                (1..9).inject(0) do |total, spot|
                        puts "player : #{player}, spot : #{spot}"
                        puts board.can_be_moved(spot, player)
                        total += board.can_be_moved(spot, player) ? 1 : 0
                end
        end
end
