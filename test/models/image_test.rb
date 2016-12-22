require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  should validate_presence_of(:attachment_cache_url)
  should validate_presence_of(:attachment_content_type)
  should validate_presence_of(:attachment_file_size)

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

  test '#attachment_url correctly translates original file name to styled version' do
    image = images(:valid_image)
    image.attachment_cache_url = 'http://locable.com/_originals/123/logo.png'

    assert_equal 'http://locable.com/r/big/123/logo.png', image.attachment_url('big')
  end
end
