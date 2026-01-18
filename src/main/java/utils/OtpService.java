package utils;

import jakarta.servlet.http.HttpSession;

import java.security.SecureRandom;

public class OtpService {
    private static final SecureRandom RAND = new SecureRandom();
    private static final long DEFAULT_TTL_MS = 5*60*1000;// mã có hiệu lực 5 phút
    private static final int MAX_ATTEMPTS = 3;
    private static final long LOCK_TTL_MS = 30_000;// khóa 30 giây sau 3 lần nhập sai

    public static String generateOtp(int digits) {
        int bound = (int) Math.pow(10, digits);
        int min = (int) Math.pow(10, digits - 1);
        int num = min + RAND.nextInt(bound - min);
        return String.valueOf(num);
    }

    public static void storeOtp(HttpSession session, String email, String otp){
        session.setAttribute("OTP_EMAIL",email);
        session.setAttribute("OTP_CODE",otp);
        session.setAttribute("OTP_VALID",Boolean.TRUE);
        session.setAttribute("OTP_TS", System.currentTimeMillis());
        session.setAttribute("OTP_TTL", DEFAULT_TTL_MS);

        //khởi tạo số lần thử và bỏ khóa
        session.setAttribute("OTP_ATTEMPTS",0);
        session.removeAttribute("OTP_LOCK_TS");
    }

    public static boolean isLocked(HttpSession session){
        Long lockTs = (Long) session.getAttribute("OTP_LOCK_TS");
        if (lockTs == null){
            return false;
        }
        long now = System.currentTimeMillis();
        if (now - lockTs > LOCK_TTL_MS){
            //Hết thời gian khóa: tự mở khóa và reset số lần thử
            session.removeAttribute("OTP_LOCK_TS");
            session.setAttribute("OTP_ATTEMPTS",0);
            return false;
        }
        return true;
    }

    public static boolean isOtpValid(HttpSession session){
        Object valid = session.getAttribute("OTP_VALID");
        Long ts = (Long) session.getAttribute("OTP_TS");
        Long ttl = (Long) session.getAttribute("OTP_TTL");
        if (!(valid instanceof Boolean) || !((Boolean) valid)){
            return false;
        }
        long now = System.currentTimeMillis();
        return ts != null && ttl != null && now - ts <= ttl;
    }

    public static boolean verifyOtp(HttpSession session,String email, String otp){
        if (isLocked(session)){
            return false;
        }
        if (!isOtpValid(session)){
            return false;
        }
        String sessEmail = (String) session.getAttribute("OTP_EMAIL");
        String sessOtp = (String) session.getAttribute("OTP_CODE");
        boolean ok = email != null && email.equals(sessEmail) && otp != null && otp.equals(sessOtp);

        if (!ok){
            int attempts = getAttempts(session) + 1;
            session.setAttribute("OTP_ATTEMPTS",attempts);
            if (attempts >= MAX_ATTEMPTS){
                session.setAttribute("OTP_LOCK_TS",System.currentTimeMillis());
            }
        }else {
            //Xác thực thành công: vô hiệu mã OTP
            session.setAttribute("OTP_ATTEMPTS",0);
            session.removeAttribute("OTP_LOCK_TS");
        }
        return ok;
    }

    public static int getAttempts(HttpSession session) {
        Object val = session.getAttribute("OTP_ATTEMPTS");
        return val instanceof Integer ? (Integer) val : 0;
    }

    public static long getLockRemainMs(HttpSession session){
        Long lockTs = (Long) session.getAttribute("OTP_LOCK_TS");
        if (lockTs == null) return 0;
        long now = System.currentTimeMillis();
        long remain = LOCK_TTL_MS - (now - lockTs);
        return Math.max(remain, 0);
    }


    public static void clear(HttpSession session){
        session.removeAttribute("OTP_EMAIL");
        session.removeAttribute("OTP_CODE");
        session.removeAttribute("OTP_VALID");
        session.removeAttribute("OTP_TS");
        session.removeAttribute("OTP_TTL");
        session.removeAttribute("OTP_ATTEMPTS");
        session.removeAttribute("OTP_LOCK_TS");
        session.removeAttribute("PENDING_USER");
    }

}
