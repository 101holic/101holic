class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :user, index: true
      t.integer :provider_cd
      t.string :uid
      t.string :token
      t.timestamp :token_expires_at
      t.string :secret
      t.string :username
      t.string :profile_url

      t.timestamps
    end
  end
end
