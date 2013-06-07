class VkController < ApplicationController
  respond_to :html, :json

  def authorize_vk
    respond_with(cookies[:auth_token])
  end

  def handle_vk_req
    app = VK::Application.new app_id: 2274254, app_secret: 'zaTYr7Kb3iHjgVXbQzCF', redirect_uri: 'http://albums.dev/handle_vk_req', verb: :post
    result = app.authorize({code:params[:code], redirect_uri: 'http://albums.dev/handle_vk_req'})
    cookies[:auth_token] = { :value => result["access_token"] }
    cookies[:vk_id] = { :value => result["user_id"] }

  end

  def albums
    @user = vk_user
  end

  private

  def vk_user
    VK::Application.new access_token: cookies[:auth_token] 
  end
end
