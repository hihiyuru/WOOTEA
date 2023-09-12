//
//  Avatar.swift
//  WOOTEA
//
//  Created by 徐于茹 on 2023/9/12.
//

import Foundation
import UIKit

func randomEmoji() -> String {
    let emojis = ["😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "😊", "😇", "🙂", "🙃", "😉", "😌", "😍", "🥰", "😘", "😗", "😙", "😚", "😋", "😛", "😝", "😜", "🤪", "🤨", "🧐", "🤓", "😎", "🤩", "🥳", "😏", "😒", "😞", "😔", "😟", "😕", "🙁", "☹️", "😣", "😖", "😫", "😩", "🥺", "😢", "😭", "😤", "😠", "😡", "🤬", "🤯", "😳", "🥵", "🥶", "😱", "😨", "😰", "😥", "😓", "🤗", "🤔", "🤭", "🤫", "🤥", "😶", "😐", "😑", "😬", "🙄", "😯", "😦", "😧", "😮", "😲", "🥱", "😴", "🤤", "😪", "😵", "🤐", "🥴", "🤢", "🤮", "🤕", "🤒", "🤑", "🤠", "😈", "👿", "👹", "👺", "🤡", "💩", "👻", "💀", "☠️", "👽", "👾", "🤖", "🎃", "😺", "😸", "😹", "😻", "😼", "😽", "🙀", "😿", "😾"]
    
    return emojis.randomElement() ?? "😀"
}

func randomColor() -> UIColor {
    let lowerBound: CGFloat = 60.0 / 255.0
    let upperBound: CGFloat = 200.0 / 255.0
    let randomValue = { () -> CGFloat in
        return CGFloat(arc4random()) / CGFloat(UInt32.max) * (upperBound - lowerBound) + lowerBound
    }
    return UIColor(red: randomValue(), green: randomValue(), blue: randomValue(), alpha: 1.0)
}
