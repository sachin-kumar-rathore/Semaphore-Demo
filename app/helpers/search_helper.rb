module SearchHelper
  def search_css_styles(search_model)
    popup_models = ['contact', 'site', 'task', 'document']
    popup_models.include?(search_model) ? "clickable" : ""
  end

  def get_data_href(search_model, link)
    popup_models = ['contact', 'site', 'task', 'document']
    popup_models.include?(search_model) ? "data-href=#{link.gsub('?id=','/')}" : "href=#{link}"
  end
end