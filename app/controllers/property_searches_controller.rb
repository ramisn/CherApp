# frozen_string_literal: true

class PropertySearchesController < AuthenticationsController
  def create
    respond_to do |format|
      format.json do
        search = current_user.property_searches.new(saved_searches_params)
        if search.save
          render json: build_search_form(search), status: 201
        else
          render json: { errors: search.errors }, status: 400
        end
      end
    end
  end

  def destroy
    search = current_user.property_searches.find(params[:id])
    if search.delete
      flash[:notice] = t('flashes.property_searches.delete.notice')
    else
      flash[:alert] = t('flashes.property_searches.delete.alert')
    end
    redirect_back fallback_location: root_path
  end

  def show
    property_search = PropertySearch.find(params[:id])
    respond_to do |format|
      format.json { render json: property_search }
    end
  end

  private

  def build_search_form(search)
    render_to_string('property_searches/_property_search_form.html.haml', layout: false, locals: { saved_search: search })
  end

  def saved_searches_params
    params.require(:property_search)
          .permit(:search_in, :minprice, :maxprice, :search_type,
                  :minbeds, :minbaths, :alias,
                  :minarea, :maxarea, :minyear, :maxyear,
                  :minacres, :maxacres, :water,
                  :maxdom, :features, :exteriorFeatures,
                  types: [], statuses: [])
  end
end
