require_relative "../support/fabricator_helper"

Fabricator(:genotype) do
  transient is_diploid: false
  transient range: nil

  after_build do |genotype, transients|
    fields = FabricatorHelper.attributes_for('foram')

    fields.keys.each do |field|
      next if genotype.send(field).send(:effective).present?
      range = transients[:range] || fields[field][:range]
      gene_value = -> { rand(range) if transient[:is_diploid] }

      genotype.send("#{field}=", [rand[:range], 2.times.map { gene_value.call }].flatten)
    end
  end
end
