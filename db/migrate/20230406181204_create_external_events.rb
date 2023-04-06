class CreateExternalEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :external_events do |t|
      t.references :calendar, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.string :external_id

      t.timestamps
    end
  end
end
