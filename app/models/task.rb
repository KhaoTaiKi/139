class Task < ApplicationRecord
  validates :title, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :completed, -> { where(completed: true) }
  scope :active, -> { where(completed: false).or(where(completed: nil)) }

  def completed?
    !!completed
  end
end
