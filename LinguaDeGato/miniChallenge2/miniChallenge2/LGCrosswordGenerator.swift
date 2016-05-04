//
//  LGCrosswordGenerator.swift
//  miniChallenge2
//
//  Created by Andre Scherma Soleo on 06/11/15.
//  Copyright © 2015 Kobayashi. All rights reserved.
//
//  An object that creates a custom crossword game from some input words and
//  clues.

import Foundation


class LGCrosswordGenerator {
    //MARK: Properties
    
    //size properties
    let rows: Int
    let cols: Int
    
    let maxloops: Int
    
    var avaiableWords: [WordAndClue]
    var currentWordlist = [WordAndClue]()
    
    var grid: [[CrosswordElement?]]!
    
    var copy: LGCrosswordGenerator?
    
    // MARK: Initializer
    init(rows: Int, cols: Int, maxloops: Int, avaiableWords: [WordAndClue]) {
        
        self.rows = rows
        self.cols = cols
        self.maxloops = maxloops
        self.avaiableWords = avaiableWords
        self.clearGrid()
    }
    
    
    // MARK: Computional Methods
    
    func computeCrossword(timePermitted: NSTimeInterval, spins: Int) {
        
        //flag to asure at least one spin to run completely
        var oneCompleteSpin = false
        
        let start = NSTimeIntervalSince1970
        
        //compute at least one crossword, and compute more while time is not over
        while (oneCompleteSpin == false && NSTimeIntervalSince1970 - start < timePermitted) {
            
            self.copy = LGCrosswordGenerator(rows: self.rows, cols: self.cols, maxloops: self.maxloops, avaiableWords: self.avaiableWords)
            
            copy!.randomizeWordlist()
            var spinCount = 0
            
            
            // fitAndAdd forces cross until a whole spin can't add a word
            var forceCross = true
            while spinCount < spins {
                var crossInSpin = false
                for word in copy!.avaiableWords{
                    if !(copy!.currentWordlist.contains(word)){
                        let wordCrossed = copy!.fitAndAdd(word, onlyAddInCross: forceCross)
                        if wordCrossed {
                            crossInSpin = true
                        }
                    }
                }
                forceCross = crossInSpin
                spinCount += 1
            }
            
            if self.copy!.currentWordlist.count > self.currentWordlist.count {
                self.currentWordlist = copy!.currentWordlist
                self.grid = self.copy!.grid
            }
            oneCompleteSpin = true
        }
        clipGrid()
    }
    
    //suggest coordinates on empty spaces and letters matchs, not applied to seed
    private func suggestCoord(word: WordAndClue) -> [CrosswordCoordinate] {
       
        var coordList = [CrosswordCoordinate]()
        
        //letterIndex starts at 1, since 0 would be the index of the clue
        var letterIndex = 1
        //iterate throught word letters
        for letter in word.word.characters {
            
            var rowIndex = 0
            //iterate trought grid rows
            for row in self.grid{
                
                var colIndex = 0
                //iterate througt row cells
                for cell in row{
                    
                    //why it does not works with "CrosswordChar!"? (just a question)
                    if cell == nil || cell is CrosswordChar {
                        
                        if cell == nil || letter == (cell as! CrosswordChar).theChar {
                           
                            //suggest vertical placement
                            //prevent suggest points out of grid
                            var head = rowIndex - letterIndex
                            if ((head >= 0) && (head + word.lenght < self.rows)) {
                                //clue offset to left
                                coordList.append(CrosswordCoordinate(col: colIndex, row: head,
                                    vertical: true, clueOffsetLeft: true))
                                //clue offset to right
                                coordList.append(CrosswordCoordinate(col: colIndex, row: head,
                                    vertical: true, clueOffsetLeft: false))
                            }
                        
                            //suggest horizontal placement
                            //prevent suggest points out of grid
                            head = colIndex - letterIndex
                            if ((head >= 0) && (head + word.lenght < self.cols)) {
                                //clue offset to left
                                coordList.append(CrosswordCoordinate(col: head, row: rowIndex,
                                    vertical: false, clueOffsetLeft: true))
                                //clue offset to right
                                coordList.append(CrosswordCoordinate(col: head, row: rowIndex,
                                    vertical: false, clueOffsetLeft: false))
                            }
                        }
                    }
                    colIndex += 1
                }
                rowIndex += 1
            }
            letterIndex += 1
        }
        coordList = sortCoordlist(word, coordlist: coordList)
        return coordList
    }
    
