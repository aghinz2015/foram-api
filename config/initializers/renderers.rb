require 'action_controller/metal/renderers'

ActionController.add_renderer :csv do |csv, options|
  self.response_body = csv.respond_to?(:to_csv) ? csv.to_csv(options) : csv
end

ActionController.add_renderer :gen do |gen, options|
  self.response_body = gen.respond_to?(:to_gen) ? gen.to_gen(options) : gen
end
