#include <iostream>
#include <string>
#include <time.h> 
using namespace std;

// Game Rules
// Game Rules
class GameRules{
	static const int EASY_DIFFICULTY = 1;
	static const int MED_DIFFICULTY = 2;
	static const int HARD_DIFFICULTY = 3;
public:
	static int difficulty;
	static const int BOARD_SIZE = 3;
	static void setupRules();
	static bool changeDifficulty(int diff);
	static int getCurrentDifficulty();
}; // end GameRules

int GameRules::difficulty = 1;

int GameRules::getCurrentDifficulty()
{
	return GameRules::difficulty;
} // end getCurrentDifficulty
bool GameRules::changeDifficulty(int diff)
{
	if (diff == EASY_DIFFICULTY)
	{
		difficulty = EASY_DIFFICULTY;
		return true;
	}
	else if (diff == MED_DIFFICULTY)
	{
		difficulty = MED_DIFFICULTY;
		return true;
	}
	else if (diff == HARD_DIFFICULTY)
	{
		difficulty = HARD_DIFFICULTY;
		return true;
	}
	return false;
} // end changeDifficulty

// end Game Rules

//GameBoard
//GameBoard
class GameBoard{
	int **board; // 2D array
	int size;
	int currentPlayer;
public:
	GameBoard();
	GameBoard(int boardSize, int CurrentPlayer);
	void swapPlayer();
	bool isMoveLegal(int x, int y);
	bool makeMove(int x, int y);
	int isGameWon();
	int** getCopyOfBoardState();
	int getBoardSize(){ return size; };
	int getCurrentPlayer(){ return currentPlayer; };
}; // end GameBoard

void GameBoard::swapPlayer()
{
	if (currentPlayer == 1)
	{
		currentPlayer = 2;
	}
	else
	{
		currentPlayer = 1;
	}
}

int** GameBoard::getCopyOfBoardState(){
	int **Returner;
	Returner = new int*[size];
	for (int i = 0; i<size; i++)
	{
		Returner[i] = new int[size];
		for (int j = 0; j<size; j++)
		{
			Returner[i][j] = board[i][j];
		}
	}
	return Returner;
}

GameBoard::GameBoard()
{
	size = 3;
	currentPlayer = 1;
	// get game board size: default:3
	board = new int *[size];
	for (int i = 0; i<size; i++)
	{
		// make a game board of proper size
		board[i] = new int[size];
		// initialize the board to 0
		for (int j = 0; j<size; j++)
		{
			board[i][j] = 0;
		} // end for
	} // end for
} // end GameBoard constructor

GameBoard::GameBoard(int boardSize, int CurrentPlayer)
{
	size = boardSize;
	currentPlayer = CurrentPlayer;
	// get game board size: default:3
	board = new int *[size];
	for (int i = 0; i<size; i++)
	{
		// make a game board of proper size
		board[i] = new int[size];
		// initialize the board to 0
		for (int j = 0; j<size; j++)
		{
			board[i][j] = 0;
		} // end for
	} // end for
} // end GameBoard constructor

bool GameBoard::isMoveLegal(int x, int y){
	if (0 <= x && x <= size)
	{
		if (0 <= y && y <= size)
		{
			if (board[x][y] == 0)
			{
				return true;
			} // if
		} // if
	} // if
	return false;
} //end isMoveLegal

bool GameBoard::makeMove(int x, int y)
{
	if (isMoveLegal(x, y))
	{
		board[x][y] = currentPlayer;
		swapPlayer();
		return true;
	}//if
	return false;
}// end makeMove

