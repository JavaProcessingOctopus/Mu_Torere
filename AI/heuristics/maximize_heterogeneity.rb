# encoding: UTF-8

class MaximizeHeterogeneity
  def self.calculate_value(board, player)
    # The putahi doesn't matter here, since it's not next
    # any other piece.
    (1..8).inject(0) do |total, spot|
      if board.get_string_value(board.get_piece(spot)) == player
        prev = board.get_string_value(board.get_previous(spot))
        nex = board.get_string_value(board.get_next(spot))

        total += prev != player ? 0 : 1
        total += nex != player ? 0 : 1
      end
      total
    end
  end
end
