package utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {
    private final String smtpHost;
    private final int smtpPort;
    private final String username;
    private final String password;
    private final boolean useTls;

    public EmailService(String smtpHost, int smtpPort, String username, String password, boolean useTls) {
        this.smtpHost = smtpHost;
        this.smtpPort = smtpPort;
        this.username = username;
        this.password = password;
        this.useTls = useTls;
    }

    public void sendEmail(String to, String subject, String bodyHtml) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        // Timeouts để tránh treo
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");
        props.put("mail.smtp.writetimeout", "10000");

        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", String.valueOf(smtpPort));

        // STARTTLS (587)
        if (useTls && smtpPort == 587) {
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
        }

        // SSL (465) – tự bật nếu port là 465 hoặc đặt MAIL_SMTP_SSL=true
        boolean useSsl = smtpPort == 465 || "true".equalsIgnoreCase(val("MAIL_SMTP_SSL"));
        if (useSsl) {
            props.put("mail.smtp.ssl.enable", "true");
        }

        // Tin cậy chứng chỉ host
        props.put("mail.smtp.ssl.trust", smtpHost);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        // Bật debug bằng cách đặt biến môi trường/VM: MAIL_DEBUG=true
        boolean debug = "true".equalsIgnoreCase(val("MAIL_DEBUG"));
        session.setDebug(debug);

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(username));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
        msg.setSubject(subject);
        msg.setContent(bodyHtml, "text/html; charset=UTF-8");

        Transport.send(msg);
    }

    public static void sendHtmlFromEnv(String to, String subject, String bodyHtml) throws MessagingException {
        String host = val("MAIL_SMTP_HOST");
        String portStr = val("MAIL_SMTP_PORT");
        String user = val("MAIL_SMTP_USER");
        String pass = val("MAIL_SMTP_PASS");
        String tls = val("MAIL_SMTP_TLS");
        boolean useTls = tls == null || !tls.equalsIgnoreCase("false");
        int port = portStr == null ? 587 : Integer.parseInt(portStr);
        if (host == null || user == null || pass == null) {
            throw new MessagingException("Thiếu cấu hình SMTP (host/user/pass)");
        }
        new EmailService(host, port, user, pass, useTls).sendEmail(to, subject, bodyHtml);
    }

    private static String val(String key) {
        String v = System.getProperty(key);
        return v != null ? v : System.getenv(key);
    }
}
