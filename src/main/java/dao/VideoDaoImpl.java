package dao;

import entity.Video;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import utils.JpaUtils;

import java.util.List;

public class VideoDaoImpl implements VideoDao {

    @Override
    public List<Video> findPage(int pageNumber, int pageSize) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Video> query = em.createQuery(
                    "SELECT v FROM Video v WHERE v.status = TRUE ORDER BY v.postingDate DESC, v.id DESC",
                    Video.class
            );
            int firstResult = (pageNumber - 1) * pageSize;
            query.setFirstResult(firstResult);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countAll() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(v) FROM Video v WHERE v.status = TRUE",
                    Long.class
            );
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public Video findById(int id){
        EntityManager em = JpaUtils.getEntityManager();
        try{
            return em.find(Video.class, id);
        }finally {
            em.close();
        }
    }

    @Override
    public List<Video> findRelated(int excludeId,int limit){
        EntityManager em = JpaUtils.getEntityManager();
        try{
            TypedQuery<Video> q = em.createQuery(
                    "SELECT v FROM Video v WHERE v.status = TRUE AND v.id<> :vid ORDER BY v.postingDate DESC, v.id DESC",
                    Video.class
            );
            q.setParameter("vid", excludeId);
            q.setMaxResults(limit);
            return q.getResultList();
        }finally {
            em.close();
        }
    }

    @Override
    public void incrementViews(int id){
        EntityManager em = JpaUtils.getEntityManager();
        try{
            em.getTransaction().begin();
            Video v = em.find(Video.class, id);
            if (v != null) {
                v.setViews((v.getViews() == null ? 0 : v.getViews()) + 1);
            }
            em.getTransaction().commit();
        }catch (Exception ex){
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        }finally {
            em.close();
        }
    }

    @Override
    public List<Video> findAll() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Video> q = em.createQuery(
                    "SELECT v FROM Video v ORDER BY v.postingDate DESC, v.id DESC",
                    Video.class
            );
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public void update(Video video) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            Video managed = em.find(Video.class, video.getId());
            if (managed == null) {
                throw new IllegalArgumentException("Video không tồn tại: id=" + video.getId());
            }
            managed.setLinkYoutube(video.getLinkYoutube());
            managed.setTitle(video.getTitle());
            managed.setContent(video.getContent());
            managed.setStatus(video.getStatus());
            managed.setPostingDate(video.getPostingDate());
            managed.setThumbnailUrl(video.getThumbnailUrl());
            managed.setChannelName(video.getChannelName());
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            em.close();
        }
    }

    @Override
    public Video findByLink(String linkYoutube) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Video> q = em.createQuery(
                    "SELECT v FROM Video v WHERE v.linkYoutube = :link",
                    Video.class
            );
            q.setParameter("link", linkYoutube);
            List<Video> rs = q.getResultList();
            return rs.isEmpty() ? null : rs.get(0);
        } finally {
            em.close();
        }
    }

    @Override
    public void deleteById(int id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();

            // Xóa phụ thuộc (do FK không cascade)
            em.createQuery("DELETE FROM Comment c WHERE c.video.id = :vid")
              .setParameter("vid", id).executeUpdate();
            em.createQuery("DELETE FROM Favourite f WHERE f.video.id = :vid")
              .setParameter("vid", id).executeUpdate();
            em.createQuery("DELETE FROM Share s WHERE s.video.id = :vid")
              .setParameter("vid", id).executeUpdate();
            
            // Native SQL dùng positional parameter (?) thay vì named parameter
            em.createNativeQuery("DELETE FROM WatchHistory WHERE VideoId = ?1")
              .setParameter(1, id).executeUpdate();

            Video v = em.find(Video.class, id);
            if (v != null) em.remove(v);

            em.getTransaction().commit();
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            em.close();
        }
    }

    @Override
    public Video insert(Video video) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(video);
            em.getTransaction().commit();
            return video;
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            em.close();
        }
    }

    @Override
    public boolean existsByLinkAndChannel(String linkYoutube, String channelName) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Long> q = em.createQuery(
                    "SELECT COUNT(v) FROM Video v WHERE v.linkYoutube = :link AND v.channelName = :channel",
                    Long.class
            );
            q.setParameter("link", linkYoutube);
            q.setParameter("channel", channelName);
            return q.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Video> findPageByKeyword(String keyword, int pageNumber, int pageSize) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String searchPattern = "%" + keyword.toLowerCase() + "%";
            TypedQuery<Video> query = em.createQuery(
                    "SELECT v FROM Video v WHERE v.status = TRUE " +
                    "AND LOWER(v.title) LIKE :keyword " +
                    "ORDER BY v.postingDate DESC, v.id DESC",
                    Video.class
            );
            query.setParameter("keyword", searchPattern);
            int firstResult = (pageNumber - 1) * pageSize;
            query.setFirstResult(firstResult);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countByKeyword(String keyword) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String searchPattern = "%" + keyword.toLowerCase() + "%";
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(v) FROM Video v WHERE v.status = TRUE " +
                    "AND LOWER(v.title) LIKE :keyword",
                    Long.class
            );
            query.setParameter("keyword", searchPattern);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Video> findAllActive() {
        EntityManager em = utils.JpaUtils.getEntityManager();
        try {
            TypedQuery<Video> q = em.createQuery(
                "SELECT v FROM Video v WHERE v.status = TRUE ORDER BY v.postingDate DESC, v.id DESC",
                Video.class
            );
            List<Video> list = q.getResultList();
            // In ra console để kiểm tra
            System.out.println("==> Danh sách video đã đăng (status=1):");
            for (Video v : list) {
                System.out.println("ID: " + v.getId() + ", Title: " + v.getTitle() + ", Status: " + v.getStatus());
            }
            return list;
        } finally {
            em.close();
        }
    }
}
