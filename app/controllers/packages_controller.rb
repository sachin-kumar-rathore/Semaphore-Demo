class PackagesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_package, only: %i[show destroy]

  def index
    load_packages
  end

  def show; end

  def new
    @package = Package.new
    @modules = GeneralModule.default_modules.order('id asc')
  end

  def create
    @package = Package.new(package_params)
    @package.package_modules.new(package_module_params)
    if @package.save
      flash.now[:success] = 'Package created successfully'
      load_packages
    end
  end

  def destroy
    if @package.destroy
      flash.now[:success] = 'Package has been removed successfully'
      load_packages
    else
      flash.now[:danger] = 'Package not found'
    end
  end

  private

  def package_params
    params.require(:package).permit(:name)
  end

  def package_module_params
    module_id_params[:module_ids].map { |id| { general_module_id: id } }
  end

  def module_id_params
    params.require(:package).permit(:module_ids => [])
  end

  def set_package
    @package = Package.find_by(id: params[:id])
  end

  def load_packages
    @packages = Package.order('created_at desc')
  end
end