int GameBoard::isGameWon()
{

	bool movesLeft = false;
	// check rows if player x wins, return x
	for (int a = 0; a<size; a++)
	{
		int RowCheck = board[a][0];
		for (int b = 0; b<size; b++)
		{
			if (RowCheck == 0)
			{
				movesLeft = true;
				break;
			}// if
			if (!(board[a][b] == RowCheck))
			{
				//doesn't win
				if (board[a][b] == 0)
				{
					movesLeft = true;
				} // if
				break;
			} // if

			if (b == size - 1)
			{
				return RowCheck;
			}
		}// for
	}//for

	// check Columns if player x wins, return x
	for (int c = 0; c<size; c++)
	{
		int RowCheck = board[0][c];
		for (int d = 0; d<size; d++)
		{
			if (RowCheck == 0)
			{
				movesLeft = true;
				break;
			}// if
			if (!(board[d][c] == RowCheck))
			{
				//doesn't win
				if (board[d][c] == 0)
				{
					movesLeft = true;
				} // if
				break;
			} // if

			if (d == size - 1)
			{
				return RowCheck;
			}
		}// for
	}//for
	// check diagonals if player x wins, return x
	for (int e = 0; e<size; e++)
	{
		int RowCheck = board[0][0];
		if (RowCheck == 0)
		{
			movesLeft = true;
			break;
		}// if
		if (!(board[e][e] == RowCheck))
		{
			//doesn't win
			break;
		} // if

		if (e == size - 1)
		{
			return RowCheck;
		}
	}//for
	// check diagonals if player x wins, return x
	for (int f = 0; f<size; f++)
	{
		int RowCheck = board[0][size-1];
		if (RowCheck == 0)
		{
			movesLeft = true;
			break;
		}// if
		if (!(board[f][size - 1 - f] == RowCheck))
		{
			//doesn't win
			break;
		} // if

		if (f == size - 1)
		{
			return RowCheck;
		}

	}//for
	// if no moves left, return 3
	// else, return 0
	if (movesLeft)
	{
		return 0;
	}
	else
	{
		for (int g = 0; g < size; g++)
		{
			for (int h = 0; h < size; h++)
			{
				if (board[g][h] == 0)
				{
					return 0;
				}
			}
		}

		return 3;
	}
} // end isGameWon
// End Game Board

// GameBoard Drawer
// GameBoard Drawer
class GameBoardDrawer{
	GameBoard board;
public:
	GameBoardDrawer();
	GameBoardDrawer(GameBoard givenBoard);
	void drawGameBoard();
}; // end GameBoardDrawer

GameBoardDrawer::GameBoardDrawer()
{
	board = GameBoard();
}

GameBoardDrawer::GameBoardDrawer(GameBoard givenBoard)
{
	board = givenBoard;
}

void GameBoardDrawer::drawGameBoard()
{
	int **outputboard = board.getCopyOfBoardState();

	cout << "   ";
	for (int x = 0; x < board.getBoardSize(); x++)
	{
		cout << x + 1 << " ";
	}
	cout << '\n';
	cout << "   ";
	for (int x = 0; x < board.getBoardSize(); x++)
	{
		cout << "__";
	}
	cout << '\n';

	for (int i = 0; i<board.getBoardSize(); i++)
	{
		cout << i + 1 << " " << "|";
		for (int j = 0; j<board.getBoardSize(); j++)
		{
			cout << outputboard[i][j] << " ";
		}
		cout << '\n';
	}
}

// Game Board Prompter
class GameBoardPrompter{
	GameBoard board;
	int move[2];
public:
	GameBoardPrompter();
	GameBoardPrompter(GameBoard givenBoard);
	int getInteger(int maxValue);
	int* getNextUserMove();
	int getUserDifficultyChange();

}; // end GameBoardPrompter

GameBoardPrompter::GameBoardPrompter()
{
	board = GameBoard();
}

GameBoardPrompter::GameBoardPrompter(GameBoard givenBoard)
{
	board = givenBoard;
}

//Prompts the user to perform input, only accepts integer values between 1 and maxValue, returns integer entered
int GameBoardPrompter::getInteger(int maxValue)
{

	if (maxValue < 1)
	{
		return -2; //Error code, maxValue has to be 1 or greater
	}

	string rawInput;

	getline(cin, rawInput);
	int valueGiven;
	valueGiven = atoi(rawInput.c_str());

	if ((valueGiven <= maxValue) && (valueGiven >= 1))
	{
		return valueGiven;
	}

	return -1; //Error code, user did not enter a proper value

}

