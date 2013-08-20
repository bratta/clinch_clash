module ClinchClash
  class Battle
    include ClinchClash::Util

    def initialize
      @players = []
      init_players
      name_players
    end

    def init_players
      players = nil
      while players == nil
        players = prompt_user("Enter number of players")
        players = nil if players !~ /\d+/
        players.to_i.times do 
          @players << Player.new
        end
      end
    end

    def name_players
      @players.each do |player|
        player.name = prompt_user("Enter a name for #{player.name}").capitalize
      end
    end

    def doit
      @players.each {|x| puts x.to_s }
      pause_for_user
      execute_round
      if @players.count == 1
        puts "#{@players.first.name} wins the game!".bright.color(:green)
      else
        print "Tie game: ".bright.color(:yellow)
        puts @players.map(&:name).join(", ").bright.color(:yellow)
      end
    end

    private

    def execute_round
      round_number = 1
      max_rounds = @players.count * 3
      while @players.count > 1 && round_number < max_rounds
        player1 = @players.sample
        player2 = (@players - [player1]).sample
        round_banner(round_number, player1.name, player2.name)
        initiate_attacks(player1, player2)
        check_for_death(player1, player2)
        round_number += 1
        pause_for_user
      end
    end

    def initiate_attacks(player1, player2)
      attack_counter = 10
      while (!player1.is_dead? && !player2.is_dead? && attack_counter > 0)
        player1.attack(player2)
        attack_counter -= 1
      end
    end

    def check_for_death(player1, player2)
      if player1.is_dead?
        puts "#{player2.name} wins this round!".bright.color(:blue)
        @players.delete(player1)
      elsif player2.is_dead?
        puts "#{player1.name} wins this round!".bright.color(:blue)
        @players.delete(player2)
      else
        puts "Stalemate!".bright.color(:red)
      end
    end
  end
end
