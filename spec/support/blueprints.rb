require 'machinist/active_record'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

User.blueprint do
  name {"User-#{sn}"}
  email {"User-#{sn}@nowhere.com"}
  password {"password"}
end

Game.blueprint do
  player_one {Player.make!}
end

Player.blueprint do
  user {User.make!}
end
