import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList<MSButton> bombs = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
int NUM_ROWS = 20;
int NUM_COLS = 20;
int num_bombs = 30;
void setup () {
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[20][20];
    for(int i = 0; i < NUM_ROWS; i++) {
        for(int j = 0; j < NUM_COLS; j++) {
            buttons[i][j] = new MSButton(i,j);
        }
    }
    for(int b = 0; b < num_bombs; b++) {
        setBombs();
    }
}
public void setBombs() {
    int r = (int)(NUM_ROWS*Math.random());
    int c = (int)(NUM_COLS*Math.random());
    if(!bombs.contains(buttons[r][c])) {
        bombs.add(buttons[r][c]);
    }
}
public boolean lost = false;
public void draw () {
    background( 0 );
    if(isWon())
        displayWinningMessage();
    if (lost) {
        String losingMessage = "YOU LOSE";
        for (int c = 6; c < losingMessage.length() + 6; c ++) {
            buttons[(int)(NUM_ROWS / 2)][c].setLabel(losingMessage.substring(c - 6, c - 5));
        }
        for(int i = 0; i < bombs.size(); i++) {
            bombs.get(i).mousePressed();
        }
    }
}
public boolean isWon() {
    for(int i = 0; i < NUM_ROWS; i++) {
        for(int j = 0; j < NUM_COLS; j++) {
            if (!bombs.contains(buttons[i][j]) && !buttons[i][j].isClicked()) {
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage() {
    lost = true;
}
public void displayWinningMessage() {
    String winningMessage = "YOU WIN!";
    for (int c = 6; c < winningMessage.length()+6; c++) {
        buttons[(int)(NUM_ROWS / 2)][c].setLabel(winningMessage.substring(c-6, c-5));
    }
}

public class MSButton {
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc ) {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked() {
        return marked;
    }
    public boolean isClicked() {
        return clicked;
    }
    // called by manager
    
    public void mousePressed ()  {
        clicked = true;
        if (mouseButton == RIGHT) {
            if(isMarked()) {
                marked = false;
            }
            else {
                marked = true;
                clicked = false;
            }
        }
        else if (bombs.contains(this)) {
            displayLosingMessage(); 
        }
        else if(countBombs(r,c) > 0) {
            label = "" + countBombs(r,c);
        }
        else {
             if (isValid(r, c - 1) && !buttons[r][c - 1].isClicked()) {
                buttons[r][c - 1].mousePressed();
            }
            if (isValid(r, c + 1) && !buttons[r][c + 1].isClicked()) {
                buttons[r][c + 1].mousePressed();
            }
            if (isValid(r - 1, c) && !buttons[r - 1][c].isClicked()) {
                buttons[r - 1][c].mousePressed();
            }
            if (isValid(r + 1, c) && !buttons[r + 1][c].isClicked()) {
                buttons[r + 1][c].mousePressed();
            }
            if (isValid(r + 1, c - 1) && !buttons[r + 1][c - 1].isClicked()) {
                buttons[r + 1][c - 1].mousePressed();
            }
            if (isValid(r - 1, c + 1) && !buttons[r - 1][c + 1].isClicked()) {
                buttons[r - 1][c + 1].mousePressed();
            }
            if (isValid(r - 1, c - 1) && !buttons[r - 1][c - 1].isClicked()) {
                buttons[r - 1][c - 1].mousePressed();
            }
            if (isValid(r + 1, c + 1) && !buttons[r + 1][c + 1].isClicked()) {
                buttons[r + 1][c + 1].mousePressed(); 
            }
        }
    }

    public void draw () {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel) {
        label = newLabel;
    }
    public boolean isValid(int r, int c) {
        if(r>=0 && r <= 19 && c >= 0 && c <= 19) {
            return true;
        }
        else {
            return false;
        }
    }
    public int countBombs(int row, int col) {
        int numBombs = 0;
        for(int r = row-1; r <= row+1; r++) {
            for(int c = col-1; c <= col+1; c++) {
                if(isValid(r,c) && bombs.contains(buttons[r][c])) {
                    if(r==row&&c==col) {
                        continue;
                    }
                    numBombs++;
                }
            }
        }
        return numBombs;
    }
}



