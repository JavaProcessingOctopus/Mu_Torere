# encoding: UTF-8
# A simple piece of the board.
class Piece
  attr_accessor :player

  def initialize(player)
    @player = player
  end
end
