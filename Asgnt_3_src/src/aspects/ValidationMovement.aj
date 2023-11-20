package aspects;

import agent.Move;
import agent.Player;
import chess.Board;
import piece.Knight;
import piece.Pawn;

public aspect ValidationMovement {
	// on créer un poincut sur la méthode isValidMove pour rajouter des conditions
	pointcut validationMovement(Player player,Move mv):call(boolean agent.Player.makeMove(Move))&& !within(aspects.*) && target(player) && args(mv);
	
	boolean around(Player player,Move mv):validationMovement(player,mv){

        //On regarde si la position initial est à l'intérieur du plateau
        if (mv.xI < 0 || mv.xI >= Board.SIZE || mv.yI < 0 || mv.yI >= Board.SIZE) 
        { 
        	System.out.println("La position initial n'est pas dans la plateau");
        	return false;
        	
        }
        
        
        //On regarde si la position finale est à l'intérieur du plateau
        if (mv.xF < 0 || mv.xF >= Board.SIZE || mv.yF < 0 || mv.yF >= Board.SIZE) { 
        	System.out.println("La position finale n'est pas dans la plateau");
        	return false;
        	
        }
        
        // on regarde si il y a une pièce sur l'emplacement choisi
        if (!player.getPlayground().getGrid()[mv.xI][mv.yI].isOccupied()) 
        {
        	System.out.println("Il n'y a pas de pièces sur la case de départ choisie");
        	return false; 
        }
        
      //On regarde si la pièce appartient au joueur
        if (player.getPlayground().getGrid()[mv.xI][mv.yI].getPiece().getPlayer() != player.getColor()) {
            System.out.println("La pièce n'appartient pas au joueur");
            return false;
        }
        
        
        
      //On regarde si la case n'est pas déjà occupée par une pièce du joueur
        if (player.getPlayground().getGrid()[mv.xF][mv.yF].isOccupied() &&
                player.getPlayground().getGrid()[mv.xF][mv.yF].getPiece().getPlayer() == player.getColor()) {
            System.out.println("La case finale est déjà occupée par une pièce du joueur");
            return false;
        }
        //On regarde si le mouvement est autorisé
        if (!player.getPlayground().getGrid()[mv.xI][mv.yI].getPiece().isMoveLegal(mv)) 
        { 
        	System.out.println("Le mouvement n'est pas autorisé");
        	return false; 
        }
        
     // on regarde si les pièce ne traverse pas d'autre pièce sauf pour le chevalier
        if(player.getPlayground().getGrid()[mv.xI][mv.yI].getPiece().getClass() != Knight.class) {
        	// On regarde si le déplacement est vertical
            if(mv.xI == mv.xF) {
            	//on a un mvt vertical
            	int départ = mv.yI +1;
            	int max = mv.yF;
            	
            	//on inverse si xI>xF
            	if(mv.yI > mv.yF) {
            		départ = mv.yF +1;
                	max = mv.yI;
            	}
            	//boucle pour vérifier si les cases sont occupé
            	for(int i =départ;i<max;i++) {
            		boolean occupied = player.getPlayground().getGrid()[mv.xF][i].isOccupied();
            		if(occupied) {
            			//si la case est occupée on retourne false
            			
            			System.out.println("la pièce traverse verticalement une autre pièce en " + mv.xF + i);
            			return false;
            		}
            		
            	}
            }
            //On regarde si le movement est  horizontal
            if(mv.yI == mv.yF) {
            	//on a un mvt horizontal
            	int départ = mv.xI +1;
            	int max = mv.xF;
            	
            	//on inverse si xI>xF
            	if(mv.xI > mv.xF) {
            		départ = mv.xF +1;
                	max = mv.xI;
            	}
            	//boucle pour vérifier si les cases sont occupé
            	for(int i =départ;i<=max;i++) {
            		boolean occupied = player.getPlayground().getGrid()[i][mv.yF].isOccupied();
            		if(occupied) {
            			//si la case est occupée on retourne false
            			System.out.println("la pièce traverse horizontalement une autre pièce");
            			return false;
            		}
            	
            	}
            }
            //Le mouvement est donc diagonale
            else {
            	int deltaX = Integer.compare(mv.xF, mv.xI);
                int deltaY = Integer.compare(mv.yF, mv.yI);
                
                int x = mv.xI;
                int y = mv.yI;
                x += deltaX;
                y += deltaY;
                while (x != mv.xF && y != mv.yF) {
                	if (player.getPlayground().getGrid()[x][y].isOccupied()) 
                	{ 
                		System.out.println("la pièce traverse diagonalement une autre pièce");
                		return false;
                	}
                	x += deltaX;
                    y += deltaY;
         
                }
            	
            }
        }
       
       
        System.out.println("Le mouvement est valide");
        return true;
	}
	
    


}
