class CreateOrderStates < ActiveRecord::Migration
  def self.up
    create_table :order_states do |t|
      t.string :name
      t.string :code
    end

    OrderState.create(:code => 'new', :name => 'Nová')
    OrderState.create(:code => 'processed', :name => 'Vyřizuje se')
    OrderState.create(:code => 'shipped', :name => 'Odeslaná')
    OrderState.create(:code => 'paid', :name => 'Zaplacená')
    OrderState.create(:code => 'paid_not_shipped', :name => 'Zaplacená neodeslaná')
    OrderState.create(:code => 'canceled', :name => 'Stornovaná')
  end

  def self.down
    drop_table :order_states
  end
end
