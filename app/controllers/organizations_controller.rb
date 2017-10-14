class OrganizationsController < ApplicationController

  def edit 
    @organization = current_user.organization
  end

  def update
    @organization = current_user.organization
    if @organization.update(organization_params)
      flash[:notice] = "Organization successfully updated."
      redirect_to dashboard_index_path
    else
      flash[:error] = @organization.errors.full_messages.join(',')
      render 'edit'
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :url, :primary_contact_first_name,
      :primary_contact_last_name, :primary_contact_phone, :primary_contact_email)
  end

end
