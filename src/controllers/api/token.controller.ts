import { Body, Controller, HttpException, HttpStatus, Post, UseGuards } from "@nestjs/common";
import { AllowToRoles } from "src/misc/allow.to.roles.descriptor";
import { RoleCheckerGuard } from "src/misc/role.checker.guard";
import { AdministratorService } from "src/services/administrator/administrator.service";
import { UserService } from "src/services/user/user.service";
import { Request} from "express";
import { UserRefreshTokenDto } from "src/dtos/auth/user.refresh.token.dto";
import * as jwt from "jsonwebtoken";
import { JwtRefreshDataDto } from "src/dtos/auth/jwt.refresh.dto";
import { jwtSecret } from "config/jwt.secret";
import { LoginInfoDto } from "src/dtos/auth/login.info.dto";
import { ApiResponse } from "src/misc/api.response.class";

@Controller('token')
export class TokenController{
    constructor(
        private administratorService: AdministratorService,
        private userService: UserService
    ){}

    

    private getDatePlus(numberOfSeconds: number): number{
        return new Date().getTime() / 1000 + numberOfSeconds;
    }

    private getIsoDate(timestamp: number): string{
        const date = new Date();
        date.setTime(timestamp * 1000);
        return date.toISOString(); 
    }
}
