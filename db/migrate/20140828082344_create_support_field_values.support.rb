# This migration comes from support (originally 20140827145506)
class CreateSupportFieldValues < ActiveRecord::Migration[4.2]
  def change
    create_table :support_field_values do |t|
      t.integer :field_id
      t.integer :ticket_id
      t.text :value

      t.timestamps

      t.index :ticket_id
    end
  end
end
