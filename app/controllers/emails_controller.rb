class EmailsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_user!, only: [:index]
  before_action :set_email, only: [:show, :edit, :update, :destroy]

  # GET /emails
  # GET /emails.json
  def index
    @emails = current_org.emails.includes(:contacts)
    filtering_params(params).each do |key, value|
      @emails = @emails.public_send(key, value) if value.present?
    end
    @emails = @emails.paginate(page: params[:page], per_page: 3)
    respond_to do |format|
      format.html {render 'index'}
      format.js
    end
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
  end

  # POST /emails
  # POST /emails.json
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

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email.destroy
    respond_to do |format|
      format.html { redirect_to emails_url, notice: 'Email was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def show_existing_contacts
    @email = current_org.emails.find(params[:id])
    @contacts = current_org.contacts
    respond_to do |format|
      format.js
    end
  end

  def attach_contact_to_email
    @email = current_org.emails.find(params[:id])
    @contact = current_org.contacts.find(params[:contact_id])
    respond_to do |format|
      @email.contacts << @contact
      @emails = current_org.emails.includes(:contacts, :project).paginate(page: params[:page], per_page: 3)
      flash.now[:success] = 'Contact was successfully added to Email.'
      format.js
    end
  end

  def show_existing_projects
    @email = current_org.emails.find(params[:id])
    @projects = current_org.projects
    respond_to do |format|
      format.js
    end
  end

  def attach_project_to_email
    @email = current_org.emails.find(params[:id])
    @project = current_org.projects.find(params[:project_id])
    respond_to do |format|
      @email.update(project_id: params[:project_id])
      @emails = current_org.emails.includes(:contacts, :project).paginate(page: params[:page], per_page: 3)
      flash.now[:success] = "Contact was successfully added to Project - #{@project.name}."
      format.js
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_email
    @email = Email.find(params[:id])
  end

  def filtering_params(params)
    params.slice(:project, :contact)
  end

end
