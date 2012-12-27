with Ada.Integer_Text_IO, Ada.Text_IO, Ada.Unchecked_Deallocation,Ada.Streams.Stream_IO,arbre_huffman,file_priorite,code;
use Ada.Integer_Text_IO, Ada.Text_IO,Ada.Streams.Stream_IO,arbre_huffman,code;

package body Dico is

     -- Chaque case du tableau correspond au nombre d'occurence (Occu)
     -- et au code binaire (CB) appartenant au caractère correspondant
     -- à la valeur de l'indice du tableau
     type Caracteres_Info is record
	  Occu: Integer; 
	  CB:Code_Binaire;
     end record;

     --Fichier Info est un tableau qui contient les informations des caracteres
     -- de la table ASCII relativement au fichier
     type Fichier_Info is array(Integer range 0..255) of Caracteres_Info; 
     type F_Tableau is access Fichier_Info;
     
     --Dico Caracteres Interne contient le tableau d'information sur les caractères 
     -- ainsi que l'arbre d'Huffman associé
     type Dico_Caracteres_Interne is record
	  Table:F_Tableau;
	  A:Arbre;
     end record;
	  
     
     procedure LibererD is new Ada.Unchecked_Deallocation(Dico_Caracteres_Interne,Dico_Caracteres);
     procedure LibererFTab is new Ada.Unchecked_Deallocation(Fichier_Info,F_Tableau);	


     package File_Prio_Occu is new file_priorite(
	  Arbre,
	  Positive,
	  "<");
     use File_Prio_Occu;

