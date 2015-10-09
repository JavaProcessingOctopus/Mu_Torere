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
                @son = son #maybe we could put a recursive call with a parameter for depth to build the tree from node.rb and not algo.rb
                @brother = brother #same thing for brother
                @board = board
                @current_player = current_player
                @heuristic = heuristic
                @piece_played = piece_played
                @heuristic_value = nil
        end
        
        def calculate_heuristic_value() #calculates personal heuristic_value and returns best value to father
                _best_value, _brother_best_value = 0, 0 #declaring and initializing the variable to be shure exist outside if statements
                #if i'm a leaf and i have a brother
                if @son == nil
						            #i can calculate my value
						            @heuristic_value = heuristic.calculate_value(@board, @current_player)
				        #if i'm a branch
				        else
				                #i must ask my value to my son
						            @heuristic_value = @son.calculate_heuristic_value()
				        end
				        
                if brother == nil
                        #the best value is my value
                        _best_value = @heuristic_value
                else
						    #i must choose the best value for my father
						    _brother_best_value = @brother.calculate_heuristic_value()
                        if (@current_player == 'A') #if i'm a min node
                                #then the best value is the smallest value
                                _best_value = _brother_best_value < @heuristic_value ? _brother_best_value : @heuristic_value
                        elsif (@current_player == 'B') #if i'm a max node
                                #then the best value is the smallest value
                                _best_value = _brother_best_value > @heuristic_value ? _brother_best_value : @heuristic_value
                        else #this should not happpen
                                #TODO write code for error case
                        end
                end
                return _best_value
        end
end
