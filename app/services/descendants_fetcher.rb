class DescendantsFetcher
  attr_reader :forams

  def initialize(forams)
    @forams = forams
  end

  def fetch_descendants(foram, options={})
    level = options[:level].to_i || 1

    descendants_hash(foram, level)
  end

  private

  def children_array(foram)
    foram_id = foram.foram_id

    forams.where(first_parent_id: foram_id) + forams.where(second_parent_id: foram_id)
  end

  def serialized_genotype(foram)
    foram.genotype.serializable_hash.except("_id")
  end

  def descendants_hash(foram, level)
    result = { id: foram.id.to_s, genotype: serialized_genotype(foram) }
    if level > 0
      children = children_array(foram)
      children_hashes = []
      children.each { |child| children_hashes << descendants_hash(child, level - 1) }
      result[:children] = children_hashes unless children_hashes.empty?
    end

    result
  end
end
