import { Body, Controller, Delete, Param, Post, Req, UploadedFile, UseInterceptors } from "@nestjs/common";
import { FileInterceptor } from "@nestjs/platform-express";
import { Crud } from "@nestjsx/crud";
import { StorageConfig } from "config/storage.config";
import { Article } from "src/entities/article.entity";
import { AddArticleDto } from "src/dtos/article/add.article.dto";
import { ArticleService } from "src/services/article/article.service";
import {diskStorage} from "multer";
import { Photo } from "src/entities/photo.entity";
import { PhotoService } from "src/services/photo/photo.service";
import { ApiResponse } from "src/misc/api.response.class";
import * as fileType from "file-type";
import * as fs from "fs";
import * as sharp from "sharp";

@Controller('api/article')
@Crud({
    model: {
        type: Article
    },
    params: {
        id: {
            field: 'articleId',
            type: 'number',
            primary: true
        }
    },
    query: {
        join:{
            category: {
                eager: true
            },
            photos:{
                eager: true
            },
            articlePrices: {
                eager: true
            },
            articleFeatures: {
                eager: true
            },
            features: {
                eager: true
            }
        }
    }
})

export class ArticleController{
    constructor(
        public service: ArticleService,
        public PhotoService: PhotoService
        ){}

    @Post('createFull') // POST http://localhost:3000/api/article/createFull
    createFullArticle(@Body() data: AddArticleDto){
        return this.service.createFullArticle(data);
    }

    @Post(':id/uploadPhoto/') // POST http://localhost:3000/api/article/:id/upload-photos
    @UseInterceptors(
        FileInterceptor('photo', {
            storage: diskStorage({
                destination: StorageConfig.photo.destination,
                filename: (req, file, callback) => {
                    // req nam ne treba jer se u njemu nalaze informacije vezane za sadrzaj fajla, velicnu fajla, ip korisnika... 
                    
                    // 'Neka   slika .jpg' =>  '20200420-954124875-Neka-slika.jpg'
                    let original: string = file.originalname;

                    let normalized = original.replace(/\s+/g, '-');
                    normalized = normalized.replace(/[^A-z0-9\.\-]/g, '');
                    
                    let sada = new Date();
                    let datePart = '';
                    datePart += sada.getFullYear().toString();
                    datePart += (sada.getMonth() + 1).toString();
                    datePart += sada.getDate().toString();

                    let randomPart: string = 
                    new Array(10)                    
                    .fill(0)
                    .map(e => (Math.random()* 9).toFixed(0).toString())
                    .join('');

                    let fileName = datePart + '-' + randomPart + '-' + normalized;

                    fileName = fileName.toLocaleLowerCase();

                    callback(null, fileName);
                }
            }),
            fileFilter: (req, file, callback) => {
                // 1. proveri extenziju: JPG, PNG           
                if(!file.originalname.toLowerCase().match(/\.(jpg|png)$/)){
                    // callback(new Error('Bad file extensions!'), false); // callback sluzi da dojavimo gresku koja je nastala ali na konzoli, false ne prihvati upload fajla
                    req.fileFilterError = 'Bad file extensions!';  // .fileFilterError sam ja napravio, nije vec postojece polje
                    callback(null, false);
                    return;
                }

                // 2. Check tipa sadrzaja: image/jpeg, image/png (mimetype)
                if(!(file.mimetype.includes('jpeg') || file.mimetype.includes('png'))){
                    req.fileFilterError ='Bad file content!';
                    callback(null, false);
                    return;
                }

                callback(null, true);
            },
            limits:{
                files: 1,
                fileSize: StorageConfig.photo.maxSize,
            },
        })
    )
    async uploadPhoto(
        @Param('id') articleId: number,
        @UploadedFile() photo,
        @Req() req
    ): Promise<ApiResponse | Photo>{
        // prikazi gresku klijentu
        if(req.fileFilterError){
            return new ApiResponse('error', -4002, req.fileFilterError);
        }

        // ako nema uploadovanog fajla
        if(!photo){
            return new ApiResponse('error', -4002, 'File not uploaded');
        }

        // mime type da ne okacim blabla.exe.jpg
        const fileTypeResult = await fileType.fromFile(photo.path);

        if(!fileTypeResult){
            //  obrisi taj fajl
            fs.unlinkSync(photo.path);

            return new ApiResponse('error', -4002, 'Cannot detect file type');
        }

        const realMimeType = fileTypeResult.mime;

        if(!(realMimeType.includes('jpeg') || realMimeType.includes('png'))){
             // obrisi taj fajl
             fs.unlinkSync(photo.path);
             
             return new ApiResponse('error', -4002, 'Bad file content type');
        }

        // Save a resized file
        await this.createResizedImage(photo, StorageConfig.photo.resize.thumb)
        await this.createResizedImage(photo, StorageConfig.photo.resize.small);



        const newPhoto: Photo = new Photo();
        newPhoto.articleId = articleId;
        newPhoto.photoPath = photo.filename;

        const savedPhoto = await this.PhotoService.add(newPhoto);

        if(!savedPhoto){
            return new ApiResponse('error', -4001); // 4001 file not upload
        }

        return savedPhoto;
    }

    async createResizedImage(photo, resizeSettings){
        const originalFilePath = photo.path;
        const fileName = photo.filename;

        const destinationFilePath = StorageConfig.photo.destination + resizeSettings.directory + fileName;
        
        await sharp(originalFilePath)
        .resize({
            fit: 'cover', 
            width: resizeSettings.width,
            height: resizeSettings.height
        })
        .toFile(destinationFilePath);
    }

    // http://localhost:3000/api/article/1/deletePhoto/45
    @Delete(':articleId/deletePhoto/:photoId')
    public async deletePhoto(
        @Param('articleId') articleId: number,
        @Param('photoId') photoId: number
    ) {
        const photo = await this.PhotoService.findOne({
            articleId: articleId,
            photoId: photoId
        });

        if (!photo) {
            return new ApiResponse('error', -4004, 'Photo not found123');
        }

        try {
            fs.unlinkSync(StorageConfig.photo.destination + photo.photoPath);
            fs.unlinkSync(StorageConfig.photo.destination + StorageConfig.photo.resize.thumb.directory + photo.photoPath);
            fs.unlinkSync(StorageConfig.photo.destination + StorageConfig.photo.resize.small.directory + photo.photoPath);
        } catch (e) {
            console.log(e);
        }


        const DeleteResult = await this.PhotoService.deleteById(photoId);

        if (DeleteResult.affected === 0) {
            return new ApiResponse('error', -4004, 'Photo not found789');
        }

        return new ApiResponse('ok', 0, 'One photo deleted');

    }
}