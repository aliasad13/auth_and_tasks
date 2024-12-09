lass TaskSerializer < ActiveModel::Serializer
attributes :id, :title, :description, :status, :formatted_due_date

def formatted_due_date
  object.due_date.strftime("%B %d, %Y")
end
