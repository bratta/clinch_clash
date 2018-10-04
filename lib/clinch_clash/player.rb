# frozen_string_literal: true

module ClinchClash
  # Player class
  class Player
    include ClinchClash::Util

    class << self
      attr_accessor :player_number
    end

    attr_accessor :name, :hp, :hp_current, :hit, :defense, :url, :modifiers

    def initialize(opts = {})
      ClinchClash::Player.player_number = 0 if ClinchClash::Player.player_number.nil?
      ClinchClash::Player.player_number += 1
      @name = opts[:name] || "player #{ClinchClash::Player.player_number}"
      initialize_statistics(opts)
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

    def dead?
      effective_hp <= 0
    end

    def alive?
      effective_hp.positive?
    end

    def attack(player2, counterattack = false)
      return if check_for_death(self) || check_for_death(player2)

      check_hits_against(player2)
      check_lucky_strike_against(player2)
      player2.attack(self, true) unless counterattack
    end

    def yelp_info(yelp_info)
      return unless yelp_info

      @name = yelp_info[:name]
      @url = yelp_info[:url]
      apply_yelp_bonus(yelp_info[:rating]) if yelp_info[:rating]
    end

    def to_s
      formatted = <<-PLAYER_DESC
      #{@name}
      HP: #{@hp_current}/#{@hp}
      Hit: #{@hit}#{modifier_s(@modifiers[:hit])} :: Defense: #{@defense}#{modifier_s(@modifiers[:defense])}
      PLAYER_DESC
      formatted.strip
    end

    private

    def initialize_statistics(opts)
      @hp = opts[:hp] || rand_range(6, 10)
      @hp_current = opts[:hp_current] || @hp
      @hit = opts[:hit] || rand_range(1, 5)
      @defense = opts[:defense] || rand_range(1, 5)
      @modifiers = { hp: 0, hit: 0, defense: 0 }
    end

    def apply_yelp_bonus(rating)
      @modifiers[:hit] += rating.to_f.floor
    end

    def modifier_s(modifier)
      return '' if modifier.zero?

      modifier.negative? ? modifier.to_s : "+#{modifier}"
    end

    def hit_verbs
      [
        'hit', 'destroyed', 'demolished', 'eviscerated', 'demoralized', 'beat down', 'smacked',
        'love tapped', 'choked out', 'creamed', 'pummeled', 'tickled', 'grazed', 'exploded',
        'whipped', 'punched', 'poked', 'shot', 'slapped silly', 'smoked'
      ]
    end

    def missed_verbs
      [
        'missed', 'whiffed', 'was nowhere near', 'was not even close to hitting'
      ]
    end

    def check_for_death(player)
      if player.effective_hp <= 0
        puts "#{name} is dead, Jim.".bright.color(:red)
        return true
      end
      false
    end

    def check_hits_against(player2)
      hit = effective_hit - player2.effective_defense
      hit.positive? ? print_hit(player2, hit) : print_miss(player2)
    end

    def print_hit(player2, hit)
      print "#{name} #{hit_verbs.sample} ".bright.color(:red)
      print "#{player2.name} for #{hit} ".bright.color(:blue)
      puts 'points'
      player2.hp_current = player2.hp_current - hit
    end

    def print_miss(player2)
      print "#{name}'s attack #{missed_verbs.sample} ".bright.color(:cyan)
      puts "#{player2.name}!"
    end

    def check_lucky_strike_against(player2)
      return unless rand(100) == 42

      lucky_strike = (effective_hp - player2.effective_defense).abs + 1
      print 'LUCKY STRIKE! '.bright.color(:green)
      puts "#{name} hits #{player2.name} for #{lucky_strike}!".bright.color(:blue)
      player2.hp_current = player2.hp_current - lucky_strike
    end
  end
end
