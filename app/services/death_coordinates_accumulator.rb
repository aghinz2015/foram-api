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
    range_hash = {
      x_min: forams.min(:x), x_max: forams.max(:x),
      y_min: forams.min(:y), y_max: forams.max(:y),
    }

    if type == :three_dimensions
      counters = {}
      range_hash[:z_min] = forams.min(:z)
      range_hash[:z_max] = forams.max(:z)

      map = %Q{
        function() {
          emit({x: this.x, y: this.y, z: this.z}, 1)
        }
      }

      reduce = %Q{
        function(key, values) {
          return Array.sum(values);
        }
      }

      result = forams.map_reduce(map, reduce).out(inline: true)
      result.each { |entry| counters[entry["_id"].values] = entry["value"] }
      formatted_counters_for_3d(counters).merge!(range_hash)
    else
      counters = Hash.new { |hash, key| hash[key] = Hash.new(0) }

      z_param = type == :bubble ? :z : :deathHour
      range_hash[:z_min] = forams.min(z_param)
      range_hash[:z_max] = forams.max(z_param)

      map = %Q{
        function() {
          emit({x: this.x, y: this.y, z: this.#{z_param}}, 1)
        }
      }

      reduce = %Q{
        function(key, values) {
          return Array.sum(values);
        }
      }

      result = forams.map_reduce(map, reduce).out(inline: true)
      result.each do |entry|
        values = entry["_id"].values
        counters[[values[0], values[1]]][values[2]] = entry["value"]
      end

      formatted_counters_for_bubbles(counters, range_hash[:z_min], range_hash[:z_max]).merge!(range_hash)
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

    { data: result }
  end

  def formatted_counters_for_bubbles(counters, z_min, z_max)
    result = []

    z_range = (z_min.to_i..z_max.to_i)

    counters.each do |(x, y), z_hash|
      entry = { name: "x: #{x}, y: #{y}" }
      entry[:x] = z_range.map { |z| [z, x] }
      entry[:y] = z_range.map { |z| [z, y] }
      entry[:size] = z_range.map { |z| [z, z_hash[z.to_f] || 0] }
      result << entry
    end

    { data: result }
  end
end
