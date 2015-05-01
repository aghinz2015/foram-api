Rails.application.routes.draw do
  def api_version(version, options = {}, &routes)
    api_constraint = Constraints::APIConstraint.new({ version: version }.merge(options))

    scope module: "v#{version}", constraints: api_constraint, &routes
  end

  constraints subdomain: 'api', defaults: { format: :json } do
    api_version 1, default: true do
      resources :forams, except: [:new, :edit]
    end
  end
end
