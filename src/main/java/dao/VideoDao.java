package dao;

import entity.Video;

import java.util.List;

public interface VideoDao {
    List<Video> findPage(int pageNumber, int pageSize);
    long countAll();
    Video findById(int id);
    List<Video> findRelated(int excludeId, int limit);
    void incrementViews(int id);
    List<Video> findAll();
    void update(Video video);
    Video findByLink(String linkYoutube);
    void deleteById(int id);
    
    // Thêm mới
    Video insert(Video video);
    boolean existsByLinkAndChannel(String linkYoutube, String channelName);
    
    // Tìm kiếm theo từ khóa
    List<Video> findPageByKeyword(String keyword, int pageNumber, int pageSize);
    long countByKeyword(String keyword);
    List<Video> findAllActive(); // Thêm dòng này
}
