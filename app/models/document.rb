class Document < ApplicationRecord
  belongs_to :comment

  validate :file_size_under_one_mb
  validates :file_contents, :filename, presence: true

  def initialize(params = {})
    @file = params.delete(:file)
    super
    if @file && @file.try(:original_filename).present?
      self.filename = sanitize_filename(@file.original_filename)
      self.content_type = @file.content_type
      self.file_contents = @file.read
      self.size = @file.size.to_i
    end
  end

  private

  def sanitize_filename(filename)
    return File.basename(filename)
  end

  NUM_BYTES_IN_MEGABYTE = 1048576
  def file_size_under_one_mb
    if @file.present? && (@file.size.to_f / NUM_BYTES_IN_MEGABYTE) > 1
      errors.add(:file, 'File size cannot be over one megabyte.')
    end
  end
end
