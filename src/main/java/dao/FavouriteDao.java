package dao;

import entity.Favourite;
import entity.Video;

import java.util.List;

public interface FavouriteDao {
    boolean exists(int userId, int videoId);
    Favourite find(int userId, int videoId);
    Favourite add(int userId, int videoId);
    void remove(int userId, int videoId);
    long countByVideo(int videoId);
    List<Video> findLikedVideos(int userId);
    long countByUser(int userId);
    List<Favourite> findAll();
    List<Object[]> findByVideoId(int videoId);
}
