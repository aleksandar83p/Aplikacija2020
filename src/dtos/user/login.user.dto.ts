import * as Validator from "class-validator";

export class LoginUserDto{
    @Validator.IsNotEmpty()
    @Validator.IsEmail({
        allow_ip_domain: false,  // sale@127.0.0.1
        allow_utf8_local_part: true,
        require_tld: true // ne moze sale@localhost, mora imati .com i slicno .pa_nesto
    })
    email: string;

    @Validator.IsNotEmpty()
    @Validator.IsString()
    @Validator.Length(6, 128)
    password: string;
}
