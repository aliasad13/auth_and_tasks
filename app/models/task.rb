class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :status, presence: true #after initialize sets this true
  validates :due_date, presence: true
  validate :validate_due_date

  after_initialize :set_default_status, if: :new_record? #setting default status whenever a new task is initialized

  enum status: {pending: 0, in_progress: 1, completed: 2}

  private

  def set_default_status
    self.status ||= 'pending'
  end

  def validate_due_date
    if due_date.to_date < Date.today
      errors.add(:due_date, 'past dates cannot be added as a due date')
    end
  end
end