-- Début des procédures --

     procedure Libere_Dico(D : in out Dico_Caracteres) is
     begin
	  Libere_Arbre(D.A);
	  for I in 0..255 loop
	       if ( D.Table(I).CB /= Code_Null) then
		 Libere_Code(D.Table(I).CB);
	       end if;
	  end loop;
	  
	  LibererFTab(D.Table);
	  LibererD(D);
     end;



     procedure Affiche(D : in Dico_Caracteres) is
     C: Character;
        begin	  
	  Put_Line("Affichage des occurences");
	  New_Line;
	  for I in 0..255 loop
	       if(D.Table(I).Occu /=0) then
		    C:=Character'Val(I);
		    Put(C);
		    Put_Line(": ");
		    Put(D.Table(I).Occu);		    
		    
		    if ( D.Table(I).CB /= Code_Null) then
			 Put_Line(" Code: ");
			 Affiche(D.Table(I).CB);
		    end if;		    
		    New_Line;
	       end if;
	  end loop;
     end;


     procedure Lit_Nb_Occurences(Nom_Fichier : in String; D : out Dico_Caracteres) is
     F: Ada.Streams.Stream_IO.File_Type;
     car: Character;
     pos:Integer;   
     begin
	  
     --Creation du Dico--
	  D:=new Dico_Caracteres_Interne;
	  D.Table:=new Fichier_Info;
     --Initialisation du Dico--
	  for I in 0..255 loop   
	       D.Table(I).Occu:=0;
	       D.Table(I).CB:=Cree_Code;
	  end loop;

	  D.A:=Arbre_Vide;

     --Ouverture du fichier et lecture--
     open(F,in_file,Nom_Fichier);         
     while not end_of_file(F) loop
	       car:=Character'Input(Stream(F));		       
	       pos:=Character'Pos(car);
	       D.Table(pos).Occu:=D.Table(pos).Occu+1;
     end loop;    
     close(F);
     end;
     


     procedure Lit_Dico(D : out Dico_Caracteres; Fichier : Ada.Streams.Stream_IO.File_Type) is    
     clesRestantes:Integer;
     I: Integer:=0;
     begin	
	
	  --Creation du dictionnaire, initialisation et remplissage--
	  D:=new Dico_Caracteres_Interne;
	  D.Table:=new Fichier_Info;
	  --Initialisation du Dico--
	  for I in 0..255 loop   
	       D.Table(I).Occu:=0;
	       D.Table(I).CB:=Cree_Code;
	  end loop;
	
	Integer'Read(Stream(Fichier),clesRestantes);
	
	while clesRestantes>0 loop				
	
	       Integer'Read(Stream(Fichier), I);
	       Integer'Read(Stream(Fichier), D.Table(I).Occu);
	       clesRestantes:=clesRestantes-1;	  
	 			 
	end loop;	

     --On genere le code--
     Genere_Codes(D);
     end;


     procedure Ecrit_Dico(D : in Dico_Caracteres; Fichier : Ada.Streams.Stream_IO.File_Type) is
     clesRestantes:Integer;
     I: Integer:=0;
     begin

	clesRestantes:= Nb_Cles(D);	
	-- On ecrit dans le fichier la taille du tableau afin
	-- de savoir où commence réelement le texte
	Integer'Write(Stream(Fichier), clesRestantes );
	
	while I<256 and then clesRestantes>0 loop
		
	  if(D.Table(I).Occu/=0) then
	       Integer'Write(Stream(Fichier), I);
	       Integer'Write(Stream(Fichier), D.Table(I).Occu);
	       clesRestantes:=clesRestantes-1;  
	  end if;
	  I:=I+1;			 
	end loop;
     end;


     procedure Genere_Codes(D : in out Dico_Caracteres) is
	F:File_Prio:= Cree_File(256);
	A1,A2,A:Arbre;
	P1,P2:Positive;
	C:Code_Binaire;
	car:Character;
	pos:Integer;
	Nbcles:Positive;
     begin
	 
     --Creation de la file de priorite--
	  for I in 0..255 loop   
	       if(D.Table(I).Occu/=0) then
		    car:=Character'Val(I);
		    Insere(F, Cree_Feuille(car), D.Table(I).Occu);
	       end if;
	  end loop;
     --On gere les cas particuliers
	  --Cas Non vide--
	  if (Est_Vide(F)=False) then
	       NBcles:=Nb_Cles(D);
	       --Cas un seul element	       
	       if (NBcles=1) then
		    Supprime(F,A,P1);
		    D.A:=Cree_Arbre(Cree_Feuille(Caractere(A)),Arbre_Vide);
		    pos:=Character'Pos(Caractere(A));
		    C:=Cree_Code;
		    Ajoute_Apres(ZERO,C);
		    D.Table(pos).CB:=C; -- Par defaut, on code le seul character par le bit zero --
	       else
	       --Creation de l'arbre de huffman--
		    for I in 1..(NBcles-1) loop
			 Supprime(F,A1,P1);
			 Supprime(F,A2,P2);
			 A:=Cree_Arbre(A1,A2);
			 Insere(F,A,P1+P2);
		    end loop;
	       --On associe l'arbre du dico à l'arbre resultant et on libere la file--		    
		    D.A:=A;
		    Libere_File(F);
	       --Parcours de l'arbre afin d'obtenir le code des caractères--
		    C:=Cree_Code;
		    Attribution_Codes(D,A,C);
	       end if;
	  end if;
     end;
	  


     procedure Attribution_Codes(D: in out Dico_Caracteres; A:in Arbre; C:in out Code_Binaire) is
	C1,C2: Code_Binaire;
	pos:Integer;
     begin
	  if (Est_Feuille(A)) then
	        --Si A est une feuille, le code binaire de A.C (Character) est C -- 
	        pos:=Character'Pos(Caractere(A));
	        D.Table(pos).CB:=C;
	  --Sinon c'est un noeud--
	  else
	       C1:=Cree_Code(C);
	       Ajoute_Apres(ZERO,C1);
	       Attribution_Codes(D,Fils_Gauche(A),C1);
	       C2:=Cree_Code(C);
	       Ajoute_Apres(UN,C2);
	       Attribution_Codes(D,Fils_Droit(A),C2);
	       Libere_Code(C);
	  end if;

     end;



     function Get_Arbre_Huffman(D : Dico_Caracteres) return Arbre is
     begin
	  if (D.A=Arbre_Vide) then raise Codes_Non_Generes;
	  else
	       return D.A;
	  end if;
     end;


     function Get_Code(C : Character; D : Dico_Caracteres) return Code_Binaire is
     pos:Integer:=Character'Pos(C);
     begin 
	  if(D.Table(pos).Occu=0) then raise Caractere_Absent;
	  else
	       if (D.Table(pos).CB=Code_Null) then raise Codes_Non_Generes;
	       else
		    return D.Table(pos).CB;
	       end if;
	  end if;
     end;
     



     function Nb_Cles(D : in Dico_Caracteres) return Natural is
     N:Natural:=0;
     begin
	  for I in 0..255 loop   
	       if(D.Table(I).Occu/=0) then
		    N:=N+1;
	       end if;
	  end loop;
	  return N;
     end;


     function Nb_Total_Caracteres(D : in Dico_Caracteres) return Natural is
     N:Natural:=0;
     begin
	  for I in 0..255 loop   
		    N:=N+D.Table(I).Occu;
	  end loop;
	  return N;
     end;

end;