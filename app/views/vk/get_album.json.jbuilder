@user_id = cookies[:vk_id]

photos = @user.photos.get(uid: @user_id, aid: @aid)

json.array! photos do |photo|
  json.preview photo['src']
  json.big photo['src_big']
end
