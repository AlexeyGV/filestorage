module Services
  module Items
    class Destroy

      def initialize(item)
        @item = item
      end

      def call
        Item.transaction do
          @item.destroy
          delete_file
        end
      rescue
        false
      end

      private

      def delete_file
        File.delete(@item.decorate.full_path)
      end

    end
  end
end