int* GameBoardPrompter::getNextUserMove()
{
	cout << "Input the row of your move" << endl;
	move[0] = getInteger(board.getBoardSize())-1;


	cout << "Input the column of your move:" << endl;
	move[1] = getInteger(board.getBoardSize())-1;

	return move;
}
int GameBoardPrompter::getUserDifficultyChange()
{
	int difficulty;
	cout << "Which difficulty would you like?" << endl;
	cout << "[1] for easy, [2] for medium, [3] for hard" << endl;
	// debug line // needs error handling
	difficulty = getInteger(3);
	if (difficulty < 1 || difficulty > 3)
	{
		cout << "Invalid selection, try again." << endl;
		difficulty = getUserDifficultyChange();
	}
	return difficulty;

}

//AI Opponent
// AI Opponent
class AIOpponent{
	GameBoard board;
	int difficulty;
	int* move;
	bool winsWithNextMove(int** boardCopy);
	bool playerWinsWithNextMove(int** boardCopy);
	int* getNextMoveEasy();
	int* getNextMoveMed();
	int* getNextMoveHard();
public:
	AIOpponent();
	AIOpponent(GameBoard givenBoard, int diff);
	int* getNextMove();
}; // end AIOpponent

AIOpponent::AIOpponent()
{
	move = new int[2];
	board = GameBoard();
}

AIOpponent::AIOpponent(GameBoard givenBoard, int diff)
{
	move = new int[2];
	difficulty = diff;
	board = givenBoard;
}

int* AIOpponent::getNextMove()
{
	if (difficulty == 1)
	{
		return getNextMoveEasy();
	}
	else if (difficulty == 2)
	{
		return getNextMoveMed();
	}
	else 
	{
		return getNextMoveHard();
	}
}

int* AIOpponent::getNextMoveEasy()
{
	if (board.isGameWon() == 3) //If the game has no more moves left, return an error
	{
		move[0] = -1;
		move[1] = -1;
		return move;
	}
	int** boardCopy = board.getCopyOfBoardState();
	int x;
	int y;
	while (true)
	{
		x = rand() % board.getBoardSize();
		y = rand() % board.getBoardSize();
		if (board.isMoveLegal(x, y))
		{
			move[0] = x;
			move[1] = y;
			return move;
		}
	}
	move[0] = -1;
	move[1] = -1;
	return move;
}

