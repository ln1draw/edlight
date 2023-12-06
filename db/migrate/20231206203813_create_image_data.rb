class CreateImageData < ActiveRecord::Migration[7.1]
  def change
    create_table :image_data do |t|
      t.string :description
      t.string :name
      t.string :image

      t.timestamps
    end
  end
end
