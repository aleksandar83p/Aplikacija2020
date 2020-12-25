import { JwtDataDto } from "src/dtos/auth/jwt.data.dto";


// prosirujem Request JS objekat koji se nalazi u epxress, ubacujem mu novi properti token
declare module 'express'{
    interface Request{
        token: JwtDataDto;
    }
}