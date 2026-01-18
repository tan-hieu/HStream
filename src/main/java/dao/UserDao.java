package dao;

import entity.User;

import java.util.List;

public interface UserDao {
	boolean existsByEmail(String email);
	List<User> findAll();
	User findByEmail(String email);
	User findById(int id);
	User delete(int id);
	User update(User user);
	User insert(User user);
}
