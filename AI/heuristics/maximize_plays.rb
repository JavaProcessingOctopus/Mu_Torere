# encoding: UTF-8

class MaximizePlays
  def self.calculate_value(board, player)
    (1..9).inject(0) do |total, spot|
      total + board.can_be_moved(spot, player) ? 1 : 0
    end
  end
end
