# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# track = Track.create(attribute: 'value')
# parent_model.child_models.create(attribute: 'value')

require 'bcrypt'

# パスワードをハッシュ化するヘルパーメソッド
def hash_password(password)
  salt = BCrypt::Engine.generate_salt
  BCrypt::Engine.hash_secret(password, salt)
end

# ジャンルの定義
genres = Album.genres.keys

# ユーザーデータのシード
5.times do |n|
  User.create!(
    email: "test#{n + 1}@test.com",
    password: 'password',
    password_confirmation: 'password',
    name: "テスト太郎#{n + 1}",
    instrument: User.instruments.keys.sample,
    role: User.roles.keys.sample
  )
end

# アルバムデータのシード
Album.create(title: "Thriller", genre: genres.sample, artist_name: "Michael Jackson")
Album.create(title: "Abbey Road", genre: genres.sample, artist_name: "The Beatles")
Album.create(title: "The Dark Side of the Moon", genre: genres.sample, artist_name: "Pink Floyd")
Album.create(title: "OK Computer", genre: genres.sample, artist_name: "Radiohead")
Album.create(title: "Nevermind", genre: genres.sample, artist_name: "Nirvana")

# 曲データのシード
albums = Album.all
albums.each do |album|
  2.times do |n|
    album.songs.create(
      song_name: "Song #{n + 1}",
      bpm: rand(80..180)
    )
  end
end

# トラックデータのシード
users = User.all
songs = Song.all
users.each do |user|
  2.times do |n|
    user.tracks.create(
      song: songs.sample,
      start: 0,
      "end": rand(180..300),
      section: n + 1,
      bpm: rand(80..180),
      instrument: user.instrument
    )
  end
end
