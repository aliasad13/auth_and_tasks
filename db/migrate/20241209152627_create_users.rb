class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, unique: true
      t.string :password_digest
      t.string :phone
      t.string :status

      t.timestamps
    end
  end
end
