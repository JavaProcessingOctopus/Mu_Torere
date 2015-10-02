#encoding: UTF-8
require_relative 'board'
class Mu_Torere
        attr_accessor :game_board

        def initialize()
                @game_board = Game_Board.new()
                @current_player = nil
                next_player()
        end

        def next_player()
                @current_player = @current_player == "A" ? "B" : "A"
                lost?()
        end

        def move()
                # This is where the playing takes place
                puts @game_board.to_s
                p "Player : " + @current_player

                input = gets.to_i

                while !@game_board.can_be_moved(input, @current_player)
                        p "You can't move that piece"
                        input = gets.to_i
                end

                @game_board.move(input)
                next_player()
        end

        def lost?()
                @game_board.lost?(@current_player) ?  you_lost() : move()
        end

        def you_lost()
                puts @game_board.to_s
                p "Player : " + @current_player + " lost the game."
        end
end

game = Mu_Torere.new()

