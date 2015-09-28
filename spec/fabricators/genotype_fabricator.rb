require_relative "../support/fabricator_helper"

Fabricator(:genotype) do
  transient is_diploid: false
  transient range: nil

  after_build do |genotype, transients|
    fields = FabricatorHelper.attributes_for('foram')

    fields.keys.each do |field|
      next if genotype.send(field).send(:effective).present?
      range = transients[:range] || fields[field][:range]
      
      genotype.send("#{field}=", Fabricate(:gene, range: range, is_diploid: transients[:is_diploid]))
    end
  end
end
