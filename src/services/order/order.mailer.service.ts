import { MailerService } from "@nestjs-modules/mailer";
import { Injectable } from "@nestjs/common";
import { MailConfig } from "config/mail.config";
import { CartArticle } from "src/entities/cart-article.entity";
import { Order } from "src/entities/order.entity";
// npm install @nestjs-modules/mailer nodemailer

@Injectable()
export class OrderMailer{
    constructor(private readonly mailerService : MailerService){}

    async sendOrderEmail(order: Order){        
        await this.mailerService.sendMail({
            to: order.cart.user.email,
            bcc: MailConfig.orderNotificationMail,
            subject: 'Order details',
            encoding: 'UTF-8',
            // replyTo: 'no-replay@domain.com'
            html: this.makerOrderHtml(order),
        })
    }

    private makerOrderHtml(order: Order): string{
        let suma = order.cart.cartArticles.reduce((sum, current: CartArticle) =>{
            return sum + current.quantity * current.article.articlePrices[current.article.articlePrices.length-1].price
        }, 0);

        return `<p>Zahvaljujemo se za Vašu porudžbinu!</p>
                <p>Ovo su detalji Vaše porudžbine</p>
                <ul>
                    ${order.cart.cartArticles.map((cartArticle: CartArticle) => {
                        return `<li> 
                            ${cartArticle.article.name} x 
                            ${cartArticle.quantity}
                        </li>`;
                    })}
                </ul>
                <p>Ukupan iznoz je: ${ suma.toFixed(2) } EUR</p>
                <p>Potpis...</p>
                `;
    }
}