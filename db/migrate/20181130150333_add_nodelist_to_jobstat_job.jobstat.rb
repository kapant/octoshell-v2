# This migration comes from jobstat (originally 20181130150138)
class AddNodelistToJobstatJob < ActiveRecord::Migration
  def change
    add_column :jobstat_jobs, :nodelist, :text
  end
end
