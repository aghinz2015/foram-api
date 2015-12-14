class ErrorsController < ApplicationController
  include ErrorMessages
  # skip_before_action :authenticate_user!
  before_action :set_status_code

  def show
    render json: { error: error_message }, status: @status_code
  end

  private

  def error_message
    error_message_for @status_code
  end

  def set_status_code
    @status_code = params[:status_code] || 500
  end
end
