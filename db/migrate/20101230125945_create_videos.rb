class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.text :url
      t.text :title
      t.text :video_url
      t.text :download_path
      t.boolean :downloaded
      t.text :encoded_path
      t.boolean :encoded

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
