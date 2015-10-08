#encoding: UTF-8

class Node
        attr_accessor :son, :brother
        attr_reader :board, :heuristic, 
                :heuristic_value, :current_player, :piece_played

        def initialize(son, 
                       brother, 
                       board, 
                       heuristic, 
                       current_player, 
                       piece_played = nil
                      )
                @son = son
                @brother = brother
                @board = board
                @current_player = current_player
                @heuristic = heuristic
                @piece_played = piece_played
                @heuristic_value = heuristic.calculate_value(
                        @board,
                        current_player
                )
        end
        
        def calculate_heuristic_value()
                #if i'm a leaf
                if son == nil
                        #i can calculate my value
                        @heuristic_value = heuristic.calculate_value(@board, current_player)
                #if i'm a branch
                else
                        #i must ask my sons what their best value is
                        
end
