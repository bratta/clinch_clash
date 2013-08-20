require 'io/console'

module ClinchClash
  module Util
    def rand_range(min, max)
      (min..max).to_a.sample
    end

    def pause_for_user
      puts ""
      print "Press any key...".bright.color(:white)
      user_input = STDIN.getch
      puts ""
      user_input
    end

    def prompt_user(message)
      print "#{message} ".bright.color(:white)
      print ">".bright.color(:red)
      print ">".bright.color(:green)
      print "> ".bright.color(:blue)
      gets.chomp
    end

    def round_banner(round, name1, name2)
      puts ""
      print "-".bright.color(:green)
      print "=".bright.color(:blue)
      print "-".bright.color(:green)
      print "=".bright.color(:blue)
      print "#".bright.color(:cyan)
      print "( ".bright.color(:red)
      print "ROUND #{round}: ".bright.color(:white)
      print "#{name1} ".bright.color(:yellow)
      print "-VS- ".bright.color(:magenta)
      print "#{name2} ".bright.color(:yellow)
      print ")".bright.color(:red)
      print "#".bright.color(:cyan)
      print "=".bright.color(:blue)
      print "-".bright.color(:green)
      print "=".bright.color(:blue)
      puts "-".bright.color(:green)
    end
  end
end
