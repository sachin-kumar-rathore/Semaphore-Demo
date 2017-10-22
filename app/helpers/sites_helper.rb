module SitesHelper
  def selected_contact(id)
    Contact.where(id: id).map(&:attributes).to_json
  end
end
