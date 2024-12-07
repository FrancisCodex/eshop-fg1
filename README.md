<div align=center>
    <h2>Clothing Web App</h2>
</div>

<div align=center>

### Features

| Feature       | Implemented? |
|---------------|--------------|
| Rate Limiting | Yes          |
| Caching       | Yes          |
| API Keys      | Yes          |
| Logging       | Yes          |

</div>

### How to run:

>[!NOTE]
> Ignore ra ang eshop-fg1 na folder

Pag create ug bag-o nga database then e import ang `eshop.sql` saimo xammp **phpmyadmin**

Adto sa Product nga folder then pag open ug terminal and run `composer install` inig mahuman e change ang values sa `connect.php` saimo database configuration

Same sab sa shopping cart folder run `composer install` tapos e rename ang `.env.example` into `.env` then e add napud ang imo database configuration sa `.env` file