with ada.text_io;
use ada.text_io;
with ada.integer_text_io;
use ada.integer_text_io;
with ada.float_text_io;
use ada.float_text_io;

package body geom2d is

	use ES_T ;
   use Fct_Reel;

	function norme(v : vecteur ) return Reel is
   a:Reel; 
		begin
      a:= sqrt(v(1)*v(1)+v(2)*v(2));
		return a;
	end norme ; 


	function "+"(u,v : vecteur) return vecteur is 
		w : vecteur ; 
		begin 
	
		w(1):= u(1)+v(1) ; 
		w(2) := u(2)+v(2);
	
		return w ; 	
	end "+";
   
   function "-"(u,v : vecteur) return vecteur is 
		w : vecteur ; 
		begin 
	
		w(1):= u(1)-v(1) ; 
		w(2) := u(2)-v(2);
	
		return w ; 	
	end "-";
	
	function "*"(v : vecteur ; a : Reel) return vecteur is
		begin
		return (a*v(1),a*v(2));
	end "*";

	function "*"(a : Reel ; v : vecteur ) return vecteur is
		begin
		return v*a;
	end "*";
   
   --fonction de multiplication gauche d'un matrice par un vecteur
	function "*"(M : Matrice; v : vecteur) return vecteur is
		begin 
		return ( M(1,1)*v(1) + M(1,2)*v(2) , M(2,1)*v(1) + M(2,2)*v(2)) ; 
	end "*";
   
   --fonction de calcul de detreminant
	function det(M : Matrice ) return Reel is 
		begin
		return M(1,1)*M(2,2)-M(2,1)*M(1,2) ;
	end det ;
   
   --fonction de division d'une matrice par un reel
	function "/"(v : vecteur; a : Reel) return vecteur is
	begin
	
		if a=0.0 then 
			raise DIVISION_PAR_ZERO ; 
		end if ;	
		return (v(1)/a, v(2)/a);
	end "/";

   --fonction d'inversion d'une matrice
	function inv(M :Matrice) return Matrice is  
		
	D : Reel ;
   M2: Matrice;
	begin 
		D := det(M);
		if D = 0.0 then 
			raise MATRICE_NON_INVERSIBLE ; 
		end if ;
      M2(1,1):=(1.0/D)*M(2,2);
      M2(1,2):=-1.0*(1.0/D)*M(1,2);
      M2(2,1):=-1.0*(1.0/D)*M(2,1);
      M2(2,2):=(1.0/D)*M(1,1);
		return M2;
	end inv ; 
	
   
      --fonction de calcul de la distance d'un point a une droite
   function distance(P,A,B: point) return Reel is
   
   v1,v2,v3,v4: Vecteur;    
   d: Reel;    --distance du point au segment
   l: Reel;    --calcul du lambda
   
   begin
   
   if A(1)=B(1) and A(2)=B(2) then     --cas ou A=B
         
         v1(1):=P(1)-A(1);     --calcul du vcteur AP
         v1(2):=P(2)-A(2);
         d:=norme(v1);         --calcul de la norme de AP 
   
   else     -- cas ou A est different de B
         
         v1(1):=P(1)-A(1);     --calcul du vecteur AP
         v1(2):=P(2)-A(2);
         
         v2(1):=B(1)-A(1);     --calcul du vecteur AB
         v2(2):=B(2)-A(2);
         
         l:= (v1(1)*v2(1)+v1(2)*v2(2))/(norme(v2)*norme(v2));
         
         v3(1):=A(1)+l*v2(1);    --calcul du vecteur OQ
         v3(2):=A(2)+l*v2(2);
         
         
         if l<0.0 then
          
               d:=norme(v1);
               
         elsif 0.0<=l and l<=1.0 then
               
               v4(1):=P(1)-v3(1);     --calcul du vcteur QP
               v4(2):=P(2)-v3(2);
               d:=norme(v4);         --calcul de la norme de QP
         
         elsif l>1.0 then
         
                v4(1):=P(1)-B(1);     --calcul du vcteur BP
                v4(2):=P(2)-B(2);
                d:=norme(v4);         --calcul de la norme de BP
         
         end if;
    
    end if;
    
    return d;
   
   end distance; 
   
   
   
   --calcul des fonctions de base de Bernstein2
   function bernstein2(k: integer; t: reel) return reel is 
   
   B: Reel;
   
   begin 
      
      if  k=0 then
          B:= (1.0-t)*(1.0-t);
      elsif  k=1 then
          B:= 2.0*t*(1.0-t);
      else
          B:= t*t;
      end if;
   
   return B;
   
   end bernstein2;   
   
    --calcul des fonctions de base de Bernstein2
   function bernstein3(k: integer; t: reel) return reel is 
   
   B: Reel;
   
   begin 
      
      if  k=0 then
          B:= (1.0-t)*(1.0-t)*(1.0-t);
      elsif  k=1 then
          B:= 3.0*t*(1.0-t)*(1.0-t);
      elsif k=2 then
          B:= 3.0*t*t*(1.0-t);
      elsif k=3 then
          B:= t*t*t;
      end if;
   
   return B;
   
   end bernstein3;
   
   --evaluation d'une Bezier de degre 2
   function evaluation_bezier2(B2: bezier2; t: reel) return point is
   
   P: point;
   C0, C1, C2: point;
   
   begin
   
      --point de la courbe de bezier de degre 2
      C0:= B2(0);
      C1:= B2(1);
      C2:= B2(2);
   
      P(1):= C0(1)*bernstein2(0,t) + C1(1)*bernstein2(1,t) + C2(1)*bernstein2(2,t);
      P(2):= C0(2)*bernstein2(0,t) + C1(2)*bernstein2(1,t) + C2(2)*bernstein2(2,t);
     
   return P;
    
   end evaluation_bezier2;
   
   --evaluation d'une Bezier de degre 3
   function evaluation_bezier3(B3: bezier3; t: reel) return point is
   
   P: point;
   C0, C1, C2, C3: point;
   
   begin
   
      --point de la courbe de bezier de degre 2
      C0:= B3(0);
      C1:= B3(1);
      C2:= B3(2);
      C3:= B3(3);
   
      P(1):= C0(1)*bernstein3(0,t) + C1(1)*bernstein3(1,t) + C2(1)*bernstein3(2,t)+C3(1)*bernstein3(3,t);
      P(2):= C0(2)*bernstein3(0,t) + C1(2)*bernstein3(1,t) + C2(2)*bernstein3(2,t)+C3(2)*bernstein3(3,t);
     
   return P;
    
   end evaluation_bezier3;
   
   
   --conversion d'une bezier de degre 2 en bezier de degre 3
   function conversion(B2: bezier2) return bezier3 is
   
   P0, P1, P2, C0, C1, C2, C3 : point;
   B3: bezier3;
   
   begin
   
      --point de la bezier2
      P0:= B2(0);
      P1:= B2(1);
      P2:= B2(2);
   
      --calcul des point de la bezier 3
      C0:= P0;
      C1(1):= P0(1)/3.0 + (2.0*P1(1))/3.0;
      C1(2):= P0(2)/3.0 + (2.0*P1(2))/3.0;
      C2(1):= (2.0*P1(1))/3.0 + P2(1)/3.0;
      C2(2):= (2.0*P1(2))/3.0 + P2(2)/3.0;
      C3:= P2;
   
      B3:= (C0,C1,C2,C3);
   
      return B3;
      
   end conversion;
   
   --fonction de calcul de la distance d'un point a une bezier2
   function distance_point_bezier2(P: point; B: Bezier2; k: reel) return Reel is

   begin

   return norme(evaluation_bezier2(B,k) + (-1.0)*P);   --la distance d'un point a une bezier est la norme du vecteur forme par l'evaluation de bezier2 et le point donne
   
   end distance_point_bezier2; 
   
   --fonction de calcul de la distance d'un point a une bezier3
   function distance_point_bezier3(P: point; B: Bezier3; k: reel) return Reel is
   
   Q: point;
   
   begin
   
   Q:= evaluation_bezier3(B,k);
   
   return norme(P-Q);   --la distance d'un point a une bezier est la norme du vecteur forme par l'evaluation de bezier3 et le point donne
   
   end distance_point_bezier3;
   
end geom2d;



















































