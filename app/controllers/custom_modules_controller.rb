class CustomModulesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_custom_module, except: %[index]

  def index
    @custom_modules = CustomModule.all.order('id ASC')
                                  .paginate(page: params[:page], per_page: 8)
  end

  def edit; end

  def update
    if @custom_module.update(custom_module_params)
      flash[:success] = 'Custom module has been successfully updated'
      redirect_to custom_modules_path
    else
      render :edit
    end
  end

  private
  
  def custom_module_params
    params.require(:custom_module).permit(:name)
  end

  def set_custom_module
    @custom_module = CustomModule.find_by_id(params[:id])
  end
end
