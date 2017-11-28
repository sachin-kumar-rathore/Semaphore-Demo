class ConsideredLocationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_considered_location, only: [:edit, :destroy, :update, :show_contacts,
                                                 :attach_contact, :remove_contact ]
  respond_to :js

  def index
    @considered_locations = current_org.considered_locations.paginate(page: params[:page], per_page: 8)
  end

  def new
    @considered_location = current_org.considered_locations.new
  end

  def create
    @considered_location = current_org.considered_locations.create(considered_location_params)
    if @considered_location
      flash[:success] = "Considered Location successfully added."
      load_considered_locations
    end
  end

  def edit

  end

  def update
    if @considered_location.update(considered_location_params)
      flash[:success] = "Considered Location successfully updated."
      load_considered_locations
    end
  end

  def destroy
    if @considered_location.destroy
      flash[:success] = "Considered Location successfully deleted."
      load_considered_locations
    end
  end

  def show_contacts
    @contacts = current_org.contacts.where.not(id: @considered_location.contact_considered_locations.map(&:contact_id))
    if params[:name].present? || params[:email].present?
      @contacts = @contacts.name_or_email_search(params[:name], params[:email])
    end    
    @contacts = @contacts.paginate(page: params[:page], per_page: 5)
  end

  def attach_contact
    @contact_considered_location = @considered_location.contact_considered_locations.where(contact_id: params[:contact_id]).first_or_initialize
    if @contact_considered_location && @contact_considered_location.save
      flash.now[:success] = 'Contact was successfully added to considered location.'
    else
      flash.now[:success] = 'Could not add contact to considered location.'
    end  
  end

  def remove_contact
    @contact_considered_location = @considered_location.contact_considered_locations.where(contact_id: params[:contact_id]).first
    if @contact_considered_location && @contact_considered_location.destroy
      flash.now[:success] = 'Contact was successfully deleted from considered location.'
    else
      flash.now[:success] = 'Could not delete contact from considered location.'
    end
  end

  private

  def considered_location_params
    params.require(:considered_location).permit(:status, :location, :city, :city_abbreviation,
                                                 :country, :country_abbreviation)
  end

  def load_considered_locations
    @considered_locations = current_org.considered_locations.paginate(page: params[:page], per_page: 8)
  end

  def set_considered_location
    @considered_location = current_org.considered_locations.where(id: params[:id]).first
    if @considered_location.blank?
      flash.now[:danger] = "Could not find the considered location"
      redirect_to settings_path
    end
  end

end
