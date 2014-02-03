-- manipulation d'image noir & blanc

with ada.text_io;
use ada.text_io;
with ada.integer_text_io;
use ada.integer_text_io;

package image_pbm is

	-- le type pixel
	subtype pixel is integer range 0..1;

	-- le type image
	type image is private;
	
	-- declaration d'exceptions 
	INDICES_PIXEL_HORS_BORNES,
	PREMIER_CARACTERE_FAUX ,
	DEUXIEME_CARACTERE_FAUX ,
	TROP_DE_CARACTERES ,
	ERREUR_FORMAT_CARACTERE,
	NON_DIESE ,
	FORMAT_IMAGE_INCORRECT,
	ALLOCATION_TABLEAU_PIXELS_IMPOSSIBLE : exception;
	
	-- creation d'une image de dimensions LxH
	function creer_image(L,H : positive) return image;
	
	-- placer le pixel p en position (i,j) dans l'image M
	procedure set_pixel(M : in out image; i,j : in positive; p : in pixel);
	
	-- recupere le pixel p en position (i,j) dans l'image M
	-- renvoie 0 si (i,j) est hors bornes de l'image
	function get_pixel(M : in image; i,j : in positive) return pixel;
	
	-- lecture d'une image PBM ASCII
	function lire_image(nom_f : in string) return image;
	
	-- ecrire l'image � l'ecran
	procedure put(M : image);
	
	--récupère la largeur de l'image
	function largeur(M : in image) return positive ;
	
	--recupère la hauteur de l'image
	function hauteur(M : in image) return positive ;

   --calcul d'une image auxiliaire a partir de l'image de depart
   function image_auxiliaire(M: image) return image;

private
	-- le type tableau de pixels
	type tableau is array(positive range<>, positive range<>) of pixel;
	type tableau_ptr is access tableau;
	
	-- le type image
	type image is record
		L,H : positive; -- largeur et hauteur
		pixels : tableau_ptr;
	end record;
	
end image_pbm;
