module ClinchClash
  class Player
    include ClinchClash::Util

    @@player_number = 0
    attr_accessor :name, :hp, :hp_current, :hit, :defense, :url
    attr_accessor :modifiers

    def initialize(opts={})
      @@player_number += 1
      @name = opts[:name] ? opts[:name] : "player #{@@player_number}"
      @hp = opts[:hp] ? opts[:hp] : rand_range(6, 10)
      @hp_current = opts[:hp_current] ? opts[:hp_current] : @hp
      @hit = opts[:hit] ? opts[:hit] : rand_range(1, 5)
      @defense = opts[:defense] ? opts[:defense] : rand_range(1, 5)
      @modifiers = {
        hp: 0,
        hit: 0,
        defense: 0
      }
    end

    def effective_hp
      @hp_current + @modifiers[:hp]
    end

    def effective_hit
      @hit + @modifiers[:hit]
    end

    def effective_defense
      @defense + @modifiers[:defense]
    end

    def is_dead?
      effective_hp <= 0
    end

    def is_alive?
      effective_hp > 0
    end

    def attack(player2, counterattack = false)
      if effective_hp <= 0
        puts "#{name} is dead, Jim.".bright.color(:red)
        return false
      end
      if player2.effective_hp <= 0 
        puts "#{player2.name} is dead, captain.".bright.color(:red)
        return false
      end

      hit = 0
      hit = effective_hit - player2.effective_defense
      if hit > 0
        print "#{name} "
        print "#{hit_verbs.sample} ".bright.color(:red)
        print "#{player2.name} for "
        print "#{hit} ".bright.color(:blue)
        puts "points"
        player2.hp_current = player2.hp_current - hit
      else
        print "#{name}'s attack "
        print "#{missed_verbs.sample} ".bright.color(:cyan)
        puts "#{player2.name}!"
      end

      if rand(100) == 42
        lucky_strike = (effective_hp - player2.effective_defense).abs + 1
        print "LUCKY STRIKE! ".bright.color(:green)
        puts "#{name} hits #{player2.name} for #{lucky_strike}!".bright.color(:blue)
        player2.hp_current = player2.hp_current - lucky_strike
      end

      player2.attack(self, true) unless counterattack
    end

    def set_yelp_info(yelp_info)
      if (yelp_info)
        @name = yelp_info["name"]
        @url = yelp_info["url"]
        apply_yelp_bonus(yelp_info["rating"]) if yelp_info["rating"]
      end
    end

    def apply_yelp_bonus(rating)
      @modifiers[:hit] += rating.to_f.floor
    end

    def modifier_s(modifier)
      return "" if modifier == 0
      return modifier.to_s if modifier < 0
      return "+#{modifier}" if modifier > 0
    end

    def to_s
      formatted = <<-EOT
      #{@name}
      HP: #{@hp_current}/#{@hp}
      Hit: #{@hit}#{modifier_s(@modifiers[:hit])} :: Defense: #{@defense}#{modifier_s(@modifiers[:defense])}
      EOT
      formatted.strip
    end

    def hit_verbs
      [
        "hit", "destroyed", "demolished", "eviscerated", "demoralized", "beat down", "smacked", 
        "love tapped", "choked out", "creamed", "pummeled", "tickled", "grazed", "exploded",
        "whipped", "punched", "poked", "shot", "slapped silly", "smoked"
      ]
    end

    def missed_verbs
      [
        "missed", "whiffed", "was nowhere near", "was not even close to hitting"
      ]
    end
  end
end