    //return True if the word added has crossed (or the first); False if just fits
    private func fitAndAdd(word: WordAndClue, onlyAddInCross: Bool) -> Bool {
        print("fit and Add: \(word.word), \(onlyAddInCross)")
        
        var fit = false
        var hasCrossed = false
        var counter = 0
        var coordlist = self.suggestCoord(word)
        
        while !fit  && counter < coordlist.count/* && counter < self.maxloops*/{
            
            //this is the first word, the seed
            if self.currentWordlist.count == 0 {
                let isVert = (random() % 2 == 0)

                /*
                //set seed coordinate to 1,1 to open space to crossed words'clue
                word.coordinate = CrosswordCoordinate(col: self.cols / 2 , row: self.rows / 2, vertical: isVert)
                */
                
                //set seed on center of the grid (horizontal center if word is vertical and vice-versa)
                if isVert {
                    word.coordinate = CrosswordCoordinate(col: self.cols / 2 , row: 0, vertical: isVert, clueOffsetLeft: true)
                }
                else {
                    word.coordinate = CrosswordCoordinate(col: 0 , row: self.rows / 2, vertical: isVert, clueOffsetLeft: true)
                }
                
                if checkFitScore(word, coord: word.coordinate!) > 0 {
                    fit = true
                    hasCrossed = true
                    setWord(word)
                    currentWordlist.append(word)
                }
            }
            //not the seed, will try to cross
            //dont know why test other coordinates. If first does not fit, why the others would?
            else {
                //if there is not used coordinate (avoid accessing index out of range)
                if (coordlist.count > 0 /*&& counter < coordlist.count*/) {
                    word.coordinate = coordlist[counter]
                    
                    if word.coordinate!.score > 1 {
                        fit = true
                        hasCrossed = true
                        setWord(word)
                        currentWordlist.append(word)
                    }
                    else if onlyAddInCross == false && word.coordinate!.score > 0 {
                        fit = true
                        setWord(word)
                        currentWordlist.append(word)
                    }
                }
            }
            counter += 1
        }
        return hasCrossed
    }
    
