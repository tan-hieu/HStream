package dao;

import entity.Favourite;
import entity.User;
import entity.Video;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

import utils.JpaUtils;

public class FavouriteDaoImpl implements FavouriteDao {

    @Override
    public boolean exists(int userId, int videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Long> q = em.createQuery(
                    "SELECT COUNT(f) FROM Favourite f WHERE f.user.id = :uid AND f.video.id = :vid", Long.class);
            q.setParameter("uid", userId);
            q.setParameter("vid", videoId);
            return q.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }

    @Override
    public Favourite find(int userId, int videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Favourite> q = em.createQuery(
                    "SELECT f FROM Favourite f WHERE f.user.id = :uid AND f.video.id = :vid", Favourite.class);
            q.setParameter("uid", userId);
            q.setParameter("vid", videoId);
            return q.getSingleResult();
        } catch (NoResultException ex) {
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public Favourite add(int userId, int videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            if (exists(userId, videoId)) return find(userId, videoId);
            em.getTransaction().begin();
            User u = em.find(User.class, userId);
            Video v = em.find(Video.class, videoId);
            if (u == null || v == null) {
                em.getTransaction().rollback();
                return null;
            }
            Favourite f = Favourite.builder()
                    .user(u)
                    .video(v)
                    .likeDate(LocalDate.now())
                    .build();
            em.persist(f);
            em.getTransaction().commit();
            return f;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public void remove(int userId, int videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            Favourite f = findInternal(em, userId, videoId);
            if (f != null) em.remove(f);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    private Favourite findInternal(EntityManager em, int userId, int videoId) {
        try {
            TypedQuery<Favourite> q = em.createQuery(
                    "SELECT f FROM Favourite f WHERE f.user.id = :uid AND f.video.id = :vid", Favourite.class);
            q.setParameter("uid", userId);
            q.setParameter("vid", videoId);
            return q.getSingleResult();
        } catch (NoResultException ex) {
            return null;
        }
    }

    @Override
    public long countByVideo(int videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Long> q = em.createQuery(
                    "SELECT COUNT(f) FROM Favourite f WHERE f.video.id = :vid", Long.class);
            q.setParameter("vid", videoId);
            return q.getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Video> findLikedVideos(int userId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Video> q = em.createQuery(
                    "SELECT f.video FROM Favourite f JOIN f.video v " +
                            "WHERE f.user.id = :uid AND v.status = TRUE " +
                            "ORDER BY f.likeDate DESC, v.id DESC",
                    Video.class
            );
            q.setParameter("uid", userId);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countByUser(int userId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Long> q = em.createQuery(
                    "SELECT COUNT(f) FROM Favourite f WHERE f.user.id = :uid",
                    Long.class
            );
            q.setParameter("uid", userId);
            return q.getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Favourite> findAll() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.createQuery("SELECT f FROM Favourite f", Favourite.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Object[]> findByVideoId(int videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.createQuery(
                "SELECT f.id, u.id, u.fullname, u.email, v.id, v.title, f.likeDate " +
                "FROM Favourite f " +
                "JOIN f.user u " +
                "JOIN f.video v " +
                "WHERE v.id = :vid", Object[].class)
                .setParameter("vid", videoId)
                .getResultList();
        } catch (Exception e) {
            return Collections.emptyList();
        } finally {
            em.close();
        }
    }
}
