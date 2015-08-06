module ErrorMessages
  def error_message_for(status_code)
    try("error_message_for_#{status_code}") || 'Unknown error'
  end

  def error_message_for_404
    case exception
    when Mongoid::Errors::DocumentNotFound
      'REST resource not found'
    when ActionController::RoutingError
      'API endpoint not found'
    else
      'Resource not found'
    end
  end

  def error_message_for_500
    'Internal server error'
  end

  private

  def exception
    @exception ||= env["action_dispatch.exception"]
  end
end