    //Calculate a score to a coordinate. 0 means no fit, 1 means fit and 2+ means crosses
    //The more crosses the better
    private func checkFitScore(word: WordAndClue, coord: CrosswordCoordinate) -> Int {
        //print("checkfitscore - \(word.word): [\(coord.row)][\(coord.col)]")
        
        //preliminary tests. Not realy necessary, since suggestCoord() already make this tests
        //just to avoid trouble, lets test if the coordinate is inside the matrix
        if (coord.col < 0 || coord.row < 0 || coord.col >= self.cols || coord.row >= self.rows) {
            //print("1.a score = 0")
            return 0
        }
        
        //test if the word would fit in an empty matrix on given coordinate
        if coord.vertical {
            if (coord.row + word.lenght > self.rows){
                //print("1.b score = 0")
                return 0
            }
        } else {
            if (coord.col + word.lenght > self.cols){
                //print("1.c score = 0")
                return 0
            }
        }
        
        
        //testing word's coordinate square by square (clue, then letters)
        
        //this counter in particular starts in 1, cause it's not an index
        var squareCounter = 1
        
        //give standart value of 1, will override if collision is detected
        var score = 1
        
        var rowIndex = coord.row
        var colIndex = coord.col
        
        //test collision for clue. There's no clue cross, cell must be empty.
        if !checkIfCellClear(rowIndex, col: colIndex){
            //print("clue collision")
            return 0
        }
        
        //test collision for clues surroundings (since clue will occupy a 2x2 square)
        for cell in clueSurrondingCells(rowIndex, aCol: colIndex, vert: coord.vertical){
            //test if is inside matrix (since checkIfCellClear returns true for coordinates outside matrix)
            if (cell.row < 0 || cell.row >= self.rows || cell.col < 0 || cell.col >= self.cols){
                return 0
            }
            if !checkIfCellClear(cell.row, col: cell.col) {
                return 0
            }
        }
        
        //increment index after clue test
        squareCounter += 3
        if coord.vertical {
            rowIndex += 3
        }
        else {
            colIndex += 3
        }
        
        
        for letter in word.word.characters {
            let aCell = getCell(rowIndex, col: colIndex)
            
            var isCross = false
            
            //if there is a letter there
            if aCell is CrosswordChar {
                if (aCell as! CrosswordChar).theChar == letter {
                    //it's a cross!
                    isCross = true
                    score += 1
                } else {
                    //it's a collision!
                    //print("2.a score = 0")
                    return 0
                }
            }
            //if it's empty,
            else if aCell == nil {
                //do nothing, just go ahead (should I use a break or a continue?)
            }
            //if there is something else there, as a clue, it's a collision
            else {
                //print("2.b score = 0")
                return 0
            }
            
            //check surroundings, clues are permitted in surroundings
            
            //vertical
            if coord.vertical {
                //does not check surronds if it's a cross
                if isCross == false {
                    if getCell(rowIndex, col: colIndex + 1) is CrosswordChar { //check right cell
                        //print("2.|.a score = 0")
                        return 0
                    }
                    if getCell(rowIndex, col: colIndex - 1) is CrosswordChar { //check left cell
                        //print("2.|.b score = 0")
                        return 0
                    }
                }
                //check extremes even in crosses (avoids "concatenation" and "encapsulation")
                //top is clue, can be surrounded, so lets comment this piece of code
                /*
                if letterCount == 1 { //check top only on first letter
                    if !checkIfCellClear(rowIndex - 1, col: colIndex){
                        print("2.|.c score = 0")
                        return 0
                    }
                }
                */
                if squareCounter == word.lenght { //check bottom only on last letter
                    if getCell(rowIndex + 1, col: colIndex) is CrosswordChar {
                        //print("2.|.d score = 0")
                        return 0
                    }
                }
                rowIndex += 1
            }
                
            //horizontal
            else {
                //does not check surronds if it's a cross
                if isCross == false {
                    
                    if getCell(rowIndex - 1, col: colIndex) is CrosswordChar { //check top cell
                        //print("2.-.a score = 0")
                        return 0
                    }
                    if getCell(rowIndex + 1, col: colIndex) is CrosswordChar { //check bottom cell
                        //print("2.-.b score = 0")
                        return 0
                    }
                }
                //check extremes even in crosses (avoids "concatenation" and "encapsulation")
                
                //top is clue, can be surrounded, so lets comment this piece of code
                /*
                if letterCount == 1 { //check left only on first letter
                    if !checkIfCellClear(rowIndex, col: colIndex - 1){
                        print("2.-.c score = 0")
                        return 0
                    }
                }
                */
                if squareCounter == word.lenght { //check right only on last letter
                    if getCell(rowIndex, col: colIndex + 1) is CrosswordChar {
                        //print("2.-.d score = 0")
                        return 0
                    }
                }
                colIndex += 1
            }
            squareCounter += 1
        }
        //print("score = \(score)")
        return score
    }
    
    //MARK: Auxiliar computational methods
    
    private func randomizeWordlist () {
        
        //randomize avaiableWords
        var tempList = [WordAndClue]()
        let elements = avaiableWords.count
        
        while tempList.count < elements {
            
            let aIndex = random() % avaiableWords.count
            tempList.append(avaiableWords[aIndex])
            //irresponsable use of class property as auxiliar variable
            avaiableWords.removeAtIndex(aIndex)
        }
        
        //sort randomized list by word lenght (greater first)
        tempList.sortInPlace({return ($0.lenght > $1.lenght)})
        
        //atribute the randomized and sorted list
        self.avaiableWords = tempList
    }
    
