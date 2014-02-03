with image_pbm, geom2d, ada.text_io, ada.float_text_io;
use image_pbm, geom2d, ada.text_io, ada.float_text_io;
with ada.integer_text_io;
use ada.integer_text_io;


package body contour is 


--recupere la valeur du pixel NW
function get_pixel_voisin_NW(M : in image; i,j : in integer) return pixel is 

   p:pixel;
   
   begin
      if i=0 or j=0 then
         p:=0;
      else 
         P:=get_pixel(M,i,j);
      end if;
      
      return p;
end get_pixel_voisin_NW;


--recupere la valeur du pixel SE
function get_pixel_voisin_NE(M : in image; i,j : in integer) return pixel is
	
	p:pixel;
   
begin
		if i=largeur(M) or j=0 then
			p:=0;
		else
			p:=get_pixel(M,i+1,j);
		end if;
      return p;
      	
end get_pixel_voisin_NE;


--recupere la valeur du pixel SE
function get_pixel_voisin_SE(M : in image; i,j : in integer) return pixel is
	
	p:pixel;
   
begin

		if i=largeur(M) or j = hauteur(M) then
			p:=0;
		else
			p:=get_pixel(M,i+1,j+1);
		end if;
      return p;	
end get_pixel_voisin_SE;


--recupere la valeur du pixel SW
function get_pixel_voisin_SW(M : in image; i,j : in integer) return pixel is
	
	p:pixel;
   
	begin
   
		if i= 0 or j = hauteur(M) then
			p:=0;
		else
			p:=get_pixel(M,i,j+1);
		end if;
      return p;	

end get_pixel_voisin_SW;


--calcul du point initial
function point_initial(M : in image) return point is

i,j: positive;

   begin

   i:=1;
   j:=1;

   while j<hauteur(M) and then get_pixel(M,i,j)=0 loop
      i:=1;
      while i<largeur(M) and then get_pixel(M,i,j)=0 loop
         i:=i+1;
      end loop;
   
      if get_pixel(M,i,j)=0 then j:=j+1;
      end if;
   
   end loop;
   
   return (long_float(i-1),long_float(j-1));
   
end point_initial;


-- faire avancer le robot d'une case
procedure avancer(r : in out Robot) is

begin
		case r.o is
			when Nord   => r.y := r.y-1;
			when Est => r.x := r.x+1;
			when Sud    => r.y := r.y+1;
			when West => r.x := r.x-1;
		end case;

end avancer;


