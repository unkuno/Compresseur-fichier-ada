with Ada.Text_Io; use Ada.Text_Io;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.sequential_io;
with Ada.Streams.Stream_io;use Ada.Streams.Stream_io;
with code;use code;
with Arbre_Huffman;use Arbre_Huffman;
with Dico;use Dico;



procedure tp_huffman is


	       
------------------------------------------------------------------------------
-- COMPRESSION
------------------------------------------------------------------------------

	procedure Compresse(Nom_Fichier_In, Nom_Fichier_Out : in String) is
	
	Dico:Dico_Caracteres;
	F_in,F_out: Ada.Streams.Stream_Io.File_Type;
	car: Character;
	Code: Code_Binaire;
	itBit: Integer:=0;
	valAecrire:Integer:=0;
	Iterator:Code_Binaire;
	B:Bit;
	
	begin	  	  
	  
	  --Création du dictionnaire//	  	 	  
	  Lit_Nb_Occurences(Nom_Fichier_In,Dico);	  	  
	  Genere_Codes(Dico);
 	  --Creation du fichier out, on lui associe le dictionnaire géneré--
 	  create(F_out,out_file, Nom_Fichier_Out);
 	  Ecrit_Dico(Dico, F_out);
 	  --On ouvre le fichier in--
 	  open(F_in,in_file,Nom_Fichier_In);
 	  --Parcours du fichier...--
 	  while not end_of_file(F_in) loop
 		    --On lit un caractère--
 		    car:=Character'Input(Stream(F_in));		           	  
 		    --On ecrit le code correspondant dans le fichier--
  		    Code:=Get_Code(car,Dico);	
  		    Iterator:=Parcours_Init(Code);
 		    
 
 		    while(Parcours_Has_Next(Iterator)=True) loop
 			-- Character c = le caractere que l'on ecrira
 			itBit:=itBit+1;
 			Parcours_Next(Iterator,B);
 			valAecrire:=valAecrire*2 + B;
			
 			 if itBit >= 8 then
 			     Character'Write(Stream(F_Out), Character'Val(valAecrire) );
 			     valAecrire:=0;
 			     itBit:=0;
 			end if;
 		    end loop;
 	  end loop;
 
 	  if itBit/=0 then
 	  	valAecrire:=valAecrire*(2**(8-itBit) );
 	  	Character'Write(Stream(F_Out), Character'Val(valAecrire) );
 	  end if;
 	  --On libere les ressources
 	  Libere_Dico(Dico);	 
 	  Close(F_in); 
 	  Close(F_Out);

	end Compresse;



------------------------------------------------------------------------------
-- DECOMPRESSION
------------------------------------------------------------------------------

	procedure Decompresse(Nom_Fichier_In, Nom_Fichier_Out : in String) is
	
	Dico:Dico_Caracteres;
	F_in,F_out: Ada.Streams.Stream_Io.File_Type;
	Parcours: Arbre;
	car:Character;
	valLue,Bit:Integer;
	NbrCar:Integer;

	begin
	  --On ouvre le fichier à décompresser et on récupere le dictionnaire--
	  open(F_in, in_file, Nom_Fichier_In);
	  Put_line("decompresse");
	  --Chargement du dictionnaire--	  
	  Lit_Dico(Dico,F_in);
	  --Creation du nouveau fichier--
	  create(F_out, out_file, Nom_Fichier_Out);
	  
	  --Nbr de caracteres dans le fichier,le -1 correspond aux caractères de debut et de fin--
	  NbrCar:=Nb_Total_Caracteres(Dico);
	  
	  --On va remplir le fichier en parcourant l'arbre d'huffman associé au dico--
	  Parcours:=Get_Arbre_Huffman(Dico);
	  while not end_of_file(F_in) loop	    
		    
		   Character'Read(Stream(F_in), car);	        
		   valLue:=Character'Pos(car);
		   
		   for iBit in 0..7 loop
		
		   	Bit:= valLue/(2**(7-iBit));
		   	if(Bit = 0) then
				 Parcours:=Fils_Gauche(Parcours);
		   	else
				 Parcours:=Fils_Droit(Parcours);
				 valLue:=valLue-2**(7-iBit);
		   	end if;

		   	if(Est_Feuille(Parcours)) then
				   if(NbrCar>0) then
					Character'Write(Stream(F_out), Caractere(Parcours)); --PROC WRITE ELMT CHARACTER--
					NbrCar:=NbrCar-1;
				   end if;
				   Parcours:=Get_Arbre_Huffman(Dico);
		    	end if;
			
			
		    end loop;
	  end loop;

	  
	--On libere les ressources--
	Libere_Dico(Dico);
	Close(F_in);
	Close(F_Out);
	end Decompresse;


------------------------------------------------------------------------------
-- PG PRINCIPAL
------------------------------------------------------------------------------

begin

	if (Argument_Count /= 3) then
		Put_Line("Utilisation:");
		Put_Line("  Compression : ./huffman -c fichier.txt fichier.comp");
		Put_Line("  Decompression : ./huffman -d fichier.comp fichier.comp.txt");
		Set_Exit_Status(Failure);
		return;
	end if;

	if (Argument(1) = "-c") then
		Compresse(Argument(2), Argument(3));
	else
		Decompresse(Argument(2), Argument(3));
	end if;

	Set_Exit_Status(Success);

end tp_huffman;