    //give each coordinate a score, then, in newCoordlist, randomize and sort
    private func sortCoordlist(word: WordAndClue, coordlist: [CrosswordCoordinate]) -> [CrosswordCoordinate] {
        
        var tempCoordlist = coordlist
        var newCoordlist = [CrosswordCoordinate]()
        
        //give score
        for coord in tempCoordlist {
            coord.score = checkFitScore(word, coord: coord)
        }
        
        //transfer coordinates randomicaly from tempCoordlist to newCoordlist
        let elements = tempCoordlist.count
        while newCoordlist.count < elements{
            let aIndex = random() % tempCoordlist.count
            newCoordlist.append(tempCoordlist[aIndex])
            tempCoordlist.removeAtIndex(aIndex)
        }
        
        //sort newCoordilist, bigger scores first
        newCoordlist.sortInPlace({
            //TODO: priorizes nearest to center
            //comparing non-crossing coordinates priorizes the nearest to matrix origin
            if $0.score == 1 && $1.score == 1 {
                
                let firstDeltaFromCenterX = $0.col - self.cols / 2
                let firstDeltaFromCenterY = $0.row - self.rows / 2
                let secondDeltaFromCenterX = $1.col - self.cols / 2
                let secondDeltaFromCenterY = $1.row - self.rows / 2
                
                let firstDistanceFromCenter = (firstDeltaFromCenterX * firstDeltaFromCenterX) + (firstDeltaFromCenterY * firstDeltaFromCenterY)
                let secondDistanceFromCenter = (secondDeltaFromCenterX * secondDeltaFromCenterX) + (secondDeltaFromCenterY * secondDeltaFromCenterY)
                
                return firstDistanceFromCenter < secondDistanceFromCenter
            }
            return $0.score > $1.score
        })
        
        return newCoordlist
    }
    
    //MARK: Auxiliar grid methods
    
    private func clearGrid(){
        
        var aGrid = [[CrosswordElement?]]()
        
        for _ in 0...self.rows - 1{
            var aRow = [CrosswordElement?]()
            
            for _ in 0...self.cols - 1{
                aRow.append(nil)
            }
            aGrid.append(aRow)
        }
        self.grid = aGrid
    }
    
    //trying get cell out of grid, returns nil
    private func getCell(row: Int, col: Int) -> CrosswordElement? {
       
        if (row < 0 || row >= self.rows || col < 0 || col >= self.cols){
            return nil
        }
        
        return self.grid[row][col]
    }
    
    
    //set an CrosswordElement in a grid cell
    private func setCell(row: Int, col: Int, element: CrosswordElement?) {

        if (row >= 0 || row < self.rows || col >= 0 || col < self.cols){
            self.grid[row][col] = element
        }
    }
    
    // check if cell is clear.
    // If coordinate is out of matrix, returns true (not a SURROUNDING
    // obstruction)
    private func checkIfCellClear(row: Int, col: Int) -> Bool {
        
        if (row < 0 || col < 0 || row >= self.rows || col >= self.cols){
            return true
        }
        //if it's nil, it's empty, returns true
        return (self.grid[row][col] == nil)
    }
    
    //Don't you ever dare to call this function without warranties
    //that word.cordinate != nil. You're an adult dev, I don't have
    //to take care of your fucking shit!
    private func setWord(word: WordAndClue){
        
        var row = word.coordinate!.row
        var col = word.coordinate!.col
        
        //set clue
        let clue = CrosswordClue(anImageID: word.clue.imageID, anAudioPath: word.clue.audioPath)
        
        //coordinate data must be passed to CrosswordClue, so it can generate a ClueView properly
        
        //clue.offsetToLeft = word.coordinate!.clueOffsetLeft
        
        clue.isVertical = word.coordinate!.vertical
        setCell(row, col: col, element: clue)
        
        //set clue holders
        // clue use 2x2 in matrix, so index is increased by two from coordinate
        let holder = CrosswordCluePlaceholder()
        for cell in clueSurrondingCells(row, aCol: col, vert: word.coordinate!.vertical){
            setCell(cell.row , col: cell.col, element: holder)
        }
        
        if (word.coordinate!.vertical) {
            row += 3
        }
        else {
            col += 3
        }
        
        //set letters
        for letter in word.word.characters{
            
            if checkIfCellClear(row, col: col) {
                let element = CrosswordChar(aChar: letter)
                element.belongsTo.append(word)
                setCell(row, col: col, element: element)
            } else {
                //setWord would not be called if there was something that colide with the word
                //thus I'm SURE cell is a CrosswordChar
                let cell = getCell(row, col: col) as! CrosswordChar
                cell.belongsTo.append(word)
            }
        
            if word.coordinate!.vertical {
                row += 1
            }
            else {
                col += 1
            }
        }
    }
    
