package entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.LinkedHashSet;
import java.util.Set;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@NamedQuery(name = "User.findAll", query = "SELECT u FROM User u")
@Table(name = "Users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id", nullable = false)
    private Integer id;

    @Column(name = "Password", nullable = false, length = 50)
    private String password;

    @Column(name = "Email", nullable = false, length = 50)
    private String email;

    @Column(name = "Fullname", nullable = false, length = 100)
    private String fullname;

    @Column(name = "Mobile", nullable = false, length = 20)
    private String mobile;

    @Column(name = "Birthdate", nullable = false)
    private LocalDate birthdate;

    @Column(name = "Gender", nullable = false)
    private Boolean gender = false;

    @Column(name = "Admin", nullable = false)
    private Boolean admin = false;

    @Column(name = "Avatar")
    private String avatar;

    @Column(name = "Active", nullable = false)
    private Boolean active = true;

    @Column(name = "CreatedDate", insertable = false, updatable = false)
    private LocalDateTime createdDate;

    @OneToMany(mappedBy = "user")
    private Set<Comment> comments = new LinkedHashSet<>();

    @OneToMany(mappedBy = "user")
    private Set<Favourite> favourites = new LinkedHashSet<>();

    @OneToMany(mappedBy = "user")
    private Set<Share> shares = new LinkedHashSet<>();

}