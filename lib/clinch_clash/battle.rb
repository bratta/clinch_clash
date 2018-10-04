# frozen_string_literal: true

module ClinchClash
  # The main class that does the work
  class Battle
    include ClinchClash::Util

    attr_accessor :config, :players, :yelp

    def initialize(config_file = nil)
      @players = []
      load_config(config_file)
      @yelp = ClinchClash::Yelp.new(@config.yelp.api_key)
      init_players
      gather_places
    end

    def doit
      @players.each { |x| puts x.to_s }
      pause_for_user
      execute_rounds
      @players.count == 1 ? game_is_won : tie_game
    end

    private

    def init_players
      players = nil
      while players.nil?
        players = prompt_user('Enter number of players')
        players = nil if players !~ /\d+/
        players.to_i.times do
          @players << Player.new
        end
      end
    end

    def load_config(config_file = nil)
      config_file ||= File.join(Dir.home, '.clinch-clash.yml')
      required_fields = ['yelp', 'yelp.api_key',
                         'battle', 'battle.max_round_multiplier',
                         'battle.number_of_attacks_per_round']
      @config = Konfigyu::Config.new(config_file, required_fields: required_fields)
    end

    def gather_places
      search_term = prompt_user('Enter a Yelp search term')
      zipcode = prompt_user('Enter a zipcode')
      results = @yelp.search(search_term, zipcode)
      add_yelp_info_to_players(results)
    end

    def add_yelp_info_to_players(results)
      @players.each do |player|
        chosen_name = results.sample
        results -= [chosen_name]
        player.yelp_info(chosen_name)
      end
    end

    def execute_rounds
      round_number = 1
      max_rounds = @players.count * @config.battle.max_round_multiplier
      while @players.count > 1 && round_number < max_rounds
        single_round(round_number)
        round_number += 1
        pause_for_user
      end
    end

    def single_round(round_number)
      player1 = @players.sample
      player2 = (@players - [player1]).sample
      round_banner(round_number, player1.name, player2.name)
      initiate_attacks(player1, player2)
      check_for_death(player1, player2)
    end

    def game_is_won
      winner = @players.first
      puts "#{winner.name} wins the game!".bright.color(:green)
      Launchy.open winner.url if winner.url
    end

    def tie_game
      print 'Tie game: '.bright.color(:yellow)
      puts @players.map(&:name).join(', ').bright.color(:yellow)
    end

    def initiate_attacks(player1, player2)
      attack_counter = @config.battle.number_of_attacks_per_round
      while !player1.dead? && !player2.dead? && attack_counter.positive?
        player1.attack(player2)
        attack_counter -= 1
      end
    end

    def check_for_death(player1, player2)
      if player1.dead?
        puts "#{player2.name} wins this round!".bright.color(:blue)
        @players.delete(player1)
      elsif player2.dead?
        puts "#{player1.name} wins this round!".bright.color(:blue)
        @players.delete(player2)
      else
        puts 'Stalemate!'.bright.color(:red)
      end
    end
  end
end
