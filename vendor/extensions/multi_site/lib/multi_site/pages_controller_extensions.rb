module MultiSite::PagesControllerExtensions
  def self.included(base)
    base.class_eval do
      before_filter :load_site
    
      #alias_method_chain :index, :root
      alias_method_chain :continue_url, :site
      alias_method_chain :remove, :back
      responses.destroy.default do 
        return_url = session[:came_from]
        session[:came_from] = nil
        redirect_to return_url || admin_pages_url(:root => model.root.id)
      end
    end
  end

#  def index
#    @homepage = @site.homepage
#    #@homepage ||= Page.find_by_parent_id(nil)
#    logger.info "SITE (index_with_root)" + @site.inspect
#    logger.info "HOMEPAGE (index_with_root)" + @homepage.inspect
#    response_for :plural
#  end

  def remove_with_back
    session[:came_from] = request.env["HTTP_REFERER"]
    remove_without_back
  end
  
  def continue_url_with_site(options={})
    options[:redirect_to] || (params[:continue] ? edit_admin_page_url(model) : admin_pages_url(:root => model.root.id))
  end
  
  def load_site
    if params[:root] || session[:root_page_id] # If a root page is specified
      homepage = Page.find(params[:root] || session[:root_page_id])
      @site = homepage.site  
      session[:root_page_id] = homepage.id
    else 
      @site = Site.first(:order => "position ASC") # If there is a site defined
    end
    
    Page.current_site = @site
    @homepage = @site.homepage
    #logger.info "SITE (load_site)" + @site.inspect
  end
  
  def change_site(site)
    @site = site.is_a?(Site) ? site : Site.find(site)
    Page.current_site = @site
    @homepage = @site.homepage
    session[:root_page_id] = @homepage.id
  end

end
