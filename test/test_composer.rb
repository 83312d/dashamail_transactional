# frozen_string_literal: true

require 'test_helper'

class TestComposerComposer < Minitest::Test
  def setup
    @composer = DashamailTransactional::Composer.new
  end

  def test_initial_state
    assert_nil @composer.call[:to]
    assert_equal DashaMail.config.from_name, @composer.call[:from_name]
    assert_equal DashaMail.config.from_email, @composer.call[:from_email]
    assert_equal DashaMail.config.ignore_delivery_policy, @composer.call[:ignore_delivery_policy]
    assert_equal DashaMail.config.no_track_clicks, @composer.call[:no_track_clicks]
    assert_equal DashaMail.config.no_track_opens, @composer.call[:no_track_opens]
  end

  def test_setter_methods
    @composer.to = 'test@example.com'
    @composer.subject = 'Test Subject'
    @composer.message = 'Test Message'
    @composer.campaign_id = 'Test Campaign ID'

    assert_equal 'test@example.com', @composer.call[:to]
    assert_equal 'Test Subject', @composer.call[:subject]
    assert_equal 'Test Message', @composer.call[:message]
    assert_equal 'Test Campaign ID', @composer.call[:campaign_id]
  end

  def test_add_attachment
    mock_attachment = { name: 'test.txt', content: 'VGVzdCBjb250ZW50' }
    DashamailTransactional::Utils.stub :build_attachment, mock_attachment do
      @composer.add_attachment('test.txt')
      assert_equal 1, @composer.call[:attachments].size
      assert_equal mock_attachment, @composer.call[:attachments].first
    end
  end

  def test_add_inline
    mock_inline = { name: 'image.jpg', content: 'RmFrZSBpbWFnZSBjb250ZW50', cid: 'cid123' }
    DashamailTransactional::Utils.stub :build_inline, mock_inline do
      @composer.add_inline('image.jpg', 'cid123')
      assert_equal 1, @composer.call[:inline].size
      assert_equal mock_inline, @composer.call[:inline].first
    end
  end

  def test_overriding_default_values
    @composer.from_name = 'New Name'
    @composer.from_email = 'new@example.com'
    @composer.ignore_delivery_policy = false
    @composer.no_track_clicks = true
    @composer.no_track_opens = true

    assert_equal 'New Name', @composer.call[:from_name]
    assert_equal 'new@example.com', @composer.call[:from_email]
    assert_equal false, @composer.call[:ignore_delivery_policy]
    assert_equal true, @composer.call[:no_track_clicks]
    assert_equal true, @composer.call[:no_track_opens]
  end
end
