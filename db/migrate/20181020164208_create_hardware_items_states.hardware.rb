# This migration comes from hardware (originally 20181017142729)
class CreateHardwareItemsStates < ActiveRecord::Migration[4.2]
  def change
    create_table :hardware_items_states do |t|
      t.belongs_to :item
      t.belongs_to :state
      t.text :reason_en
      t.text :reason_ru
      t.text :description_en
      t.text :description_ru
      t.timestamps null: false
    end
  end
end
