module Gods
  class Maker
    def initialize a
      puts "I ahve been initialized #{a}"
      12
    end
  end
end
class Ini
  include Gods
  def initialize
    puts "Ini revving up"
    Maker.new 21
  end
end

Ini.new