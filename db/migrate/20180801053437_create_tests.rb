class CreateTests < ActiveRecord::Migration[5.1]
  def change
    create_table :tests do |t|
      t.references :subject, foreign_key: true
      t.integer :time_required
      t.json :question_details
      t.integer :number_of_questions
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end