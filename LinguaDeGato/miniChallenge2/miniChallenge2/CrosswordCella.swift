//
//  CrosswordCell.swift
//  miniChallenge2
//
//  Created by Vítor Machado Rocha on 11/06/15.
//  Copyright (c) 2015 Kobayashi. All rights reserved.
//

import SpriteKit

/*
//Define os tipos existentes de letras. O "0" vai serveir para desabilitar o quadrado(item) da matriz, não vai poder receber letras e é chamado de Unknown. O "A" fica com 1, "B", 2... Sendo espaços válidos para receber letras.
//Imagino que faça sentido que os espaços válidos para receber letras já saibam que letras podem receber, então, apesar de terem a mesma imagem, têm nomes diferentes. 
//Quando uma letra for colocada no seu quadrado certo, ele torna-se um "RightChoiced" e, assume uma nova imagem, que seria a da letra. Assim facilita a mudança de quadrado vazio para preenchido. Acho que compensa o fato de criar imagens iguais com nomes diferentes.

enum LetterType: Int, Printable {
    case Unknown = 0, A, B, C, D, E
    
    var spriteName: String {
        let spriteNames = [
            "Empty",
            "A",
            "B",
            "C",
            "D",
            "E"]
        
        //Esse rawValue - 1 vai servir pra que o case do LetterType - que começa em 1 para itens válidos - pode ser igualado ao índice da matriz, que vai começar em 0. (Vou ver se iso vai faer realmente sentido no nosso caso, mas por enquanto vou deixar)
        return spriteNames[rawValue - 1]
    }
    
    var rightChoicedSpriteName: String {
        return spriteName + "-RightChoiced"
    }
    
    //Essa função adiciona as letras, mas ainda não sei como vai ser usada, acho que vai depender do algorítimo. Por enquanto vou deixar random pra poder ir testando.
    static func random() -> LetterType {
        return LetterType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
    
    //Para poder usar println e receber uma resposta possível de entender
    var description: String {
        return spriteName
    }
    
}
*/

//Aqui é onde são criadas as linhas e colunas que vão existir na tela, visíveis ou não.

class CrosswordCell: Printable {
    
    var column: Int
    var row: Int
    let char: Character?
    var sprite: SKSpriteNode
    var isCorrect: Bool = false
    
    init(column: Int, row: Int, char: Character?) {
        self.column = column
        self.row = row
        self.char = char
        
        if (self.char != nil){
            self.sprite = SKSpriteNode()
            self.sprite.addChild(SKLabelNode(text: String(self.char!)))
            
        }
        else{
            self.sprite = SKSpriteNode()
            self.sprite.addChild(SKShapeNode(rectOfSize: CGSizeZero))
        }
    }
    
    //Para poder usar println e receber uma resposta possível de entender
    var description: String {
        return "char:(\(char), square:(\(column),\(row))"
    }

}