bool AIOpponent::winsWithNextMove(int** boardCopy)
{
	bool emptySpaceFound = false;
	int emptySpaceCandidate[2];
	emptySpaceCandidate[0] = -1;
	emptySpaceCandidate[1] = -1;
	// first check rows, if they are all filled with the AI's pieces except one spot (which is empty) then we know where to move
	for (int i = 0; i<board.getBoardSize(); i++)
	{

		for (int j = 0; j<board.getBoardSize(); j++)
		{
			if (boardCopy[i][j] == 1) //If there is the human player's piece here, then this row will not work, go to next one
			{
				emptySpaceFound = false;
				break;
			}

			if (boardCopy[i][j] == 0) //If their is an empty space, we might know where to move
			{
				if (!emptySpaceFound) //Check to see if another empty space was found in this row, if so, exit
				{
					emptySpaceFound = true;
					emptySpaceCandidate[0] = i;
					emptySpaceCandidate[1] = j;
				}
				else
				{
					emptySpaceFound = false;
					break;
				}
			}

		}// for

		if (emptySpaceFound)
		{
			move[0] = emptySpaceCandidate[0];
			move[1] = emptySpaceCandidate[1];
			return true;
		}

		// now check all those columns, if they are all filled with the AI's pieces except one spot (which is empty) then we know where to move
		for (int i = 0; i<board.getBoardSize(); i++)
		{

			for (int j = 0; j<board.getBoardSize(); j++)
			{
				if (boardCopy[j][i] == 1) //If there is the human player's piece here, then this column will not work, go to next one
				{
					emptySpaceFound = false;
					break;
				}

				if (boardCopy[j][i] == 0) //If their is an empty space, we might know where to move
				{
					if (!emptySpaceFound) //Check to see if another empty space was found in this column, if so, exit
					{
						emptySpaceFound = true;
						emptySpaceCandidate[0] = j;
						emptySpaceCandidate[1] = i;
					}
					else
					{
						emptySpaceFound = false;
						break;
					}
				}

			}// for

			if (emptySpaceFound)
			{
				move[0] = emptySpaceCandidate[0];
				move[1] = emptySpaceCandidate[1];
				return true;
			}

		}//for
		// finally check the diagonals, using the same procedure
		for (int i = 0; i<board.getBoardSize(); i++)
		{
			if (boardCopy[i][i] == 1) //If there is the human player's piece here, then this diagonal will not work
			{
				emptySpaceFound = false;
				break;
			}

			if (boardCopy[i][i] == 0) //If their is an empty space, we might know where to move
			{
				if (!emptySpaceFound) //Check to see if another empty space was found in this diagonal, if so, exit
				{
					emptySpaceFound = true;
					emptySpaceCandidate[0] = i;
					emptySpaceCandidate[1] = i;
				}
				else
				{
					emptySpaceFound = false;
					break;
				}
			}

		}//for

		if (emptySpaceFound)
		{
			move[0] = emptySpaceCandidate[0];
			move[1] = emptySpaceCandidate[1];
			return true;
		}

		//next diagonal
		for (int i = board.getBoardSize() - 1; i >= 0; i--)
		{
			if (boardCopy[i][board.getBoardSize()-1 - i] == 1) //If there is the human player's piece here, then this diagonal will not work
			{
				emptySpaceFound = false;
				break;
			}

			if (boardCopy[i][board.getBoardSize()-1 - i] == 0) //If their is an empty space, we might know where to move
			{
				if (!emptySpaceFound) //Check to see if another empty space was found in this diagonal, if so, exit
				{
					emptySpaceFound = true;
					emptySpaceCandidate[0] = i;
					emptySpaceCandidate[1] = board.getBoardSize() - 1 - i;
				}
				else
				{
					emptySpaceFound = false;
					break;
				}
			}

		}//for

		if (emptySpaceFound)
		{
			move[0] = emptySpaceCandidate[0];
			move[1] = emptySpaceCandidate[1];
			return true;
		}

		return false;

	}//for
}

