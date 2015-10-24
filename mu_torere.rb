# encoding: UTF-8

require_relative 'board'
require_relative 'mt_tools'

def recursive_require(file)
  puts file
  if File.directory?(file)
    Dir[file + '/*'].each { |inner_file| recursive_require(inner_file) }
  else
    require file
  end
end

recursive_require('./AI')

class MuTorere
  attr_reader :game_board, :lost

  def initialize
    @game_board = GameBoard.new
    @lost = false
    @current_player = nil
    @ai = AI.new(
      AlphaBeta,
      ComplexHeuristic,
      'B'
    )
    #@ai2 = AI.new(
      #Alpha_Beta,
      #Maximize_Plays,
      #'B'
    #)
  end

  def next_player
    @current_player = @current_player == 'A' ? 'B' : 'A'
  end

  def move
    p 'Player : ' + @current_player
    puts @game_board.to_s
    if @current_player == @ai.player
      @ai.play(@game_board)
    #elsif @current_player == @ai2.player
      #@ai2.play(@game_board)
    else
      # This is where the playing takes place
      input = gets.to_i

      until @game_board.can_be_moved(input, @current_player)
        p "You can't move that piece"
        input = gets.to_i
      end
      @game_board.move(input)
    end
  end

  def lost?
    you_lost if @game_board.lost?(@current_player)
  end

  def you_lost
    puts @game_board.to_s
    p "Player : #{@current_player} lost the game."
    @lost = true
  end
end

game = MuTorere.new
game.next_player
until game.lost
  game.move
  game.next_player
  game.lost?
end
