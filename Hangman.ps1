#Initialize
. (Join-Path -Path $PSscriptroot -ChildPath 'Hangman-Helpers.ps1')

#Define variables
[array]$IncorrectGuesses = @()
[array]$CorrectGuesses = @()
$GameState = "InProgress"
$Inputmessage = "What letter do you want to guess"

#Write intro
Clear-Host
Write-Host "Welcome to the classic game of Hangman. The object of the game is to find a word by guessing letters one at a time."
Write-Host "The game ends when either you guessed all the letters of the word, of the wrong letters have hanged the poor hangman."

#Ask user for preferred dictionary
$Language = Ask-HM-Language

#Import preferred dictionary
$Dictionary = Get-Content -Raw -Path $PSscriptroot\Dictionary-$Language.json | ConvertFrom-Json

#Get random word from dictionary and place it into an array
$WordString = $Dictionary | Get-Random
$WordArray = $WordString.ToCharArray()

#MAIN LOOP
While ($GameState -like "InProgress") {
    #Draw the gallow
    Draw-HM-Gallow -IncorrectGuessesAmount $IncorrectGuesses.Count

    #Write incorrect guesses
    $IncorrectGuesses = $IncorrectGuesses | Sort-Object
    Write-HM-IncorrectGuesses

    #Write the solution part, with correct letters in place
    Write-HM-CorrectGuesses

    #Ask user for input
    Get-HM-Input   

    #Check to see if you win, lose or neither
    $CheckForWin = Check-HM-Membership -GuessedLetters $CorrectGuesses -GuessWord $WordArray
    if ($CheckForWin -eq $true) {$GameState = "Win"}
    if ($InCorrectGuesses.Count -eq 6) {$GameState = "Lose"}

} #End while gamestate...

#Write ending and show if you win or lose
Write-HM-Ending