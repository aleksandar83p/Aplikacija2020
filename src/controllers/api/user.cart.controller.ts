import { Body, Controller, Get, Patch, Post, Req, UseGuards } from "@nestjs/common";
import { AllowToRoles } from "src/misc/allow.to.roles.descriptor";
import { RoleCheckerGuard } from "src/misc/role.checker.guard";
import { CartService } from "src/services/cart/cart.service";
import { Request } from "express";
import { AddArticleToCartDto } from "src/dtos/cart/add.article.to.cart.dto";
import { Cart } from "src/entities/cart.entity";
import { EditArticleInCartDto } from "src/dtos/cart/edit.article.in.dto";

@Controller('api/user/cart')
export class UserCartController{
    constructor(private cartService: CartService){}

    private async getActiveCartForUserId(userId: number){
        
        let cart = await this.cartService.getLastActiveCartByUserId(userId);

        if(!cart){
            cart = await this.cartService.createNewCartForUser(userId);
        }

        return await this.cartService.getById(cart.cartId);
    }
    
    // GET http://localhost:3000/api/user/cart
    @Get() 
    @UseGuards(RoleCheckerGuard)
    @AllowToRoles('user')
    async getCurrentCart(@Req() req: Request): Promise<Cart>{
       return await this.getActiveCartForUserId(req.token.id);         
    }

    // POST http://localhost:3000/api/user/cart/addToCart
    @Post('addToCart')
    @UseGuards(RoleCheckerGuard)
    @AllowToRoles('user')
    async addToCart(@Body() data: AddArticleToCartDto, @Req() req: Request): Promise<Cart>{  // u trenutno aktivnu korpu dodaje artikal u odredjenoj kolicini
        const cart = await this.getActiveCartForUserId(req.token.id);

        return await this.cartService.addArticleToCart(cart.cartId, data.articleId, data.quantity);
    }    

    // PATCH http://localhost:3000/api/user/cart/
    @Patch()
    @UseGuards(RoleCheckerGuard)
    @AllowToRoles('user')
    async changeQuantity(@Body() data: EditArticleInCartDto, @Req() req: Request): Promise<Cart>{
        const cart = await this.getActiveCartForUserId(req.token.id);
        return await this.cartService.changeQuantity(cart.cartId, data.articleId, data.quantity);
    }
}