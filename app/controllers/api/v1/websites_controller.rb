class Api::V1::WebsitesController < Api::V1::BaseController

  def index
    render json: {websites: current_account.websites}
  end
  
  def create
    @website = current_account.websites.build(website_params)
    if @website.save
      render json: {website: @website}, status: :created
    else
      render json: {error: @website.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    @website = current_account.websites.where(id: params[:id]).first
    if @website.blank?
      render json: {message: 'website not found'}, status: :not_found
    else
      @website.destroy
      render json: {message: 'website deleted successfully'}, status: :ok
    end
  end

  private

  def website_params
    params.permit(:url, :run_interval_in_seconds, :callback_url)
  end
end
