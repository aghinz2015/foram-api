class GenerationMetricCalculator
  attr_reader :forams, :grouping_parameter, :genes, :generations, :precision

  ATTRIBUTE_TYPES = %i(effective first_set second_set)

  def initialize(forams, grouping_parameter, genes, precision, start: nil, stop: nil)
    @forams = forams
    @grouping_parameter = grouping_parameter
    @genes = genes.map { |name| name.to_s.camelize(:lower) }
    @start = start
    @stop = stop
    @precision = precision
  end

  def generation_metrics
    @metrics ||= begin
      {
        grouping_parameter: grouping_parameter_hash,
        global: extract_globals
      }.merge!(genes_stats_hash)
    end
  end

  private

  def genes_stats_hash
    @genes_stats_hash ||= begin
      result = {}
      genes.each_with_index do |name, index|
        result["gene#{index + 1}"] = {
          name: name,
          effective:  { min: [], max: [], average: [], sum: [], count: [], standard_deviation: { plus_standard_deviation: [], minus_standard_deviation: [] } },
          first_set:  { min: [], max: [], average: [], sum: [], count: [], standard_deviation: { plus_standard_deviation: [], minus_standard_deviation: [] } },
          second_set: { min: [], max: [], average: [], sum: [], count: [], standard_deviation: { plus_standard_deviation: [], minus_standard_deviation: [] } }
        }
      end

      aggregated_stats.values.each do |generation_stats|
        genes.each_with_index do |name, index|
          gene_in_result = result["gene#{index + 1}"]

          stats = generation_stats[name]
          stats.each do |gene_type, stats_hash|
            gene_type_in_result = gene_in_result[gene_type.to_sym]
            [:min, :max, :average, :sum, :count].each do |stats_type|
              value = stats_hash[stats_type.to_s] ? stats_hash[stats_type.to_s].round(precision) : nil
              gene_type_in_result[stats_type.to_sym] << value
            end

            std_dev_place = gene_type_in_result[:standard_deviation]
            standard_deviation = stats_hash["standard_deviation"]
            average = stats_hash["average"]
            if standard_deviation && average
              std_dev_place[:plus_standard_deviation] << (average + standard_deviation).round(precision)
              std_dev_place[:minus_standard_deviation] << (average - standard_deviation).round(precision)
            else
              std_dev_place[:plus_standard_deviation] << nil
              std_dev_place[:minus_standard_deviation] << nil
            end
          end
        end
      end

      result
    end
  end

  def grouping_parameter_hash
    {
      name:   grouping_parameter,
      values: aggregated_stats.keys,
      sizes:  aggregated_stats.values.map { |h| h["size"] },
    }
  end

  def aggregated_stats
    @aggregated_stats ||= begin
      map = %Q{
        function() {
          emit(
            this.#{grouping_parameter.to_s.camelize(:lower)},
            {
              size: 1,
              #{genes_emit_hash_elements}
            }
          );
        }
      }

      reduce = %Q{
        function(key, values) {
          var result = {};

          var size = 0;
          values.forEach(function(value) {
            size += value.size;
          });
          result.size = size;

          #{genes_result_hash_elements_agregation_string}

          return result;
        }
      }

      finalize = %Q{
        function(key, reducedVal) {
          var variance = 0;
          var average = 0;

          #{genes_finalize_string}

          return reducedVal;
        }
      }


      result = forams.map_reduce(map, reduce).finalize(finalize).out(inline: true)
      result = Hash[result.map(&:values).map(&:flatten)]
    end
  end

  def genes_emit_hash_elements
    hash_elements = genes.map { |name| single_gene_emit_hash_elements(name) }
    hash_elements.join(",\n")
  end

  def single_gene_emit_hash_elements(name)
    %Q{
      #{name} : {
        effective: {
          count: this.genotype.#{name}[0] != null ? 1 : 0,
          sum: this.genotype.#{name}[0] || 0,
          sum_of_squares: this.genotype.#{name}[0] != null ? this.genotype.#{name}[0] * this.genotype.#{name}[0] : 0,
          min: this.genotype.#{name}[0],
          max: this.genotype.#{name}[0]
        },
        first_set: {
          count: this.genotype.#{name}[1] != null ? 1 : 0,
          sum: this.genotype.#{name}[1] || 0,
          sum_of_squares: this.genotype.#{name}[1] != null ? this.genotype.#{name}[1] * this.genotype.#{name}[1] : 0,
          min: this.genotype.#{name}[1],
          max: this.genotype.#{name}[1]
        },
        second_set: {
          count: this.genotype.#{name}[2] != null ? 1 : 0,
          sum: this.genotype.#{name}[2] || 0,
          sum_of_squares: this.genotype.#{name}[2] != null ? this.genotype.#{name}[2] * this.genotype.#{name}[2] : 0,
          min: this.genotype.#{name}[2],
          max: this.genotype.#{name}[2]
        }
      }
    }
  end

  def genes_finalize_string
    hash_elements = genes.map { |name| single_gene_finalize_string(name) }
    hash_elements.join("\n")
  end

  def single_gene_finalize_string(name)
    %Q{
      var #{name}_hash = reducedVal.#{name};

      if(#{name}_hash.effective.count > 0) {
        average = #{name}_hash.effective.sum / #{name}_hash.effective.count;
        #{name}_hash.effective.average = average;

        variance = (#{name}_hash.effective.sum_of_squares / #{name}_hash.effective.count) - average * average
        #{name}_hash.effective.standard_deviation = Math.sqrt(Math.abs(variance));
      }

      if(#{name}_hash.first_set.count > 0) {
        average = #{name}_hash.first_set.sum / #{name}_hash.first_set.count;
        #{name}_hash.first_set.average = average;

        variance = (#{name}_hash.first_set.sum_of_squares / #{name}_hash.first_set.count) - average * average
        #{name}_hash.first_set.standard_deviation = Math.sqrt(Math.abs(variance));
      }

      if(#{name}_hash.second_set.count > 0) {
        average = #{name}_hash.second_set.sum / #{name}_hash.second_set.count;
        #{name}_hash.second_set.average = average;

        variance = (#{name}_hash.second_set.sum_of_squares / #{name}_hash.second_set.count) - average * average
        #{name}_hash.second_set.standard_deviation = Math.sqrt(Math.abs(variance));
      }

      reducedVal.#{name} = #{name}_hash;
    }
  end

  def genes_result_hash_elements_agregation_string
    hash_elements = genes.map { |name| single_gene_result_hash_elements_agregation_string(name) }
    hash_elements.join("\n")
  end

  def single_gene_result_hash_elements_agregation_string(name)
    %Q{
      var #{name} = {
        effective: {
          count: 0,
          sum: 0,
          sum_of_squares: 0,
          min: null,
          max: null
        },
        first_set: {
          count: 0,
          sum: 0,
          sum_of_squares: 0,
          min: null,
          max: null
        },
        second_set: {
          count: 0,
          sum: 0,
          sum_of_squares: 0,
          min: null,
          max: null
        }
      };

      values.forEach(function(value) {
        var gene_values = value.#{name};

        #{name}.effective.count += gene_values.effective.count;
        #{name}.effective.sum += gene_values.effective.sum;
        #{name}.effective.sum_of_squares += gene_values.effective.sum_of_squares;

        if(#{name}.effective.min == null || gene_values.effective.min != null && #{name}.effective.min > gene_values.effective.min) {
          #{name}.effective.min = gene_values.effective.min;
        }

        if(#{name}.effective.max == null || gene_values.effective.max != null && #{name}.effective.max < gene_values.effective.max) {
          #{name}.effective.max = gene_values.effective.max;
        }

        #{name}.first_set.count += gene_values.first_set.count;
        #{name}.first_set.sum += gene_values.first_set.sum;
        #{name}.first_set.sum_of_squares += gene_values.first_set.sum_of_squares;

        if(#{name}.first_set.min == null || gene_values.first_set.min != null && #{name}.first_set.min > gene_values.first_set.min) {
          #{name}.first_set.min = gene_values.first_set.min;
        }

        if(#{name}.first_set.max == null || gene_values.first_set.max != null && #{name}.first_set.max < gene_values.first_set.max) {
          #{name}.first_set.max = gene_values.first_set.max;
        }

        #{name}.second_set.count += gene_values.second_set.count;
        #{name}.second_set.sum += gene_values.second_set.sum;
        #{name}.second_set.sum_of_squares += gene_values.second_set.sum_of_squares;

        if(#{name}.second_set.min == null || gene_values.second_set.min != null && #{name}.second_set.min > gene_values.second_set.min) {
          #{name}.second_set.min = gene_values.second_set.min;
        }

        if(#{name}.second_set.max == null || gene_values.second_set.max != null && #{name}.second_set.max < gene_values.second_set.max) {
          #{name}.second_set.max = gene_values.second_set.max;
        }
      });

      result.#{name} = #{name};
    }


  end

  def extract_globals
    result = {}

    genes.each_with_index do |name, index|
      result[name] = {
        effective: {},
        first_set: {},
        second_set: {}
      }

      [:effective, :first_set, :second_set].each do |gene_type|
        [:min, :max].each do |stat_type|
          value = genes_stats_hash["gene#{index + 1}"][gene_type][stat_type].compact.send(stat_type)
          value = value ? value.round(precision) : nil
          result[name][gene_type][stat_type] = value
        end

        sum = genes_stats_hash["gene#{index + 1}"][gene_type].delete(:sum).compact.sum.round(precision)
        count = genes_stats_hash["gene#{index + 1}"][gene_type].delete(:count).compact.sum.round(precision)

        result[name][gene_type][:average] = (sum / count).round(precision) if count > 0
      end
    end

    result
  end
end
