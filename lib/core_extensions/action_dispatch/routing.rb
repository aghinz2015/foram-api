module CoreExtensions
  module ActionDispatch
    module Routing
      def api(version:, **options, &routes)
        api_constraint = Constraints::APIConstraint.new(options.merge(version: version))

        scope module: "v#{version}", constraints: api_constraint, &routes
      end
    end
  end
end
