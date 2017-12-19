class ItemDecorator < Draper::Decorator
  delegate_all
  delegate :url_helpers, to: 'Rails.application.routes'

  def full_path
    [Item::STORAGE_PATH, path].join('/')
  end

  def link
    url_helpers.download_items_url(path: path)
  end
end
