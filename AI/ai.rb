#encoding: UTF-8

require_relative './tree/node'

class AI
        attr_reader :algorithm, :heuristic, :player

        def initialize(algo, heuristic, player)
                @player = player
                @algo = algo
                @heuristic = heuristic
        end

        def play(board)
                node = Node.new(nil, nil, board, heuristic, @player, nil)
                @algo.build_next_board_states(node)
                board.move(@algo.search_best_move(node))
        end

end
