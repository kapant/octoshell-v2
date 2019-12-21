# This migration comes from jobstat (originally 20171226061144)
class CreateJobstatJobs < ActiveRecord::Migration[4.2]
  def change
    return if File.exists? '/tmp/skip-octoshell-bad-migrations'
    create_table :jobstat_jobs do |t|
      t.string :cluster, :limit => 32
      t.bigint :drms_job_id
      t.bigint :drms_task_id
      t.string :login, :limit => 32, :index => true
      t.string :partition, :limit => 32, :index => true
      t.datetime :submit_time, :index => true
      t.datetime :start_time, :index => true
      t.datetime :end_time, :index => true
      t.bigint :timelimit
      t.string :command, :limit => 1024
      t.string :state, :limit => 32, :index => true
      t.bigint :num_cores
      t.bigint :num_nodes

      t.timestamps null: false
    end
  end
end
