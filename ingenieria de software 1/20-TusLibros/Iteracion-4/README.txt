
0. Cargar los paquetes necesarios antes de cargar los .st (Los de Morphs y los del Web server)
 sino se rompen las clases.

1. abrir el servidor en un workspace
librosServer := LibrosServer listeningOn: 8080

luego abrir la ventana de LogIn

librosClientLoginWindow open.


Tras abrir la ventana de login ingresar datos

usuario:pepe
clave:5678

o
usuario:ramon
clave:1234

luego uno puede crear un carrito o ver la lista de compras hechas anteriormente

en crear un carrito uno puede seleccionar la cantidad de libros para agregar o quitar del carrito
(en caso de no seleccionar numero se manipulan libros de a 1)

al presionar checkout se tratara de comprar el contenido del carrito, en caso positivo mostrara el ticket
en caso de no poder hacer checkout se abrira una ventana de error

para cerrar todo

cerrar ventanas relacionadas a LibrosServer

en el workspace hacer:
librosServer destroy.