    //clips external empty rows and columns
    private func clipGrid() {
        
        var firstRow = 0
        var lastRow = self.rows - 1
        var firstCol = 0
        var lastCol = self.cols - 1
        
        //capture first non-void row
        var indexFound = false
        for i in 0...(self.rows - 1) {
            for cell in self.grid[i] {
                if cell != nil {
                    firstRow = i
                    indexFound = true
                    break
                }
            }
            if indexFound == true{
                break
            }
        }
        
        //capture the last non-void row
        indexFound = false
        for i in 0...(self.rows - 1) {
            //it's ugly, I know, but its pratical.
            for cell in self.grid[(self.rows - 1) - i] {
                if cell != nil {
                    lastRow = (self.rows - 1) - i
                    indexFound = true
                    break
                }
            }
            if indexFound == true{
                break
            }
        }
        
        //capture first non-void column
        indexFound = false
        for i in 0...(self.cols - 1) {
            //it's ugly, I know, but its pratical.
            for j in firstRow...(lastRow){
                if self.grid[j][i] != nil {
                    firstCol = i
                    indexFound = true
                    break
                }
            }
            if indexFound == true {
                break
            }
        }
        
        //capture last non-void column
        indexFound = false
        for i in 0...(self.cols - 1) {
            //it's ugly, I know, but its pratical.
            for j in firstRow...(lastRow){
                if self.grid[j][(self.cols - 1) - i] != nil {
                    lastCol = (self.cols - 1) - i
                    indexFound = true
                    break
                }
            }
            if indexFound == true {
                break
            }
        }
        
        //copy the elements from self.grid without void rows and columns
        var newGrid = [[CrosswordElement?]]()
        
        for i in firstRow...lastRow {
            var aRow = [CrosswordElement?]()
            for j in firstCol...lastCol {
                aRow.append(self.grid[i][j])
            }
            newGrid.append(aRow)
        }
        
        for word in self.currentWordlist {
            word.coordinate!.row = word.coordinate!.row - firstRow
            word.coordinate!.col = word.coordinate!.col - firstCol
        }
        
        self.grid = newGrid
    }
    
    //returns an array with clue's cell surrounding cells
    func clueSurrondingCells(aRow: Int, aCol: Int, vert: Bool) -> [(row: Int, col: Int)] {
        
        var cellIndexes = [(row: Int, col: Int)]()
        
        if vert {
            for i in aRow...aRow + 2 {
                for j in aCol - 1...aCol + 1 {
                    if !(i == aRow && j == aCol) {
                        cellIndexes.append((row: i, col: j))
                    }
                }
            }
        }
        else {
            for i in aRow - 1...aRow + 1 {
                for j in aCol...aCol + 2 {
                    if !(i == aRow && j == aCol) {
                        cellIndexes.append((row: i, col: j))
                    }
                }
            }
        }
    
        /*  used for 2x2 clues
        if vert {
            if offsetLeft {
                cellIndexes.append((row: aRow, col: aCol - 1))
                cellIndexes.append((row: aRow + 1, col: aCol))
                cellIndexes.append((row: aRow + 1, col: aCol - 1))
            }
            else{
                cellIndexes.append((row: aRow, col: aCol + 1))
                cellIndexes.append((row: aRow + 1, col: aCol))
                cellIndexes.append((aRow + 1, col: aCol + 1))
            }
        }
        else {
            if offsetLeft {
                cellIndexes.append((row: aRow, col: aCol + 1))
                cellIndexes.append((row: aRow + 1, col: aCol))
                cellIndexes.append((row: aRow + 1, col: aCol + 1))
            }
            else{
                cellIndexes.append((row: aRow, col: aCol + 1))
                cellIndexes.append((row: aRow - 1, col: aCol))
                cellIndexes.append((aRow - 1, col: aCol + 1))
            }
        }
        */
        
        return cellIndexes
    }
    
    //MARK: Visual output methods
    func solution() {
        var outStr = ""
        for row in self.grid{
            for cell in row {
                //cell is empty
                if cell == nil {
                    //I wanted to use .append, but it acused ambiguous use. I had to use gambiarra
                    outStr.appendContentsOf(".")
                }
                else {
                    //cell has a character
                    if cell is CrosswordChar {
                        outStr.append((cell as! CrosswordChar).theChar)
                    }
                    //cell has another element, probably a clue
                    if cell is CrosswordClue {
                        outStr.appendContentsOf("&")
                    }
                    if cell is CrosswordCluePlaceholder {
                        outStr.appendContentsOf("*")
                    }
                }
            }
            outStr.appendContentsOf("\n")
        }
        print(outStr)
    }
    
}