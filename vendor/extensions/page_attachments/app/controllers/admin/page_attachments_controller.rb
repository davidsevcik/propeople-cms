class Admin::PageAttachmentsController < ApplicationController

	protect_from_forgery :except => [:create, :resize]
	
  
  def index
    @attachments = PageAttachment.paginate :per_page => 25, :page => params[:page], :conditions => {:parent_id => nil}, :order => 'title, filename'
  end
  
  
  def grid
    @attachments = PageAttachment.paginate :per_page => 25, :page => params[:page], :conditions => {:parent_id => nil}, :order => 'title, filename'
  end
  
  
  def create  # ukladani z ckeditoru
  	@attachment = PageAttachment.new
  	@attachment.uploaded_data = params[:upload]
  	@attachment.page_id = params[:page_id]
  	@attachment.copy_for_translation = false
  	@attachment.save!
  	
  	render :text => "<html><body><script type=\"text/javascript\">window.parent.CKEDITOR.tools.callFunction('#{params[:CKEditorFuncNum]}', '#{@attachment.public_filename}');</script></body></html>"
  end
  
  
  def ckeditor_browser
    @attachments = PageAttachment.find_all_by_page_id_and_parent_id(params[:page_id], nil)
    
    render :partial => 'ckeditor_browser', :layout => false
  end
  
  
  def resize
  	if params[:url] =~ /[^\/]+$/ && params[:page_id] && params[:width] && params[:height]
  		if attachment = PageAttachment.find_by_page_id_and_filename(params[:page_id], $&)
  		  suffix = "w#{params[:width]}h#{params[:height]}"
  		  if attachment.width == params[:width].to_i && attachment.height == params[:height].to_i
  		    render :text => 'original'
  		  elsif attachment.thumbnails.exists?(:thumbnail => suffix)
  		    render :text => 'exists'
  		  else
    			temp_file = attachment.temp_path || attachment.create_temp_file
          attachment.create_or_update_thumbnail(temp_file, suffix, "#{params[:width]}x#{params[:height]}")
          render :text => 'created'
        end
  		else
  			raise ActiveRecord::RecordNotFound.new('Page attachment not found')
  		end
  	else
  		raise ArgumentError.new("Parametrs url and page_id needed")
  	end	
  end
  
  
  
  def edit
    @page_attachment = PageAttachment.find(params[:id])
    if request.xhr?
      @flags = PageAttachment.flags
      render :partial => 'ajax_edit', :layout => false 
    end
  end
  
  
  def update
    @page_attachment = PageAttachment.find(params[:id])
    if @page_attachment.update_attributes(params[:page_attachment])
      redirect_to admin_page_attachments_url
    else
      render :edit
    end
  end
  
	def move_higher
		if request.post?
			@attachment = PageAttachment.find(params[:id])
			@attachment.move_higher
			render :partial => 'admin/page/attachment', :layout => false, :collection => @attachment.page.attachments
		end
	end

	def move_lower
		if request.post?
			@attachment = PageAttachment.find(params[:id])
			@attachment.move_lower
			render :partial => 'admin/page/attachment', :layout => false, :collection => @attachment.page.attachments
		end
	end
	
	def destroy
		if request.post?
			@attachment = PageAttachment.find(params[:id])
			page = @attachment.page
			@attachment.destroy
			render :partial => 'admin/page/attachment', :layout => false, :collection => page.attachments
		end
	end
end
