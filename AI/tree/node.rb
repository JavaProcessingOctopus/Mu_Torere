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
                @heuristic_value = nil
        end
        
        def calculate_heuristic_value(@board, current_player) #calculates personal heuristic_value and returns best value to father
                var @brother_best_value, @best_value
                #if i'm a leaf and i have a brother
                if son == nil
						#i can calculate my value
						@heuristic_value = heuristic.calculate_value(@board, @current_player)
				#if i'm a branch
				else
						#i must ask my value to my son
						@heuristic_value = @son.calculate_heuristic_value()
				end
                if brother == nil
                        #the best value is my value
                        @best_value = @heuristic_value
                else
						#i must choose the best value for my father
						@brother_best_value = @brother.calculate_heuristic_value(@board, @current_player)
                        if (current_player == A) #if i'm a min node
                                #then the best value is the smallest value
                                @brother_best_value < @heuristic_value ? @best_value = @brother_best_value : @best_value = @heuristic_value
                        else #if i'm a max node
                                #then the best value is the smallest value
                                @brother_best_value > @heuristic_value ? @best_value = @brother_best_value : @best_value = @heuristic_value
                        end
                end
                return @best_value
        end
end
