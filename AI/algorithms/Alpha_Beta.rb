# encoding: UTF-8

class AlphaBeta
  # Here we are creating the next nodes, which are function
  # of the number of playable pieces
  def self.build_next_board_states(node,
           depth = 7,
           alpha = -Float::INFINITY,
           beta = Float::INFINITY,
           max_node_bool = true
                                  )

    next_step_max_node_bool = !max_node_bool
    initial_board = node.board
    current_node = node
    new_node = nil
    player = node.current_player
    ennemy = MT_Tools.get_ennemy(node.current_player)
    alpha = alpha # max
    beta = beta # min
    depth = depth

    # ------------ Stop if someone has won on this node ------------------
    if initial_board.lost?(player)
      value_to_return = node.calculate_heuristic_value
      return value_to_return
    # ------------ Else, initialise the value to return ------------------
    elsif max_node_bool
      value_to_return = -Float::INFINITY
    elsif !max_node_bool
      value_to_return = Float::INFINITY
    end

    #------------- Iterate over every spot of the game. ------------------
    (1..9).each do |spot|
    #------------------  cutting branches ----------------
      if alpha >= beta
        #puts "BREAK"
        break
      end

    #----- Create new node with new board state -----------
      if initial_board.can_be_moved(spot, player)
        #puts "#{'**'*(5-depth)}New iteration at depth #{depth} on pion #{spot}"
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
          #puts "#{'---'*(5-depth)}HERE depth : #{depth}, pion : #{spot} value : #{new_node.heuristic_value}"
        else
    #------- Otherwise recursively build a new one --------
          #puts "#{'  '*(5-depth)}enter recursive call at depth : #{depth}, value : #{new_node.heuristic_value} alpha : #{alpha}, beta : #{beta}"
          new_node.heuristic_value = self.build_next_board_states(
            new_node,
            depth-1,
            alpha,
            beta,
            next_step_max_node_bool
          )
          #puts "#{'  '*(5-depth)}Out of recursive call at depth : #{depth}, value : #{new_node.heuristic_value}, alpha : #{alpha}, beta : #{beta}"
        end
        
        # Shortening lines
        nnhv = new_node.heuristic_value

    #- If the last node created, recursively or not, is the
    #- father node's first son, bind it to him as its son -
        if !node.son
          current_node.son = new_node
          current_node = new_node
        else
    #- Otherwise bind it to the current node, meaning any -
    # node in the brother chain on the father's first son -
          current_node.brother = new_node
          current_node = new_node
        end

    # ------------ Finally, do two things : ---------------
    # --- First, Get the max or min of the alpha or beta
    #  and the new node heuristic value ----------------
    # --- Second, set the value to return at the max or min
    # between the alpha or beta and the new node heuristic
    # value -----------------------------------------------
        if max_node_bool
          alpha = [alpha, nnhv].max
          value_to_return = [
            value_to_return,
            nnhv
          ].max
        else
          beta = [beta, nnhv].min
          value_to_return = [
            value_to_return,
            nnhv
          ].min
        end
      end
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
    return piece_to_play
  end
end
