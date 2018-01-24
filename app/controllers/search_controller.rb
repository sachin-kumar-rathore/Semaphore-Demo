class SearchController < ApplicationController

  def index
    @data_hash = Autocompleter.new(params[:term]).call(current_org.id, current_org.users.ids)
    render json: @data_hash.values.flatten[0..5].map{|x| [[:label, x[:hint]], [:value, x[:link]]].to_h} unless params[:all_results]
  end
end
