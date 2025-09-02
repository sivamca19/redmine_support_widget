class SupportWidget < ApplicationRecord
  before_create :generate_token
  belongs_to :project
  belongs_to :tracker
  belongs_to :status, :class_name => 'IssueStatus'
  belongs_to :priority, :class_name => 'IssuePriority'

  private

  def generate_token
    self.token ||= SecureRandom.hex(16)
  end
end
