# frozen_string_literal: true

require 'test_helper'

class TestUtils < Minitest::Test
  def setup
    @temp_dir = Dir.mktmpdir
  end

  def teardown
    FileUtils.remove_entry @temp_dir
  end

  def test_build_attachment_with_valid_file
    file_path = create_temp_file('test.txt', 'Hello, World!')
    result = DashamailTransactional::Utils.build_attachment(file_path)

    assert_equal 'test.txt', result[:name]
    assert_equal Base64.strict_encode64('Hello, World!'), result[:filebody]
  end

  def test_build_attachment_with_empty_file
    file_path = create_temp_file('empty.txt', '')
    result = DashamailTransactional::Utils.build_attachment(file_path)

    assert_equal 'empty.txt', result[:name]
    assert_equal '', result[:filebody]
  end

  def test_build_attachment_with_binary_file
    binary_content = "\x00\x01\x02\x03"
    file_path = create_temp_file('binary.bin', binary_content)
    result = DashamailTransactional::Utils.build_attachment(file_path)

    assert_equal 'binary.bin', result[:name]
    assert_equal Base64.strict_encode64(binary_content), result[:filebody]
  end

  def test_build_attachment_with_non_existent_file
    assert_raises(StandardError, 'File not exist') do
      DashamailTransactional::Utils.build_attachment('non_existent.txt')
    end
  end

  def test_build_inline_with_valid_image
    file_path = create_temp_file('image.jpg', 'fake image content')
    result = DashamailTransactional::Utils.build_inline(file_path, 'test_cid')

    assert_equal 'image/jpeg', result[:mime_type]
    assert_equal 'image.jpg', result[:filename]
    assert_equal Base64.strict_encode64('fake image content'), result[:body]
    assert_equal 'test_cid', result[:cid]
  end

  def test_build_inline_with_unknown_file_type
    file_path = create_temp_file('unknown.xyz', 'unknown content')
    result = DashamailTransactional::Utils.build_inline(file_path, 'test_cid')

    assert_equal 'x-chemical/x-xyz', result[:mime_type]
    assert_equal 'unknown.xyz', result[:filename]
    assert_equal Base64.strict_encode64('unknown content'), result[:body]
    assert_equal 'test_cid', result[:cid]
  end

  def test_build_inline_with_empty_file
    file_path = create_temp_file('empty.png', '')
    result = DashamailTransactional::Utils.build_inline(file_path, 'test_cid')

    assert_equal 'image/png', result[:mime_type]
    assert_equal 'empty.png', result[:filename]
    assert_equal '', result[:body]
    assert_equal 'test_cid', result[:cid]
  end

  def test_build_inline_with_non_existent_file
    assert_raises(StandardError, 'File not exist') do
      DashamailTransactional::Utils.build_inline('non_existent.jpg', 'test_cid')
    end
  end

  def test_build_inline_with_very_long_filename
    max_length = DashamailTransactional::Utils::MAX_FILENAME_LENGTH
    extension = '.txt'
    base_length = max_length - extension.bytesize
    long_filename = "#{"a" * 300}#{extension}"
    short_content = 'Short content'

    temp_file = Tempfile.new(['test', extension])
    temp_file.write(short_content)
    temp_file.close

    File.stub :basename, long_filename do
      result = DashamailTransactional::Utils.build_inline(temp_file.path, 'test_cid')

      expected_truncated_name = "#{"a" * base_length}#{extension}"
      assert_equal expected_truncated_name, result[:filename]
      assert_equal max_length, result[:filename].bytesize
      assert_equal Base64.strict_encode64(short_content), result[:body]
      assert_equal 'test_cid', result[:cid]
    end
  ensure
    temp_file.unlink
  end

  private

  def create_temp_file(name, content)
    path = File.join(@temp_dir, name)
    File.write(path, content)
    path
  end
end
