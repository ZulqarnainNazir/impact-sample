require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  should validate_presence_of(:attachment_cache_url)
  # should validate_presence_of(:attachment_content_type)
  # should validate_presence_of(:attachment_file_size)

  test 'Image with non-image content type should be invalid' do
    image = images(:valid_image)
    image.attachment_content_type = 'application/pdf'

    assert_not image.valid?
    assert_not_empty image.errors[:attachment_content_type]
  end

  test 'Images over 10 mebabytes should be invalid' do
    image = images(:valid_image)
    image.attachment_file_size = 11.megabytes

    assert_not image.valid?
    assert_not_empty image.errors[:attachment_file_size]
  end

  test '#attachment_url returns the attachment_cache_url when style == :original' do
    image = images(:valid_image)

    assert_equal image.attachment_cache_url, image.attachment_url(:original)
  end

  test '#s3_key generates a key from the attachment_cache_url' do
    image = images(:valid_image)
    image.attachment_cache_url = 'http://locable.com/_originals/123/logo.png'

    assert_equal 'r/thumbnail/123/logo.png', image.s3_key(:thumbnail)
  end

  test '#s3_key works with spaces in the attachment_cache_url' do
    image = images(:valid_image)
    image.attachment_cache_url = 'http://locable.com/_originals/123/logo (1).png'

    assert_equal 'r/thumbnail/123/logo (1).png', image.s3_key(:thumbnail)
  end

  test '#s3_key with no style paramenter returns the original' do
    image = images(:valid_image)
    image.attachment_cache_url = 'http://locable.com/_originals/123/logo.png'

    assert_equal '_originals/123/logo.png', image.s3_key
  end
end
