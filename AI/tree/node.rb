# encoding: UTF-8

class Node
  attr_accessor :son, :brother, :heuristic_value
  attr_reader :board, :heuristic, :current_player, :piece_played, :ai_player

  def initialize(son, brother, board, heuristic, current_player,
                 piece_played = nil, ai_player
                )
    @son = son
    @brother = brother
    @board = board
    @current_player = current_player
    @heuristic = heuristic
    @piece_played = piece_played
    @heuristic_value = nil
    @ai_player = ai_player
  end
  
  def calculate_heuristic_value
    @heuristic_value = heuristic.calculate_value(@board, @ai_player)
  end
end
