with Ada.Integer_Text_IO, Ada.Text_IO, Ada.Unchecked_Deallocation;
use Ada.Integer_Text_IO, Ada.Text_IO;

     
package body code is

     --On caracterise un Code_Binaire_interne par un Bit, un pointeur vers le Bit suivant et un pointeur vers le Bit courant(voir itérateur)--
     type Code_Binaire_Interne is record	  
	  B: Bit;
	  Suiv: Code_Binaire;
     end record;

     procedure LibererC is new Ada.Unchecked_Deallocation(Code_Binaire_Interne,Code_Binaire);
     

     function Cree_Code return Code_Binaire is
     begin
	  return Null;
     end Cree_Code;

     

     function Code_Null return Code_Binaire is
     begin
	  return Null;
     end Code_Null;
     
     
     
     
     function Cree_Code(C : in Code_Binaire) return Code_Binaire is
     C2:Code_Binaire;
     begin
	  --Allocation mémoire pour C2--
	  if (C=Null) then return Null;
	  else
	       C2:=new Code_Binaire_Interne;
	       C2.B:=C.B;
	       C2.Suiv:=Cree_Code(C.Suiv);
	       return C2;
	  end if;
     end;


     procedure Libere_Code(C : in out Code_Binaire) is
     tmp:Code_Binaire;
     begin
	 if(C/=Null) then
	       Libere_Code(C.Suiv);
	       LibererC(C);
	  end if;
	
	--tmp:=C;
	
	--while(tmp/=Code_Null) loop
		--C:=C.suiv;
		--LibererC(tmp);
		--Put("lib");
		--tmp:=C;
	--end loop;

     end;

     
     function Longueur(C : in Code_Binaire) return Natural is
     Nbr:Natural:=0;
     Parcours:Code_Binaire:=C;
     begin	 
	  while (Parcours /=Null) loop
	       Nbr:=Nbr+1;
	       Parcours:=Parcours.Suiv;
	  end loop;
	  return Nbr;
     end Longueur;

     
     procedure Affiche(C : in Code_Binaire) is
     Parcours:Code_Binaire:=C;
     begin
	  if(C=Null) then raise Code_Vide;
	  else
	       while (Parcours /= Null) loop
		    Put(Parcours.B);
		    Parcours:=Parcours.Suiv;
	       end loop;
	  end if;
     end;



     procedure Ajoute_Avant(B : in Bit; C : in out Code_Binaire) is
     N:Code_Binaire;
     begin
	  --IF trop long->raise Excp--
	  N:=new Code_Binaire_Interne;
	  N.B:=B;
	  N.Suiv:=C;
	  C:=N;
     end;



     procedure Ajoute_Apres(B : in Bit; C : in out Code_Binaire) is
     N:Code_Binaire;
     Parcours:Code_Binaire;
     begin
	  N:=new Code_Binaire_Interne;
	  N.B:=B;
	  N.Suiv:=Null;
	  if(C=Null) then	  
	       C:=N;
	  else
	       Parcours:=C;
	       while(Parcours.Suiv /= Null) loop
		    Parcours:=Parcours.Suiv;
	       end loop;
	       
	       Parcours.Suiv:=N;
	  end if;
     end;


     procedure Ajoute_Apres(C1 : in Code_Binaire; C : in out Code_Binaire) is
     Parcours:Code_Binaire;
     begin
	  if(C=Null) then 
	       C:=C1; 
	  else
	       Parcours:=C;
	       While(Parcours.Suiv /= Null) loop
		    Parcours:=Parcours.Suiv;
	       end loop;
	       
	       Parcours.Suiv:=C1;
	  end if;
     end;




     
     function Parcours_Init(C : Code_Binaire) return Code_Binaire is
     begin
	return C;
     end;



     function Parcours_Has_Next(C : Code_Binaire) return Boolean is
     begin
	if( C/=Null) then return True;
	else return False;
	end if;
     end Parcours_Has_Next;


     procedure Parcours_Next(C : in out Code_Binaire; B: out Bit) is
     begin
	  if( Parcours_Has_Next(C)=False) then raise Code_Entierement_Parcouru;
	  else
	       B:=C.B;
	       C:=C.Suiv;
	  end if;
     end Parcours_Next;

 
end;
     