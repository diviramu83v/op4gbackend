# frozen_string_literal: true

class Employee::ClientsController < Employee::OperationsBaseController
  authorize_resource

  def index
    @clients = Client.by_name.includes(:projects)
  end

  def show
    @client = Client.find(params[:id])
    @projects = @client.projects
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to @client
    else
      render 'new'
    end
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])

    if @client.update(client_params)
      redirect_to @client
    else
      render 'edit'
    end
  end

  private

  def client_params
    params.require(:client).permit(:name, :custom_uid_parameter, :custom_key_parameter)
  end
end
