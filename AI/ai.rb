#encoding: UTF-8

require 'benchmark'
include Benchmark
require_relative './tree/node'
require_relative '../Mechanism/mt_tools'
require_relative '../Mechanism/Tool'

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
                
                move = nil
                diff = Benchmark.realtime(){
                        move = @algo.search_best_move(node)
                }
                
                @tool.average_time(diff) #TODO erase
                @tool.average_node(node)  #TODO erase
                
                board.move(move)
        end

end
