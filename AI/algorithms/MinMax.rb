#encoding: UTF-8

class MinMax

# Here we are creating the next nodes, which are function
        # of the number of playable pieces
        def self.build_next_board_states(node)
                initial_board = node.board
                current_node = node
                new_node = nil
                player = node.current_player
                ennemy = MT_Tools.get_ennemy(node.current_player)
                first_son = false
               
                # For each move you can play,
                # Create a son node with the heuristic value of
                # that play. 
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
							
								(1..9).each do |spot| 
										if node_board.can_be_moved(spot, ennemy)
												node_board2 = node_board.clone
												node_board2.move(spot)
												new_node2 = Node.new(
													nil, 
													nil, 
													node_board2, 
													node.heuristic,
													# Setting the son node to
													# ennemy enable us to chain
													# this method.
													ennemy,
													spot
										)
												if first_son
														current_node.brother = new_node
														current_node = current_node.brother
												else
														current_node.son = new_node
														current_node = current_node.son
														first_son = true
												end
										end
								end
                        end
                end
        end
		
		  # Then play the move with the highest value
        def self.search_best_move(node)
                node = node.son
                piece_to_play = node.piece_played
                best_heuristic_found = node.heuristic_value
                #puts "Piece played : #{node.piece_played}"
                #puts "Heuristic : #{node.heuristic_value}"
                while node.son
                        node = node.son
						while node.brother
								node = node.brother
									if best_heuristic_found < node.heuristic_value
										best_heuristic_found = node.heuristic_value
										piece_to_play = node.piece_played
									end
						end
						
						if best_heuristic_found > node.heuristic_value
										best_heuristic_found = node.heuristic_value
										piece_to_play = node.piece_played
						end
                #puts "Piece played : #{node.piece_played}"
                #puts "Heuristic : #{node.heuristic_value}"
                end
                return piece_to_play
        end
end