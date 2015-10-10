#encoding: UTF-8

class Alpha_Beta
        # Here we are creating the next nodes, which are function
        # of the number of playable pieces
        def self.build_next_board_states(node, depth = 2, alpha = -Float::INFINITY, beta = Float::INFINITY) #method returns node
				initial_board = node.board
                current_node = node
                new_node = nil
                player = node.current_player
                ennemy = MT_Tools.get_ennemy(node.current_player)
                first_son = false
               
				alpha = alpha #alpha is always smaller than beta
				beta = beta
				depth = depth
				if(depth > 0) #if i'm not a leaf
						#creating my sons
						(1..9).each do |spot|
								if initial_board.can_be_moved(spot, player)
										node_board = initial_board.clone
										node_board.move(spot)
										new_node = Node.new(
												nil, 
												nil, 
												node_board, 
												node.heuristic,
												# Setting the son node to
												# ennemy enable us to chain
												# this method.
												ennemy,
												spot
										)
										self.build_next_board_states(new_node, depth-1, alpha, beta)
										# First node is the son, others are his
										# brothers.
										if first_son
												current_node.brother = new_node
												current_node = current_node.brother
										else
												current_node.son = new_node
												current_node = current_node.son
												first_son = true
										end
                                       
                                       
										if(current_node.son != nil)#if i have my first son
												#the follow part checks if i should continue making brothers or cut te tree
												if(current_node.son.heuristic_value == nil)
														current_node.son.calculate_heuristic_value()
												end
												value = current_node.son.heuristic_value
												if((player == "A") && (alpha > value))
													alpha = value
												elsif((player == "B") && (beta < value))
                                                      beta = value
												else break #cutting branch
												end
										end
								end
						end
						#if you reach this part, you either built all the sons or reached the "break"
				end
		end

        # Then play the move with the highest value
		def self.search_best_move(node)
                node = node.son
				piece_to_play = node.piece_played
                
                node.calculate_heuristic_value()
                
                best_heuristic_found = node.heuristic_value
                #puts "Piece played : #{node.piece_played}"
                #puts "Heuristic : #{node.heuristic_value}"
                while node.brother
                        node = node.brother
                        if best_heuristic_found < node.heuristic_value
                                best_heuristic_found = node.heuristic_value
                                piece_to_play = node.piece_played
                        end
                #puts "Piece played : #{node.piece_played}"
                #puts "Heuristic : #{node.heuristic_value}"
                end
                return piece_to_play
        end
end
