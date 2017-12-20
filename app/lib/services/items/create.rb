require 'digest'

module Services
  module Items
    class Create
      attr_reader :item

      def initialize(file)
        @file = file
        @item = Item.new
      end

      def call(manager_class = Services::Items::Manager)
        manager = manager_class.new(filename)
        Item.transaction do
          save_file(manager.full_path)
          @item.path = manager.local_path
          @item.original_filename = @file.original_filename
          @item.save!
          true
        end
      rescue
        remove_file(manager.full_path)
        false
      end

      private

      def save_file(file_path)
        File.open(file_path, 'wb') do |f|
          f.write(@file.read)
        end
      end

      def remove_file(file_path)
        File.delete(file_path) if File.exist?(file_path)
      end

      def filename
        ext = File.extname(@file.original_filename)
        name = digest(file_basename) + ext
      end

      def file_basename
        File.basename(@file.original_filename) << timestamp
      end

      def timestamp
        Time.zone.now.strftime('%Y%m%d%H%M%S')
      end

      def digest(basename)
        Digest::MD5.hexdigest(basename)
      end

    end
  end
end
