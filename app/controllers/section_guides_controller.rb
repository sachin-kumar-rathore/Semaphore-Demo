class SectionGuidesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_section_guide, only: [:edit, :update]
  layout 'admin'

  def index
    @section_guides = SectionGuide.all.paginate(page: params[:page], per_page: 8)
  end

  def edit; end

  def update
    if @section_guide.update(section_guide_params)
      flash[:success] = 'Section information is successfully updated.'
      redirect_to section_guides_path
    else
      flash[:danger] = @section_guide.errors.full_messages.join(', ')
      render :edit
    end
  end

  private

  def set_section_guide
    @section_guide = SectionGuide.find_by_id(params[:id])
  end

  def section_guide_params
    params.require(:section_guide).permit(:section_name, :section_info)
  end
end
