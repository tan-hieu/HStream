package entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.LinkedHashSet;
import java.util.Set;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "Videos")
public class Video {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id", nullable = false)
    private Integer id;

    @Column(name = "LinkYoutube", nullable = false, length = 100)
    private String linkYoutube;

    @Column(name = "Title", nullable = false, length = 200)
    private String title;

    @Column(name = "Content", nullable = false, length = 200)
    private String content;

    @Column(name = "Views", nullable = false)
    private Integer views;

    @Column(name = "Status", nullable = false)
    private Boolean status;

    @Column(name = "Posting_date")
    private LocalDate postingDate;

    @Column(name = "ThumbnailUrl")
    private String thumbnailUrl;

    @Column(name = "ChannelName")
    private String channelName;

    @OneToMany(mappedBy = "video")
    private Set<Comment> comments = new LinkedHashSet<>();

    @OneToMany(mappedBy = "video")
    private Set<Favourite> favourites = new LinkedHashSet<>();

    @OneToMany(mappedBy = "video")
    private Set<Share> shares = new LinkedHashSet<>();

}