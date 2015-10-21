#encoding: UTF-8

class MT_Tools
        def self.get_ennemy(player)
                {"A" => "B", "B" => "A"}[player]
        end

        def self.save_match(player1=nil, player2=nil, current_player)
                #if human player parametuer is nul, if AI parameter is the AI object
                #this method is called at the end of the game, so current_player has lost
                unless(player1==nil)
                        p1_name = "#{player1.algo}-" + player1.heuristic.to_s
                else
                        p1_name = "Human"
                end
                
                unless(player2==nil)
                        p2_name = "#{player2.algo}-" + player2.heuristic.to_s
                else
                        p2_name = "Human"
                end
                         if p1_name == p2_name
                                p2_name = p2_name + "_2"
                         end
                if(current_player=="A") #curent player is the loser
                        winner = p2_name
                else
                        winner = p1_name
                end
                file = File.new("match_results", "a+")
                        file.puts "#{p1_name} vs #{p2_name}: Win #{winner}"     
                file.close        
        end
        
        def self.count_nodes(node)
              if node.son == nil && node.brother == nil
                      return 1
              elsif node.son == nil && node.brother != nil
                      return count_nodes(node.brother) + 1
              elsif node.son != nil && node.brother == nil
                      return count_nodes(node.son) + 1
              else#if node.son!=nil && node.brother !=nil
                      return count_nodes(node.son) + count_nodes(node.brother) + 1
              end
        end
end

