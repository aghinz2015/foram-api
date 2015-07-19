class FabricatorHelper
  def self.attributes_for(model)
    yaml_config['models'][model]
  end

  def self.yaml_config
    @result ||= begin
      temp = {}

      Dir[Rails.root.join('spec', 'support', 'fabricators', '**', '*.yml')].each do |file|
        yaml_data = YAML.load(File.read(file))

        yaml_data['models'].each_pair do |model, attributes|
          attributes.each_pair do |attribute, data|
            if data['range']
              range_data = data.delete('range')
              data[:range] = (range_data['min']..range_data['max'])
            end
          end
        end

        temp.merge! yaml_data
      end

      temp
    end
  end
end
