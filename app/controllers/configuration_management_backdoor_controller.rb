class ConfigurationManagementBackdoorController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate

  def authenticate
    _username, password = ActionController::HttpAuthentication::Basic \
      .user_name_and_password(request) rescue [nil, nil]
    if password == nil
      response.headers['WWW-Authenticate'] = 'Basic realm="Configuration Management Backdoor via secret_key_base"'
      render plain: 'unauthorized', status: 401
    elsif Rails.application.secrets.secret_key_base != password
      render plain: 'Forbidden', status: 403
    end
  end

  def invoke_ruby
    begin
      code = request.body.read
      render json: {result: eval(code)}
    rescue Exception => e
      render json: {error: e.to_s}, status: 422
    end
  end

  def invoke_sql
    begin
      code = request.body.read
      res = ActiveRecord::Base.connection.execute code
      render json: {result: res}
    rescue Exception => e
      render json: {error: e.to_s}, status: 422
    end
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
