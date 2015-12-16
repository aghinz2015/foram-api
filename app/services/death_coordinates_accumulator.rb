class DeathCoordinatesAccumulator
  attr_reader :forams, :type

  DEFAULT_RADIUS = 40
  ENLARGING_FACTOR = 75

  def initialize(forams, type)
    @forams = forams
    @type = type
  end

  def data_hash
    @data_hash ||= accumulate_death_coordinates
  end

  private

  def accumulate_death_coordinates
    if type == :three_dimensions
      counters = Hash.new(0)

      forams.each { |foram| counters[[foram.x, foram.y, foram.z]] += 1 }

      formatted_counters_for_3d(counters)
    else
      counters = Hash.new { |hash, key| hash[key] = Hash.new(0) }

      z_param = type == :bubble ? :z : :death_hour
      forams.each { |foram| counters[[foram.x, foram.y]][foram.send(z_param)] += 1 }

      formatted_counters_for_bubbles(counters)
    end
  end

  def formatted_counters_for_3d(counters)
    result = []
    sum = counters.values.sum

    counters.each do |(x, y, z), size|
      fraction = size / sum.to_f
      radius = fraction * DEFAULT_RADIUS * ENLARGING_FACTOR

      result << { x: x, y: y, z: z, size: size, marker: { radius: radius } }
    end

    result
  end

  def formatted_counters_for_bubbles(counters)
    result = []

    z_array = counters.values.map(&:keys).flatten(1).uniq.sort
    z_range = (z_array.first.to_i..z_array.last.to_i)

    #because we might use limited forams collection, we dont't use global model #min and #max
    x_set = Set.new
    y_set = Set.new

    counters.each do |(x, y), z_hash|
      x_set << x
      y_set << y

      entry = { name: "x: #{x}, y: #{y}" }
      entry[:x] = z_range.map { |z| [z, x] }
      entry[:y] = z_range.map { |z| [z, y] }
      entry[:size] = z_range.map { |z| [z, z_hash[z] || 0] }
      result << entry
    end

    { data: result, z_min: z_range.first, z_max: z_range.last,
                    x_min: x_set.min, x_max: x_set.max,
                    y_min: y_set.min, y_max: y_set.max }
  end
end
