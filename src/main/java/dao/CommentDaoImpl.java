package dao;

import entity.Comment;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import utils.JpaUtils;

import java.util.List;

public class CommentDaoImpl implements CommentDao {
    @Override
    public List<Comment> findByVideoId(int videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Comment> q = em.createQuery(
                    "SELECT c FROM Comment c JOIN FETCH c.user WHERE c.video.id = :vid ORDER BY c.commentDate DESC, c.id DESC",
                    Comment.class
            );
            q.setParameter("vid", videoId);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countByVideoId(int videoId) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Long> q = em.createQuery(
                    "SELECT COUNT(c) FROM Comment c WHERE c.video.id = :vid",
                    Long.class
            );
            q.setParameter("vid", videoId);
            return q.getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public Comment insert(Comment c) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(c);
            em.getTransaction().commit();
            return c;
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw ex;
        } finally {
            em.close();
        }
    }
}
