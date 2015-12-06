class Genotype
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  embedded_in :foram

  def method_missing(method, *args, &block)
    super method.to_s.camelize(:lower).to_sym, *args, &block
  end
end
