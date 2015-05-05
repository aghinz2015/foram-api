Rails.application.routes.draw do
  def api(version:, **options, &routes)
    api_constraint = Constraints::APIConstraint.new(options.merge(version: version))

    scope module: "v#{version}", constraints: api_constraint, &routes
  end

  constraints subdomain: 'api', defaults: { format: :json } do
    api version: 1, default: true do
      resources :forams, except: [:new, :edit]
    end
  end
end
