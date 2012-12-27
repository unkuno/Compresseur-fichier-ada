with Ada.Integer_Text_IO, Ada.Text_IO, Ada.Unchecked_Deallocation;
use Ada.Integer_Text_IO, Ada.Text_IO;

     
package body File_Priorite is

     type Cellule is record
	  D: Donnee;
	  P: Priorite;
     end record;

     type Tableau is array(Positive range<>) of Cellule;
     type P_Tableau is access Tableau;
     
     type File_Interne is record	  
	  Tas: P_Tableau;
	  Nb_El: Natural;
	  Cap: Positive;
     end record;


     procedure LibererFile is new Ada.Unchecked_Deallocation(File_Interne,File_Prio);
     procedure LibererTab is new Ada.Unchecked_Deallocation(Tableau,P_Tableau);

-- début des procédures --



     function Est_Racine(I:Positive) return Boolean is
     begin
	  return I=1;
     end Est_Racine;	     
     
 

    
     function Pere(I:Positive) return Positive is
     begin
	  if(I=1) then return 1;
	  else return (I/2);
	  end if;     
     end Pere;



     function Cree_File(Capacite: Positive) return File_Prio is
	  Fp:File_Prio:= new File_Interne;
     begin
	  Fp.Tas:=new Tableau(1..Capacite);
	  Fp.Cap:=Capacite;
	  Fp.Nb_El:=0;
	  
	  return Fp;
     end Cree_File;
  


  
     function Est_Vide(F: in File_Prio) return Boolean is
     begin
	  if F.Nb_El=0 then return True;
	  else return False;
	  end if;
     end Est_Vide;       




     function Est_Pleine(F: in File_Prio) return Boolean is
     begin
	  if F.Nb_El=F.Cap then return True;
	  else return False;
	  end if;
     end Est_Pleine;



     procedure Libere_File(F : in out File_Prio) is
     begin
	  LibererTab(F.Tas);
	  LibererFile(F);
     end;	       




     procedure Insere(F : in File_Prio; D : in Donnee; P : in Priorite) is
	  N:Cellule;
	  IndexPere:Positive;
	  IndexFils:Positive;
     begin
	  
	  if (Est_Pleine(F)) then raise File_Prio_Pleine;
	  else  
	       N.D:=D;
	       N.P:=P;
	       --On ajoute le nouveau noeud au tas--	       
	       F.Nb_El:=F.Nb_El+1;
	       F.Tas(F.Nb_El):=N;
	       --Reorganisation du tas--
	       if( not Est_Racine(F.Nb_El)) then 
	       --Initialisation--
		    IndexFils:=F.Nb_El;
		    IndexPere:=Pere(IndexFils);
		    while ( (not Est_Racine(IndexFils)) and then Est_Prioritaire(F.tas(IndexFils).P,F.Tas(IndexPere).P) ) loop
			 N:=F.Tas(IndexPere);
			 F.Tas(IndexPere):=F.Tas(IndexFils);
			 F.Tas(IndexFils):=N;
			 
			 IndexFils:=IndexPere;
			 IndexPere:=Pere(IndexFils);
	            end loop;
		end if;
	    
	   end if;
	     --Free N?--  
     end;


	procedure Supprime(F: in File_Prio; D: out Donnee; P: out Priorite) is
	Pere:Positive;
	FilsD:Positive;
	FilsG:Positive;
	N:Cellule;	
	begin
	
	  if (Est_Vide(F)) then raise File_Prio_Vide;
	  else  	  
	       --D recoit la donnée du premier element du tas (le plus prioritaire)--
	       --Et P sa priorité--
	       D:=F.Tas(1).D;
	       P:=F.Tas(1).P;
	       --On remplace cet element par le dernier situé dans le tas--
	       F.Tas(1):=F.Tas(F.Nb_El);
	       F.Nb_El:=F.Nb_El-1;
	       
	       --Reorganisation du tas--
	       if(F.Nb_El /= 0) then
		    --Initialisation
		    Pere:=1;
		    FilsD:=2*Pere+1;
		    FilsG:=2*Pere;

		    while ( (Pere<=(F.Nb_El/2)) and then ( Est_Prioritaire(F.tas(FilsD).P,F.tas(Pere).P)  or Est_Prioritaire(F.tas(FilsG).P,F.Tas(Pere).P) )) loop
		    
			 N:=F.Tas(Pere);
			 
			 if (Est_Prioritaire(F.tas(FilsD).P,F.Tas(FilsG).P) ) then
			      F.Tas(Pere):=F.Tas(FilsD);
			      F.Tas(FilsD):=N;
			      Pere:=FilsD;
			 else	      
			      F.Tas(Pere):=F.Tas(FilsG);
			      F.Tas(FilsG):=N;
			      Pere:=FilsG;		    
			 end if;
			 
			 FilsD:=2*Pere+1;
			 FilsG:=2*Pere;
		    end loop;  

		end if;
	      
	    end if;
	  end; 





	procedure Prochain(F: in File_Prio; D: out Donnee; P: out Priorite) is
	begin
	  if (Est_Vide(F)) then raise File_Prio_Vide;
	  else  	  
	       D:=F.Tas(1).D;
	       P:=F.Tas(1).P;
	  
	  end if;
	end;  



end;