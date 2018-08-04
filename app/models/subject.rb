class Subject < ApplicationRecord
  belongs_to :user
  # rails_admin do 
  #   list do 
  #     field :id
  #     field :title
  #     field :user_id
  #   end
  # end
end
