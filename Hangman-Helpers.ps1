function Draw-HM-Gallow {
    param (
        $IncorrectGuessesAmount
    )

    #Define variables
    If ($IncorrectGuessesAmount -ge 1) {$Error1 = "red"} else {$Error1 = "white"}
    If ($IncorrectGuessesAmount -ge 2) {$Error2 = "red"} else {$Error2 = "white"}
    If ($IncorrectGuessesAmount -ge 3) {$Error3 = "red"} else {$Error3 = "white"}
    If ($IncorrectGuessesAmount -ge 4) {$Error4 = "red"} else {$Error4 = "white"}
    If ($IncorrectGuessesAmount -ge 5) {$Error5 = "red"} else {$Error5 = "white"}
    If ($IncorrectGuessesAmount -ge 6) {$Error6 = "red"} else {$Error6 = "white"}

    Clear-Host
    Write-Host ""
    Write-Host "      _______       "
    Write-Host "      | /   |       "
    Write-Host "      |/  " -NoNewline; Write-Host "  @       " -ForegroundColor $Error1
    Write-Host "      |   " -NoNewline; Write-Host " /"         -ForegroundColor $Error3 -NoNewline; Write-Host "|"        -ForegroundColor $Error2 -NoNewline; Write-Host "\      " -ForegroundColor $Error4
    Write-Host "      |   " -NoNewline; Write-Host "  |       " -ForegroundColor $Error2
    Write-Host "      |   " -NoNewline; Write-Host " /"         -ForegroundColor $Error5 -NoNewline; Write-Host " \      " -ForegroundColor $Error6
    Write-Host "   ___|__________   "
    Write-Host "  /   |         /|  "
    Write-Host " /_____________//  "
    Write-Host "|_____________|/   "
    Write-Host ""

} #End Draw-HM-Gallow

function Ask-HM-Language {
    Write-Host ""
    $Language = $false
    Write-Host "The game is in English, but can be played with a different dictionary. The following languages are available:"
    Write-Host "-English (EN)"
    Write-Host "-Dutch (NL)"
    Write-Host "-German (DE)"
    Write-Host ""
    
    While ($Language -eq $false) {
        $LangChoice = Read-Host "What language do you prefer?"
        if ($LangChoice -in @("EN","NL","DE")) {
            $Language = $LangChoice
        } else {
            While ($Language -eq $false) {
                $LangChoice = Read-Host "Incorrect choice. What language do you prefer?"
                if ($LangChoice -in @("EN","NL","DE")) {
                    $Language = $LangChoice
                } #End if
            } #End while
        } #End ifelse
    } #End while

    Write-Host "You have chosen " -NoNewline
    Write-Host $Language -ForegroundColor Cyan -NoNewline
    Write-Host ". Excellent! Let's play the game..."
    Start-Sleep -Seconds 2

    Return $Language
} #End Ask-HM-Language 

function Write-HM-IncorrectGuesses {
    Write-Host "Incorrect guesses: " -NoNewline
    foreach ($Guess in $IncorrectGuesses) {
        Write-Host "$Guess " -NoNewline -ForegroundColor Red
    } #End foreach
    Write-Host ""
    Write-Host ""

} #End Write-HM-IncorrectGuesses

function Write-HM-CorrectGuesses {
    Write-Host "The word to find is: " -NoNewline
    foreach ($Letter in $WordArray) {
        if ($CorrectGuesses -contains $Letter) {
            Write-Host "$Letter " -NoNewline -ForegroundColor Green
        } else {
            Write-Host "_ " -NoNewline
        } #End ifelse
    } #End foreach
    Write-Host ""
    Write-Host ""
} #End Write-HM-CorrectGuesses

function Get-HM-Input {
    $Guess = Read-Host "$Script:Inputmessage"
    #Validate that the input is exactly one character, which must be a letter
    If ($Guess.Length -gt 1) {
        $Script:Inputmessage = "Only input one letter. Try again"
        return
    } #End if
    elseif ($Guess.Length -eq 0) {
        $Script:Inputmessage = "You do have to input something. Try again"
        return
    } #End elseif
    elseif ($Guess -notmatch "[a-z]") {
        $Script:Inputmessage = "That's not a letter! Try again"
        return
    } #End elseif
    else {
        $Script:Inputmessage = "What letter do you want to guess"
    } #End else

    #Check if the guessed letter is in one of the previous guesses
    $Guess | ForEach-Object {
        if ($CorrectGuesses -contains $_) {
            $Script:Inputmessage = "You already tried that letter and it was correct. Try again"
        } elseif ($InCorrectGuesses -contains $_) {
            $Script:Inputmessage = "You already tried that letter and it was incorrect. Try again"
       } else {
            If ($WordArray -contains $_) {
                $Script:CorrectGuesses += $_
            } else {
                $Script:IncorrectGuesses += $_
            } #End If in WordArray
        } #End ifelseifelse
    } #End ForEach-Object

}

function Check-HM-Membership {
    param (
    $GuessedLetters,
    $GuessWord
    )

    <#
    .Synopsis
        Checks if all members of the array $Second (the word to be found) are found in the array $First (the letters correctly guessed
    #>

    #Define variables
    [array]$Truth = @()
    $Result = $true

    #Main loop
    $GuessWord | ForEach-Object {
        If ($GuessedLetters -notcontains $_) {
            $Truth += $false
        } #End if
        If ($GuessedLetters -contains $_) {
            $Truth += $true
        } #End if
    } #End ForEach-Object

    #See if the result is true or false and return that value    
    if ($Truth -contains $false) {$Result = $false}
    else {$Result = $True}
    Return $Result

} #End Check-Membership

function Write-HM-Ending {
    Clear-Host
    If ($GameState -eq "win") {
        Write-Host ""
        Write-Host " #################################################################################################################"
        Write-Host " The word was " -NoNewline
        Write-Host "$WordString" -ForegroundColor Green -NoNewline
        Write-Host "."
        Write-Host " You won, congratulations!"
        Write-Host " #################################################################################################################"
    }

    If ($GameState -eq "lose") {
        Write-Host ""
        Write-Host " #################################################################################################################"
        Write-Host " Unfortunately, the poor hangman got hung because you didn't find the correct word in time: " -NoNewline
        Write-Host "$WordString" -ForegroundColor Red -NoNewline
        Write-Host "."
       Write-Host " #################################################################################################################"

    }

}