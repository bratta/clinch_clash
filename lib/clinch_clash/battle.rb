module ClinchClash
  class Battle
    include ClinchClash::Util

    def initialize(config_file = nil)
      @players = []
      @config_file = config_file || File.join(Dir.home, '.clinch-clash.yml')
      load_config
      @yelp = ClinchClash::Yelp.new(@config[:yelp])
      init_players
      if @config[:yelp]
        gather_places
      else
        name_players
      end
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
        winner = @players.first
        puts "#{winner.name} wins the game!".bright.color(:green)
        puts winner.url if winner.url
      else
        print "Tie game: ".bright.color(:yellow)
        puts @players.map(&:name).join(", ").bright.color(:yellow)
      end
    end

    private

    def load_config
      loaded_config = File.exist?(@config_file) ? YAML::load(File.open(@config_file)) : {}
      if loaded_config.empty?
        puts "You need a .clinch-clash.yml file in your home directory!"
        puts "Configure it like this:\n"
        puts ":yelp"
        puts "  client_id: MY CLIENT ID"
        puts "  client_secret: MY CLIENT SECRET"
        puts ""
        puts "To get the id/secret, you will need to register an account with Yelp:"
        puts "https://www.yelp.com/developers"
        puts ""
        exit
      end
      @config = symbolize_keys(default_config.merge(loaded_config))
    end

    def default_config
      { max_round_multiplier: 3, number_of_attacks_per_round: 10 }
    end

    def gather_places
      search_term = prompt_user("Enter a Yelp search term")
      zipcode = prompt_user("Enter a zipcode")
      response = search_yelp(search_term, zipcode)

      result = []
      if response && response["businesses"]
        response["businesses"].each do |business|
          result << { 
            "name" => business["name"],
            "rating" =>  business["rating"],
            "url" => business["url"]
          }
        end
      end

      @players.each do |player|
        chosen_name = result.sample
        result = result - [chosen_name]
        player.set_yelp_info(chosen_name)
      end
    end

    def search_yelp(search_term, zipcode)
      response = @yelp.search(search_term, zipcode)
      if (response["error"])
        puts "Error searching Yelp: #{response["error"]["text"]}"
        exit
      end
      response
    end

    def execute_round
      round_number = 1
      max_rounds = @players.count * @config[:max_round_multiplier]
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
      attack_counter = @config[:number_of_attacks_per_round]
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
