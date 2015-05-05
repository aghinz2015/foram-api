module Constraints
  class APIConstraint
    attr_reader :version, :default

    def initialize(version:, default: false)
      @version = version
      @default = default
    end

    def matches?(req)
      default || matches_api_version?(req)
    end

    private

    def matches_api_version?(req)
      return false unless req.headers.key? 'Accept'

      req.headers['Accept'].include?("application/vnd.foram.v#{version}")
    end
  end
end
