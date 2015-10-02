#encoding: UTF-8
require_relative 'piece'
class Game_Board
        attr_accessor :board, :putahi

        def initialize()
                @board = Array.new
                8.times do 
                        @board << Piece.new(
                                @board.length > 3 ? "B" : "A"
                        )
                end
                @putahi = nil
        end

        def get_string_value(piece)
                piece == nil ? "0" : piece.player
        end
        
        def to_s()
                (0..6).inject([]) do |array, index|
                        array << "."*15
                        case
                        when index == 3
                                array.last[7] = get_string_value(@putahi)
                        when index%2 == 0
                                array.last[2] = get_string_value(@board[index/2])
                                array.last[12] = get_string_value(@board[-1-index/2])
                        end
                        array
                end
        end

        def get_piece(spot)
                spot == 9 ? @putahi : @board[spot-1]
        end

        def get_next(spot)
                # given spot is at index +1, same as length
                if spot + 1 >= @board.length
                        @board[0]
                else
                        @board[spot]
                end
        end

        def get_previous(spot)
                @board[spot-2]
        end

        def can_be_moved(spot, cp)
                prev = get_previous(spot)
                nex = get_next(spot)
                piece = get_piece(spot)
                case
                when piece == nil
                        return false
                when piece.player != cp
                        return false
                when spot == 9 && piece.player == cp
                        return true
                when prev == nil || nex == nil 
                        return true
                when @putahi == nil && (prev.player != cp || nex.player != cp)
                        return true
                else
                        return false
                end
        end

        def move(spot)
                piece = get_piece(spot)
                case
                when spot == 9
                        @board.each_with_index do |p, i|
                                @board[i] = piece if !p
                        end
                when !@putahi
                        @putahi = piece
                when !get_previous(spot)
                        @board[spot-2] = piece
                when !get_next(spot)
                        if spot == @board.length
                             @board[0] = piece
                        else
                             @board[spot] = piece
                        end
                end
                spot == 9 ? @putahi = nil : @board[spot-1] = nil
        end

        def lost?(cp)
                return false  if can_be_moved(9, cp)
                @board.each_with_index do |piece, spot|
                        if can_be_moved(spot+1, cp) 
                                return false
                        end
                end
                return true
        end
end
