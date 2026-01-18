package dao;

import entity.Share;
import java.util.List;

public interface ShareDao {
    Share find(int userId, int videoId, String email);
    boolean upsert(int userId, int videoId, String email); //true:lần đầu,false cập nhật
    List<Share> findAll();
}
