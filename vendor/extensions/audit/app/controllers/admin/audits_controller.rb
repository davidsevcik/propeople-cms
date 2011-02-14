class Admin::AuditsController < ApplicationController

  before_filter :include_assets

  def index
    params[:direction] ||= 'asc'
    params[:date] &&= Date.parse(params[:date])
    params[:date] ||= Date.today
    @audits = scope_from_params
  end
  
  private
    def include_assets
      @stylesheets << 'admin/audit'
      @javascripts << 'admin/audit'
    end
    
    def scope_from_params
      filters = %w(ip user event_type before date after log auditable_type auditable_id)
      filters.inject(AuditEvent) do |chain,filter|
        chain = chain.send(filter, params[filter]) unless params[filter].blank?
        chain
      end.paginate(pagination_parameters)
    end

    def sort_direction
      params['direction'] == 'asc' ? 'asc' : 'desc'
    end

    def pagination_parameters
      { 
        :per_page => AuditEvent.per_page,
        :order => "audit_events.created_at #{sort_direction}",
        :page => params[:p]
      }
    end
  
end