-- faire tourner le robot `a gauche
procedure changer_direction(M: in image ;r : in out Robot) is 

p1,p2: pixel;

begin

   case r.o is
      when Nord =>
      p1:=get_pixel_voisin_NW(M,r.x,r.y);
      p2:=get_pixel_voisin_NE(M,r.x,r.y);
         case p1 is
            when 1 => r.o:=West;
            when 0 => 
               if p2= 1 then r.o:= Nord;
               else r.o:= Est;
               end if;
         end case;
         
      when Est =>
      p1:=get_pixel_voisin_NE(M,r.x,r.y);
      p2:=get_pixel_voisin_SE(M,r.x,r.y); 
         case p1 is
					when 1 => r.o:= Nord; 
					when 0 => if p2 = 1 then r.o:= Est;
						  else r.o:= Sud;
                    end if;
         end case;
         
      when Sud => 
      p1:=get_pixel_voisin_SE(M,r.x,r.y);
      p2:=get_pixel_voisin_SW(M,r.x,r.y);
          case p1 is
					when 1 => r.o:= Est; 
					when 0 => if p2 = 1 then r.o:= Sud;
						  else r.o:= West;
                    end if;
          end case;
          
      when West =>
      p1:=get_pixel_voisin_SW(M,r.x,r.y);
		p2:=get_pixel_voisin_NW(M,r.x,r.y);
         case p1 is
					when 1 => r.o:= Sud; 
					when 0 => if p2 = 1 then r.o:= West;
						  else r.o:= Nord;
                    end if;
               end case;
		end case;
      
end changer_direction;
       


--memorisation de la position
procedure memoriser(r: in robot; L: in out polygone)is

begin
		append(L,(long_float(r.x),long_float(r.y)));
      		
end memoriser;


--calcul du contour de l'image
procedure calcul_contour(M: in image;A: in out image; p: in point; C: in out contours) is

L:polygone;
r: robot;

begin

   r.x :=integer(p(1));
   r.y:= integer(p(2));
   r.o := Est;

   memoriser(r,L);
   if r.o=Est  then
      set_pixel(A,r.x+1,r.y+1,0);
   end if;
   avancer(r);
   memoriser(r,L);

   while r.x/=integer(p(1)) or r.y/= integer(p(2)) loop
      changer_direction(M,r);
      if r.o=Est then
            set_pixel(A,r.x+1,r.y+1,0);
      end if;
      avancer(r);

      memoriser(r,L);
      
   end loop;
   
   append(C,L);
   
end calcul_contour;

procedure ecrire_contour(F : in string; L : in polygone) is

f1: file_type;
c: curseur_point;
p: point;

begin

   open(f1,out_file,F);
   
   c:= first(L);  --initialisation du curseur
   
   put_line(f1,"1");New_line(f1) ;
   put(f1,integer(Length(L)),1);
   new_line(f1);
   new_line(f1);
   while c /= liste_point.no_element loop
         p:= element(c);
         put(f1,float(p(1)),5,1,0);
         put(f1,float(p(2)),5,1,0);
         new_line(f1);
         next(c);
   end loop;
   
   close(f1);
   
end ecrire_contour;

--ecrit de l'ensemble des contours dans un fichier 
   procedure ecrire_ensemble_contour(F : in string; C : in contours ; M : in image) is
   
   f1: file_type;
   cc: curseur_contour;
   cp: curseur_point;
   p: point;
   L:polygone;

   begin
   
 
   create(f1,out_file,F);
   
   put(f1,integer(Length(C)),1);new_line(f1);

   put(f1, Largeur(M));new_line(f1);
   put(f1, Hauteur(M));new_line(f1);
   
   cc:=first(C);
   
   while cc /= liste_contour.no_element loop --parcours de la liste de contour
         
         L:=element(cc);
         
         cp:=first(L);
         
         New_line(f1) ;
         put(f1,integer(Length(L)),1);
         new_line(f1);
         
         while cp /= liste_point.no_element loop --affichage d'un contour
            p:= element(cp);
            put(f1,float(p(1)),5,1,0);
            put(f1,float(p(2)),5,1,0);
            new_line(f1);
            next(cp);
         end loop;
         
         new_line(f1);
         
         next(cc);
         
   end loop;
         
   close(f1);
   
   end ecrire_ensemble_contour;

--recherche d'un eventuel pixel egale a 1
procedure recherche_pixel(M : in image; i,j: out integer; B: out boolean) is

   begin
   i:=1; --i,j sont les coordonnees du pixel et non pas du point 
   j:=1;
        
   while j<hauteur(M) and then get_pixel(M,i,j)=0 loop
      i:=1;
      
      while i<largeur(M) and then get_pixel(M,i,j)=0 loop
         i:=i+1;
      end loop;
   
      if get_pixel(M,i,j)=0 then 
            j:=j+1;
      end if;
   
   end loop;
   
   if i=largeur(M) and j=hauteur(M) and get_pixel(M,i,j)=0 then 
         B:=false;
   else 
         B:=true;
   end if;
end recherche_pixel;  


--extraction de tous les contours
procedure calcul_ensemble_contour(M: in image; p: in out point; C: out contours) is 

   A:image;
   L: polygone;
   B: boolean;
   compteur,i,j: integer;
   

   begin
   compteur := 0 ;
   B:=true;
   A:=image_auxiliaire(M);
   p:= point_initial(M) ;
   while B loop
      calcul_contour(M,A,p,C);
      recherche_pixel(A,i,j,B);
      p(1):=long_float(i-1);
      p(2):=long_float(j-1);
      --compteur := compteur + 1 ;
   end loop;
   
   --put(compteur);

end calcul_ensemble_contour; 

--procedure d'ecriture du nombre de contours et de la somme des nombres de segments de chaque contour
   procedure ecrire_info(C: in contours) is
   
   nb_p: integer;  --nompbre de points formant l'ensemble de l'image
   cc: curseur_contour;
   L:polygone;
   
   begin
   
      put(integer(length(C)));      --affichage du nombre de contour
      new_line;
      
      cc:=first(C);
      nb_p:=0;
      
      while cc /= liste_contour.no_element loop --parcours de la liste de contour
            
            L:=element(cc);
            
            --on retire 1 au nombre de points pour obtenir le nombre de                         segments, car le point initial d'un contour est compte deux fois 
            nb_p:=nb_p+integer(length(L))-1;  
            
            next(cc);
         
      end loop;
      
      put(nb_p);
   
   end ecrire_info;   

end contour;

   
   


         


   
   














































