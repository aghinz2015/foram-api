module ForamScoping
  extend ActiveSupport::Concern

  def foram_scope
    Foram.for_user(current_user).simulation_start(params[:simulation_start])
  end
end
