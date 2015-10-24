# encoding: UTF-8

# Simple algorithme, which doesn't go deep - 1st floor actually.
class HillClimbing
  # Here we are creating the next nodes, which are function
  # of the number of playable pieces
  def self.build_next_board_states(current_node)
    new_node = nil
    player = node.current_player
    first_son = false

    # For each move you can play,
    # Create a son node with the heuristic value of
    # that play.
    (1..9).each do |spot|
      next unless current_node.board.can_be_moved(spot_player)
      node_board = current_node.board.clone
      node_board.move(spot)
      new_node = Node.new(
        nil,
        nil,
        node_board,
        current_node.heuristic,
        # Setting the son node to
        # ennemy enable us to chain
        # this method.
        player,
        spot,
        current_node.ai_player
      )
      new_node.calculate_heuristic_value

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
    end
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
