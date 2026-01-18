package utils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JpaUtils {
	/*private static EntityManagerFactory emf;
	
	static {
		try {
			emf = Persistence.createEntityManagerFactory("ASM_JAVA4");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static EntityManager getEntityManager() {
		return emf.createEntityManager();
	}
	
	public static void shutdown() {
		if (emf != null && emf.isOpen()) {
			emf.close();
		}
	}*/
	private static final EntityManagerFactory emf = buildEmf();

	private static EntityManagerFactory buildEmf() {
		try {
			return Persistence.createEntityManagerFactory("ASM_JAVA4");
		} catch (Exception ex) {
			// Log and rethrow to surface configuration issues early
			throw new IllegalStateException("Failed to initialize JPA EntityManagerFactory (persistence unit ASM_JAVA4)", ex);
		}
	}

	public static EntityManager getEntityManager() {
		return emf.createEntityManager();
	}
}
