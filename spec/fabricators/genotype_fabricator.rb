require_relative "../support/fabricator_helper"

Fabricator(:genotype) do
  transient isDiploid: false
  transient range: nil

  after_build do |genotype, transients|
    fields = FabricatorHelper.attributes_for('foram')

    fields.keys.each do |field|
      next if genotype[field] && genotype[field].send(:effective).present?
      range = transients[:range] || fields[field][:range]
      gene_value = -> { rand(range) if transients[:isDiploid] }
      genotype[field] = [rand(range), 2.times.map { gene_value.call }].flatten
    end
  end
end
