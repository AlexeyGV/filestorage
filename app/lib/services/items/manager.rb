module Services
  module Items
    class Manager
      FILES_PER_FOLDER = 999.freeze

      def initialize(filename)
        @filename = filename
      end

      def full_path
        @full_path ||= [Item::STORAGE_PATH, local_path].join('/')
      end

      def local_path
        @local_path ||= [folder_name, @filename].join('/')
      end

      private

      def split_filename
        @filename.sub(/(?<folder>\w{2})(?<subfolder>\w{2})/, '\k<folder>/\k<subfolder>/')
      end

      def folder_name
        prepare_folder
        return current_folder_name if current_folder_is_ok?
        # TODO: it has to return folder anyway, generate new filename
        # next_folder_name
        # folder_name
      end

      def current_folder_name
        @current_folder_name ||= split_filename.first(5)
      end

      def current_full_folder_name
        @current_full_folder_name ||= [Item::STORAGE_PATH, current_folder_name].join('/')
      end

      def prepare_folder
        FileUtils.mkdir_p(current_full_folder_name) unless File.exists?(current_full_folder_name)
      end

      def current_folder_is_ok?
        path = current_full_folder_name
        mask = [path, '*'].join('/')
        File.exists?(path) && Dir[mask].length < FILES_PER_FOLDER
      end

    end
  end
end
