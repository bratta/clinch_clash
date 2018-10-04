# frozen_string_literal: true

require 'io/console'

module ClinchClash
  # Utility mixin methods
  module Util
    def rand_range(min, max)
      (min..max).to_a.sample
    end

    def pause_for_user
      puts ''
      print 'Press any key...'.bright.color(:white)
      user_input = STDIN.getch
      puts ''
      user_input
    end

    def prompt_user(message)
      print "#{message} ".bright.color(:white)
      print '>'.bright.color(:red)
      print '>'.bright.color(:green)
      print '> '.bright.color(:blue)
      gets.chomp
    end

    def round_banner(round, name1, name2)
      puts ''
      [['-', :green], ['=', :blue], ['-', :green], ['=', :blue], ['#', :cyan], ['( ', :red],
       ["ROUND #{round}: ", :white], ["#{name1} ", :yellow], ['-VS- ', :magenta], ["#{name2} ", :yellow],
       [' )', :red], ['#', :cyan], ['=', :blue], ['-', :green], ['=', :blue], ['-', :green]].each do |elem|
         print elem[0].bright.color(elem[1])
       end
      puts ''
    end
  end
end
