package dao;

import java.util.List;

import entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import utils.JpaUtils;

public class UserDaoImpl implements UserDao{
    
    @Override
    public User insert(User user) {
        EntityManager em = JpaUtils.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        
        try {
            trans.begin();
            em.persist(user);
            trans.commit();
            return user;
        }catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
    
    @Override
    public User update(User user) {
        EntityManager em = JpaUtils.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            User updatedUser = em.merge(user);
            trans.commit();
            return updatedUser;
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            throw e;
        }finally {
            em.close();
        }
    }
    
    @Override
    public User delete(int id) {
        EntityManager em = JpaUtils.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            User user = em.find(User.class, id);
            if (user != null) {
                // Xóa các bản ghi liên quan trước khi xóa user
                // Xóa Comments của user
                em.createQuery("DELETE FROM Comment c WHERE c.user.id = :userId")
                  .setParameter("userId", id)
                  .executeUpdate();
                
                // Xóa Favourites của user
                em.createQuery("DELETE FROM Favourite f WHERE f.user.id = :userId")
                  .setParameter("userId", id)
                  .executeUpdate();
                
                // Xóa Shares của user
                em.createQuery("DELETE FROM Share s WHERE s.user.id = :userId")
                  .setParameter("userId", id)
                  .executeUpdate();
                
                // Xóa WatchHistory của user (nếu có)
                try {
                    em.createQuery("DELETE FROM WatchHistory w WHERE w.user.id = :userId")
                      .setParameter("userId", id)
                      .executeUpdate();
                } catch (Exception ignored) {
                    // Bỏ qua nếu không có entity WatchHistory
                }
                
                // Cuối cùng xóa user
                em.remove(user);
            }
            trans.commit();
            return user;
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
    
    @Override
    public User findById(int id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.find(User.class, id);
        } finally {
            em.close();
        }
    }
    
    @Override
    public User findByEmail(String email) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery(
                    "SELECT u FROM User u WHERE u.email = :email", User.class);
            query.setParameter("email", email);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<User> findAll() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<User> q = em.createQuery("SELECT u FROM User u", User.class);
            List<User> list = q.getResultList();
            System.out.println("[UserDaoImpl] findAll size=" + (list == null ? 0 : list.size()));
            return list;
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean existsByEmail(String email) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.email = :email", Long.class);
            query.setParameter("email", email);
            return query.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }
}
