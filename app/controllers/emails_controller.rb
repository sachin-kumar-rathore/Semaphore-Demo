class EmailsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_user!, only: [:index]
  before_action :set_email, only: [:show, :edit, :update, :destroy]
  respond_to :html, only: [:index]
  respond_to :js

  def index
    @emails = current_org.emails.includes(:contacts)
    filtering_params(params).each do |key, value|
      @emails = @emails.public_send(key, value) if value.present?
    end
    @emails = @emails.paginate(page: params[:page], per_page: 8).order('updated_at DESC')
  end

  def show
  end

  def create
    user = User.find_by_email(params['sender'])
    if user.present?
      @email = user.organization.emails.new()
      @email.generate_email(params)
      begin
        @email.save
      rescue Exception => e
        puts "caught exception #{e}!"
      end
    end
    head :ok
  end

  def destroy
    @email.destroy
    respond_to do |format|
      format.html { redirect_to emails_url, notice: 'Email was successfully destroyed.' }
    end
  end

  def show_existing_contacts
    @email = current_org.emails.where(id: params[:id]).first
    @contacts = current_org.contacts
  end

  def attach_contact_to_email
    @email = current_org.emails.where(id: params[:id]).first
    @contact = current_org.contacts.find(params[:contact_id])
    @email.contacts << @contact
    @emails = current_org.emails.includes(:contacts, :project).paginate(page: params[:page], per_page: 3)
    flash.now[:success] = 'Contact was successfully added to Email.'
  end

  def show_existing_projects
    @email = current_org.emails.where(id: params[:id]).first
    @projects = current_org.projects
  end

  def attach_project_to_email
    @email = current_org.emails.where(id: params[:id]).first
    @project = current_org.projects.find(params[:project_id])
    @email.update(project_id: params[:project_id])
    @emails = current_org.emails.includes(:contacts, :project).paginate(page: params[:page], per_page: 3)
    flash.now[:success] = "Contact was successfully added to Project - #{@project.name}."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_email
    @email = current_org.emails.where(id: params[:id]).first
  end

  def filtering_params(params)
    params.slice(:project, :contact)
  end

end
