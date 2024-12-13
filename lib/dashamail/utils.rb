# frozen_string_literal: true

require 'base64'
require 'mime-types'

module DashamailTransactional
  class Utils
    MAX_FILENAME_LENGTH = 255

    class << self
      def build_attachment(file_path)
        validate_and_read_file(file_path) do |file_name, file_content|
          {
            name: truncate_filename(file_name),
            filebody: Base64.strict_encode64(file_content)
          }
        end
      end

      def build_inline(file_path, cid)
        validate_and_read_file(file_path) do |file_name, file_content|
          {
            mime_type: MIME::Types.type_for(file_path).first&.to_s || 'application/octet-stream',
            filename: truncate_filename(file_name),
            body: Base64.strict_encode64(file_content),
            cid: cid
          }
        end
      end

      private

      def validate_and_read_file(file_path)
        raise StandardError, 'File not exist' unless File.exist?(file_path)

        file_name = File.basename(file_path)
        file_content = File.open(file_path, 'rb', &:read)

        yield(file_name, file_content)
      end

      def truncate_filename(filename)
        return filename if filename.bytesize <= MAX_FILENAME_LENGTH

        extension = File.extname(filename)
        basename = File.basename(filename, extension)
        max_basename_length = MAX_FILENAME_LENGTH - extension.bytesize
        "#{basename.byteslice(0, max_basename_length)}#{extension}"
      end
    end
  end
end
