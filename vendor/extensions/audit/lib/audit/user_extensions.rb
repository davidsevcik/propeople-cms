module Audit
  module UserExtensions

    def self.included(base)
      base.class_eval do
        extend Auditable

        audit_event :create do |event|
          "#{event.user_link} created " + link_to(h(event.auditable.name), event.auditable_path)
        end

        audit_event :update do |event|
          "#{event.user_link} updated " + link_to(h(event.auditable.name), event.auditable_path)
        end

        audit_event :destroy do |event|
          "#{event.user_link} deleted " + link_to(h(event.auditable.name), event.auditable_path)
        end

        audit_event :login do |event|
          "#{event.user_link} logged in"
        end

        audit_event :logout do |event|
          "#{event.user_link} logged out"
        end

        audit_event :bad_login do |event|
          "failed login attempt"
        end

        audit_event :bad_password do |event|
          "failed login attempt for " + link_to(h(event.auditable.name), event.auditable_path)
        end

        named_scope :with_audited_events, :joins => 'INNER JOIN audit_events ON audit_events.user_id = users.id', :order => :login, :select => "DISTINCT(users.id), login"

      end
    end

  end
end