import { Injectable, CanActivate, ExecutionContext } from "@nestjs/common";
import { Observable } from 'rxjs';
import { Request } from 'express';
import { Reflector } from "@nestjs/core";

@Injectable()
export class RoleCheckerGuard implements CanActivate {
    constructor(private reflector: Reflector) {}

    canActivate(context: ExecutionContext): boolean | Promise<boolean> | Observable<boolean> {
        const req : Request =  context.switchToHttp().getRequest();
        const role = req.token.role;

        const allowedToRoles = this.reflector.get<("administrator" | "user")[]>('allow_to_roles', context.getHandler());
        
        if(!allowedToRoles.includes(role)){
            return false;
        }

        return true;
    }
}


        // refleksija, sagledao metod koji se izvrsava, njegov soruce kod i iz soruce koda izvucemo meta podatke
        // za ovo pravimo konstruktor


        // uzeti neki niz vrednosti koji su admin ili user, to pozivamo za izcitavanja meta podataka koji se nalaze u kljucu allow_to_rolese

            /* iz contexta uzimamo hendler to bi bio: recimo ova funkcija
            @Put()
            @AllowToRoles('administrator')
            add(@Body() data: ...
            iz tog hendlera(te add fukncije) pristupamo AllowToRoles metapodatku koji sadrzi niz
            58 lekcija 26. minut
            */      

            // ako nema role koju trazimo