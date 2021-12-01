module Spree
  class HomeController < Spree::StoreController
    include Spree::CacheHelper

    before_action :load_homepage, only: [:index]

    respond_to :html

    def index
      redirect_to
    end

    private

    def etag_index
      [
        store_etag,
        last_modified_index,
      ]
    end

    def last_modified_index
      page_last_modified = @cms_home_page&.maximum(:updated_at)&.utc if @cms_home_page.respond_to?(:maximum)
      current_store_last_modified = current_store.updated_at.utc

      [page_last_modified, current_store_last_modified].compact.max
    end

    def accurate_title
      @cms_home_page&.seo_title || super
    end

    def load_homepage
      @cms_home_page = current_store.homepage(I18n.locale)
    end
  end
end
