package aspects;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

import agent.Move;
import agent.Player;
import chess.Board;


public aspect Logging {
	 // Pointcut pour recuperer la méthode makeMove() de la classe Player
    pointcut isMakeMove(Player player, Move mv) : call(void *.movePiece(Move)) && !within(aspects.*) && this(player) && args(mv);

    //after pour enregistrer les coups dans un fichier    
    after(Player player, Move mv) : isMakeMove (player,mv) {
    	logMove(player.toString()+": " + mv.toString() + "\n");
        
    }
    

    // Méthode pour enregistrer les coups dans un fichier
    private void logMove(String move) {
        try {
            FileWriter fileWriter = new FileWriter("chess_moves.log", true);
            BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);
            bufferedWriter.write(move);
            bufferedWriter.newLine();
            bufferedWriter.close();
            
        } catch (IOException e) {
            
        }

    }
    
    

}
