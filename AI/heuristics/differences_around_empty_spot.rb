# encoding: UTF-8

class DifferenceAroundEmptySpot
  def self.calculate_value(board, player)
    (1..8).inject(0) do |total, spot|
      if board.get_string_value(board.get_piece(spot)) == '0'
        prev = board.get_string_value(board.get_previous(spot))
        nex = board.get_string_value(board.get_next(spot))

        total += prev == player ? 2 : -2
        total += nex == player ? 2 : -2
      end
      total
    end
  end
end