bool AIOpponent::playerWinsWithNextMove(int** boardCopy)
{
	bool emptySpaceFound = false;
	int emptySpaceCandidate[2];
	emptySpaceCandidate[0] = -1;
	emptySpaceCandidate[1] = -1;
	// first check rows, if they are all filled with the Players's pieces except one spot (which is empty) then we know where to move
	for (int i = 0; i < board.getBoardSize(); i++)
	{

		for (int j = 0; j < board.getBoardSize(); j++)
		{
			if (boardCopy[i][j] == 2) //If there is the AI player's piece here, then this row will not work, go to next one
			{
				emptySpaceFound = false;
				break;
			}

			if (boardCopy[i][j] == 0) //If their is an empty space, we might know where to move
			{
				if (!emptySpaceFound) //Check to see if another empty space was found in this row, if so, exit
				{
					emptySpaceFound = true;
					emptySpaceCandidate[0] = i;
					emptySpaceCandidate[1] = j;
				}
				else
				{
					emptySpaceFound = false;
					break;
				}
			}

		}// for

		if (emptySpaceFound)
		{
			move[0] = emptySpaceCandidate[0];
			move[1] = emptySpaceCandidate[1];
			return true;
		}
	}


	// now check all those columns, if they are all filled with the Players's pieces except one spot (which is empty) then we know where to move
	for (int i = 0; i<board.getBoardSize(); i++)
	{

		for (int j = 0; j<board.getBoardSize(); j++)
		{
			if (boardCopy[j][i] == 2) //If there is the AI player's piece here, then this column will not work, go to next one
			{
				emptySpaceFound = false;
				break;
			}

			if (boardCopy[j][i] == 0) //If their is an empty space, we might know where to move
			{
				if (!emptySpaceFound) //Check to see if another empty space was found in this column, if so, exit
				{
					emptySpaceFound = true;
					emptySpaceCandidate[0] = j;
					emptySpaceCandidate[1] = i;
				}
				else
				{
					emptySpaceFound = false;
					break;
				}
			}

		}// for

		if (emptySpaceFound)
		{
			move[0] = emptySpaceCandidate[0];
			move[1] = emptySpaceCandidate[1];
			return true;
		}

	}//for
	// finally check the diagonals, using the same procedure
	for (int i = 0; i<board.getBoardSize(); i++)
	{
		if (boardCopy[i][i] == 2) //If there is the AI player's piece here, then this diagonal will not work
		{
			emptySpaceFound = false;
			break;
		}

		if (boardCopy[i][i] == 0) //If their is an empty space, we might know where to move
		{
			if (!emptySpaceFound) //Check to see if another empty space was found in this diagonal, if so, exit
			{
				emptySpaceFound = true;
				emptySpaceCandidate[0] = i;
				emptySpaceCandidate[1] = i;
			}
			else
			{
				emptySpaceFound = false;
				break;
			}
		}

	}//for

	if (emptySpaceFound)
	{
		move[0] = emptySpaceCandidate[0];
		move[1] = emptySpaceCandidate[1];
		return true;
	}

	//next diagonal
	for (int i = board.getBoardSize() - 1; i >= 0; i--)
	{
		if (boardCopy[i][board.getBoardSize()-1 - i] == 2) //If there is the AI player's piece here, then this diagonal will not work
		{
			emptySpaceFound = false;
			break;
		}

		if (boardCopy[i][board.getBoardSize()-1 - i] == 0) //If their is an empty space, we might know where to move
		{
			if (!emptySpaceFound) //Check to see if another empty space was found in this diagonal, if so, exit
			{
				emptySpaceFound = true;
				emptySpaceCandidate[0] = i;
				emptySpaceCandidate[1] = board.getBoardSize() - 1 - i;
			}
			else
			{
				emptySpaceFound = false;
				break;
			}
		}

	}//for

	if (emptySpaceFound)
	{
		move[0] = emptySpaceCandidate[0];
		move[1] = emptySpaceCandidate[1];
		return true;
	}

	return false;

}//for

int* AIOpponent::getNextMoveMed()
{
	if (board.isGameWon() == 3) //If the game has no more moves left, return an error
	{
		move[0] = -1;
		move[1] = -1;
		return move;
	}

	int** boardCopy = board.getCopyOfBoardState();

	//The medium difficulty opponent first looks to see if there is anywhere it can win THIS move
	if (winsWithNextMove(boardCopy))
	{
		return move;
	}
	//Then check, if player can win next turn
	if (playerWinsWithNextMove(boardCopy))
	{
		//If so, block that winning move with your own!
		return move;
	}

	//Welp, that didn't work, just select a move at random, like it was an Easy AI Opponent

	int x;
	int y;
	while (true)
	{
		x = rand() % board.getBoardSize();
		y = rand() % board.getBoardSize();
		if (board.isMoveLegal(x, y))
		{
			move[0] = x;
			move[1] = y;
			return move;
		}
	}
	move[0] = -1;
	move[1] = -1;
	return move;
}

