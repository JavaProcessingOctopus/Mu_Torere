# encoding: UTF-8
require_relative 'piece'

# Class representign the board in a Mu_Torere game
class GameBoard
  attr_reader :outer_board, :putahi

  def initialize(outer_board = nil, putahi = nil)
    if !outer_board
      @outer_board = []
      8.times do
        @outer_board << Piece.new(@outer_board.length > 3 ? 'B' : 'A')
      end
    else
      @outer_board = outer_board
    end
    @putahi = putahi
  end

  def clone
    GameBoard.new(
      @outer_board.clone,
      @putahi ? @putahi.clone : nil
    )
  end

  def get_string_value(piece)
    piece.nil? ? '0' : piece.player
  end

  def to_s
    (0..6).inject([]) do |array, index|
      array << '.'*15
      case
      when index == 3
        array.last[7] = get_string_value(@putahi)
      when index%2 == 0
        array.last[2] = get_string_value(@outer_board[index/2])
        array.last[12] = get_string_value(@outer_board[-1 - index/2])
      end
      array
    end
  end

  def get_piece(spot)
    spot == 9 ? @putahi : @outer_board[spot - 1]
  end

  def get_next(spot)
    # given spot is at index +1, same as length
    if spot >= @outer_board.length
      @outer_board[0]
    else
      @outer_board[spot]
    end
  end

  def get_previous(spot)
    @outer_board[spot - 2]
  end

  def can_be_moved(spot, cp)
    prev = get_previous(spot)
    nex = get_next(spot)
    piece = get_piece(spot)
    case
    when piece.nil?
      return false
    when piece.player != cp
      return false
    when spot == 9 && piece.player == cp
      return true
    when prev.nil? || nex.nil?
      return true
    when @putahi.nil? &&
      (prev.player != cp || nex.player != cp)
      return true
    else
      return false
    end
  end

  def move(spot)
    piece = get_piece(spot)
    case
    when spot == 9
      @outer_board.each_with_index do |p, i|
        @outer_board[i] = piece if !p
      end
    when !@putahi
      @putahi = piece
    when !get_previous(spot)
      @outer_board[spot - 2] = piece
    when !get_next(spot)
      if spot == @outer_board.length
        @outer_board[0] = piece
      else
        @outer_board[spot] = piece
      end
    end
    spot == 9 ? @putahi = nil : @outer_board[spot - 1] = nil
  end

  def lost?(cp)
    return false if can_be_moved(9, cp)
    @outer_board.each_with_index do |_, spot|
      return false if can_be_moved(spot + 1, cp)
    end
    true
  end
end
