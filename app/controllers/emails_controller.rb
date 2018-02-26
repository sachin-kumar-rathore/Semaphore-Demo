# Manage emails belonging to an organization
class EmailsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create]
  before_action :authenticate_user!, only: %i[index]
  before_action :set_email, only: %i[show edit update destroy
                                     show_existing_contacts
                                     attach_contact_to_email
                                     show_existing_projects_and_activities
                                     attach_project_or_activity_to_email]
  respond_to :html, only: %i[index]
  respond_to :js

  def index
    @emails = current_org.emails.includes(:contacts)
    filtering_params(params).each do |key, value|
      @emails = @emails.public_send(key, value) if value.present?
    end
    @emails = @emails.paginate(page: params[:page], per_page: 8)
                     .order('emails.updated_at DESC')
  end

  def show; end

  def create
    user = User.find_by_email(params['sender'])
    if user.present?
      @email = user.organization.emails.new
      @email.generate_email(params)
      begin
        @email.save
        EmailWorker.perform_in(10.minutes, @email.id)
      rescue Exception => e
        puts "caught exception #{e}!"
      end
    end
    head :ok
  end

  def destroy
    @email.destroy
    respond_to do |format|
      format.html redirect_to emails_url,
                  notice: 'Email was successfully destroyed.'
    end
  end

  def show_existing_contacts
    @contacts = current_org.contacts
  end

  def attach_contact_to_email
    @contact = current_org.contacts.find(params[:contact_id])
    @email.contacts << @contact
    @emails = current_org.emails.includes(:contacts)
                         .paginate(page: params[:page], per_page: 8)
    flash.now[:success] = 'Contact was successfully added to Email.'
  end

  def show_existing_projects_and_activities
    @projects = current_org.projects
    @activities = current_org.activities
  end

  def attach_project_or_activity_to_email
    @email.update(mailable_id: params[:mailable_id],
                  mailable_type: params[:mailable_type])
    @emails = current_org
              .emails.includes(:contacts)
              .paginate(page: params[:page], per_page: 8)
    flash.now[:success] =
      "Contact was successfully added to #{params[:mailable_type]}."
  end

  private

  def set_email
    @email = current_org.emails.where(id: params[:id]).first
  end

  def filtering_params(params)
    params.slice(:project, :contact)
  end
end
