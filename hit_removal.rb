require "rturk"

class Rails
  def self.env
    Env.new
  end
  class Env
    def test?
      false
    end
  end
end


require "./config/initializers/aws"

hits = RTurk::Hit.all

puts "#{hits.size} HITs. \n"

unless hits.empty?
  puts "Approving all assignments and disposing of each hit!"

  hits.each do |hit|
    hit.expire!
    hit.assignments.each do |assignment|
      assignment.approve!
    end
    hit.dispose!
  end
end