import { Body, Controller, Post, Req } from "@nestjs/common";
import { LoginAdministratorDto } from "src/dtos/administrator/login.administrator.dto";
import { ApiResponse } from "src/misc/api.response.class";
import { AdministratorService } from "src/services/administrator/administrator.service";
import * as crypto from 'crypto';
import { resolve } from "path";
import { LoginInfoAdministratorDto } from "src/dtos/administrator/login.info.administrator.dto";
import * as jwt from "jsonwebtoken";
import { JwtDataAdministratorDto } from "src/dtos/administrator/jwt.data.administrator.dto";
import {Request} from "express";
import { jwtSecret } from "config/jwt.secret";

@Controller('auth/')
export class AuthController{
    constructor(public administratorService: AdministratorService) {}

    @Post('login') // http://localhost:3000/auth/login/
    async doLogin(@Body() data: LoginAdministratorDto, @Req() req: Request): Promise<LoginInfoAdministratorDto | ApiResponse>{
        const administrator = await this.administratorService.getByUsername(data.username);

        if(!administrator){            
            return new Promise(resolve => resolve(new ApiResponse("error", -3001)));  // ne postoji, nismo nasli admina    
        }
        
        const passwordHash = crypto.createHash('sha512');
        passwordHash.update(data.password);
        const passwordHashString = passwordHash.digest('hex').toUpperCase();

        if(administrator.passwordHash !== passwordHashString){           
            return new Promise(resolve => resolve(new ApiResponse("error", -3002))); // lozinka se ne pokpala
        }

        // lekcija 45, na oko 23.5 minuta
        // administratorID
        // username
        // token JWT
        //  TAJNA SIFRA
        //  JSON = {administratorId, username, expire, ip...}
        //  Sifrovanje (TAJNA SIFRA -> JSON) -> Sifrant binarni -> BASE64
        // dobijamo HEX STRING, ovo ne moze da desifruje krajni korisnik jer ne poseduje tajnu sifru sa kojom moze da dekodira da bi dobio originalni JSON

        // TOKEN = JSON {adminId, username...}

        const jwtData = new JwtDataAdministratorDto();
        jwtData.administratorId = administrator.administratorId;
        jwtData.username = administrator.username;
        
        let sada = new Date();
        sada.setDate(sada.getDate() + 14); // + 14 dana
        const istekTimestamp = sada.getTime() / 1000;
        jwtData.ext = istekTimestamp;

        jwtData.ip = req.ip.toString();
        jwtData.ua = req.headers["user-agent"];

        // sada kreiramo, potpisujemo token
        let token: string = jwt.sign(jwtData.toPlainObject(), jwtSecret);

        const responseObject = new LoginInfoAdministratorDto(
            administrator.administratorId,
            administrator.username,
            token
        );

        return new Promise(resolve => resolve(responseObject));   
    };
}