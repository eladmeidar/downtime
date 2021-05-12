class Api::V1::ChecksController < Api::V1::BaseController

  before_action :find_website

  def update
    @website.update_attribute(:active, true)
    render json: {website: @website}, status: :ok
  end

  def destroy
    @website.update_attribute(:active, false)
    render json: {website: @website}, status: :ok
  end

  protected

  def find_website
    @website = current_account.websites.where(id: params[:id]).first
    if @website.blank?
      render json: {error: 'website not found'}, status: :not_found and return
    end
  end
end
