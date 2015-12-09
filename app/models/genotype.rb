class Genotype
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  embedded_in :foram

  def method_missing(method, *args, &block)
    if respond_to?(method_name = method.to_s.underscore.to_sym)
      super method_name, *args, &block
    else
      super method.to_s.camelize(:lower).to_sym, *args, &block
    end
  end
end
