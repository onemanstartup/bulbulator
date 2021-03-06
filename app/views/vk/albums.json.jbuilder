@user_id = cookies[:vk_id]

json.albums do
  thumb_ids = []
  titles = {}
  albums = @user.photos.getAlbums

  albums.each do |album|
    thumb_ids << (album['owner_id'] + '_' + album['thumb_id'])
    titles[album['aid']] = album['title']
  end

  ids = thumb_ids.join(',')
  covers = @user.photos.getById(photos: ids)
  json.array! covers do |cover|
    json.aid cover['aid']
    json.title titles[cover['aid']]
    json.src cover['src_big']
  end
end

json.user do
  json.(@user.getProfiles(uid: @user_id, fields: 'first_name, last_name, city, photo_medium')[0], 'first_name', 'last_name', 'photo_medium')
  json.activity @user.vk_call('activity.get', {uid: @user_id})['activity']
end