int* AIOpponent::getNextMoveHard()
{

	int** boardCopy = board.getCopyOfBoardState();
	//First, check if AI can win
	if (winsWithNextMove(boardCopy))
	{
		return move;
	}

	//Then check, if player can win next turn
	if (playerWinsWithNextMove(boardCopy))
	{
		//If so, block that winning move with your own!
		return move;
	}

	//Then, check if it can make priority moves (Diagonals)

	//Check first diagonal
	for (int a = 0; a < board.getBoardSize(); a++)
	{
		if (boardCopy[a][a] == 0)
		{
			move[0] = a;
			move[1] = a;
			return move;
		}
	}

	//Check second diagonal
	for (int b = 0; b < board.getBoardSize(); b++)
	{
		if (boardCopy[b][board.getBoardSize()-1 - b] == 0)
		{
			move[0] = b;
			move[1] = board.getBoardSize() - 1 - b;
			return move;
		}
	}
	// No priority moves available, just pick one!
	int x;
	int y;
	while (true)
	{
		x = rand() % board.getBoardSize();
		y = rand() % board.getBoardSize();
		if (board.isMoveLegal(x, y))
		{
			move[0] = x;
			move[1] = y;
			return move;
		}
	}

	cout << "Something has gone terribly, terribly wrong." << endl;
	move[0] = -1;
	move[1] = -1;
	return move;
}

//GBC
class GameBoardController
{
	GameBoard gameboard;
	GameBoardDrawer drawer;
	GameBoardPrompter userInterface;
	AIOpponent opponent;
	bool gameExists;
	int firstPlayer;
public:
	GameBoardController();
	void makeNewGame();
	void update();

}; // end GameBoardController

GameBoardController::GameBoardController()
{
	gameExists = false;
	firstPlayer = 1;
	gameboard = GameBoard();
	drawer = GameBoardDrawer(gameboard);
	userInterface = GameBoardPrompter(gameboard);

}

void GameBoardController::makeNewGame()
{
	int size = GameRules::BOARD_SIZE;
	int nextPlayer;
	if (firstPlayer == 2)
	{
		nextPlayer = 1;
	}
	else
	{
		nextPlayer = 2;
	}

	gameboard = GameBoard(size, firstPlayer);
	drawer = GameBoardDrawer(gameboard);
	userInterface = GameBoardPrompter(gameboard);

	opponent = AIOpponent(gameboard, GameRules::getCurrentDifficulty());

	firstPlayer = nextPlayer;
	gameExists = true;

}

void GameBoardController::update()
{
	//First thing, see if we currently have a game going on, if we don't, ask the player if he'd like to start a game or change difficulty
	if (!gameExists)
	{
		cout << "Would you like to start a new game [1] or change the difficulty [2] ?" << '\n';
		int choice = userInterface.getInteger(2);
		while (choice <= -1)
		{
			cout << "Invalid Input, please enter a valid integer, then press Enter." << '\n'
				<< "Would you like to start a new game [1] or change the difficulty [2]?" << '\n';
			choice = userInterface.getInteger(2);
		}

		if (choice == 1)
		{
			makeNewGame();
		}
		else
		{
			GameRules::changeDifficulty(userInterface.getUserDifficultyChange());
		}
	}
	else
	{
		drawer.drawGameBoard();

		int boardState = gameboard.isGameWon();
		if (boardState >= 1) //The game is somehow over, either someone won or there was a tie
		{
			if (boardState == 1)
			{
				cout << "Congratulations, you've won the game! Good job!" << '\n';
			}
			else if (boardState == 2)
			{
				cout << "Sorry, the computer has won this game. Better luck next time!" << '\n';
			}
			else
			{
				cout << "Tie! Nobody wins, everybody loses! Keep trying!" << '\n';
			}
			gameExists = false;
		}
		else
		{
			int* move;
			if (gameboard.getCurrentPlayer() == 1) //Human's turn, keep asking until he gives legal input, then do it
			{
				move = userInterface.getNextUserMove();
				while (!(gameboard.makeMove(move[0], move[1])))
				{
					cout << "Invalid move, please try again" << '\n';
					move = userInterface.getNextUserMove();
				}

			}
			else
			{
				cout << "The Computer is making its move..." << '\n';
				move = opponent.getNextMove();
				while (!gameboard.makeMove(move[0], move[1]))
				{
					move = opponent.getNextMove();
				}
			}
		}
	}

	update();
}

void main(){
	srand(time(NULL));
	GameBoardController control = GameBoardController();
	control.update();


} //main