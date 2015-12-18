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
    case exception
    when Moped::Errors::ConnectionFailure
      hosts = current_user.active_mongo_session.try(:hosts) || ['localhost:27017']
      I18n.t('errors.mongo_sessions.connection_failure', ip_addresses: hosts)
    else
      'Internal server error'
    end
  end

  private

  def exception
    @exception ||= env["action_dispatch.exception"]
  end
end
