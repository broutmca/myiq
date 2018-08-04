class CreateScores < ActiveRecord::Migration[5.1]
  def change
    create_table :scores do |t|
      t.references :test, foreign_key: true
      t.json :answer_details
      t.json :users_raw_answers
      t.timestamps
    end
  end
end
