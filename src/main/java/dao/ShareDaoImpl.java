package dao;

import entity.Share;
import entity.User;
import entity.Video;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import utils.JpaUtils;

import java.time.LocalDate;
import java.util.List;

public class ShareDaoImpl implements ShareDao{
    @Override
    public Share find(int userId, int videoId, String email) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Share> q = em.createQuery(
                    "SELECT s FROM Share s WHERE s.user.id = :uid AND s.video.id = :vid AND s.email = :email",
                    Share.class
            );
            q.setParameter("uid", userId);
            q.setParameter("vid", videoId);
            q.setParameter("email", email);
            return q.getSingleResult();
        } catch (NoResultException ex) {
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public boolean upsert(int userId, int videoId, String email) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();

            Share existing = null;
            try {
                TypedQuery<Share> q = em.createQuery(
                        "SELECT s FROM Share s WHERE s.user.id = :uid AND s.video.id = :vid AND s.email = :email",
                        Share.class
                );
                q.setParameter("uid", userId);
                q.setParameter("vid", videoId);
                q.setParameter("email", email);
                existing = q.getSingleResult();
            } catch (NoResultException ignore) {}

            if (existing == null) {
                User u = em.find(User.class, userId);
                Video v = em.find(Video.class, videoId);
                if (u == null || v == null) {
                    em.getTransaction().rollback();
                    throw new IllegalArgumentException("User/Video not found");
                }
                Share s = Share.builder()
                        .user(u)
                        .video(v)
                        .email(email)
                        .shareDate(LocalDate.now())
                        .build();
                em.persist(s);
                em.getTransaction().commit();
                return true; // lần đầu
            } else {
                existing.setShareDate(LocalDate.now());
                em.merge(existing);
                em.getTransaction().commit();
                return false; // cập nhật thời gian
            }
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Share> findAll() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.createQuery("SELECT s FROM Share s", Share.class).getResultList();
        } finally {
            em.close();
        }
    }
}
