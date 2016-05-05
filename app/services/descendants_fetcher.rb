class DescendantsFetcher
  attr_reader :forams

  def initialize(forams)
    @forams = forams
  end

  def fetch_descendants(foram, options={})
    level = options[:level].to_i || 1

    descendants_hash(foram, level)
  end

  def children_count(foram_id)
    forams.or({ firstParentId: foram_id }, { secondParentId: foram_id }).count
  end

  private

  def children_array(foram)
    foram_id = foram.foram_id

    forams.where(firstParentId: foram_id) + forams.where(secondParentId: foram_id)
  end

  def serialized_genotype(foram)
    foram.genotype.serializable_hash.except("_id")
  end

  def descendants_hash(foram, level, parent_id = nil)
    id = foram.id.to_s
    result = { id: id, genotype: serialized_genotype(foram), chambers_count: foram.chambers_count }
    result[:parent_id] = parent_id if parent_id
    if level > 0
      children = children_array(foram)
      children_hashes = []
      children.each { |child| children_hashes << descendants_hash(child, level - 1, id) }
      result[:children] = children_hashes unless children_hashes.empty?
    end

    result
  end
end
