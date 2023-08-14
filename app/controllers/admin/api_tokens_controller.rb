# frozen_string_literal: true

class Admin::ApiTokensController < Admin::BaseController
  def index
    @tokens = ApiToken.all
    @token = ApiToken.new
  end

  def new
    @token = ApiToken.new
  end

  def edit
    @token = ApiToken.find(params[:id])
  end

  def create
    @token = ApiToken.new(api_token_params)

    flash[:alert] = 'Unable to save token.' unless @token.save

    redirect_to api_tokens_path
  end

  def update
    @token = ApiToken.find(params['id'])
    flash[:alert] = 'Unable to save token.' unless @token.update(api_token_params)

    redirect_to api_tokens_path
  end

  def destroy
    @token = ApiToken.find(params[:id])
    @token.destroy

    redirect_to api_tokens_path
  end

  private

  def api_token_params
    params.require(:api_token).permit(:description, :vendor_id, :status)
  end
end
