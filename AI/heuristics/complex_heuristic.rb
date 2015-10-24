# encoding: UTF-8

# A complex heuristic, made of few other ones.
class ComplexHeuristic
  def self.calculate_value(board, player)
    # The putahi doesn't matter here, since it's not next
    # any other piece.
    (1..9).inject(0) do |total, spot|
      # If the piece belongs to the current player
      piece = board.get_string_value(board.get_piece(spot))
      if piece == player
        if spot == 9
          total += 5
        else
          prev = board.get_string_value(board.get_previous(spot))
          nex = board.get_string_value(board.get_next(spot))
          [prev, nex].each { |x| total += 2 if x == player || x == '0' }
        end
      end
      total
    end
  end
end
