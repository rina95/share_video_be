class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.belongs_to :user
      t.text :url
      t.string :video_id
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
