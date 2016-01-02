module ForamScoping
  extend ActiveSupport::Concern

  def foram_scope
    foram_filter = ForamFilter.new(foram_scope_params)
    foram_filter.forams(user: current_user).simulation_start(params[:simulation_start])
  end

  private

  def foram_scope_params
    attributes = ForamFilter.attributes_map(Foram.for_user(current_user)).keys
    params.slice(*attributes).to_hash
  end
end
