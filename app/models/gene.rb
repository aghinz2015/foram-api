class Gene
  attr_accessor :effective, :first_set, :second_set

  def initialize(effective = nil, first_set = nil, second_set = nil)
    @effective  = effective
    @first_set  = first_set
    @second_set = second_set
  end

  def mongoize
    [effective, first_set, second_set]
  end

  def self.mongoize(object)
    case object
    when Gene then object.mongoize
    else object
    end
  end

  def self.demongoize(object)
    Gene.new(*object)
  end

  def self.evolve(object)
    mongoize(object)
  end
end
