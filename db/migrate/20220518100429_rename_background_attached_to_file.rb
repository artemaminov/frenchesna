class RenameBackgroundAttachedToFile < ActiveRecord::Migration[5.2]
  def up
    ActiveStorage::Attachment.all.each {|attachment|
      attachment.name = 'file'
      attachment.save
    }
  end

  def down
    puts "Can't recover changed data"
  end
end
