require 'rails_helper'
require 'faker'

RSpec.describe ContactsController, type: :controller do

  let(:valid_attributes) {
    {name: Faker::Name.first_name, email: Faker::Internet.email}
  }

  let(:invalid_attributes) {
    {name: nil, email: Faker::Internet.email}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ContactsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      contact = Contact.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      contact = Contact.create! valid_attributes
      get :show, params: {id: contact.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      contact = Contact.create! valid_attributes
      get :edit, params: {id: contact.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Contact" do
        expect {
          post :create, params: {contact: valid_attributes}, session: valid_session
        }.to change(Contact, :count).by(1)
      end

      it "redirects to the created contact" do
        post :create, params: {contact: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Contact.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {contact: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {name: Faker::Name.first_name}
      }

      it "updates the requested contact" do
        contact = Contact.create! valid_attributes
        previous_name = contact.name
        put :update, params: {id: contact.to_param, contact: new_attributes}, session: valid_session
        contact.reload
        expect(contact.name).not_to eq(previous_name)
      end

      it "redirects to the contact" do
        contact = Contact.create! valid_attributes
        put :update, params: {id: contact.to_param, contact: valid_attributes}, session: valid_session
        expect(response).to redirect_to(contact)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        contact = Contact.create! valid_attributes
        put :update, params: {id: contact.to_param, contact: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested contact" do
      contact = Contact.create! valid_attributes
      expect {
        delete :destroy, params: {id: contact.to_param}, session: valid_session
      }.to change(Contact, :count).by(-1)
    end

    it "redirects to the contacts list" do
      contact = Contact.create! valid_attributes
      delete :destroy, params: {id: contact.to_param}, session: valid_session
      expect(response).to redirect_to(contacts_url)
    end
  end

end
