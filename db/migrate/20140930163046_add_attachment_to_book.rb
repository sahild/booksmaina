class AddAttachmentToBook < ActiveRecord::Migration
  def self.up
    add_attachment :books, :cover
  end

  def self.down
    remove_attachment :books, :cover
  end
end
