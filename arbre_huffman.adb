with Ada.Integer_Text_IO, Ada.Text_IO, Ada.Unchecked_Deallocation;
use Ada.Integer_Text_IO, Ada.Text_IO;

     
package body arbre_huffman is


     procedure LibererA is new Ada.Unchecked_Deallocation(Noeud,Arbre);
-- début des procédures --

     function Cree_Feuille(C : in Character) return Arbre is
     A:Arbre:=new Noeud;
     begin
	--Une feuille est caractérisée par une valeur et pointe vers deux arbres vides--  
	  A.C:=C;
	  A.Fg:=Arbre_vide;
	  A.Fd:=Arbre_vide;
	  return A;
     end Cree_Feuille;


     function Cree_Arbre(A1, A2 : in Arbre) return Arbre is
     A:Arbre:=new Noeud;
     begin
	--La valeur du noeud n'a pas d'importance ici --  	  
	  A.Fg:=A1;
	  A.Fd:=A2;
	  return A;
     end Cree_Arbre;   


     procedure Libere_Arbre(A : in out Arbre) is
     begin
	  --On libere recursivement l'ensemble des noeud alloués en mémoire--
	  --Le test d'arrêt est l'arbre vide--
	  if(A/=Arbre_Vide) then
	       Libere_Arbre(A.Fg);
	       Libere_Arbre(A.Fd);
	       LibererA(A);
	  end if;
     end;

	

     function Est_Feuille(A : in Arbre) return Boolean is
     begin
	  if (A=Arbre_Vide) then
	       Put_Line("Erreur Arbre vide");
	       return False;
	  -- Si le noeud pointe vers deux arbres vide, alors c'est une feuille--
	  elsif( A.Fg=Arbre_Vide and A.Fd=Arbre_Vide) then return True;
	  else return False;
	  end if;
     end;


     function Fils_Gauche(A : in Arbre) return Arbre is
     begin
	  if (A=Arbre_Vide or else Est_Feuille(A)) then
	       Put_Line("Erreur Fils_Gauche");
	       return Arbre_vide;
	  else 
	       return A.Fg;
	  end if;     
     end Fils_Gauche;



     function Fils_Droit(A : in Arbre) return Arbre is
     begin
	  if (A=Arbre_Vide or else Est_Feuille(A)) then
	       Put_Line("Erreur Fils_Droit");
	       return Arbre_vide;
	  else 
	       return A.Fd;
	  end if;     
     end Fils_droit;

  

     procedure Affiche(A : in Arbre) is
     begin
	  --On affiche la valeur puis on parcours recursivement (type?) l'arbre--
	  --Arret si il s'agit d'un arbre vide--
	  if ( A/=Arbre_Vide) then 
	       if (Est_Feuille(A)) then
		    Put(A.C);
	       else
		    Affiche(A.Fd);
		    Affiche(A.Fd);
	       end if;
	  end if;
     end;	



     function Caractere(A : in Arbre) return Character is
     begin
	  --Cas d'erreur--
	  if ( not Est_Feuille(A)) then raise Caractere_Invalide;
	  end if;
	  return A.C;
     end Caractere;

end;