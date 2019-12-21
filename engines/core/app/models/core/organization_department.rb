# == Schema Information
#
# Table name: core_organization_departments
#
#  id              :integer          not null, primary key
#  checked         :boolean          default(FALSE)
#  name            :string(255)
#  organization_id :integer
#
# Indexes
#
#  index_core_organization_departments_on_organization_id  (organization_id)
#

module Core
  class OrganizationDepartment < ApplicationRecord
    include MergeDepartments
    include Checkable
    belongs_to :organization, inverse_of: :departments

    has_many :projects

    has_many :employments, inverse_of: :organization_department
    has_many :users, class_name: Core.user_class.to_s, through: :employments
    has_many :members, inverse_of: :organization_department
    has_many :surety_members, inverse_of: :organization_department
    after_create :notify_admins

    scope :finder, ->(q){ where("name like :q", q: "%#{q.mb_chars}%").order(:name) }

    validates :name, :organization, presence: true

    def to_s
      name
    end

    def full_name
      "#{organization.short_name}, #{name}"
    end

    def as_json(options)
      { id: id, text: name }
    end

    def notify_admins
      Core::MailerWorker.perform_async(:new_organization_department, id)
    end

    def simple_readable_attributes
      %i[name]
    end
  end
end
