#encoding: UTF-8

class Node
        attr_accessor :son, :brother
        attr_reader :board, :heuristic, 
                :heuristic_value, :current_player, :piece_played, :ia_player

        def initialize(son, 
                       brother, 
                       board, 
                       heuristic, 
                       current_player, 
                       piece_played = nil,
                       ia_player
                      )
                @son = son #maybe we could put a recursive call with a parameter for depth to build the tree from node.rb and not algo.rb
                @brother = brother #same thing for brother
                @board = board
                @current_player = current_player
                @heuristic = heuristic
                @piece_played = piece_played
                @heuristic_value = nil
                @ia_player=ia_player
                #puts "new node"
        end
        
        def calculate_heuristic_value() #calculates personal heuristic_value and returns best value to father
                best_value, brother_best_value = nil, nil #declaring and initializing the variable to be shure exist outside if statements
                
                #searching for personal heuristic_value
                if (@son == nil) #if i'm a leaf
						#i can calculate my value
						@heuristic_value = heuristic.calculate_value(@board, @ai_player)
				else #if i'm a branch
						#i must ask my value to my son
						@heuristic_value = @son.calculate_heuristic_value()
				end
				        
				#searching for best_value to return to father
                if (@brother == nil)
						#the best value is my value
						best_value = @heuristic_value
                else
						#i must choose the best value for my father
						brother_best_value = @brother.calculate_heuristic_value()
						if (@current_player == @ia_player) #if i'm a max node(enemy turn) #TODO if values of current_player change, then correct this
								#then the best value is the smallest value
                                best_value = brother_best_value < @heuristic_value ? brother_best_value : @heuristic_value
                        elsif (@current_player != @ia_player) #if i'm a min node(my turn) #TODO if values of current_player change, then correct this
                                #then the best value is the smallest value
                                best_value = brother_best_value > @heuristic_value ? brother_best_value : @heuristic_value
                        else #this should not happpen
                                #TODO write code for error case
                        end
                end
                #returning best_value
                return best_value
        end
        def to_s(depth = 0)# this method prints the node tree
				depth = depth
				puts "|Val: #{ @heuristic_value } Pl: #{ @current_player} lv: #{depth}|"
				puts "|son|{" if (@son != nil)#beging listing sons
				@son.to_s(depth+1) if (@son != nil)
				puts"}"#end listing sons
				puts "|bro|" if(@brother != nil)
				@brother.to_s(depth) if (@brother != nil)
        end
end
