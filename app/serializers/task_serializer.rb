class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :formatted_due_date, :created_at, :updated_at

  def formatted_due_date
    object.due_date.in_time_zone('Asia/Kolkata').strftime("%B %d, %Y")
  end

  def created_at
    object.created_at.in_time_zone('Asia/Kolkata').strftime("%B %d, %Y %I:%M %p")
  end

  def updated_at
    object.updated_at.in_time_zone('Asia/Kolkata').strftime("%B %d, %Y %I:%M %p")
  end

end