class CustomExportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_custom_export, only: %i[edit_custom_configs destroy]

  def save_custom_configs
    custom_export = current_user.custom_exports.new(name: params[:name], filters: params[:options]) if params[:options].present?
    if custom_export.save 
      flash.now[:success] = 'Record successfully created.'
      load_custom_exports
    end
  end

  def edit_custom_configs
    if @custom_export.update_attributes(name: params[:name], filters: params[:options])
      flash.now[:success] = 'Record successfully updated.'
      load_custom_exports
    end
  end

  def destroy
    return unless @custom_export.destroy
    flash.now[:success] = 'Record successfully deleted.'
    load_custom_exports
  end

  private
  
  def set_custom_export
    @custom_export = current_user.custom_exports.where(id: params[:id]).first
  end

  def load_custom_exports
    @custom_exports = current_user.custom_exports
  end
end
