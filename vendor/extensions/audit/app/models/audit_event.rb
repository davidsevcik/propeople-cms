class AuditEvent < ActiveRecord::Base
  include Auditable

  cattr_reader :per_page
  @@per_page = 100

  belongs_to :auditable, :polymorphic => true
  belongs_to :user
  belongs_to :audit_type
  
  # before the AuditEvent is saved, call the proc defined for this AuditType & class to assemble
  # appropriate log message
  before_create :assemble_log_message

  # before and after scopes are inclusive!
  named_scope :ip,              lambda { |ip|   {:conditions => { :ip_address => ip }} }
  named_scope :user,            lambda { |user| {:conditions => { :user_id => user }} }
  named_scope :before,          lambda { |date| {:conditions => ['audit_events.created_at <= ?', Time.zone.parse(date.to_s).end_of_day]} }
  named_scope :after,           lambda { |date| {:conditions => ['audit_events.created_at >= ?', Time.zone.parse(date.to_s).beginning_of_day]} }
  named_scope :log,             lambda { |msg|  {:conditions => ['log_message LIKE ?', "%#{msg}%"]} }
  named_scope :auditable_type,  lambda { |type| {:conditions => {:auditable_type => type}} }
  named_scope :auditable_id,    lambda { |id|   {:conditions => {:auditable_id => id}} }
  named_scope :event_type,      lambda { |event|
    # event format: "<Class> <EVENT_TYPE>", where Event Type can be >= 1 word, all caps, joined by underscores
    eventarray = event.split(' ')
    auditable, audit_type = eventarray.shift.camelcase, eventarray.join('_').upcase
    {:include => :audit_type, :conditions => { 'audit_types.name' => audit_type, 'audit_events.auditable_type' => auditable}}
  }
  named_scope :date,            lambda { |date|
    date = Time.zone.parse(date.to_s)
    {:conditions => ['audit_events.created_at >= ? AND audit_events.created_at <= ?', date.beginning_of_day, date.end_of_day]}
  }
  
  class << self
    def date_before(date)
      if event = find(:first, :conditions => ['created_at < ?', Time.zone.parse(date.to_s).beginning_of_day], :select => :created_at, :order => 'audit_events.created_at desc')
        event.created_at.to_date
      end
    end

    def date_after(date)
      if event = find(:first, :conditions => ['created_at > ?', Time.zone.parse(date.to_s).end_of_day], :select => :created_at, :order => 'audit_events.created_at asc')
        event.created_at.to_date
      end
    end

    # For development use. This will not alter logs where the audited item
    # has since been deleted.
    def rebuild_logs
      all.each do |event|
        begin
          event.rebuild_log_message
        rescue
          next
        end
      end
    end
  end

  def event_type
    "#{auditable_type} #{audit_type.name.gsub(/_/, " ").titleize}"
  end
  
  def user_link
    user.nil? ? "Unknown User" : link_to(h(user.login), admin_audits_path(:user => user_id))
  end

  def auditable_path
    admin_audits_path(:auditable_type => auditable_type, :auditable_id => auditable_id)
  end

  def audit_type_with_cast=(type)
    @event_type = type.to_sym
    type = AuditType.find_by_name(type.to_s.upcase)
    self.audit_type_without_cast = type
  end
  alias_method_chain :audit_type=, :cast

  def rebuild_log_message
    @event_type = audit_type.name.downcase.to_sym
    assemble_log_message
    update_attribute(:log_message, log_message)
    reload
  end

  private

    def assemble_log_message
      return false unless Audit.logging?
      self.log_message = self.auditable.class.log_formats[@event_type].call(self)
    end

end