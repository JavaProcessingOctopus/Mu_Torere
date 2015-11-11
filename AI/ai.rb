#encoding: UTF-8

require_relative './tree/node'
require_relative '../mt_tools'
require_relative '../Tool'

class AI
        attr_reader :algo, :heuristic, :player, :tool

        def initialize(algo, heuristic, player)
                @player = player
                @algo = algo
                @heuristic = heuristic
                @tool = Tool.new(self)  #TODO erase
        end

        def play(board)
                node = Node.new(nil, nil, board, heuristic, @player, nil, @player)
                @algo.build_next_board_states(node)
                
                start = Time.now  #TODO erase
                move = @algo.search_best_move(node)
                fin = Time.now  #TODO erase
                @tool.average_time(fin - start) #TODO erase
                @tool.average_node(node)  #TODO erase
                
                board.move(move)
        end

end
