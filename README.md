# eShop-FG1  
A **Clothing E-Commerce App** designed for users to browse, purchase, and manage clothing items effortlessly.  

## API Documentation  
Explore the API endpoints using the Postman documentation:  
[View API Documentation](https://documenter.getpostman.com/view/30660484/2sAY52dzWo)  

This documentation includes:  
- Endpoint descriptions  
- Request/Response examples  
- Authentication details  

.env
HOST=localhost
DB_NAME='eshop'
USER_NAME='root'
CHARSET=utf8mb4

JWT_SECRET=da6aeb4d0c364196a02f9617e79d52fa1a89c6ceefd1ecfee383d1b74738851e
ACCESS_TOKEN_EXPIRY=3600 
REFRESH_TOKEN_EXPIRY=604800 

# phpmailer config
MAIL_EMAIL="villainzukko@gmail.com"
MAIL_PASSWORD="dwqk sgqq znrt jfhz"


## Product Catalog and Search Engine API Documentation

Explore the API endpoints using the Postman documentation: 

[View API Documentation] (https://documenter.getpostman.com/view/30764479/2sAYBVgr5G#0023f9e1-8f1c-4772-925d-35db1eab10b9)

This documentation includes:

1. Fetch all products: This endpoint allows the user to view all of the products as well as sort them base on price, date added, and product name with the option to sort in ascending or descending order.

2. Advanced Search with Filters: This endpoint allows users to search for products by product name, category (e.g., Shirt, Jacket, Shoes, Accessories, etc.), color, material, and size. It also provides the option to search within a price range (minimum and maximum) and sort results by price, date added, or product name in ascending or descending order.

3. User/Seller View All Products: This endpoint allows the seller to view his/her own products.

4. User Login: This endpoint is used to authenticate a user and generate a session token for further interactions with the e-commerce platform.

5. User/Seller Create Products: This endpoint allows a seller to create their own products. To create a product, the seller must first be authenticated through the user login.

6. User/Seller Update Products: This endpoint allows a seller to update their own products. To update a product, the seller must first be authenticated through the user login.

7. User/Admin Update Products: This endpoint allows an admin to update a seller's products. To update a seller's product, the admin must first be authenticated through the user login.

8. User/Seller Delete Products: This endpoint allows a seller to delete their own products. To delete a product, the seller must first be authenticated through the user login.

9. User/Admin Delete Products: This endpoint allows an admin to delete a seller's products. To delete a seller's product, the admin must first be authenticated through the user login.






