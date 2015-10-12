#encoding: UTF-8

class Alpha_Beta
        # Here we are creating the next nodes, which are function
        # of the number of playable pieces
        def self.build_next_board_states(node, 
                                         depth = 5, 
                                         alpha = nil, 
                                         beta = nil,
                                         min_max = "max"
                                        ) 

                next_step_min_max = min_max == "max" ? "min" : "max"
				initial_board = node.board
                current_node = node
                new_node = nil
                player = node.current_player
                ennemy = MT_Tools.get_ennemy(node.current_player)
                first_son_created = false
				
				alpha = alpha # min
				beta = beta # max
				depth = depth

                value_to_return = nil

# ------------ Stop if someone has won on this node ------------------
                if initial_board.lost?(player)
                        value_to_return = node.calculate_heuristic_value()
                        return value_to_return
                end

#------------- Iterate over every spot of the game. ------------------
                (1..9).each do |spot|
                #------------------  cutting branches ----------------
                        if alpha != nil && beta != nil && beta <= alpha
                                #puts "BREAK"
                                #break
                        end

                #----- Create new node with new board state ----------- 
                        if initial_board.can_be_moved(spot, player)
                                puts "#{'  '*(7-depth)}New iteration at depth #{depth} on pion #{spot}"
                                node_board = initial_board.clone
                #----- The piece being on the current spot is moved ---
                                node_board.move(spot)
                                new_node = Node.new(
                                        nil,
                                        nil,
                                        node_board,
                                        node.heuristic,
                                        ennemy,
                                        spot,
                                        node.ai_player
                                )
                #---- If this new node is a leaf, calculate its value -
                                if depth == 1
                                        new_node.calculate_heuristic_value()
                                        puts "#{'  '*(7-depth)}HERE depth : #{depth}, pion : #{spot} value : #{new_node.heuristic_value}"
                                else
                #------- Otherwise recursively build a new one --------
                                        puts "#{'  '*(7-depth)}enter recursive call at depth : #{depth}"
                                        new_node.heuristic_value = self.build_next_board_states(
                                                new_node,
                                                depth-1,
                                                alpha,
                                                beta,
                                                next_step_min_max
                                        )
                                        puts "#{'  '*(7-depth)}Out of recursive call at depth : #{depth}, pion : #{spot}, value : #{new_node.heuristic_value}"
                                end
                                
                                # Shortening lines
                                nnhv = new_node.heuristic_value

                #- If the last node created, recursively or not, is the
                #- father node's first son, bind it to him as its son -
                                if !first_son_created
                                        current_node.son = new_node
                                        current_node = new_node
                                        first_son_created = true
                    #------ And get the value of that first son in ----
                    #------- order to return it to its father ---------
                                        value_to_return = nnhv

                                        if (min_max == "max" &&
                                            (beta == nil ||
                                            nnhv > beta))
                                                beta = nnhv
                                        elsif (min_max == "min" &&
                                               (alpha == nil ||
                                               nnhv < alpha))
                                                alpha = nnhv
                                        end

                                else
                #- Otherwise bind it to the current node, meaning any -
                # node in the brother chain on the father's first son -
                                        current_node.brother = new_node
                                        current_node = new_node

                # And compare the value to return to this son's value -
                # Replace the value to return if this one fits better -
                                        if (min_max == "max" && 
                        #--- If we are in a Max node, we are getting --
                        #--- the Max from our sons --------------------
                                           value_to_return < nnhv)
                                                value_to_return = nnhv
                        #----- Being in a Max node also means we have -
                        #----- to set the beta value to pass it to ----
                        #----- our futures childs ---------------------
                                                beta = value_to_return
                                        elsif (min_max == "min" &&
                        #----- A Min node get the Min from its sons ---
                                              value_to_return > nnhv)
                                                value_to_return = nnhv
                        # In a Min node, the Alpha value have to be set
                                                alpha = value_to_return
                                        end
                                end
                        end
                end
                if depth == 1
                        node.heuristic_value = value_to_return
                end
                return value_to_return
        end

        # Then play the move with the highest value
		def self.search_best_move(node)
                node = node.son
                
				piece_to_play = node.piece_played
                
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
                #node.to_s
                return piece_to_play
        end
end
