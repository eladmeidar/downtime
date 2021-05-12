class Api::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_access_token
  after_action :set_api_version

  def verify_access_token
    access_token = params[:access_token] || request.authorization
    if access_token.blank?
      render json: {error: 'unauthorized'}, status: :unauthorized and return
    else
      @current_account = Account.where(access_token: access_token).first
      if @current_account.blank?
        render json: {error: 'invalid access token'}, status: :forbidden and return
      end
    end
  end

  def set_api_version
    #interface
  end

  def current_account
    @current_account
  end
end
