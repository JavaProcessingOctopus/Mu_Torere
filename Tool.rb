#encoding: UTF-8
require "rexml/document"
require_relative 'mt_tools'

class Tool
        def initialize(ai)
                @algo_name = "#{ai.algo}_"+ ai.heuristic.to_s
                @opponent = nil
                @average_time_to_move = 0
                @weight_time_to_move = 0
                @average_number_of_node = 0
                @weight_number_of_node = 0
                self.load_data()
                puts @average_time_to_move
                puts @weight_time_to_move
                puts @average_number_of_node
                puts @weight_number_of_node
        end
        
        def average_time(diff)
                @average_time_to_move = (@average_time_to_move * @weight_time_to_move + diff) / (@weight_time_to_move + 1)
                @weight_time_to_move = @weight_time_to_move + 1
        end
        
        def  average_node(node)
                nb_nodes = MT_Tools.count_nodes(node)
                @average_number_of_node = (@average_number_of_node * @weight_number_of_node + nb_nodes) / (@weight_number_of_node + 1)
                @weight_number_of_node = @weight_number_of_node + 1
        end
        
        def save_data()
                line = "name:#{@algo_name}:"
                line = line + "time_to_move:t_average:#{@average_time_to_move}:t_weight:#{@weight_time_to_move}:"
                line = line + "number_of_node:n_average:#{@average_number_of_node}:n_weight:#{@weight_number_of_node}:"
                
                file = File.new('mu_torere_data.txt', 'a')
                file.puts line
                file.close
        end
        
        def load_data()
                if File.exist?('mu_torere_data.txt')
                  file = File.new('mu_torere_data.txt', 'r')
                  file.each_line do |line|
                          if (line =~ /name:#{@algo_name}/)
                                  prev = nil
                                  line.each_line(':') do |val|
                                          case prev
                                          when 't_average:'
                                                   @average_time_to_move = val.chop!.to_f
                                          when 't_weight:'
                                                  @weight_time_to_move = val.chop!.to_f
                                          when 'n_average:'
                                                  @average_number_of_node = val.chop!.to_f
                                          when 'n_weight:'
                                                  @weight_number_of_node = val.chop!.to_f
                                          end
                                          
                                          prev = val
                                  end
                          end
                  end
                  file.close
                  end
        end
end