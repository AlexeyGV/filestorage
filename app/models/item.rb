class Item < ApplicationRecord
  STORAGE_PATH = Rails.root.join('storage').freeze

  validates :path, presence: true
end
