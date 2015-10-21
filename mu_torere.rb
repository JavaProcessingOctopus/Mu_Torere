#encoding: UTF-8

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

class Mu_Torere
        attr_reader :game_board, :lost

        def initialize()
                @game_board = Game_Board.new()
                @lost = false
                @current_player = nil
                @ai = AI.new(
                        Alpha_Beta,
                        Maximize_Plays,
                        'A'
                )
                @ai_2 = AI.new(
                        Alpha_Beta,
                        Maximize_Heterogeneity,
                        'B'
                )
        end

        def next_player()
                @current_player = @current_player == "A" ? "B" : "A"
        end

        def move()
                p "Player : " + @current_player
                puts @game_board.to_s
                if @current_player == @ai.player
                        @ai.play(@game_board)
                elsif @current_player == @ai_2.player
                        @ai_2.play(@game_board)
                else
                        # This is where the playing takes place
                        input = gets.to_i

                        while !@game_board.can_be_moved(
                                        input, 
                                        @current_player
                        )
                                p "You can't move that piece"
                                input = gets.to_i
                        end
                        @game_board.move(input)
                end
        end

        def lost?()
                you_lost() if @game_board.lost?(@current_player)
                
        end

        def you_lost()
                puts @game_board.to_s
                p "Player : " + @current_player + " lost the game."
                @lost = true
                MT_Tools.save_match(@ai, @ai_2, @current_player)
                @ai.tool.save_data  #TODO erase
                @ai_2.tool.save_data  #TODO erase
        end
end

game = Mu_Torere.new()
game.next_player
while !game.lost
        game.move
        game.next_player
        game.lost?
end
        
        
