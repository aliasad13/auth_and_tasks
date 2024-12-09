class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :status, presence: true, inclusion: {in: ['pending', 'in_progress', 'completed']}
  validates :due_date, presence: true
  validate :validate_due_date

  enum status: {pending: 0, in_progress: 1, completed: 2}

  private

  def validate_due_date
    if due_date > Date.today
      errors.add(:due_date, 'future dates are not allowed')
    end
  end
end
