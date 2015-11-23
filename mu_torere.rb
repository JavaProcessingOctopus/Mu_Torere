# encoding: UTF-8

require 'gosu'

module ZOrder
  Background, Move, Player, UI = *0..3
end

def recursive_require(file)
  if File.directory?(file)
    Dir[file + '/*'].each { |inner_file| recursive_require(inner_file) }
  else
    require file
  end
end

recursive_require('./AI')
recursive_require('./Mechanism')

class MuTorere < Gosu::Window
  attr_reader :game_board, :lost, :current_player

  def initialize
    # Gosu
    super 631, 634
    self.caption = "Mu Torere"
    @num = 0 # Trace 
    @Score = Gosu::Font.new(20)
    @ScoreUpdate = "Rouge : 0 / 0 : Jaune"
    @background_image = Gosu::Image.new("media/plateau.jpg", :tileable => true)
    @Position1 = Gosu::Font.new(20)
    @Position2 = Gosu::Font.new(20)
    @Position3 = Gosu::Font.new(20)
    @Position4 = Gosu::Font.new(20)
    @Position5 = Gosu::Font.new(20)
    @Position6 = Gosu::Font.new(20)
    @Position7 = Gosu::Font.new(20)
    @Position8 = Gosu::Font.new(20)
    @Position9 = Gosu::Font.new(20)
    @player = Gosu::Font.new(20)
    @red_piece = Gosu::Image.new("media/pion/circle-red.png")
    @orange_piece = Gosu::Image.new("media/pion/circle-orange.png")
    @coordinates = [[314, 40], [120, 122], [37,317], [119, 512], [314, 595], [509,512], [592, 317], [509, 122], [314,317]]
    @bad_piece = false

    # Game
    @game_board = GameBoard.new
    @lost = false
    @current_player = nil
    @input = nil
    @ai = AI.new(
      AlphaBeta,
      ComplexHeuristic,
      'A'
    )
    @ai2 = AI.new(
      MinMax,
      MaximizePlays,
      'B'
    )
  end

  def next_player
    @current_player = @current_player == 'A' ? 'B' : 'A'
  end

  def move(input = nil)
    @num += 1 # Trace
    p @num # Trace
    if @current_player == @ai.player
      @ai.play(@game_board)
    elsif @current_player == @ai2.player
      @ai2.play(@game_board)
    else
      if !input
        return false
      elsif !@game_board.can_be_moved(input, @current_player)
        @bad_piece = true
        return false
      end
      @game_board.move(input)
    end
    @bad_piece = false
      sleep(0.5)
    return true
  end

  def lost?
    @lost = true if @game_board.lost?(@current_player)
  end

# ------------------------------------------------------------------  Gosu
  def show_state(string)
      @player.draw(string, 10, 30, 0, 1.0, 1.0, 0xff_ff0000)
  end
  
  def draw
    @background_image.draw(0,0,0)
    @Score.draw("#{@ScoreUpdate}", 10, 10, 0, 1.0, 1.0, 0xff_000000)
    @Position1.draw("1", 310, 200, 0, 1.0, 1.0, 0xff_000000)
    @Position2.draw("2", 248, 245, 0, 1.0, 1.0, 0xff_000000)
    @Position3.draw("3", 208, 304, 0, 1.0, 1.0, 0xff_000000)
    @Position4.draw("4", 248, 365, 0, 1.0, 1.0, 0xff_000000)
    @Position5.draw("5", 310, 406, 0, 1.0, 1.0, 0xff_000000)
    @Position6.draw("6", 373, 365, 0, 1.0, 1.0, 0xff_000000)
    @Position7.draw("7", 407, 304, 0, 1.0, 1.0, 0xff_000000)
    @Position8.draw("8", 373, 245, 0, 1.0, 1.0, 0xff_000000)
    @Position9.draw("9", 310, 304, 0, 1.0, 1.0, 0xff_000000)

    if @lost
      show_state("Player #{@current_player} lost the game")
    elsif @bad_piece
      show_state("You can't move that piece")
    else
      show_state("Player #{@current_player} de jouer")
    end

    # drawing outer_board
    @game_board.outer_board.each_with_index do |p, i|
      draw_piece(i, @game_board.get_string_value(p))
    end
    #Drawing putahi
    draw_piece(8, @game_board.get_string_value(@game_board.putahi))
  end

  def update
    if button_down? Gosu::Button::KbNumpad1
      num = 1
    elsif button_down? Gosu::Button::KbNumpad2
      num = 2
    elsif button_down? Gosu::Button::KbNumpad3
      num = 3
    elsif button_down? Gosu::Button::KbNumpad4
      num = 4
    elsif button_down? Gosu::Button::KbNumpad5
      num = 5
    elsif button_down? Gosu::Button::KbNumpad6
      num = 6
    elsif button_down? Gosu::Button::KbNumpad7
      num = 7
    elsif button_down? Gosu::Button::KbNumpad8
      num = 8
    elsif button_down? Gosu::Button::KbNumpad9
      num = 9
    end
    if !lost?
      next_player if move(num)
    end
  end

  def draw_piece(index, player)
    if player == '0'
      image = nil
    else
      image = player == 'A' ? @red_piece : @orange_piece
    end
    c = @coordinates[index]
    image.draw_rot(c[0], c[1], ZOrder::Move, 0.0) if image != nil
  end
    
  def button_down(id)
    if id == Gosu::KbEscape
       close
    end
  end
end

game = MuTorere.new
game.next_player
game.show
