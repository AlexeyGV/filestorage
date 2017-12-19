class ItemsController < ApplicationController
  before_action :load_item, only: [:show, :destroy]

  def show
    send_file(@item.decorate.full_path, filename: @item.original_filename)
  end

  def create
    service = Services::Items::Create.new(params[:file])
    if service.call
      render json: { url: service.item.decorate.link }
    else
      head 422
    end
  end

  def destroy
    service = Services::Items::Destroy.new(@item)
    if service.call
      head :ok
    else
      head 422
    end
  end

  private

  def load_item
    @item = Item.find_by!(path: params[:path])
  end
end
