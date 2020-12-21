import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from "typeorm";
import { Article } from "./article.entity";

@Index("fk_photo_article_id", ["articleId"], {})
@Index("uq_photo_photo_path", ["photoPath"], { unique: true })
@Entity("photo")
export class Photo {
  @PrimaryGeneratedColumn({ type: "int", name: "photo_id", unsigned: true })
  photoId: number;

  @Column("int", { name: "article_id", unsigned: true })
  articleId: number;

  @Column("varchar", { name: "photo_path", unique: true, length: 128 })
  photoPath: string;

  @ManyToOne(() => Article, (article) => article.photos, {
    onDelete: "RESTRICT",
    onUpdate: "CASCADE",
  })
  @JoinColumn([{ name: "article_id", referencedColumnName: "articleId" }])
  article: Article;
}
