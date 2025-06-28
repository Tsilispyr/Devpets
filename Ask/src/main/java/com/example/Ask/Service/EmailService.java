package com.example.Ask.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Value("${app.frontend.url:http://localhost:8081}")
    private String frontendUrl;

    public void send(String to, String subject, String text) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("noreply@petsystem.local");
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);
            mailSender.send(message);
        } catch (Exception e) {
            // Log the error but don't throw it to avoid breaking the registration
            System.err.println("Failed to send email to " + to + ": " + e.getMessage());
        }
    }

    public void sendVerificationEmail(String to, String username, String verificationToken) {
        try {
            String subject = "Επιβεβαίωση Email - Pet Adoption System";
            String verificationUrl = frontendUrl + "/verify-email?token=" + verificationToken;
            
            String text = String.format(
                "Γεια σας %s,\n\n" +
                "Καλώς ήρθατε στο Pet Adoption System!\n\n" +
                "Για να ολοκληρώσετε την εγγραφή σας, παρακαλώ κάντε κλικ στον παρακάτω σύνδεσμο:\n\n" +
                "%s\n\n" +
                "Αυτός ο σύνδεσμος ισχύει για 24 ώρες.\n\n" +
                "Εάν δεν δημιουργήσατε εσείς αυτόν τον λογαριασμό, παρακαλώ αγνοήστε αυτό το email.\n\n" +
                "Με εκτίμηση,\n" +
                "Η ομάδα του Pet Adoption System",
                username, verificationUrl
            );
            
            send(to, subject, text);
        } catch (Exception e) {
            System.err.println("Failed to send verification email: " + e.getMessage());
        }
    }

    public void sendLoginNotification(String to, String username, String loginTime, String ipAddress) {
        try {
            String subject = "Ειδοποίηση Σύνδεσης - Pet Adoption System";
            
            String text = String.format(
                "Γεια σας %s,\n\n" +
                "Εντοπίστηκε μια νέα σύνδεση στον λογαριασμό σας:\n\n" +
                "Ώρα σύνδεσης: %s\n" +
                "IP Address: %s\n\n" +
                "Εάν δεν ήσασταν εσείς, παρακαλώ επικοινωνήστε αμέσως μαζί μας.\n\n" +
                "Με εκτίμηση,\n" +
                "Η ομάδα του Pet Adoption System",
                username, loginTime, ipAddress
            );
            
            send(to, subject, text);
        } catch (Exception e) {
            System.err.println("Failed to send login notification: " + e.getMessage());
        }
    }

    public void sendWelcomeEmail(String to, String username) {
        try {
            String subject = "Καλώς ήρθατε στο Pet Adoption System!";
            
            String text = String.format(
                "Γεια σας %s,\n\n" +
                "Καλώς ήρθατε στο Pet Adoption System!\n\n" +
                "Ο λογαριασμός σας έχει επιβεβαιωθεί επιτυχώς και μπορείτε τώρα να:\n" +
                "- Προβάλετε τα διαθέσιμα ζώα\n" +
                "- Κάνετε αιτήσεις υιοθεσίας\n" +
                "- Διαχειριστείτε το προφίλ σας\n\n" +
                "Ευχαριστούμε που επιλέξατε το σύστημά μας!\n\n" +
                "Με εκτίμηση,\n" +
                "Η ομάδα του Pet Adoption System",
                username
            );
            
            send(to, subject, text);
        } catch (Exception e) {
            System.err.println("Failed to send welcome email: " + e.getMessage());
        }
    }
}
