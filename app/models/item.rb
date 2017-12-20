class Item < ApplicationRecord
  # TODO: change storedir to "#{Rails.root}/spec/support/storage/" for testing env
  STORAGE_PATH = Rails.root.join('storage').freeze

  validates :path, presence: true
end
