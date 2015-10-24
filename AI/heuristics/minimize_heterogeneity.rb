# encoding: UTF-8

class MinimizeHeterogeneity
  def self.calculate_value(board, player)
    # The putahi doesn't matter here, since it's not next
    # any other piece.
    (1..8).inject(0) do |total, spot|
      # If the piece belongs to the current player
      if board.get_string_value(board.get_piece(spot)) == player
        prev = board.get_string_value(board.get_previous(spot))
        nex = board.get_string_value(board.get_next(spot))

        # Decrement total for each piece the
        # enne my ahs close to the current player's
        # one.
        total += prev == player ? 1 : 0
        total += nex == player ? 1 : 0
      end
      total
    end
  end
end
